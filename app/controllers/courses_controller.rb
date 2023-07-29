#FEDENA
#Copyright 2011 Cactus IT Technologies Private Limited
#
#This product includes software developed at
#Project FEDENA - http://www.projectFEDENA.org/
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

class CoursesController < ApplicationController
  layout "main"
  #before_action :login_required
  before_action :find_course, :only => [:show, :edit, :update, :destroy]
  #filter_access_to :all
  #has_many :batches

  def index
    logger.debug"pppppppp"
    @courses = Course.active
  end
 def importsubjects
   @batches = Batch.all
   Rails.logger.info "KOMPL 50"


    filename="#{RAILS_ROOT}/public/uploads/File/FSO-Wail.csv"
    require 'faster_csv'
  Rails.logger.info
  @sub = 0;
    @n_sub = 0;

@ct = 0;
   FasterCSV.foreach(filename,  :col_sep =>',', :row_sep =>:auto) do |row|
    @ct = @ct + 1
    if(@ct>1)
        if row[6].include? "/"
      subject = Subject.find(:first,:conditions => ["(name LIKE ?)",row[6].split("/")[0]])
      subject2 = Subject.find(:first,:conditions => ["(name LIKE ?)",row[6].split("/")[1]])

    else
      subject = Subject.find(:first,:conditions => ["(name LIKE ?)",row[6]])

    end
  if row[6].include? ","
      subject = Subject.find(:first,:conditions => ["(name LIKE ?)",row[6].split(",")[0]])
      subject2 = Subject.find(:first,:conditions => ["(name LIKE ?)",row[6].split(",")[1]])

    else
      subject = Subject.find(:first,:conditions => ["(name LIKE ?)",row[6]])

    end
      if row[5] != nil
      if row[5].include? "/"
        employee = Employee.find(:first,:conditions => ["(first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ? OR employee_number LIKE ?)",row[5].split("/")[0],row[5].split("/")[0],row[5].split("/")[0],row[5].split("/")[0]])
        employee2 = Employee.find(:first,:conditions => ["(first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ? OR employee_number LIKE ?)",row[5].split("/")[1],row[5].split("/")[1],row[5].split("/")[1],row[5].split("/")[1]])
      #  employee = Employee.find_by_last_name( row[5].split("/")[0] )

else
  employee = Employee.find(:first,:conditions => ["(first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ? OR employee_number LIKE ?)",row[5],row[5],row[5],row[5]])

  #employee = Employee.find_by_last_name( row[5])

end
 if row[5].include? " "
        employee = Employee.find(:first,:conditions => ["(first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ? OR employee_number LIKE ?)",row[5].split(" ")[0],row[5].split(" ")[0],row[5].split(" ")[0],row[5].split(" ")[0]])
        employee2 = Employee.find(:first,:conditions => ["(first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ? OR employee_number LIKE ?)",row[5].split(" ")[1],row[5].split(" ")[1],row[5].split(" ")[1],row[5].split(" ")[1]])
      #  employee = Employee.find_by_last_name( row[5].split("/")[0] )

else
  employee = Employee.find(:first,:conditions => ["(first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ? OR employee_number LIKE ?)",row[5],row[5],row[5],row[5]])

  #employee = Employee.find_by_last_name( row[5])

end
end
if(subject!=nil)
  @sub = @sub + 1
      Rails.logger.info @sub


else
 @n_sub = @n_sub + 1
      Rails.logger.info @n_sub
end
 if(employee != nil && subject!=nil )
      if row[5].include? "/"
        if(employee2 != nil)
        es = EmployeesSubject.new(:employee_id => employee2.id,:subject_id => subject.id)
      es.save
        Rails.logger.info  employee2.first_name + employee2.last_name
       Rails.logger.info subject.name
     end
      end
      if row[6].include? "/"
        if(subject2 != nil)
        es = EmployeesSubject.new(:employee_id => employee2.id,:subject_id => subject2.id)
      es.save
      #  Rails.logger.info  employee2.first_name + employee2.last_name
       Rails.logger.info subject2.name
     end
      end
      es = EmployeesSubject.new(:employee_id => employee.id,:subject_id => subject.id)
    es.save
     Rails.logger.info  employee.first_name + employee.last_name
    Rails.logger.info subject.name
   end
  
    if(employee == nil && subject != nil )
      Rails.logger.info "************//////*************//////***********"
     empl = Employee.new( :employee_category_id=>2, :employee_number=>row[5], :joining_date=>"2018-02-02", :first_name=>row[5], :middle_name=>"", :last_name=> row[5], :gender=>true, :job_title=> "", :employee_position_id=> 2, :employee_department_id=> 4, :reporting_manager_id => nil, :employee_grade_id=>4, :qualification=> "",:experience_detail=> "", :experience_year=> nil,:experience_month=>nil, :status=>true,:status_description=>nil, :date_of_birth=>"2008-02-02",:marital_status=> "single",:children_count=> nil, :father_name=> "", :mother_name=> "", :husband_name=> "", :blood_group=> "Inconnu", :nationality_id=>120, :home_address_line1=> nil,:home_address_line2=> nil, :home_city=>nil, :home_state=>nil, :home_country_id=>nil, :home_pin_code=> nil, :office_address_line1=>nil, :office_address_line2=> nil, :office_city=>nil, :office_state=>nil, :office_country_id=>nil, :office_pin_code=>nil, :office_phone1=> nil, :office_phone2=>nil, :mobile_phone=>nil, :home_phone=>nil,:email=> "test.test@insea.ac.ma", :fax=> nil, :photo_file_name=> nil, :photo_content_type=> nil, :photo_data=> nil, :photo_file_size=> nil, :user_id=> nil).save

