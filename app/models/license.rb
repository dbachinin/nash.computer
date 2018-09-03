class License
  include Mongoid::Document
  include Mongoid::Timestamps
  field :version, type: String
  field :lshw, type: String
  field :active, type: Mongoid::Boolean
end
