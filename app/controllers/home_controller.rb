class HomeController < ApplicationController
  def index
    if logged_in?
      
      @active_stores = Store.active.alphabetical.paginate(:page => params[:page]).per_page(10)
      @active_employees = Employee.active.alphabetical.paginate(:page => params[:page]).per_page(10)
      
      @last_shift = Shift.completed.chronological.reverse
      @todays_shifts = Shift.for_next_days(1).chronological.reverse
      @current_store = current_user.employee.current_assignment.store

      end
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
  def search
    @query = params[:query]
    @employees = Employee.search(@query)
    @stores = Store.search(@query)
    @total_hits = @employees.size + @stores.size
  end

end