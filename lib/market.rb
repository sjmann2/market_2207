require "date"

class Market
  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map(&:name)
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.inventory.include?(item)
    end
  end

  def total_inventory
    total_inventory = Hash.new { |h, k| h[k] = { quantity: 0, vendors: [] } }
    @vendors.map do |vendor|
      vendor.inventory.map do |item, quantity|
        total_inventory[item][:quantity] += quantity
        total_inventory[item][:vendors] << vendor
      end
    end
    total_inventory
  end

  def overstocked_items
    overstocked_items = []
    total_inventory.map do |item, quantity_vendors|
      if quantity_vendors[:quantity] > 50 && quantity_vendors[:vendors].length > 1
        overstocked_items << item
      end
    end
    overstocked_items
  end

  def sorted_item_list
    items = []
    total_inventory.each do |item, quantity_vendors|
      items << item.name
    end
    items.sort
  end

  def date
    Date.today.strftime("%d/%m/%Y")
  end

  def sell(item, quantity)
    if total_inventory[item][:quantity] > quantity
      @vendors.each do |vendor|
        vendor.inventory[item] -= quantity
        if vendor.inventory[item].zero?
          next
        end
      end
      return true
    else
      return false
    end
  end
end
