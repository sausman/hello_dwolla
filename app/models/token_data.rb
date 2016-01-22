class TokenData < ActiveRecord::Base
  DESIRED_FRESHNESS = 1.minute

  attr_encrypted :access_token, :key => 'a secret key', :mode => :per_attribute_iv_and_salt
  attr_encrypted :refresh_token, :key => 'a secret key', :mode => :per_attribute_iv_and_salt

  def self.fresh_token_by! criteria
    where(criteria)
      .order(created_at: :desc)
      .first!
      .to_fresh_token
  end

  def expired?
    created_at < Time.now.utc - expires_in.seconds + DESIRED_FRESHNESS
  end

  def to_fresh_token
    if expired?
      $dwolla.auths.refresh self
    else
      $dwolla.tokens.new self
    end
  end
end
