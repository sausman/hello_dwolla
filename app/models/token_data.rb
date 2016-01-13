class TokenData < ActiveRecord::Base
  DESIRED_FRESHNESS = 1.minute

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