#empl = Employee.new(:last_name => row[5] ,:first_name => row[5])
#empl.save
      es = EmployeesSubject.new(:employee_id => empl.id,:subject_id => subject.id)

    end

  if(row[5] != nil)
    if(row[5].include? "all")
    	      

    	if(subject.id != nil)
Employee.all.each do |em|

	es = EmployeesSubject.new(:employee_id => em.id,:subject_id => subject.id)
	es.save
end
end
end
 if(row[5].include? "dss")
    	      

    	if(subject.id != nil)
Employee.all.each do |em|

	es = EmployeesSubject.new(:employee_id => em.id,:subject_id => subject.id)
	es.save
end
end
end
end
end
   end
   #redirect_to :back
  end

  def new
    @course = Course.new
    @grade_types=Course.grading_types_as_options
    @school_fields=SchoolField.all
#    gpa = Configuration.find_by_config_key("GPA").config_value
#    if gpa == "1"
#      @grade_types << "GPA"
#    end
#    cwa = Configuration.find_by_config_key("CWA").config_value
#    if cwa == "1"
#      @grade_types << "CWA"
#    end
  end


  def manage_course
    @courses= Course.all
   
  end

  def manage_batches

  end
  def rechercher_par_filiere

    @school_fields = SchoolField.find(:all,  :order => "name")
    
  end
  def show_classes
    @school_field_id=params[:filiere_id]
    @school_year=params[:school_year]
    logger.debug"******************#{params[:filiere_id]}***********************"
    logger.debug"******************#{@school_field_id}***********************"
    @batches = Batch.find_all_by_school_field_id(@school_field_id).reject { |t| t.get_batch_year != @school_year.to_i }
     logger.debug"************************************************************** "
      logger.debug @batches.inspect
       render(:update) do|page|
        page.replace_html "show_classes", :partial=>"show_classe"
        
      end
  end

  def grouped_batches
  @course = Course.find(params[:id])
  @batch_groups = @course.batch_groups
  @batches = @course.batches.where(is_active: true, is_deleted: false)
                            .left_outer_joins(:grouped_batches)
                            .where(grouped_batches: { batch_id: nil })
  @batch_group = BatchGroup.new
