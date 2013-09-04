# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class AccountLedgerPresenter < BasePresenter

  def initials(name)
    name.split(' ').map(&:first).join('')
  end

  def status_text
    case status
    when 'pendent' then 'Pendiente'
    when 'approved' then 'Aprobado'
    when 'nulled' then 'Anulado'
    end
  end

  def status_tag
    case status
    when 'pendent'
      html = ["<span class='label label-warning'>", icon_tag(class: 'icon-warning-sign'),
              " Pendiente</span>"].join('')
    when 'approved'
      html = "<span class='b bonsai-dark'>Aprobado</span>"
    when 'nulled'
      html = "<span class='b red2'>Anulado</span>"
    end

    html.html_safe
  end

  def operation_label
    html = case to_model.operation
           when 'payin', 'intin'
             "<span class='label-success' >#{operation}</span>"
           when 'payout', 'devin'
             "<span class='label' >#{operation}</span>"
           when 'trans'
             "<span class='label' >#{operation}</span>"
           end

    html.html_safe
  end

  # Presents the amount referencing an account
  def amount_ref(ac_id = nil)
    case to_model.operation
    when 'payin', 'payout', 'devin', 'devout'
      amount
    when 'trans'
      if inverse?
        ac_id == account_id ? -amount_currency : amount
      else
        ac_id == account_id ? -amount_currency : amount
      end
    end
  end

  def currency_ref(ac_id = nil)
    ac_id == to_model.account_to_id ? currency : account_currency
  end

  def account_contact_tag
    html = ""
    if account_contact
      html << "<i class='icon-user'></i> #{account_contact}"
    end

    html.html_safe
  end

  def operation_text
    case operation
    when 'payin'  then 'Cobro ingreso'
    when 'intin'  then 'Cobro Intereses'
    when 'payout' then 'Pago egreso'
    when 'intout' then 'Pago Intereses'
    when 'devin'  then 'Devolución ingreso'
    when 'devout' then 'Devolución egreso'
    when 'trans'  then 'Transferencia'
    end
  end

  def account_text
    case operation
    when 'payin', 'devin'  then 'Ingreso'
    when 'payout', 'devout' then 'Egreso'
    when 'trans'  then 'Cuenta'
    end
  end

  def operation_tag
    case operation
    when 'payin', 'intin'
      text_green operation_text
    when 'payout', 'intout', 'devin', 'devout'
      text_red operation_text
    when 'trans'
      text_dark operation_text
    end
  end

  def operation_tag
    case operation
    when 'payin', 'devout'
      text_green_dark(operation_text)
    when 'payout', 'devin'
      text_red(operation_text)
    when 'trans'
      text_dark(operation_text)
    end
  end

  def account_icon(ac)
    case ac.class.to_s
    when 'Cash'    then icon_tag(class: "icon-money", title: "Efectivo")
    when 'Bank'    then icon_tag(class: "icon-building", title: "Banco")
    when 'Income'  then icon_tag(class: "icon-file", title: "Ingreso")
    when 'Expense' then icon_tag(class: "icon-file", title: "Egreso")
    end
  end

  def trans_amount
    if is_account?
      to_model.amount
    else
      -to_model.amount
    end
  end

  def trans_currency
    if is_account?
      account_currency
    else
      currency
    end
  end

  def trans_operation_tag
    if is_account?
      operation_tag
    else
      op = case to_model.operation
      when 'payin' then 'payout'
      when 'payout' then 'payin'
      end
      operation_tag(op)
    end
  end

  def trans_currency?
    is_account? ? same_currency? : true
  end

  def trans_account
    if is_account?
      account_to
    else
      account
    end
  end

  def trans_account_tag
    "#{account_icon trans_account} #{trans_account}".html_safe
  end

private
  def icon_tag(attrs = {})
    tit = "title='#{attrs[:title]}'" if attrs[:title]
    tog = " data-toggle='tooltip'" if tit
    "<i class='#{attrs[:class]}' #{tit} #{tog}></i>"
  end
end
