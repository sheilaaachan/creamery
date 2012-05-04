class JobsController < ApplicationController

	before_filter :check_login
	authorize_resource

  def index
    @jobs = Job.active.alphabetical.paginate(:page => params[:page]).per_page(15)
    @inactive_jobs = Job.inactive.alphabetical.paginate(:page => params[:page]).per_page(15)
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    if params[:from].nil?
      if params[:id].nil?
        @job = Job.new
      else
        @job = Job.find(params[:id])
      end
    else
      @job = Job.new
      if params[:from] == "store" 
        @job.store_id = params[:id]
      else
        @job.employee_id = params[:id]
      end
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(params[:job])
    if @job.save
      # if saved to database
      flash[:notice] = "Successfully created the job #{@job.name}."
      redirect_to @job # go to show job page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      flash[:notice] = "Successfully updated the job #{@job.name}."
      redirect_to @job
    else
      render :action => 'edit'
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    flash[:notice] = "Successfully removed the job #{@job.name}."
    redirect_to jobs_url
  end
end
