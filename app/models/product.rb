class Product < ActiveRecord::Base
  before_create :generate_access_token
  before_create :set_expiration

  def expired?
    self.token_created_at + 1 < DateTime.now
  end

  def with_unexpired_token(access_token, period)
    where(access_token: token).where('token_created_at >= ?', period).first
  end

  def invalidate_token
    update_columns(access_token: nil)
    touch(:token_created_at)
  end

  def make_access_token
    return if self.access_token
    generate_access_token
    update_columns(access_token: self.access_token)
    touch(:token_created_at)
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  def set_expiration
    self.token_created_at = DateTime.now
  end
end
