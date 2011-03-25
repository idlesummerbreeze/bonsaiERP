# encoding: utf-8
module TransactionsHelper
  def cash(cash)
    if cash
      "al contado"
    else
      "a crédito"
    end
  end

  def total_currency(transaction)
    ntc(transaction.total_currency) unless session[:organisation][:currency_id] == transaction.currency_id
  end

  # Transforms to the default currency
  # @param Transaction
  # @param Symbol
  # @param Hash
  # @return String
  def exchange(klass, method, currencies)
    unless klass.currency_id == currency_id
      rate = currencies[klass.currency_id].round(2)
      ntc(klass.send(method) * rate)
    else
      ntc(klass.send(method))
    end
  end

  def show_money(klass, amount, options = {})
    options = {:precision => 2}.merge(options)
    unless klass.currency_id == session[:organisation][:currency_id]
      "#{ klass.currency_symbol } #{number_to_currency amount, options}"
    else
      number_to_currency(amount, options)
    end
  end

  # Adds the currency to the label
  # @param String
  # @param Object [Transaction, Payment, PayPlan, ..]
  def currency_label(text_label, klass)
    "#{text_label} (#{klass.currency_symbol} #{klass.currency_name.pluralize})"
  end

  def list_taxes(klass)
    klass.taxes.map(&:abbreviation).join(" + ")
  end

  # Indicates if there was a price change only for Income
  def price_change(klass)
    if klass.changed_price?
      "<span class='dark' title='Precio original: #{ntc klass.original_price}' >#{ntc klass.price}</span>".html_safe
    else
      ntc klass.price
    end
  end

  # Label for contacts in transaction form
  def contact_label
    if params[:controller] == 'incomes'
      "Cliente"
    else
      "Proveedor"
    end
  end

  # Returns the path for contacts
  def cont_path
    if params[:controller] == 'incomes'
      "/clients"
    else
      "/suppliers"
    end
  end

  # Returns the title for transaction
  def transaction_title(klass)
    case klass.type
    when "Income"
      if klass.draft?
        "Proforma de venta"
      else
        "Nota de venta"
      end
    when "Buy" then "Nota de compra"
    when "Expense" then "Nota de gasto"
    end
  end

  def transaction_type
    case params[:controller]
    when "incomes"  then "Ventas"
    when "buys"     then "Compras"
    when "expenses" then "Gastos"
    end
  end

  # Returns if the organisation has to pay or recive a payment
  def transaction_pay_method
    if params[:controller] == "incomes"
      "Cobros"
    else
      "Pagos"
    end
  end

end
