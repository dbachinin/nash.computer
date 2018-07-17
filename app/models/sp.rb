class Sp
  include Mongoid::Document
  field :name, type: String
  field :price, type: String
  field :spec_act, type: String
  has_and_belongs_to_many :taryph
end
