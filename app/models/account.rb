class Account
  class << self
    def all
      PaypalAccount.all.
        concat(JustgivingAccount.all).
        sort_by(&:created_at)
    end

    def find(type_slash_id)
      type, id = type_slash_id.split('/')
      type.constantize.send(:find, id)
    end
  end
end
