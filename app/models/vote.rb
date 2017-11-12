class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :user, uniqueness: { scope: [:voteable_type, :voteable_id] }
end