require 'spec_helper'

describe TransactionParams do
  subject { TransactionParams.new }

  it "params income" do
    subject.income.should eq([:date, :contact_id, :currency, :exchange_rate, :project_id, :bill_number, :description, :due_date, :total, income_details_attributes: [:id, :item_id, :price, :quantity, :_destroy]])
  end

  it "params expense" do
    subject.expense.should eq([:date, :contact_id, :currency, :exchange_rate, :project_id, :bill_number, :description, :due_date, :total, expense_details_attributes: [:id, :item_id, :price, :quantity, :_destroy]])
  end

  it "params quick" do
    subject.quick.should eq([:date, :fact, :bill_number, :amount, :contact_id, :account_id, :account_to_id, :verification])
  end
end