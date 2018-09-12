class OsBuild
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  field :name, type: String
  field :price, type: String
  field :description, type: String
  field :sleep, type: BSON::Binary, default: false
  field :options, type: Array
end
