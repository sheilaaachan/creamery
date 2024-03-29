class Employee < ActiveRecord::Base
  # Callbacks
  before_save :reformat_phone
  before_validation :reformat_ssn

  attr_accessible :role
  
  # Relationships
  has_many :assignments
  has_many :stores, :through => :assignments
  has_many :shifts, :through => :assignments
  has_one :user
  
  # Validations
  validates_presence_of :first_name, :last_name
  validates_date :date_of_birth, :on_or_before => lambda { 14.years.ago }, :on_or_before_message => "must be at least 14 years old"
  validates_format_of :phone, :with => /^\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}$/, :message => "should be 10 digits (area code needed) and delimited with dashes only", :allow_blank => true
  validates_format_of :ssn, :with => /^\d{3}[- ]?\d{2}[- ]?\d{4}$/, :message => "should be 9 digits and delimited with dashes only"
  validates_inclusion_of :role, :in => %w[admin manager employee], :message => "is not an option"
  validates_uniqueness_of :ssn
  
  # Scopes
  scope :younger_than_18, where('date_of_birth > ?', 18.years.ago.to_date)
  scope :is_18_or_older, where('date_of_birth <= ?', 18.years.ago.to_date)
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  scope :regulars, where('role = ?', 'employee')
  scope :managers, where('role = ?', 'manager')
  scope :admins, where('role = ?', 'admin')
  scope :alphabetical, order('last_name, first_name')

  scope :search, lambda { |term| where('first_name LIKE ? OR last_name LIKE ?', "#{term}%", "#{term}%") }

  
  # Other methods
  def name
    "#{last_name}, #{first_name}"
  end
  
  def proper_name
    "#{first_name} #{last_name}"
  end
  
  def current_assignment
    curr_assignment = self.assignments.select{|a| a.end_date.nil?}
    # alternative method for finding current assignment is to use scope 'current' in assignments:
    # curr_assignment = self.assignments.current    # will also return an array of current assignments
    return nil if curr_assignment.empty?
    curr_assignment.first   # return as a single object, not an array
  end
  
  def over_18?
    date_of_birth < 18.years.ago.to_date
  end
  
  def age
    (Time.now.to_s(:number).to_i - date_of_birth.to_time.to_s(:number).to_i)/10e9.to_i
  end

  # hours that an employee has worked in the past 2 weeks
  def employee_hours
    hours = 0
    unless (self.assignments.empty? || self.current_assignment.nil? || self.current_assignment.shifts.empty?)
      self.current_assignment.shifts.completed.each do |shift|
        if [(Date.current - shift.date) <= 14]
          hours += (shift.end_time - shift.start_time)
        end
      end
    end
    (hours *= (-1)) if (hours < 0)
    hours /= 3600
    return hours.to_i
  end

  # a hash of key: employee_id, value: hours_worked
  def self.employee_hours_hash
    hash = Hash.new()
    Employee.active.alphabetical.all.each do |employee|
      hash[employee] = employee.employee_hours
    end
    hash = hash.sort_by { |k,v| v }.reverse
    keys = []
    hash.each do |pair|
      keys.push(pair[0])
    end
    return keys
  end


  
  # Misc Constants
  ROLES_LIST = [['Employee', 'employee'],['Manager', 'manager'],['Administrator', 'admin']]
  
  
  # Callback code  (NOT DRY!!!)
  # -----------------------------
   private
   def reformat_phone
     phone = self.phone.to_s  # change to string in case input as all numbers 
     phone.gsub!(/[^0-9]/,"") # strip all non-digits
     self.phone = phone       # reset self.phone to new string
   end
   def reformat_ssn
     ssn = self.ssn.to_s      # change to string in case input as all numbers 
     ssn.gsub!(/[^0-9]/,"")   # strip all non-digits
     self.ssn = ssn           # reset self.ssn to new string
   end
end
