class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  field :pre, type: Mongoid::Boolean, default: true
  field :taryph_id, type: String
  belongs_to :user
end
