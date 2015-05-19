require 'spec_helper'

describe LoanLedgerInsController do

  let(:user) { build :user, id: 1 }
  let(:contact) { create :contact, matchcode: 'James Brown' }

  before(:each) do
    stub_auth_and_tenant
    UserSession.user = user
  end

  let(:bank) { create :bank, amount: 1000 }
  let(:today) { Date.today }
  let(:loan_attributes)  {
    {
      date: today, due_date: today + 10.days, total: 500, account_to_id: bank.id,
      reference: 'Receipt 00232', contact_id: contact.id, description: 'New loan'
    }
  }

  let(:loan_give) {
    lg = Loans::GiveForm.new(loan_attributes)
    lg.create
    lg.loan
  }
  let(:loan_receive) {
    lg = Loans::ReceiveForm.new(loan_attributes)
    lg.create
    lg.loan
  }

  describe '#GET new_give' do
    it 'route' do
      expect(:get => '/loan_ledger_ins/11/new_give').to route_to({
        controller: 'loan_ledger_ins', action: 'new_give', id: '11'
      })
    end

    it 'path' do
      expect(controller.new_give_loan_ledger_in_path(1)).to eq('/loan_ledger_ins/1/new_give')
    end

    it 'OK' do
      get :new_give, id: loan_give.id

      expect(response.ok?).to eq(true)
      expect(assigns(:ledger).class).to eq(LoanLedgerInForm)
    end

    it 'ERROR' do
      get :new_give, id: 100000000000

      expect(response.ok?).to eq(false)
      expect(response.status).to eq(404)
    end

    it 'incorrect type of loan' do
      get :new_give, id: loan_receive.id

      expect(response.ok?).to eq(false)
      expect(response.status).to eq(STATUS_ERROR)
    end
  end

  describe '#PATCH give' do
    it 'route' do
      expect(:patch => '/loan_ledger_ins/11/give').to route_to({
        controller: 'loan_ledger_ins', action: 'give', id: '11'
      })
    end

    it 'path' do
      expect(controller.give_loan_ledger_in_path(1)).to eq('/loan_ledger_ins/1/give')
    end

    it 'OK' do
      patch :give, id: 11
    end
  end

  describe '#GET new_receive' do
    it 'route' do
      expect(:get => '/loan_ledger_ins/11/new_receive').to route_to({
        controller: 'loan_ledger_ins', action: 'new_receive', id: '11'
      })
    end

    it 'path' do
      expect(controller.new_receive_loan_ledger_in_path(1)).to eq('/loan_ledger_ins/1/new_receive')
    end
  end

  describe '#PATCH receive' do
    it 'route' do
      expect(:patch => '/loan_ledger_ins/11/receive').to route_to({
        controller: 'loan_ledger_ins', action: 'receive', id: '11'
      })
    end

    it 'path' do
      expect(controller.receive_loan_ledger_in_path(1)).to eq('/loan_ledger_ins/1/receive')
    end
  end

end
