class StoresController < ApplicationController

  before_filter :check_login, :except => :index, :except => :show

  def index
    @stores = Store.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_stores = Store.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    authorize! :index, @user
  end

  def show
    @store = Store.find(params[:id])
    # get all the current assignments for this store
    @current_assignments = @store.assignments.current.by_employee.paginate(:page => params[:page]).per_page(8)
  end

  def new
    @store = Store.new
    authorize! :new, @user
  end

  def edit
    @store = Store.find(params[:id])
    authorize! :edit, @user
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      # if saved to database
      flash[:notice] = "Successfully created #{@store.name}."
      redirect_to @store # go to show store page
    else
      # return to the 'new' form
      render :action => 'new'
    end
    authorize! :create, @user
  end

  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      flash[:notice] = "Successfully updated #{@store.name}."
      redirect_to @store
    else
      render :action => 'edit'
    end
    authorize! :update, @user
  end

  def destroy
    @store = Store.find(params[:id])
    @store.destroy
    flash[:notice] = "Successfully removed #{@store.name} from the AMC system."
    redirect_to stores_url
    authorize! :destroy, @user
  end
end
