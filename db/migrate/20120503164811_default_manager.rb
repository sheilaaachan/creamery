class DefaultManager < ActiveRecord::Migration
  def up
    manager = User.new
    # manager.first_name = "Elina"
    # manager.last_name = "Kim"
    manager.email = "elina@andrew.cmu.edu"
    manager.password = "secret"
    manager.password_confirmation = "secret"
    manager.employee_id = 220
    manager.employee.role = "manager"
    manager.save!
  end

  def down
    manager = User.find_by_email "elina@andrew.cmu.edu"
    User.delete manager
  end
end
