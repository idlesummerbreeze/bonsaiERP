# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ContactAccount < Account
  belongs_to :account, conditions: {staff: false}
end
