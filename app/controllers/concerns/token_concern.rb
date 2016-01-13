module TokenConcern
  extend ActiveSupport::Concern

  included do
    helper_method :logged_in?
    helper_method :token
    helper_method :account
  end

  private

  def logged_in?
    session[:account_id] != nil
  end

  def token
    raise "not logged in" unless logged_in?

    @token ||= TokenData.fresh_token_by! account_id: session[:account_id]
  end

  def account
    if logged_in?
      @account ||= token.get "accounts/#{token.account_id}"
    end
  end
end
