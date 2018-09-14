class Taryph
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  field :options, type: Array, default: []
  field :price, type: String, default: '0'
  field :name, type: String
  field :period, type: String
  field :description, type: String
  field :sleep, type: BSON::Binary, default: false
  has_and_belongs_to_many :sp
end
