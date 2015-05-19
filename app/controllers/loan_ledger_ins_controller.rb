class LoanLedgerInsController < ApplicationController
  before_action :ledger_form
  before_action :check_loan_give, only: [:new_give, :give]
  before_action :check_loan_receive, only: [:new_receive, :receive]

  # GET
  def new_give
  end

  # PATCH
  def give
  end

  # GET
  def new_receive
  end

  # PATCH
  def receive
  end

  private

    def loan
      @_loan ||= Loan.find(params[:id])
    end

    def ledger_form
      @ledger_form ||= LoanLedgerInForm.new(loan_id: loan.id)
    end

    def check_loan_give
      unless loan.is_a?(Loans::Give)
        redirect_to loans_path, status: STATUS_ERROR
      end
    end

    def check_loan_receive
      unless loan.is_a?(Loans::Receive)
        redirect_to loans_path, status: STATUS_ERROR
      end
    end

    def ledger_params
      {}
    end

    def form_url
      if %w(new_give give).include?(action_name)
        give_loan_ledger_in_path(ledger_form.loan_id)
      else
        receive_loan_ledger_in_path(ledger_form.loan_id)
      end
    end
    helper_method :form_url
    
end
