class DefaultEmployee < ActiveRecord::Migration
    def up
    emp = User.new
    # employee.first_name = "Benoit"
    # employee.last_name = "Morel"
    emp.email = "benoit@andrew.cmu.edu"
    emp.password = "secret"
    emp.password_confirmation = "secret"
    emp.employee_id = 221
    emp.employee.role = "employee"
    emp.save!
  end

  def down
    emp = User.find_by_email "benoit@andrew.cmu.edu"
    User.delete emp
  end
end
