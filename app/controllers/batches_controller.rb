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

class BatchesController < ApplicationController
  layout "main"
  before_action :init_data,:except=>[:assign_tutor,:update_employees,:assign_employee,:remove_employee,:batches_ajax]
  #filter_access_to :all
  
  def index
    @batches = @course.batches    
  end

  def new
  @batch = @course.batches.new
  @school_fields = SchoolField.all
end


  def create
  @course=Course.find(params[:course_id])
#logger.debug"hhhhhhh#{@batch.inspect}h"
@batch= Batch.new
  #params.require(:batch).permit(:name, :course_id, :start_date , :end_date , :is_active, :is_deleted , :employee_id , :schooL_field_id , :code_etude , :cycle_id, :is_active_mobilitie) # Replace attribute1, attribute2, attribute3 with the actual attributes of the Batch model
@batch.name= params[:batch][:name]
@batch.start_date= params[:batch][:start_date]
@batch.end_date= params[:batch][:end_date]
@batch.school_field_id= params[:batch][:school_field_id]
@batch.course_id= @course.id
@batch.save
  if @batch.save
    logger.debug"lplplplplp"
    flash[:notice] = "#{t('flash1')}"
    # Rest of your code
  else
   @grade_types = []
    gpa = Rails.configuration.try(:GPA)
    @grade_types << "GPA" if gpa == "1"

    cwa = Rails.configuration.try(:CWA)
    @grade_types << "CWA" if cwa == "1"

    render 'new'
  end
end


  def edit
      @school_fields=SchoolField.all
  end

  def update
    if @batch.update_attributes(params[:batch])
      flash[:notice] = "#{t('flash2')}"
      redirect_to [@course, @batch]
    else
      flash[:notice] ="#{t('flash3')}"
      redirect_to  edit_course_batch_path(@course, @batch)
    end
  end

  def show
    @students = @batch.students.sort_by {|w| w.last_name}
    @students += @batch.old_students
    @students = @students.uniq  
end

  def destroy
    if @batch.students.empty?
      @batch.destroy
      Subject.delete_all("batch_id=#{@batch.id}")
      flash[:notice] = "#{t('flash4')}"
      redirect_to @course
    else
      flash[:warn_notice] = "<p>#{t('batches.flash5')}</p>" unless @batch.students.empty?
      flash[:warn_notice] = "<p>#{t('batches.flash6')}</p>" unless @batch.subjects.empty?
      redirect_to [@course, @batch]
    end
  end

  def assign_tutor
    @batch = Batch.find_by_id(params[:id])
    @assigned_employee = @batch.employee_id.split(",") unless @batch.employee_id.nil?
    @departments = EmployeeDepartment.find(:all)
  end

  def update_employees
    @employees = Employee.find_all_by_employee_department_id(params[:department_id])
    @batch = Batch.find_by_id(params[:batch_id])
    render :update do |page|
      page.replace_html 'employee-list', :partial => 'employee_list'
    end
  end

  def assign_employee
    @batch = Batch.find_by_id(params[:batch_id])
    @employees = Employee.find_all_by_employee_department_id(params[:department_id])
    unless @batch.employee_id.blank?
      @assigned_emps = @batch.employee_id.split(',')
    else
      @assigned_emps = []
    end
    @assigned_emps.push(params[:id].to_s)
    @batch.update_attributes :employee_id => @assigned_emps.join(",")
    @assigned_employee = @assigned_emps.join(",")
    render :update do |page|
      page.replace_html 'employee-list', :partial => 'employee_list'
      page.replace_html 'tutor-list', :partial => 'assigned_tutor_list'
    end
  end

  def remove_employee
    @batch = Batch.find_by_id(params[:batch_id])
    @employees = Employee.find_all_by_employee_department_id(params[:department_id])
    @assigned_emps = @batch.employee_id.split(',')
    @removed_emps = @assigned_emps.delete(params[:id].to_s)
    @assigned_emps = @assigned_emps.join(",")
    @batch.update_attributes :employee_id =>@assigned_emps
    render :update do |page|
      page.replace_html 'employee-list', :partial => 'employee_list'
      page.replace_html 'tutor-list', :partial => 'assigned_tutor_list'
    end
  end

  def batches_ajax
    if request.xhr?
      @course = Course.find_by_id(params[:course_id]) unless params[:course_id].blank?
      @batches = @course.batches.active if @course
      if params[:type]=="list"
        render :partial=>"list"
      end
    end
  end
  private
  def init_data
    @batch = Batch.find params[:id] if ['show', 'edit', 'update', 'destroy'].include? action_name
    @course = Course.find params[:course_id]
  end
  def batch_params
  params.require(:batch).permit(:name, :course_id, :start_date , :end_date , :is_active, :is_deleted , :employee_id , :schooL_field_id , :code_etude , :cycle_id, :is_active_mobilitie) # Replace attribute1, attribute2, attribute3 with the actual attributes of the Batch model
end
end
