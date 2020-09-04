require 'bundler/setup'
Bundler.require

if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
  has_secure_password
  validates :email,
   presence: true
  #validates :password,
  #length: {in: 5..10}
  has_many :credits
  has_many :charges
  has_many :payments
end

class Credit < ActiveRecord::Base
  belongs_to :user
  has_many :charges
end

class Item < ActiveRecord::Base
  belongs_to :shop
  has_many :carts
end

class Shop < ActiveRecord::Base
  has_many :items
end

class Cart < ActiveRecord::Base
  belongs_to :item
  belongs_to :owner
end

class Charge < ActiveRecord::Base
  validates :stored_value,
  presence: true,
  format: {with: /\A[0-9]+\z/}
  belongs_to :credit
  belongs_to :user
end

class Owner < ActiveRecord::Base
  has_many :carts
end

class Payment < ActiveRecord::Base
  validates :stored_value,
  presence: true,
  format: {with: /\A[0-9]+\z/}
  belongs_to :user
end