require "./lib/item"
require "./lib/vendor"
require "./lib/market"

describe Market do
  describe "Iteration 2" do
    before :each do
      @market = Market.new("South Pearl Street Farmers Market")
      @vendor1 = Vendor.new("Rocky Mountain Fresh")
      @item1 = Item.new({ name: "Peach", price: "$0.75" })
      @item2 = Item.new({ name: "Tomato", price: "$0.50" })
      @item3 = Item.new({ name: "Peach-Raspberry Nice Cream", price: "$5.30" })
      @item4 = Item.new({ name: "Banana Nice Cream", price: "$4.25" })
      @vendor1.stock(@item1, 35)
      @vendor1.stock(@item2, 7)
      @vendor2 = Vendor.new("Ba-Nom-a-Nom")
      @vendor2.stock(@item4, 50)
      @vendor2.stock(@item3, 25)
      @vendor3 = Vendor.new("Palisade Peach Shack")
      @vendor3.stock(@item1, 65)
    end

    it "exists" do
      expect(@market).to be_a(Market)
    end

    it "has a name" do
      expect(@market.name).to eq("South Pearl Street Farmers Market")
    end

    it "can add vendors" do
      expect(@market.vendors).to eq([])

      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendors).to eq([@vendor1, @vendor2, @vendor3])
    end

    it "can give the names of all the vendors" do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
    end

    it "return a list of items that have a specified item in stock" do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendors_that_sell(@item1)).to eq([@vendor1, @vendor3])
      expect(@market.vendors_that_sell(@item4)).to eq([@vendor2])
    end
  end

  describe "Iteration 3" do
    before :each do
      @market = Market.new("South Pearl Street Farmers Market")
      @item1 = Item.new({ name: "Peach", price: "$0.75" })
      @item2 = Item.new({ name: "Tomato", price: "$0.50" })
      @item3 = Item.new({ name: "Peach-Raspberry Nice Cream", price: "$5.30" })
      @item4 = Item.new({ name: "Banana Nice Cream", price: "$4.25" })
      @vendor1 = Vendor.new("Rocky Mountain Fresh")
      @vendor1.stock(@item1, 35)
      @vendor1.stock(@item2, 7)
      @vendor2 = Vendor.new("Ba-Nom-a-Nom")
      @vendor2.stock(@item4, 50)
      @vendor2.stock(@item3, 25)
      @vendor3 = Vendor.new("Palisade Peach Shack")
      @vendor3.stock(@item1, 65)
      @vendor3.stock(@item3, 10)
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    it "can report quantities of all items sold at the market" do
      expected = {
        @item1 => {
          quantity: 100,
          vendors: [@vendor1, @vendor3],
        },
        @item2 => {
          quantity: 7,
          vendors: [@vendor1],
        },
        @item4 => {
          quantity: 50,
          vendors: [@vendor2],
        },
        @item3 => {
          quantity: 35,
          vendors: [@vendor2, @vendor3],
        },
      }
      expect(@market.total_inventory).to eq(expected)
    end

    it "can report any overstocked items" do
      expect(@market.overstocked_items).to eq([@item1])
    end

    it "can sort all item names at the market alphabetically" do
      expect(@market.sorted_item_list).to eq(["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"])
    end
  end

  describe "Iteration 4" do
    before :each do
      @item1 = Item.new({name: 'Peach', price: "$0.75"})
      @item2 = Item.new({name: 'Tomato', price: '$0.50'})
      @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
      @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
      @item5 = Item.new({name: 'Onion', price: '$0.25'})
      @market = Market.new("South Pearl Street Farmers Market")
      @vendor1 = Vendor.new("Rocky Mountain Fresh")
      @vendor1.stock(@item1, 35)
      @vendor1.stock(@item2, 7)
      @vendor2 = Vendor.new("Ba-Nom-a-Nom")
      @vendor2.stock(@item4, 50)
      @vendor2.stock(@item3, 25)
      @vendor3 = Vendor.new("Palisade Peach Shack")
      @vendor3.stock(@item1, 65)
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    it "can give the date the market was created" do
      allow(@market).to receive(:date).and_return(Date.parse("20200224").stftime("%d/%m/%Y"))
      expect(@market.date).to eq("24/02/2020")
    end

    it "can sell items if there is enough of that item in stock across the market" do
      expect(@market.sell(@item1, 200)).to be(false)
      expect(@market.sell(@item5, 1)).to be(false)
      expect(@market.sell(@item4, 5)).to be(true)
      expect(@vendor2.check_stock(@item4)).to eq(45)
      expect(@market.sell(@item1, 40)).to eq(true)
      expect(@vendor1.check_stock(@item1)).to eq(0)
      expect(@vendor3.check_stock(@item1)).to eq(60)
    end
  end
end
