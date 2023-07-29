class UsersController < ApplicationController
  layout "main" 
  before_action :set_user, only: %i[ show edit update destroy]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
 def show
  logger.debug"hohoohh"

  if params[:id] == 'listuser'
    @user = nil
  else
    @user = User.find(params[:id])
  end
end

def dashboard
  @user = current_user
  @config = Configuration.available_modules
  @employee = @user.employee_record if ['employee', 'admin'].include?(@user.role_name.downcase)

  if @user.student?
    @student = Student.find_by(admission_no: @user.username)
    @student = @user.student_record if @student.nil?
    @batch = Student.find_by(user_id: @user.id)&.batch
    @mobility = Mobility.find_by_sql("SELECT * FROM mobilities WHERE school_year = #{batch.get_batch_year.to_i}") if @batch
  end

  if @user.parent?
    @student = Student.find_by(admission_no: @user.username[1..]) if @user.username.present?
  end

  # Other code for dash_news goes here
end


  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users or /users.json
    def create
  @user = User.new(user_params)
  logger.debug"$$$$$$$"
  logger.debug  @user.inspect
   puts @user.admin
  puts @user.student
  puts @user.employee


  # Set additional attributes based on role
  if params[:role]='admin'
    logger.debug"HHHHHH"
    @user.admin = true
  elsif params[:role]='employee'
    @user.employee = true
    logger.debug"HHHHHH"
  else  
    @user.student = true
    logger.debug"HHHHHH"
  end

  if @user.save
    # User successfully created
    redirect_to dashboard_path
  end
end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end
def all
    @users = User.all
    logger.debug"hhhhh"
  end
  



def listuser
  logger.debug"kokokokokok"
  if params[:role] == 'admin'
 @users = User.where(admin: true).order(first_name: :asc)
logger.debug"lllllllllllllllllllll"
    render(:update) do |page|
      render partial: 'users/user'
    end
  elsif params[:role] == 'employee'
    render(:update) do |page|
      render partial:'users/employee_user'
    end
  elsif params[:role] == 'student'
    render(:update) do |page|
     render partial: 'users/student_user'
    end
  elsif params[:role].blank?
    @users = ""
    render(:update) do |page|
     render partial: 'users/user'
    end
  end
end




 def list_employee_user
    emp_dept = params[:dept_id]
    @employee = Employee.find_all_by_employee_department_id(emp_dept, :order =>'first_name ASC')
    @users = @employee.collect { |employee| employee.user}
    @users = @users.sort_by { |e| e.last_name }
    @users.delete(nil)
    render(:update) {|page| page.replace_html 'users', partial: 'users'}
  end
  def list_student_user
    batch = params[:batch_id]
    @student = Student.find_all_by_batch_id(batch, :conditions => { :is_active => true },:order =>'first_name ASC')
    @users = @student.collect { |student| student.user}
    @users = @users.sort_by { |e| e.last_name }
    @users.delete(nil)
    render(:update) {|page| page.replace_html 'users', :partial=> 'users'}
  end

  def list_parent_user
    batch = params[:batch_id]
    @guardian = Guardian.find(:all, :select=>'guardians.*',:joins=>'INNER JOIN students ON students.id = guardians.ward_id', :conditions => 'students.batch_id = ' + batch + ' AND is_active=1',:order =>'first_name ASC')
    users = @guardian.collect { |g| g.user}
    users.compact!
    @users  = users.paginate(:page=>params[:page],:per_page=>20)
    render(:update) {|page| page.replace_html 'users', :partial=> 'users'}
  end


 def dashboard
    @user = current_user
    @config = Configuration.available_modules
    @employee = @user.employee_record if ['employee','admin'].include?(@user.role_name.downcase)
    if @user.student?
      @student = Student.find_by_admission_no(@user.username)
  @student = @user.student_record
      # @batch_year = Student.find_by_user_id(@user.id).batch.get_batch_year


     @batch = Student.find_by_user_id(@user.id).batch 
      @mobility = Mobility.find_by_sql("select * from mobilities where school_year =#{@batch.get_batch_year.to_i}")


    end
    if @user.parent?
      @student = Student.find_by_admission_no(@user.username[1..@user.username.length])
    end
    #    @dash_news = News.find(:all, :limit => 3)
  end


  def search_user_ajax
    unless params[:query].nil? or params[:query].empty? or params[:query] == ' '
      #      if params[:query].length>= 3
      #        @user = User.first_name_or_last_name_or_username_begins_with params[:query].split
      @user = User.find(:all,
        :conditions => "(first_name LIKE \"#{params[:query]}%\"
                       OR last_name LIKE \"#{params[:query]}%\"
                       OR (concat(first_name, \" \", last_name) LIKE \"#{params[:query]}%\")
                       OR username LIKE  \"#{params[:query]}\")",
        :order => "first_name asc") unless params[:query] == ''
      #      else
      #        @user = User.first_name_or_last_name_or_username_equals params[:query].split
      #      end
      #      @user = @user.sort_by { |u1| [u1.role_name,u1.full_name] } unless @user.nil?
    else
      @user = ''
    end
    render :layout => false
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
       if params[:id] == 'listuser'
         @user = nil
         else
    # Find the user based on the ID
    @user = User.find(params[:id])
    end
end
    # Only allow a list of trusted parameters through.
    def user_params
  params.require(:user).permit(:username, :last_name, :first_name,  :email, :password, :password_confirmation,  :admin , :student , :employee , :role)
end
end
