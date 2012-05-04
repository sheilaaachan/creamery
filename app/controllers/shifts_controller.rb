class ShiftsController < ApplicationController

	# before_filter :check_login
	# authorize_resource

  def index
    @shifts = Shift.upcoming.chronological.paginate(:page => params[:page]).per_page(15)
    @past_shifts = Shift.past.chronological.paginate(:page => params[:page]).per_page(15)
  end

  def show
    @shift = Shift.find(params[:id])
  end

  def new
    if params[:from].nil?
      if params[:id].nil?
        @shift = Shift.new
      else
        @shift = Shift.find(params[:id])
      end
    else
      @shift = Shift.new
      if params[:from] == "store" 
        @shift.store_id = params[:id]
      else
        @shift.employee_id = params[:id]
      end
    end
  end

  def edit
    @shift = Shift.find(params[:id])
  end

  def create
    @shift = Shift.new(params[:shift])
    if @shift.save
      # if saved to database
      flash[:notice] = "#Successfully created a new shift at #{@shift.start_time.strftime("%l:%M %p")} on #{@shift.date.strftime("%m/%d/%y")} for #{@shift.assignment.employee.proper_name}'s current assignment."
      redirect_to @shift # go to show shift page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @shift = Shift.find(params[:id])
    if @shift.update_attributes(params[:shift])
      flash[:notice] = "#Successfully updated the #{@shift.start_time.strftime("%l:%M %p")} shift on #{@shift.date.strftime("%m/%d/%y")} from #{@shift.assignment.employee.proper_name}'s current assignment."
      redirect_to @shift
    else
      render :action => 'edit'
    end
  end

  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy
    flash[:notice] = "#Successfully removed the #{@shift.start_time.strftime("%l:%M %p")} shift on #{@shift.date.strftime("%m/%d/%y")} from #{@shift.assignment.employee.proper_name}'s current assignment."
    redirect_to shifts_url
  end
end
