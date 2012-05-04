class DefaultAdmin < ActiveRecord::Migration
  def up
    admin = User.new
    # admin.first_name = "Sheila"
    # admin.last_name = "Chan"
    admin.email = "sheilach@andrew.cmu.edu"
    admin.password = "secret"
    admin.password_confirmation = "secret"
    admin.employee_id = 219
    admin.employee.role = "admin"
    admin.save!
  end

  def down
    admin = User.find_by_email "sheilach@andrew.cmu.edu"
    User.delete admin
  end
end
