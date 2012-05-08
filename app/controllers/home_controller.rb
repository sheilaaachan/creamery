class HomeController < ApplicationController
  require 'will_paginate/array'
  def index
    if logged_in?
      @active_stores = Store.active.alphabetical.paginate(:page => params[:page]).per_page(10)
      @current_store = current_user.employee.current_assignment.store unless current_user.employee.current_assignment.nil?

      @active_employees = Employee.active.alphabetical.paginate(:page => params[:page]).per_page(10)
      @star_employees = Employee.star_employees.paginate(:page => params[:page], :per_page => 10)

      @todays_shifts = Shift.for_next_days(1).chronological.reverse
      @incomplete_shifts = Shift.incomplete.chronological.reverse.paginate(:page => params[:page], :per_page => 10)
      @past_shifts = current_user.employee.shifts.past
      @upcoming_shifts = current_user.employee.shifts.for_next_days(14)
    end
    @active_stores2 = Store.active.alphabetical.all
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