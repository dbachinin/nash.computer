class Client
  include Mongoid::Document
  field :f_name, type: String
  field :l_name, type: String
  field :address, type: String
  field :phone, type: String
  field :ips, type: Array
end
