# encoding: utf-8
require 'spec_helper'

describe Inventories::Out do
  let(:store) { build :store, id: 1 }
  let(:valid_attributes) {
    {store_id: 1, date: Date.today, description: 'Test inventory out',
     inventory_details_attributes: [
       {item_id: 1, quantity: 2},
       {item_id: 2, quantity: 2}
    ]
    }
  }
  let(:item) { build :item }
  let(:store) { build :store }
  let(:user) { build :user, id: 10 }

  it "#initialize" do
    invout = Inventories::Out.new

    invout.inventory.should be_is_out
  end

  before(:each) do
    UserSession.user = user
    Store.stub_chain(:active, where: [store])
  end

  it "creates" do
    InventoryDetail.any_instance.stub(item: item)
    Inventory.any_instance.stub(store: store)
    Stock.any_instance.stub(item: item, store: store)

    invout = Inventories::Out.new(valid_attributes)
    invout.inventory_details.should have(2).items

    invout.create.should be_true
    io = Inventory.find(invout.inventory.id)
    io.should be_is_a(Inventory)
    io.should be_is_out
    io.creator_id.should eq(user.id)
    io.ref_number.should =~ /\AS-\d{2}-\d{4}\z/

    io.inventory_details.should have(2).items
    io.inventory_details.map(&:quantity).should eq([2, 2])
    io.inventory_details.map(&:item_id).should eq([1, 2])

    stocks = Stock.active.where(store_id: io.store_id)
    stocks.should have(2).items
    stocks.map(&:item_id).sort.should eq([1, 2])
    stocks.map(&:quantity).should eq([-2, -2])

    # More items ERROR repeated
    attrs = valid_attributes.merge(inventory_details_attributes:
      [{item_id: 2, quantity: 2, store_id: 1},
       {item_id: 12, quantity: 5, store_id: 1},
       {item_id: 2, quantity: 10, store_id: 1}
      ]
    )
    invout = Inventories::Out.new(attrs)
    invout.create.should be_false
    invout.details[2].errors[:item_id].should_not be_blank

    # More items
    attrs = valid_attributes.merge(inventory_details_attributes:
      [{item_id: 2, quantity: 2, store_id: 1},
       {item_id: 12, quantity: 5, store_id: 1}
      ]
    )
    invout = Inventories::Out.new(attrs)

    invout.create.should be_true
    
    stocks = Stock.active.where(store_id: io.store_id)
    stocks.should have(3).items

    stocks.find {|v| v.item_id === 2}.quantity.should == -4
    stocks.find {|v| v.item_id === 12}.quantity.should == -5
    stocks.find {|v| v.item_id === 1}.quantity.should == -2
  end
end
