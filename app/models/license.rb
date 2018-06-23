class License
  include Mongoid::Document
  field :version, type: String
  field :lshw, type: String
  field :active, type: BSON
end
