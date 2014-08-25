class CustomersController < ApplicationController
  layout "main_page"
  before_filter :authorize, :authorize_company
  before_action :authorize_level, only: [:create, :new, :update, :destroy, :delete, :edit]
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  
  def authorize_level
    if current_user.level != "VE"
      redirect_to customers_path, :alert => "You are not authorized to perform this action!"
    end
  end
  
  def index    
    if params[:stat].nil? || params[:stat] == '1'
      @archive_value = [true, false]
      if current_user.level != "VE"
        @customer = current_user.customers.where(status: true)
      else
        @customer = Customer.where(status: true)
      end
    else 
      @archive_value = [false, true]
      if current_user.level != "VE"
        @customer = current_user.customers.all
      else
        @customer  = Customer.all
      end
    end
  end
  
  def show
    if current_user.level != "VE"
      @customer_all = current_user.customers.all
      if (@customer_all.include?(@customer)) == false
        redirect_to customers_path, :alert => "You are not authorized to perform this action!"
      end
    end  
  end
  
  def edit
  end
  
  def new
    @customer = Customer.new
  end
  
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to customer_path(@customer), notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: customer_path(@customer) }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_path, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  
    def set_customer
      @customer = Customer.find(params[:id])
    end
  
    def customer_params
      params.require(:customer).permit(:name, :adress, :city, :post_code, :country, :web, :mobile, :info, :logo, :status)
    end
end
