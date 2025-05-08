class Address
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :address_line_1, :address_line_2, :city, :state, :zip
  attr_accessor :name
  attr_reader   :errors

  validates_presence_of :address_line_1, :city, :state, :zip

  def initialize(attributes = {})
    @errors = ActiveModel::Errors.new(self)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def validate!
    errors.add(:name, "cannot be nil") if name.nil?
  end

  def self.human_attribute_name(attr, options = {})
    attr.to_s.humanize
  end
end
