class UsersController < Clearance::UsersController
  layout "main_page"
  before_filter :authorize, :authorize_company
  before_action :set_user, only: [:show, :index, :edit, :update, :destroy]
  before_action :authorize_level, only: [:edit, :update, :destroy, :delete]

  def authorize_level
    if @user != current_user && current_user.level != "VE"
      redirect_to users_path, :alert => "You are not authorized to perform this action!"
    end
  end
  
  def index
    if params[:stat].nil? || params[:stat] == '1'
      @users = User.where(status: true)
      @archive_value = [true, false]
    else
      @users = User.all
      @archive_value = [false, true]
    end
  end
  
  def show
  end
  
  def edit
    #render :layout => "main_page"
  end
  
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path(@user), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: user_path(@user) }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
    
  private
  
    def set_user      
      begin
        @user = User.find(params[:id])
      rescue
        @user = current_user
      else
        @user = User.find(params[:id])
      end  
    end
    
    def user_params
      params.require(:user).permit(:first_name, :last_name, :position, :department, :work_day, :photo, :level, :email, :city, :title, :acquirements, :status)
    end
end
