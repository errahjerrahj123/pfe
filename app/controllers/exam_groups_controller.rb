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

class ExamGroupsController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  before_filter :initial_queries
  before_filter :protect_other_student_data
  before_filter :restrict_employees_from_exam
  before_filter :protect_other_batch_exams, :only => [:show, :index]
  in_place_edit_with_validation_for :exam_group, :name
  in_place_edit_with_validation_for :exam, :maximum_marks
  in_place_edit_with_validation_for :exam, :minimum_marks
  in_place_edit_with_validation_for :exam, :weightage

  def index
    @sms_setting = SmsSetting.new
  @exam_groups = []
    @exam_groups = @batch.exam_groups
  if(!@exam_groups.empty?)
    logger.debug '************exams non vide*************'
  end
  
=begin
    Traitement des modules des années de reserve 
=end
=begin
    @batch.students.each do |st|
    logger.debug '*************************'
    logger.info st.first_name
    reserve_year_student = ReserveYearStudent.find(:first, :conditions => {:student_id => st.id , :school_year =>@batch.get_batch_year})
    if(!reserve_year_student.nil?)
      reserve_year_student_details = ReserveYearStudentDetail.find(:all,:conditions => {:reserve_year_student_id => reserve_year_student.id })
      if(!reserve_year_student_details.empty?)
        reserve_year_student_details.each do |ryd|
        logger.debug '**************annee de reserve trouve***********'
        logger.info st.first_name
        btr = Batch.find(ryd.batch_id)
        if (!btr.nil?)
        logger.debug '**************annee de reserve trouve***********'
        logger.info btr.course_id
        logger.info @batch.course_id
          
          if(btr.course_id == 1)
            bta = Batch.find(:all, :conditions => "course_id = 3 and school_field_id = #{@batch.school_field_id} and (year(start_date)= #{(@batch.get_batch_year).to_s} )").first 
          elsif (btr.course_id == 2)
            bta = Batch.find(:all, :conditions => "course_id = 4 and school_field_id = #{@batch.school_field_id} and ((year(start_date)= #{(@batch.get_batch_year.to_i+1).to_s} ) and month(start_date) < 8)").first 
          elsif (btr.course_id == 3)
            bta = Batch.find(:all, :conditions => "course_id = 5 and school_field_id = #{@batch.school_field_id} and ((year(start_date)= #{(@batch.get_batch_year)}).to_s} ))").first 
          end
          logger.debug '**************batch anticipe***********'
          
          logger.info bta.course_id unless bta.nil? 
          if((!bta.nil?) and ((@batch.course_id == 1 and bta.course_id == 3) or (@batch.course_id == 2 and bta.course_id == 4) or (@batch.course_id == 3 and bta.course_id == 5)))
            logger.debug '**************test valider***********'
            bta.exam_groups.each do |ex|
              logger.debug '**************Exam groups***********'
              if(ex.module_id == ryd.school_module_id)
                logger.debug '**************test finale valider***********'
                @exam_groups << ex
              end
          
            end
          end

        end
        end
      end
    end
   end
=end

logger.debug '************ma dkhaaaaaaaaaaaal*************'
   if (@current_user.employee? and ((SchoolField.find(@batch.school_field_id).employee_id.to_i) != (Employee.find_by_user_id(@current_user.id).id.to_i)))
       logger.debug '************dkhaaaaaaaaaaaal'+ @current_user.employee.id.to_s + 'hhhh' + @current_user.id.to_s
      @user_privileges = @current_user.privileges
      @employee_subjects= @current_user.employee_record.subjects.map { |n| n.id}
    @exam_g=[]
    @employee_subjects.each do |sb|
       @exam_groups.each do |eg|     
     if(eg.exams.all(:group => 'subject_id').map{|x|x.subject_id}.include? sb and !@exam_g.include? eg)
        @exam_g << eg
     end     
     end
      end
    @exam_groups = @exam_g
      if @employee_subjects.empty? and !@user_privileges.map{|p| p.name}.include?('ExaminationControl') and !@user_privileges.map{|p| p.name}.include?('EnterResults')
        flash[:notice] = "#{t('flash_msg4')}"
        redirect_to :controller => 'user', :action => 'dashboard'
      end
    end
  end

  def new
    @user_privileges = @current_user.privileges
    @cce_exam_categories = CceExamCategory.all if @batch.cce_enabled?
    if !@current_user.admin? and !@user_privileges.map{|p| p.name}.include?('ExaminationControl') and !@user_privileges.map{|p| p.name}.include?('EnterResults')
      flash[:notice] = "#{t('flash_msg4')}"
      redirect_to :controller => 'user', :action => 'dashboard'
    end
  end

  def create
    @exam_group = ExamGroup.new(params[:exam_group])
    @exam_group.batch_id = @batch.id
    @type = @exam_group.exam_type
    if @exam_group.save
      flash[:notice] =  "#{t('flash1')}"
      redirect_to batch_exam_groups_path(@batch)
    else
      @cce_exam_categories = CceExamCategory.all if @batch.cce_enabled?
      render 'new'
    end
  end

  def edit
    @exam_group = ExamGroup.find params[:id]
    @cce_exam_categories = CceExamCategory.all if @batch.cce_enabled?
  end

  def update
    @exam_group = ExamGroup.find params[:id]
    if @exam_group.update_attributes(params[:exam_group])
      flash[:notice] = "#{t('flash2')}"
      redirect_to [@batch, @exam_group]
    else
      @cce_exam_categories = CceExamCategory.all if @batch.cce_enabled?
      render 'edit'
    end
  end

  def destroy
    @exam_group = ExamGroup.find(params[:id], :include => :exams)
    if @current_user.employee?
      @employee_subjects= @current_user.employee_record.subjects.map { |n| n.id}
      if @employee_subjects.empty? and !@current_user.privileges.map{|p| p.name}.include?("ExaminationControl") and !@current_user.privileges.map{|p| p.name}.include?("EnterResults")
        flash[:notice] = "#{t('flash_msg4')}"
        redirect_to :controller => 'user', :action => 'dashboard'
      end
    end 
    flash[:notice] = "#{t('flash3')}" if @exam_group.destroy
    redirect_to batch_exam_groups_path(@batch)
  end

  def show
    @exam_group = ExamGroup.find(params[:id], :include => :exams)
     logger.debug"****************#{params[:id].inspect}****************************"
    logger.debug"****************#{@exam_group.id}****************************"
    @batch = @batch
    @examm = Exam.find_by_exam_group_id(@exam_group.id, :include => :exam_group)

    exam_subject = Subject.find(@examm.subject_id)
    is_elective = exam_subject.elective_group_id
    if is_elective == nil
    @exam_groups = @batch.exam_groups

      @students = Student.find_all_by_batch_id(@batch.id) unless !Student.find_all_by_batch_id(@batch.id)
      bs = BatchStudent.find_all_by_batch_id(@batch.id)
            unless bs.empty?
            bs.each do|bst|
               student = Student.find_by_id(bst.student_id)
               @students << student unless student.nil?

               code_exam = CodeExam.find(:first, :conditions=> "student_id = #{bst.student_id} and batch_id = #{@batch.id}")

            end

            end
    st_array = []
    @students.each do |std|
     annee_reserve = ReserveYearStudent.find(:first, :conditions => {:school_year=>@batch.get_batch_year, :student_id => std.id})
     if(!annee_reserve.nil?)
      annee_reserve_detail = ReserveYearStudentDetail.find(:first, :conditions => {:reserve_year_student_id => annee_reserve.id, :school_module_id => @exam.exam_group.module_id})
      if(annee_reserve_detail.nil?)

       else
        code = CodeExam.find(:first, :conditions=> "student_id = #{bst.student_id} and batch_id = #{@batch.id}")
        if code != std.matricule
          code = std.matricule
        end
         st_array << std + {:code => code}
      end
     else
       st_array << std
     end

    end
    @students = st_array
