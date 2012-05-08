class Store < ActiveRecord::Base
  # Callbacks
  before_save :find_store_coordinates
  # before_save :create_map_link
  before_save :reformat_phone
  
  # Relationships
  has_many :assignments
  has_many :employees, :through => :assignments
  has_many :shifts, :through => :assignments
  
  
  # Validations
  # make sure required fields are present
  validates_presence_of :name, :street, :city
  # if state is given, must be one of the choices given (no hacking this field)
  validates_inclusion_of :state, :in => %w[PA OH WV], :message => "is not an option"
  # if zip included, it must be 5 digits only
  validates_format_of :zip, :with => /^\d{5}$/, :message => "should be five digits long"
  # phone can have dashes, spaces, dots and parens, but must be 10 digits
  validates_format_of :phone, :with => /^\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}$/, :message => "should be 10 digits (area code needed) and delimited with dashes only"
  # make sure stores have unique names
  validates_uniqueness_of :name

  
  # Scopes
  scope :alphabetical, order('name')
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  scope :search, lambda { |term| where('name LIKE ?', "#{term}%") }

  
  
  # Misc Constants
  STATES_LIST = [['Ohio', 'OH'],['Pennsylvania', 'PA'],['West Virginia', 'WV']]
  
  def self.create_map_link_all(zoom=11, width=500, height=500)
    markers = ""; i = 1
    Store.active.all.each do |store|
      markers += "&markers=color:red%7Ccolor:red%7Clabel:#{i}%7C#{store.lat},#{store.lon}"
      i += 1
    end
    lat = 40.44
    lon = -79.9961
    map = "http://maps.google.com/maps/api/staticmap?center=
      #{lat},#{lon}&zoom=#{zoom}&size=#{width}x#{height}&maptype=roadmap#{markers}&sensor=false"
  end

  def create_map_link(zoom=13, width=500, height=500)
      markers = ""; i = 1
      markers += "&markers=color:red%7Ccolor:red%7Clabel:#{i}%7C#{self.lat},#{self.lon}"
      map = "http://maps.google.com/maps/api/staticmap?center=
      #{self.lat},#{self.lon}&zoom=#{zoom}&size=#{width}x#{height}&maptype=roadmap#{markers}&sensor=false"
  end

  def store_shift_hours
    count = 0
    unless self.assignments.current.empty?
      self.assignments.current.each do |assign|
        count += assign.employee.employee_hours
      end
    end
    return count
  end
  
  # Callback code
  # -----------------------------
  private  
  def find_store_coordinates
    coord = Geokit::Geocoders::GoogleGeocoder.geocode "#{self.street}, #{self.zip}, #{self.state}"
    if coord.success  
      self.lat, self.lon = coord.ll.split(',')
    else
      errors.add_to_base("Error with geocoding")
    end
  end

  # We need to strip non-digits before saving to db
  def reformat_phone
    phone = self.phone.to_s  # change to string in case input as all numbers 
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone = phone       # reset self.phone to new string
  end

end