end

  def create_batch_group
    @batch_group = BatchGroup.new
    @batch_group.name= params[:name]
    @course = Course.find(params[:course_id])
    @batch_group.course_id = @course.id
    #@batch_group.save
    if ! @batch_group.save
      error_messages = @batch_group.errors.full_messages.join(", ")
      Rails.logger.error("Failed to save student. Errors: #{error_messages}")
    end
    @error=false

    if params[:batch_ids].blank?
      @error=true
    end
    logger.debug"gggggggzlekggggggggg"
    if @batch_group.valid? and @error==false
      @batch_group.save
      batches = params[:batch_ids]
      batches.each do|batch|
        GroupedBatch.create(:batch_group_id=>@batch_group.id,:batch_id=>batch)
         logger.debug"gggggggg--------------gggggggg"
      end
      @batch_group = BatchGroup.new
      @batch_groups = @course.batch_groups
      @batches = @course.active_batches.reject{|b| GroupedBatch.exists?(:batch_id=>b.id)}
      render(:update) do|page|
        page.replace_html "category-list", :partial=>"batch_groups"
        page.replace_html 'flash', :text=>'<p class="flash-msg"> Batch Group created successfully. </p>'
        page.replace_html 'errors', :partial=>"form_errors"
        page.replace_html 'class_form', :partial=>"batch_group_form"
      end
      logger.debug"gggggggg-------666666666-------gggggggg"
    else
      if params[:batch_ids].blank?
        @batch_group.errors.add_to_base "Atleast one batch must be selected."
      else
        abort @batch_group.valid?
      end
    end
  end

  def edit_batch_group
    @batch_group = BatchGroup.find(params[:id])
    @course = @batch_group.course
    @assigned_batches = @course.active_batches.reject{|b| (!GroupedBatch.exists?(:batch_id=>b.id,:batch_group_id=>@batch_group.id))}
    @batches = @course.active_batches.reject{|b| (GroupedBatch.exists?(:batch_id=>b.id))}
    @batches = @assigned_batches + @batches
    render(:update) do|page|
      page.replace_html "class_form", :partial=>"batch_group_edit_form"
      page.replace_html 'errors', :partial=>'form_errors'
      page.replace_html 'flash', :text=>""
    end
  end

  def update_batch_group
    @batch_group = BatchGroup.find(params[:id])
    @course = @batch_group.course
    unless params[:batch_ids].blank?
      if @batch_group.update_attributes(params[:batch_group])
        @batch_group.grouped_batches.map{|b| b.destroy}
        batches = params[:batch_ids]
        batches.each do|batch|
          GroupedBatch.create(:batch_group_id=>@batch_group.id,:batch_id=>batch)
        end
        @batch_group = BatchGroup.new
        @batch_groups = @course.batch_groups
        @batches = @course.active_batches.reject{|b| GroupedBatch.exists?(:batch_id=>b.id)}
        render(:update) do|page|
          page.replace_html "category-list", :partial=>"batch_groups"
          page.replace_html 'flash', :text=>'<p class="flash-msg"> Batch Group updated successfully. </p>'
          page.replace_html 'errors', :partial=>"form_errors"
          page.replace_html 'class_form', :partial=>"batch_group_form"
        end
      else
        render(:update) do|page|
          page.replace_html 'errors', :partial=>'form_errors'
          page.replace_html 'flash', :text=>""
        end
      end
    else
      @batch_group.errors.add_to_base("Atleat one Batch must be selected.")
      render(:update) do|page|
        page.replace_html 'errors', :partial=>'form_errors'
        page.replace_html 'flash', :text=>""
      end
    end
  end

  def delete_batch_group
    @batch_group = BatchGroup.find(params[:id])
    @course = @batch_group.course
    @batch_group.destroy
    @batch_group = BatchGroup.new
    @batch_groups = @course.batch_groups
    @batches = @course.active_batches.reject{|b| GroupedBatch.exists?(:batch_id=>b.id)}
    render(:update) do|page|
      page.replace_html "category-list", :partial=>"batch_groups"
      page.replace_html 'flash', :text=>'<p class="flash-msg"> Batch Group deleted successfully. </p>'
      page.replace_html 'errors', :partial=>"form_errors"
      page.replace_html 'class_form', :partial=>"batch_group_form"
    end
  end

  def update_batch
   @batch = Batch.where(course_id: params[:course_name], is_deleted: false, is_active: true)

    render(:update) do |page|
      page.replace_html 'update_batch', partial: 'update_batch'
    end

  end

  def create
  @course = Course.new(course_params)
  logger.debug"hohohohoh"
  if @course.save
    logger.debug"pppppppp"
    flash[:notice] = "#{t('flash1')}"
    redirect_to action: 'manage_courses'
   
  else
    # Handle the case when the course fails to save
    render 'new'
  end
end

  def edit
    logger.debug 'hohohohokokokok'
    #@grade_types=Course.grading_types_as_options
#    @grade_types=[]
#    gpa = Configuration.find_by_config_key("GPA").config_value
#    if gpa == "1"
#      @grade_types << "GPA"
#    end
#    cwa = Configuration.find_by_config_key("CWA").config_value
#    if cwa == "1"
#      @grade_types << "CWA"
#    end

  end
def update
  logger.debug "UUUUUUUUUUUUUUUUUUUUUpdated"
  @course = Course.find(params[:id])
  if @course.update(course_params)
    # Update successful
    flash[:notice] = "#{t('flash2')}"
    redirect_to  manage_courses_path

  else
    # Update failed, re-render the edit form
    @grade_types = Course.grading_types_as_options
    render 'edit'
  end
end

 def destroy
  if params[:id] 
    logger.debug("ooooo")
    @course= Course.find( params[:id])
   #@batch= @course.batches.active
logger.debug("ooo_____________~#{@course.inspect}oo")
@course.destroy
    redirect_to manage_courses_path, status: :see_other
  else
    logger.debug("oooèèèèèèèèèèèèèoo")
    flash[:warn_notice] = "<p>#{t('courses.flash4')}</p>"
    redirect_to manage_courses_path, status: :see_other
  end
end
# def destroy
#   @course = Course.find(params[:id])
#   @batch = @course.batches.active

#   if @batch.empty?
#     @course.destroy
#     logger.debug("ooooo")
#     flash[:notice] = "#{t('flash3')}"
#     redirect_to manage_courses_path, status: :see_other
#   else
#     logger.debug("oooèèèèèèèèèèèèèoo")
#     flash[:warn_notice] = "<p>#{t('courses.flash4')}</p>"
#     redirect_to manage_courses_path, status: :see_other
#   end
# end




 
  def show
    logger.debug"lolololololo#{params[:id]}"
   @course= Course.find( params[:id])
   @batch= @course.batches.active
  #@batches = Course.all
 end



  private
  def find_course
    @course = Course.find params[:id]
  end

def course_params
    params.require(:course).permit(:course_name, :section_name, :code , :batch , :batches_attributes , :start_date , :end_date , :grading_type )
  end
end
