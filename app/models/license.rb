class License
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include LicensesHelper
  include Mongoid::Timestamps
  field :name, type: String
  field :addres, type: String
  field :license_count, type: Integer
  field :license_restrict, type: String
  field :term_of_license, type: Date
  field :description, type: String
  field :key, type: String
  field :licenses, type: Array, default: []
  field :licensefile, type: BSON::Binary
  field :active, type: Mongoid::Boolean
  field :version, type: String
  field :lshw, type: String
  # before_save :create_host_licenses
  after_create :gen_licensefile
  # after_create :useradd
  belongs_to :order
  validates :name, uniqueness: true, format: { with: /[a-zA-Z0-9а-яА-Я_\.]/ }, presence: true
  validates :license_count, format: { with: /[0-9]/ }, presence: true
  protected

  def create_host_licenses
    lic = {}
    lic["mediaservers"] = license_count.times.map{{uuid: nil}}
    self.licenses = lic
  end
  
  def gen_licensefile
    self.key = create_license(self._id.to_s)
    p self
    self.save
  end
  # def useradd
  # end
  # self.create_host_licenses(self.license_count)
end
