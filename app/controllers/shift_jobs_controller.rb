class ShiftJobsController < ApplicationController

	# before_filter :check_login
	# authorize_resource

  def index
    # get all the data on shift_jobs in the system, 10 per page
    @shift_jobs = ShiftJob.chronological.paginate(:page => params[:page]).per_page(10)
  end

  def show
    # get information on this particular shift_job
    @shift_job = ShiftJob.find(params[:id])
  end

  def new
    @shift_job = ShiftJob.new
  end

  def edit
    @shift_job = ShiftJob.find(params[:id])
  end

  def create
    @shift_job = ShiftJob.new(params[:shift_job])
    if @shift_job.save
      flash[:notice] = "Successfully created shift_job."
      redirect_to @shift_job
    else
      render :action => 'new'
    end
  end

  def update
    @shift_job = ShiftJob.find(params[:id])
    if @shift_job.update_attributes(params[:shift_job])
      flash[:notice] = "Successfully updated shift_job."
      redirect_to @shift_job
    else
      render :action => 'edit'
    end
  end

  def destroy
    @shift_job = ShiftJob.find(params[:id])
    @shift_job.destroy
    flash[:notice] = "Successfully destroyed shift_job."
    redirect_to shift_jobs_url
  end
end