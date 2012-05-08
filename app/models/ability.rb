class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    # 
      user ||= User.new # guest user (not logged in)
      if (user.employee.role == "admin")
        # admin has unlimited access in the system. 
        can :manage, :all
      elsif (user.employee.role == "manager")
        # can edit the record of an employee from their store
        can :edit, Employee do |employee|
          my_employees = user.employee.store.employees.map{|p| p.id}
          my_employees.include? employee.id 
        end
        # can view a list of all the employees that work in their store
        can :index, Employee do |employee|
          my_employees = user.employee.store.employees.map{|p| p.id}
          my_employees.include? employee.id 
        end
        # can view the details of an employee in their store
        can :show, Employee do |employee|
          my_employees = user.employee.store.employees.map{|p| p.id}
          my_employees.include? employee.id 
        end
        # can add a new shift to an employee in their store
        # can edit an existing shift to an employee in their store
        # can delete a shift from an employee in their store
        # can list all current and upcoming shifts of employees in their store
        # can list all completed shifts of employees in their store
        # can view the shift details of shifts belonging to employees in their store
        can :manage, Shift do |shift|
          shifts = user.employee.store.shifts.map{|p| p.id}
          shifts.include? shift.id 
        end
        # can view their own employee details
        can :show, Employee do |e|
          e.id == employee.id
        end     
        # can view details for their own shifts
        can :show, Shift do |shift|
          my_shifts = user.shifts.map{|s| s.id}
          my_shifts.include? shift.id 
        end
        # can view the generic home page
        # can view the details page for a particular store
        can :read, Store
        can :manage, Job
      elsif (user.employee.role == "employee")
        # can view their own employee details
        can :show, Employee do |e|
          e.id == employee.id
        end     
        # can view details for their own shifts
        can :show, Shift do |shift|
          my_shifts = user.shifts.map{|s| s.id}
          my_shifts.include? shift.id 
        end
        # can view the generic home page
        # can view the details page for a particular store
        can :read, Store
      else
        # can view the generic home page
        # can view the details page for a particular store
        can :read, Store
      end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
