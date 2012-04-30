class User < ActiveRecord::Base
  # Use built-in rails support for password protection
  has_secure_password
  
  # Specify fields that can be accessible through mass assignment (not password_digest)
  attr_accessible :email, :password, :password_confirmation

  # Relationship
  belongs_to :employee
  
  # Validations
  validates_uniqueness_of :email, :allow_blank => true
  validates_format_of :email, :with => /^[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))$/i, :message => "is not a valid format"
  validate :employee_is_active_in_system
  validates_presence_of :password, :on => :create 
  validates_presence_of :password_confirmation, :on => :create 
  validates_confirmation_of :password, :message => "does not match"
  validates_length_of :password, :minimum => 4, :message => "must be at least 4 characters long", :allow_blank => true
  

  # for use in authorizing with CanCan
  ROLES = [['Employee', :employee],['Manager', :manager],['Administrator', :admin]]

  def role?(authorized_role)
    return false if role.nil?
    role.downcase.to_sym == authorized_role
  end

  # login by email address
  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end
  
  private
  def employee_is_active_in_system
    all_active_employees = Employee.active.all.map{|e| e.id}
    unless all_active_employees.include?(self.employee_id)
      errors.add(:employee_id, "is not an active employee at the creamery")
    end
  end
  
end