=begin
    @students.each do |std|
    logger.debug "*************************************************************"
     logger.debug std.last_name
     logger.debug @batch.name
     logger.debug @examm.exam_group.module_id
     logger.debug @batch.id
    end
=end

    @students=@students.uniq{|x| x.id}
    students_tmp = []
    annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => {:school_module_id => @examm.exam_group.module_id ,:batch_id=>@batch.id})
    if !annee_reserve_detail.empty?
    annee_reserve_detail.each do |ard|
      annee_reserve = ReserveYearStudent.find(ard.reserve_year_student_id)
      @students << Student.find_by_id(annee_reserve.student_id)
      logger.debug "***************annee de reserve************************"
      logger.debug annee_reserve.student_id
    end

    end
   @students=@students.uniq{|x| x.id}

      else

      assigned_students = StudentsSubject.find_all_by_subject_id(exam_subject.id)
      @students = []
      assigned_students.each do |s|
        student = Student.find_by_id(s.student_id)
        @students.push [student.first_name, student.id, student] unless student.nil?
      end

      @ordered_students = @students.sort
      @students=[]
      @ordered_students.each do|s|
        @students.push s[2]
      end



    end
       
   @data=[]
   @students = @students.sort_by{|a| a.full_name}
   @students=@students.sort_by {|st| st.full_name.upcase}
    @students_count=@students.count
    
    @exam_group.exams.each do |exam| 
        @data[exam.id] = []
       @students.each do |student| 
        @exam_score = exam.score_for(student)
                 if @exam_score.marks
                   @data[exam.id] << format("%.2f", @exam_score.marks)
                 end
               
       end 
           @data=@data    
     logger.debug"*******************#{ @data[exam.id].inspect}**********************"
    
    end 

   if @current_user.employee?
      @user_privileges = @current_user.privileges
      @employee_subjects= @current_user.employee_record.subjects.map { |n| n.id}
      if @employee_subjects.empty? and !@current_user.privileges.map{|p| p.name}.include?("ExaminationControl") and !@current_user.privileges.map{|p| p.name}.include?("EnterResults")
        flash[:notice] = "#{t('flash_msg4')}"
        redirect_to :controller => 'user', :action => 'dashboard'
      end
    end
  end
 




  private
  def initial_queries
    @batch = Batch.find params[:batch_id], :include => :course unless params[:batch_id].nil?
    @course = @batch.course unless @batch.nil?
  end

  def protect_other_batch_exams
    @user_privileges = @current_user.privileges
    if !@current_user.admin? and !@user_privileges.map{|p| p.name}.include?('ExaminationControl') and !@user_privileges.map{|p| p.name}.include?('EnterResults') and ((SchoolField.find(@batch.school_field_id).employee_id.to_i) != (Employee.find_by_user_id(@current_user.id).id.to_i))
      @user_subjects = @current_user.employee_record.subjects.all(:group => 'batch_id')
      @user_batches = @user_subjects.map{|x|x.batch_id} unless @current_user.employee_record.blank? or @user_subjects.nil?

      unless @user_batches.include?(params[:batch_id].to_i)
        flash[:notice] = "#{t('flash_msg4')}"
        redirect_to :controller => 'user', :action => 'dashboard'
      end
    end
  end
end
