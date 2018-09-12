class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  field :pre, type: Mongoid::Boolean, default: true
  field :taryph_id, type: String
  field :sp_ids, type: Array, default: []
  belongs_to :user
  has_one :license, autosave: true, dependent: :destroy, inverse_of: :order
end
