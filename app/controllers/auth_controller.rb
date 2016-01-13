class AuthController < ApplicationController
  def new
    redirect_to auth.url
  end

  def callback
    token = auth.callback params
    session[:account_id] = token.account_id
    redirect_to root_path
  end

  def destroy
    session.delete :account_id
    redirect_to root_path
  end

  private

  def auth
    $dwolla.auths.new redirect_uri: callback_url,
                      scope: "ManageCustomers|Funding"
  end
end
