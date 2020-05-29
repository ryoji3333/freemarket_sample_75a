class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :user
  belongs_to :category
  belongs_to_active_hash :condition
  
  has_many :images
  accepts_nested_attributes_for :images, allow_destroy: true

  validates :images, length: { minimum: 1, maximum: 10 }
  validates :item_name, presence: true
  validates :explanation, presence: true
  validates :price, presence: true
  validates :condition, presence: true
  validates :ship_date, presence: true
  validates :delivery_fee, presence: true
  validates :user_id, presence: true
  validates :category_id, presence: true
  
end
