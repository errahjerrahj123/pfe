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

class ExamsController < ApplicationController
  before_filter :login_required
  before_filter :query_data, :except => [:show_all, :show_all_ar, :show_all_pdf, :save_scores_all, :save_scores_all_ar, :show_ratrappage,:envoyer_message]
  before_filter :protect_other_student_data
  before_filter :restrict_employees_from_exam, :except=>[:edit, :destroy]
  before_filter :restrict_employees_from_exam_edit, :only=>[:edit, :destroy]
  filter_access_to :all

  def new
    @exam = Exam.new
    @subjects = @batch.subjects
    if @current_user.employee? and  !@current_user.privileges.map{|m| m.name}.include?("ExaminationControl")
      @subjects= Subject.find(:all,:joins=>"INNER JOIN employees_subjects ON employees_subjects.subject_id = subjects.id AND employee_id = #{@current_user.employee_record.id} AND batch_id = #{@batch.id} ")
      if @subjects.blank?
        flash[:notice] = "#{t('flash_msg4')}"
        redirect_to [@batch, @exam_group]
      end
    end
  end

  def create
    @exam = Exam.new(params[:exam])
    @exam.exam_group_id = @exam_group.id
    if @exam.save
      flash[:notice] = "#{t('flash_msg10')}"
      redirect_to [@batch, @exam_group]
    else
      @subjects = @batch.subjects
      if @current_user.employee? and  !@current_user.privileges.map{|m| m.name}.include?("ExaminationControl")
        @subjects= Subject.find(:all,:joins=>"INNER JOIN employees_subjects ON employees_subjects.subject_id = subjects.id AND employee_id = #{@current_user.employee_record.id} AND batch_id = #{@batch.id} ")
      end
      render 'new'
    end
  end
def push_all
  @exam = Exam.find(params[:exam_id])
  @exam_group = ExamGroup.find(params[:exam_group_id])
  require 'typhoeus'
bod = {:email => "alo.mohamed@gmail.com",:password => "Apogee@2022"}.to_json
@request = Typhoeus::Request.new("http://ump-oujda.tk/api/auth",
                            :method         => :post,
                            :headers        => {'Content-Type' => 'application/json'},
                            :timeout        => 100, # milliseconds
                            :body         => bod )
                            hydra = Typhoeus::Hydra.hydra
                            hydra.queue(@request)
                            hydra.run
bod = ActiveSupport::JSON.decode(@request.response.body)
token = bod["token"]
options = {'Content-Type' => 'application/json','X-Auth-Token' => token}
ExamScore.find_all_by_exam_id(@exam.id).each do |exam_score|
student = Student.find(exam_score.student_id)
data = {:NOT_ELP => exam_score.marks }
bod = {:table_name => "RESULTAT_ELP",:condition => "where COD_IND = "+student.matricule.to_s+" and COD_SES = 1 and COD_ELP like \'"+@exam.subject.code.to_s+"\'  and COD_ADM = 1 and COD_ANU = \'"+@exam.subject.batch.get_batch_year.to_s+"\' ",:data => data}.to_json
@request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/update",
                          :method         => :post,
                          :headers        => options,
                          :timeout        => 100, # milliseconds
                          :body         => bod )
                          hydra = Typhoeus::Hydra.hydra
                          hydra.queue(@request)
                          hydra.run
bod = ActiveSupport::JSON.decode(@request.response.body)
logger.debug bod.inspect
end
flash[:notice] = "L'opération est effectuée avec succès"

redirect_to :back

end
def push_all_exams
  @exam_group = ExamGroup.find(params[:exam_group_id])
  require 'typhoeus'
bod = {:email => "alo.mohamed@gmail.com",:password => "Apogee@2022"}.to_json
@request = Typhoeus::Request.new("http://ump-oujda.tk/api/auth",
                            :method         => :post,
                            :headers        => {'Content-Type' => 'application/json'},
                            :timeout        => 100, # milliseconds
                            :body         => bod )
                            hydra = Typhoeus::Hydra.hydra
                            hydra.queue(@request)
                            hydra.run
bod = ActiveSupport::JSON.decode(@request.response.body)
token = bod["token"]
options = {'Content-Type' => 'application/json','X-Auth-Token' => token}
logger.debug @exam_group.exams.inspect
logger.debug "//////////////////////////////////////"
logger.debug "//////////////////////////////////////"
logger.debug "//////////////////////////////////////"
logger.debug "//////////////////////////////////////"
logger.debug "//////////////////////////////////////"
logger.debug "//////////////////////////////////////"
logger.debug "//////////////////////////////////////"

@exam_group.exams.each do |exam|
  @exam = exam
ExamScore.find_all_by_exam_id(@exam.id).each do |exam_score|
  exit
  exit
  exit
student = Student.find(exam_score.student_id)
data = {:NOT_ELP => exam_score.marks }
bod = {:table_name => "RESULTAT_ELP",:condition => "where COD_IND = "+student.matricule.to_s+" and COD_SES = 1 and COD_ELP like \'"+@exam.subject.code.to_s+"\'  and COD_ADM = 1 and COD_ANU = \'"+@exam.subject.batch.get_batch_year.to_s+"\' ",:data => data}.to_json
@request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/update",
                          :method         => :post,
                          :headers        => options,
                          :timeout        => 100, # milliseconds
                          :body         => bod )
                          hydra = Typhoeus::Hydra.hydra
                          hydra.queue(@request)
                          hydra.run
bod = ActiveSupport::JSON.decode(@request.response.body)
logger.debug bod.inspect
exit
exit
exit
end
end
flash[:notice] = "L'opération est effectuée avec succès"

redirect_to :back

end
def fiche_apogee
  @exam = Exam.find(params[:exam_id])
  student = Student.find(params[:student_id])
require 'typhoeus'
bod = {:email => "alo.mohamed@gmail.com",:password => "Apogee@2022"}.to_json
@request = Typhoeus::Request.new("http://ump-oujda.tk/api/auth",
                            :method         => :post,
                            :headers        => {'Content-Type' => 'application/json'},
                            :timeout        => 100, # milliseconds
                            :body         => bod )
                            hydra = Typhoeus::Hydra.hydra
                            hydra.queue(@request)
                            hydra.run
bod = ActiveSupport::JSON.decode(@request.response.body)
token = bod["token"]
options = {'Content-Type' => 'application/json','X-Auth-Token' => token}

exam_scores = {:table_name => "RESULTAT_ELP",:condition => "where COD_IND = "+student.matricule.to_s+" and COD_SES = 1 and COD_ELP like \'"+@exam.subject.code.to_s+"\'  and COD_ADM = 1 and COD_ANU = \'"+@exam.subject.batch.get_batch_year.to_s+"\' ",:columns => "*"}.to_json
                      @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
                                                             :method         => :post,
                                                             :headers        => options,
                                                             :timeout        => 100, # milliseconds
                                                             :body         => exam_scores )
                      hydra = Typhoeus::Hydra.hydra
                      hydra.queue(@request)
                      hydra.run
                      exam_scores = ActiveSupport::JSON.decode(@request.response.body)
exam_scores.each do |exam_s|
  logger.debug exam_s["DAT_CRE_ELP"]
  logger.debug exam_s["COD_NUM_UTI_MOD"]
end
@data = exam_scores

end
def push_apogee
  @exam = Exam.find(params[:exam_id])
  student = Student.find(params[:student_id])
require 'typhoeus'
bod = {:email => "alo.mohamed@gmail.com",:password => "Apogee@2022"}.to_json
@request = Typhoeus::Request.new("http://ump-oujda.tk/api/auth",
                            :method         => :post,
                            :headers        => {'Content-Type' => 'application/json'},
                            :timeout        => 100, # milliseconds
                            :body         => bod )
                            hydra = Typhoeus::Hydra.hydra
                            hydra.queue(@request)
                            hydra.run
bod = ActiveSupport::JSON.decode(@request.response.body)
token = bod["token"]
options = {'Content-Type' => 'application/json','X-Auth-Token' => token}


 scores = {:table_name => "RESULTAT_ELP",:condition => "where COD_IND = "+student.matricule.to_s+" and COD_SES = 1 and COD_ELP like \'"+@exam.subject.code.to_s+"\'  and COD_ADM = 1 and COD_ANU = \'"+@exam.subject.batch.get_batch_year.to_s+"\' ",:columns => "*"}.to_json
                       @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
                                                              :method         => :post,
                                                              :headers        => options,
                                                              :timeout        => 100, # milliseconds
                                                              :body         => scores )
                       hydra = Typhoeus::Hydra.hydra
                       hydra.queue(@request)
                       hydra.run
                       scores = ActiveSupport::JSON.decode(@request.response.body)
                       logger.debug student.matricule
                       logger.debug @exam.subject.code
                       logger.debug @exam.subject.batch.get_batch_year

logger.debug scores.inspect
score = scores.first

exam_score = ExamScore.find_by_student_id_and_exam_id(student.id,@exam.id)
data = {:NOT_ELP => exam_score.marks }
bod = {:table_name => "RESULTAT_ELP",:condition => "where COD_IND = "+student.matricule.to_s+" and COD_SES = 1 and COD_ELP like \'"+@exam.subject.code.to_s+"\'  and COD_ADM = 1 and COD_ANU = \'"+@exam.subject.batch.get_batch_year.to_s+"\' ",:data => data}.to_json
@request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/update",
                          :method         => :post,
                          :headers        => options,
                          :timeout        => 100, # milliseconds
                          :body         => bod )
                          hydra = Typhoeus::Hydra.hydra
                          hydra.queue(@request)
                          hydra.run
bod = ActiveSupport::JSON.decode(@request.response.body)
logger.debug bod.inspect
flash[:notice] = "L'opération est effectuée avec succès"

redirect_to :back
end
  def edit
    @exam = Exam.find params[:id], :include => :exam_group
    @subjects = @exam_group.batch.subjects
    if @current_user.employee?  and !@current_user.privileges.map{|m| m.name}.include?("ExaminationControl")
      @subjects= Subject.find(:all,:joins=>"INNER JOIN employees_subjects ON employees_subjects.subject_id = subjects.id AND employee_id = #{@current_user.employee_record.id} AND batch_id = #{@batch.id} ")
      unless @subjects.map{|m| m.id}.include?(@exam.subject_id)
        flash[:notice] = "#{t('flash_msg4')}"
        redirect_to [@batch, @exam_group]
      end
    end
  end
  def published
     @exam = Exam.find(params[:exam_id])

          flash[:notice] = "les notes sont publiées"

        Exam.update(@exam.id,:is_published=>true)
  redirect_to(:back)

  end
  def generate_anonymat
    @todo = params[:todo]
    if @todo == "pdf"
     @exam = Exam.find(params[:exam_id])
     @exam_group =  @exam.exam_group
@current_user  = current_user
@students= []
@students= @exam_group.batch.all_students
@students +=  @exam_group.batch.old_students
     render :pdf => "generate_anonymat"
   else
@exam = Exam.find(params[:exam_id])
     @exam_group =  @exam.exam_group
@current_user  = current_user
@students= []
@students= @exam_group.batch.all_students
@students +=  @exam_group.batch.old_students
     csv_string = FasterCSV.generate(:col_sep=>';') do | csv |
     csv << []
      if @batch.school_field_id == 10
       csv << ["Code", "Nom" , "Prenom" , "code anonymat"]
     else
      csv << ["Code", "Nom" , "Prenom"]
     end

     code=0
     @students.each do | me |
      if @batch.school_field_id == 10
         code=me.matricule
      else
       code_ex = CodeExam.find(:first, :conditions=>"student_id = #{me.id} and batch_id =#{@batch.id}")
     if(!code_ex)
            code=me.matricule
     else
            code=code_ex.code
     end
   end

      if @batch.school_field_id == 10

       csv << [code,me.last_name.to_s,me.first_name.to_s,me.user.id]
     else
       csv << [code,me.last_name.to_s,me.first_name.to_s]
     end


     end
     end

     filename=Exam.find(params[:exam_id]).subject.id
    send_data Iconv.conv("iso-8859-1//IGNORE", "iso-8859-1", csv_string),
   :type => 'text/csv; charset=iso-8859-1; header=present',
   :disposition => "attachment; filename=#{filename}.csv"


   end


  end
  def not_published
     @exam = Exam.find(params[:exam_id])

          flash[:notice] = "les notes sont masquées"

        Exam.update(@exam.id,:is_published=>false)
  redirect_to(:back)

  end
  def update
    @exam = Exam.find params[:id], :include => :exam_group

    if @exam.update_attributes(params[:exam])
      flash[:notice] = "#{t('flash1')}"
      redirect_to [@exam_group, @exam]
    else
      @subjects = @batch.subjects
      if @current_user.employee? and  !@current_user.privileges.map{|m| m.name}.include?("ExaminationControl")
        @subjects= Subject.find(:all,:joins=>"INNER JOIN employees_subjects ON employees_subjects.subject_id = subjects.id AND employee_id = #{@current_user.employee_record.id} AND batch_id = #{@batch.id} ")
      end
      render 'edit'
    end
  end
  def show_pdf

    @employee_subjects=[]
    @employee_subjects= @current_user.employee_record.subjects.map { |n| n.id} if @current_user.employee?
    @exam = Exam.find params[:id], :include => :exam_group
    unless @employee_subjects.include?(@exam.subject_id) or (@current_user.admin? or ((SchoolField.find(@exam.subject.batch.school_field_id).employee_id.to_i) == (Employee.find_by_user_id(@current_user.id).id.to_i))) or @current_user.privileges.map{|p| p.name}.include?('ExaminationControl') or @current_user.privileges.map{|p| p.name}.include?('EnterResults')
      flash[:notice] = "#{t('flash_msg6')}"
      redirect_to :controller=>"user", :action=>"dashboard"
    end
    exam_subject = Subject.find(@exam.subject_id)
    is_elective = exam_subject.elective_group_id
    if is_elective == nil
      @students = Student.find_all_by_batch_id(@batch.id) unless !Student.find_all_by_batch_id(@batch.id)
	        bs = BatchStudent.find_all_by_batch_id(@batch.id)
            unless bs.empty?
            bs.each do|bst|
               student = Student.find_by_id(bst.student_id)
               @students << student unless student.nil?
			   @students=@students.uniq{|x| x.id}
            end
            end
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

    @config = Configuration.get_config_value('ExamResultType') || 'Marks'

    @grades = @batch.grading_level_list

        render :pdf => "show_pdf"

  end
  def show
    @id = params[:id]
     @exam_group_id = params[:exam_group_id]
    params.each do |key,value|
      logger.debug "Param #{key}: #{value}"
    end
	mod_n = 0
    @employee_subjects=[]
    @employee_subjects= @current_user.employee_record.subjects.map { |n| n.id} if @current_user.employee?

    @exam = Exam.find params[:id], :include => :exam_group
     #logger.debug"****************#{params[:id].inspect}****************************"
      #logger.debug"****************$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$****************************"
    unless @employee_subjects.include?(@exam.subject_id) or (@current_user.admin? or ((SchoolField.find(@exam.subject.batch.school_field_id).employee_id.to_i) == (Employee.find_by_user_id(@current_user.id).id.to_i))) or @current_user.privileges.map{|p| p.name}.include?('ExaminationControl') or @current_user.privileges.map{|p| p.name}.include?('EnterResults')
      flash[:notice] = "#{t('flash_msg6')}"
      redirect_to :controller=>"user", :action=>"dashboard"
    end
    exam_subject = Subject.find(@exam.subject_id)
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
=begin
               if(code_exam.nil?)
                  str = generate_token()
                  code_ex = CodeExam.new(:student_id => bst.student_id, :batch_id => @batch.id, :code => str.to_s)
                  code_ex.save
               end
=end
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
	  @students.each do |std|
		logger.debug "*************************************************************"
		 logger.debug std.last_name
		 logger.debug @batch.name
		 logger.debug @exam.exam_group.module_id
		 logger.debug @batch.id
	  end

	  @students=@students.uniq{|x| x.id}
	  students_tmp = []
	  annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => {:school_module_id => @exam.exam_group.module_id ,:batch_id=>@batch.id})
	  if !annee_reserve_detail.empty?
		annee_reserve_detail.each do |ard|
			annee_reserve = ReserveYearStudent.find(ard.reserve_year_student_id)
			@students << Student.find_by_id(annee_reserve.student_id)
			logger.debug "***************annee de reserve************************"
			logger.debug annee_reserve.student_id
		end

=begin		annee_reserve = ReserveYearStudent.find(annee_reserve_detail.reserve_year_student_id)
		@students << Student.find_by_id(annee_reserve.student_id)
		logger.debug "***************annee de reserve************************"
		logger.debug annee_reserve.student_id
=end
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


    @students = @students.sort_by{|a| a.full_name}
    @config = Configuration.get_config_value('ExamResultType') || 'Marks'

    @grades = @batch.grading_level_list
   

  end
def envoyer_message

  subjects = Exam.find(params[:id])
  employee_subjects = EmployeesSubject.find_by_subject_id(subjects.subject_id)
  if employee_subjects
  logger.debug employee_subjects.inspect
  employee = Employee.find(employee_subjects.employee_id)
  exam_group = ExamGroup.find(params[:exam_group_id])
  batch = Batch.find(exam_group.batch_id)

 subject = " Saisie des note pour #{exam_group.name} terminée"
 message = "Le professeur #{employee.full_name} a terminée la saisie des note de la matière #{exam_group.name} pour la classe #{batch.name} "
 logger.debug "JJJJJJJJJJJJJJJJJJJJJJJ #{subject }   /n     #{message}"
   Reminder.create(:sender=>1, :recipient=>employee.user_id, :subject=>subject,:body=>message , :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
    flash[:notice] = "#{t('flash1')}"
    redirect_to :back
  else
     flash[:notice]="<b>ERROR:</b>#{t('flash6')}"
      redirect_to :back
 end
end

  def show_all
=begin
    @employee_subjects=[]
    @employee_subjects= @current_user.employee_record.subjects.map { |n| n.id} if @current_user.employee?
    @exam = Exam.find params[:id], :include => :exam_group
    unless @employee_subjects.include?(@exam.subject_id) or (@current_user.admin? or ((SchoolField.find(@exam.subject.batch.school_field_id).employee_id.to_i) == (Employee.find_by_user_id(@current_user.id).id.to_i))) or @current_user.privileges.map{|p| p.name}.include?('ExaminationControl') or @current_user.privileges.map{|p| p.name}.include?('EnterResults')
      flash[:notice] = "#{t('flash_msg6')}"
      redirect_to :controller=>"user", :action=>"dashboard"
    end
    exam_subject = Subject.find(@exam.subject_id)
=end
    @students=[]
	@batches_students=[]
	@subject_group=params[:subject_group]
	@course_id=params[:course_id].to_i
	@btyr=Batch.find(params[:batch_id].to_i).get_batch_year
	@batches=SubjectGroup.find(params[:subject_group]).subjects.map{|x|x.batch}.reject {|n| (n.get_batch_year != @btyr or n.course_id != @course_id)}.uniq{|x| x.id}
	#logger.debug @batches.inspect
    @batches.each do |btc|
      @students += Student.find_all_by_batch_id(btc.id) unless !Student.find_all_by_batch_id(btc.id)
	        bs = BatchStudent.find_all_by_batch_id(btc.id)
            unless bs.empty?
            bs.each do|bst|
               student = Student.find_by_id(bst.student_id)
               @students << student unless student.nil?
			   @batches_students[student.id]=bst.batch_id unless student.nil?
            end
            end
    end
	@students=@students.uniq{|x| x.id}.sort_by {|st| st.last_name}

  end

  def show_all_ar
    @students=[]
	@batches_students=[]
	@subject_group=params[:subject_group]
	@course_id=params[:course_id].to_i
	@batches=SubjectGroup.find(params[:subject_group]).subjects.map{|x|x.batch}.reject {|n| n.course_id != @course_id}.uniq{|x| x.id}
    @batches.each do |btc|
      @students += Student.find_all_by_batch_id(btc.id) unless !Student.find_all_by_batch_id(btc.id)
	        bs = BatchStudent.find_all_by_batch_id(btc.id)
            unless bs.empty?
            bs.each do|bst|
               student = Student.find_by_id(bst.student_id)
               @students << student unless student.nil?
			   @batches_students[student.id]=bst.batch_id unless student.nil?
            end
            end
=begin		annee_reserve_detail = ReserveYearStudentDetail.find(:first, :conditions => {:batch_id=>btc.id})
		logger.debug "********************je suis dans etudiant annee de reserve*******************"
		logger.debug btc.id
	  if !annee_reserve_detail.nil?
	  logger.debug "********************je suis dans etudiant annee de reserve"
		annee_reserve = ReserveYearStudent.find(annee_reserve_detail.reserve_year_student_id)
		std = Student.find_by_id(annee_reserve.student_id)
		std.batch_id = btc.id
		@students += std
	  end
=end
    end
	@students=@students.uniq{|x| x.id}.sort_by {|st| st.last_name}

  end

  def show_all_pdf
    @students=[]
	@batches_students=[]
	@subject_group=params[:subject_group]
	@course_id=params[:course_id].to_i
	@batches=SubjectGroup.find(params[:subject_group]).subjects.map{|x|x.batch}.reject {|n| n.course_id != @course_id}.uniq{|x| x.id}
    @batches.each do |btc|
      @students += Student.find_all_by_batch_id(btc.id) unless !Student.find_all_by_batch_id(btc.id)
	        bs = BatchStudent.find_all_by_batch_id(btc.id)
            unless bs.empty?
            bs.each do|bst|
               student = Student.find_by_id(bst.student_id)
               @students << student unless student.nil?
			   @batches_students[student.id]=bst.batch_id unless student.nil?
            end
            end
    end
	@students=@students.uniq{|x| x.id}.sort_by {|st| st.last_name}
    render :pdf => "show_all_pdf"
  end


  def show_ar
    @employee_subjects=[]
    @employee_subjects= @current_user.employee_record.subjects.map { |n| n.id} if @current_user.employee?
    @exam = Exam.find params[:id], :include => :exam_group
    unless @employee_subjects.include?(@exam.subject_id) or (@current_user.admin? or ((SchoolField.find(@exam.subject.batch.school_field_id).employee_id.to_i) == (Employee.find_by_user_id(@current_user.id).id.to_i))) or @current_user.privileges.map{|p| p.name}.include?('ExaminationControl') or @current_user.privileges.map{|p| p.name}.include?('EnterResults')
      flash[:notice] = "#{t('flash_msg6')}"
      redirect_to :controller=>"user", :action=>"dashboard"
    end
    exam_subject = Subject.find(@exam.subject_id)
    is_elective = exam_subject.elective_group_id
    if is_elective == nil
      @students = Student.find_all_by_batch_id(@batch.id) unless !Student.find_all_by_batch_id(@batch.id)
	        bs = BatchStudent.find_all_by_batch_id(@batch.id)
            unless bs.empty?
            bs.each do|bst|
               student = Student.find_by_id(bst.student_id)
               @students << student unless student.nil?
			   @students=@students.uniq{|x| x.id}
            end
            end

	  annee_reserve_detail = ReserveYearStudentDetail.find(:first, :conditions => {:school_module_id => @exam.exam_group.module_id ,:batch_id=>@batch.id})
	  if !annee_reserve_detail.nil?
		annee_reserve = ReserveYearStudent.find(annee_reserve_detail.reserve_year_student_id)
		@students << Student.find_by_id(annee_reserve.student_id)
	  end

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
    @config = Configuration.get_config_value('ExamResultType') || 'Marks'

    @grades = @batch.grading_level_list
	if(params[:todo])
	render :pdf => 'ar_pdf'
	else
    render 'show_ar_html'
	end
  end

  def show_ratrappage
    @courses=(params[:course_ids].gsub('%2C',',')).split(",")
    @batches=Batch.find(:all,:conditions =>["school_field_id=? and (course_id = ? or course_id = ?)",params[:school_field_id],@courses[0],@courses[1]]).reject { |b| b.get_batch_year.to_i != params[:school_year].to_i }
	@filiere=SchoolField.find(params[:school_field_id])
	@courses=@courses.reject{|c| c.to_i == 0}
	@nivau=Course.find(@courses[0]).course_name
	@liste=[]
	@batches.each do |bt|
	        @liste[bt.id]=[]
	        subjects=bt.subjects
			subjects.each do |sb|
			        found = 0
			        exams=Exam.find_all_by_subject_id(sb.id)
					exams.each do |ex|
					    exam_scores=ex.exam_scores
					     if(exam_scores)
						      exam_scores.each do |es|
								   @annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id =#{es.student_id} and school_year = #{bt.get_batch_year} " )
								   @annee_reserve_detail = []
								   if(@annee_reserve != nil )
								   @annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve.id}" )
			                       end
								   school_module=SchoolModule.find(ExamGroup.find(ex.exam_group_id).module_id)
								    @annee_reserve_detail.each do |ar|
										if(ar.school_module_id == school_module.id)
											found = 1
										end
									end
									if (!((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?)))
									 bat_anc= Batch.find(:first, :conditions => "course_id = #{bt.course.id.to_s} and school_field_id = #{@filiere.id.to_s} and (year(start_date)= #{(bt.get_batch_year.to_i-1).to_s} or (year(start_date)=#{(bt.get_batch_year).to_s} and month(start_date) < 8))")
									 subjectss=bat_anc.subjects
									 subjectss.each do |sbb|
										examss=Exam.find_all_by_subject_id(sbb.id)
										examss.each do |exx|
										school_modulee=SchoolModule.find(ExamGroup.find(exx.exam_group_id).module_id)
										  exam_scoress=exx.exam_scores
										  if(exam_scoress and school_modulee.id == school_module.id)
											exam_scoress.each do |ess|
											  if(ess.student_id == es.student_id and ess.marks.to_f < 10 and (Student.find(ess.student_id).batch_id==bt.id or BatchStudent.find_all_by_student_id_and_batch_id(ess.student_id,bt.id).length > 0))
													school_module=SchoolModule.find(ExamGroup.find(exx.exam_group_id).module_id)
													module_infos=school_module.marks_infos(bat_anc.id,ess.student_id,bat_anc.start_date.year)
													moyenne_module_ar=module_infos["average"]
													if (((ess.marks.to_f<10 and moyenne_module_ar.to_f<10)) and ess.remarks != 'DISP')
														@liste[bt.id] << {:student_id=>ess.student_id,:subject_name=>sbb.name,:school_module_name=>school_module.name,:mark_element=>ess.marks,:mark_element_ar=>ess.marks_ar,:mark_module=>moyenne_module_ar,:mark_module_retenue=>module_infos["held_average"],:observation=>ess.remarks}
													end
											end
										  end
										end
									 end
									 end
							       else(es.marks.to_f < 10 and (Student.find(es.student_id).batch_id==bt.id or BatchStudent.find_all_by_student_id_and_batch_id(es.student_id,bt.id).length > 0))
								       school_module=SchoolModule.find(ExamGroup.find(ex.exam_group_id).module_id)
									   module_infos=school_module.marks_infos(bt.id,es.student_id,bt.start_date.year)
								       moyenne_module_ar=module_infos["average"]
                                       if (((es.marks.to_f<10 and moyenne_module_ar.to_f<10)) and es.remarks != 'DISP')
									       @liste[bt.id] << {:student_id=>es.student_id,:subject_name=>sb.name,:school_module_name=>school_module.name,:mark_element=>es.marks,:mark_element_ar=>es.marks_ar,:mark_module=>moyenne_module_ar,:mark_module_retenue=>module_infos["held_average"],:observation=>es.remarks}
									   end
								   end
								  end
							  end
						 end

			end
	end
    render :pdf=>'show_ratrappage',:orientation=> 'Landscape'
  end
  def destroy
    @exam = Exam.find params[:id], :include => :exam_group
    if @current_user.employee?  and !@current_user.privileges.map{|m| m.name}.include?("ExaminationControl")
      @subjects= Subject.find(:all,:joins=>"INNER JOIN employees_subjects ON employees_subjects.subject_id = subjects.id AND employee_id = #{@current_user.employee_record.id} AND batch_id = #{@batch.id} ")
      unless @subjects.map{|m| m.id}.include?(@exam.subject_id)
        flash[:notice] = "#{t('flash_msg4')}"
        redirect_to [@batch, @exam_group] and return
      end
    end
    if @exam.destroy
      batch_id = @exam.exam_group.batch_id
      batch_event = BatchEvent.find_by_event_id_and_batch_id(@exam.event_id,batch_id)
      event = Event.find_by_id(@exam.event_id)
      event.destroy
      batch_event.destroy
      flash[:notice] = "#{t('flash5')}"
    end
    redirect_to [@batch, @exam_group]
  end

  def importmarks
    @exam = Exam.find(params[:id])
    @error= false
   if request.post?
     uploaded_io = params[:importfile_fichier]
     File.open(Rails.root.join('public', 'uploads','File', uploaded_io.original_filename), 'wb') do |file|
       file.write(uploaded_io.read)
     end

     filename="#{RAILS_ROOT}/public/uploads/File/"+uploaded_io.original_filename
    require 'faster_csv'
   @n=0
    FasterCSV.foreach(filename,  :col_sep =>';', :row_sep =>:auto) do |row|
        if row[3].nil?
         next
        end

     matricule=row[0]
     code_exam = CodeExam.find(:first, :conditions=> "code = #{matricule}")
     if(code_exam)
     @st = Student.find_by_id(code_exam.student_id) unless code_exam.nil?
     else
     @st = Student.find_by_matricule(matricule)
     end
     if !@st.nil?
     @exam_score = ExamScore.find(:first, :conditions => {:exam_id => @exam.id, :student_id => @st.id} )
      #Rails.logger.info "J "+row[3].to_s+" Exam : "+@exam.maximum_marks.to_s + " M "+row[4].to_s + " EERREEZZAA "
      if @exam_score.nil?
        if (row[3].sub(',','.').to_f <= @exam.maximum_marks.to_f)
	  Rails.logger.info "No exam_score.nil"
          ExamScore.create do |score|
            score.exam_id          = @exam.id
            score.student_id       = @st.id
	    if !row[3].nil?
              score.marks            = row[3].sub(',','.').to_f
	    end
            #score.grading_level_id = details[:grading_level_id]
            score.remarks          = ""
          end
          examscore = ExamScoreModification.find_by_student_id_and_exam_id(@st.id,@exam.id)
          ExamScoreModification.create do |exam_score_modification|
            exam_score_modification.exam_scores_id  = examscore.id
            exam_score_modification.user_id         = current_user.id
            exam_score_modification.old_marks       = "0"
            exam_score_modification.new_marks       = examscore.marks
          end
        else
          @error = true
        end
      else
        Rails.logger.info "exam_score.nil"
        if (row[3].to_s.sub(',','.').to_f <= @exam.maximum_marks.to_f)
          old_marks = @exam_score.marks
	  if !row[3].nil?
           @exam_score.marks = row[3].sub(',','.').to_f
	  end
          if @exam_score.save
            examscore = @exam_score
            ExamScoreModification.create do |exam_score_modification|
              exam_score_modification.exam_scores_id  = examscore.id
              exam_score_modification.user_id         = current_user.id
              exam_score_modification.old_marks       = old_marks
              exam_score_modification.new_marks       = examscore.marks
            end
          else
            flash[:warn_notice] = "#{t('flash4')}"
            @error = nil
          end
        else
          @error = true
        end
      end

     #Rails.logger.info c.errors.full_messages.to_sentence
     flash[:notice] = "Importation de fichier effectue."
    end
   end
   end
    redirect_to [@exam_group, @exam]

  end


  def importmarksar
    @exam = Exam.find(params[:id])
    @error= false

   if request.post?
    logger.debug "wayeeeeeeeh"
    @batch_id= ExamGroup.find(params[:exam_group_id]).batch.id
    logger.debug "hoplala"

     # @batch_id=params[:batch_id]
     uploaded_io = params[:importfile_fichier]
     File.open(Rails.root.join('public', 'uploads','File', uploaded_io.original_filename), 'wb') do |file|
       file.write(uploaded_io.read)
     end

     filename="#{RAILS_ROOT}/public/uploads/File/"+uploaded_io.original_filename
    require 'faster_csv'
   @n=0
    FasterCSV.foreach(filename,  :col_sep =>';', :row_sep =>:auto) do |row|
       if row[3].nil?
         next
        end
        if row.nil?
            logger.debug "lolololo"
            logger.debug "its nil"
        end
        logger.debug row[0]
        logger.debug row[1]
        logger.debug "hololololo"
     matricule=row[0]
     @st = Student.find(:first, :conditions => {:matricule => matricule} )
     if !@st.nil?
     @exam_score = ExamScore.find(:first, :conditions => {:exam_id => @exam.id, :student_id => @st.id} )
      if @exam_score.nil?
        if (row[3].sub(',','.').to_f <= @exam.maximum_marks.to_f)
          Rails.logger.info "No exam_score.nil"
          ExamScore.create do |score|
            score.exam_id          = @exam.id
            score.student_id       = @st.id
            if !row[3].nil?
             score.marks_ar         = row[3].sub(',','.').to_f
            end
            #score.grading_level_id = details[:grading_level_id]
            score.remarks          = ""
          end
        else
          @error = true
        end
      elsif(@exam_score.marks.to_f<6 or (@exam_score.marks.to_f<10 and SchoolModule.find(ExamGroup.find(@exam.exam_group_id).module_id).marks_infos(@batch_id,@st.id,Batch.find(@batch_id).start_date.year)["average"]<10))

        Rails.logger.info "exam_score.nil"
        if (row[3].to_s.sub(',','.').to_f <= @exam.maximum_marks.to_f)
          if !row[3].nil?
           @exam_score.marks_ar = row[3].sub(',','.').to_f
          end
          if @exam_score.save
          else
            flash[:warn_notice] = "#{t('flash4')}"
            @error = nil
          end
        else
          @error = true
        end
      end

     #Rails.logger.info c.errors.full_messages.to_sentence
     flash[:notice] = "Importation de fichier effectue."
    end
   end
   end
#    redirect_to [@exam_group, @exam]
	redirect_to (:action => 'show_ar')

  end


def save_scores
    @exam = Exam.find(params[:id])
    @error= false
	@configStart = Configuration.get_config_value('StartNoteDate')
	@configEnd = Configuration.get_config_value('EndNoteDate')
	@configAuth = Configuration.get_config_value('Note')
	logger.debug "****************Configuration*******************"
	logger.debug @configStart
	logger.debug @configEnd
	d1 = Date.strptime(@configStart, "%Y-%m-%d")
	d2 = Date.strptime(@configEnd, "%Y-%m-%d")
	logger.debug d1
	logger.debug d2

	if params[:code_exam]
		params[:code_exam].each_pair do |s,c|
			@code_exam = CodeExam.find(:first, :conditions => {:batch_id => @batch.id, :student_id => s})
			if !@code_exam.nil? and @code_exam.code.to_s != c.to_s
				unless CodeExam.first.check_if_exists(c,s)
					flash[:modified_notice]="mis à jour avec succès!"
				end
				@code_exam.code = c.to_s
				@code_exam.save
				logger.debug "updated with success &)"
			elsif @code_exam.nil?
				#flash[:warn_notice] = CodeExam.first.check_if_exists(c.to_s,s)
				unless CodeExam.first.check_if_exists(c,s)
					flash[:modified_notice]="créé avec succès!"
				end
				CodeExam.create(:student_id=>s,:batch_id=>@batch.id,:code=>c.to_s)
				logger.debug "created with success &)"
			end
			logger.debug "student id #{s} and code = #{c} #{@batch.id}"
		end
		logger.debug "it aint null --------------"
	else
		logger.debug "yes it is"
	end

	# if(d1 <= Date.today and Date.today <=  d2 and @configAuth == "1")
	if(@configAuth == "1")
    params[:exam].each_pair do |student_id, details|
      @exam_score = ExamScore.find(:first, :conditions => {:exam_id => @exam.id, :student_id => student_id} )
      if @exam_score.nil?
        if details[:marks].to_f <= @exam.maximum_marks.to_f and details[:marks].to_f >= @exam.minimum_marks.to_f
          if details[:marks].to_s != "NC"
            ExamScore.create do |score|
              score.exam_id          = @exam.id
              score.student_id       = student_id
              score.marks            = details[:marks]
              score.nc          = nil
             # score.marks_ar         = details[:marks_ar]
              score.grading_level_id = details[:grading_level_id]
              score.remarks          = details[:remarks]
            end
            # examscore = ExamScoreModification.find_by_student_id_and_exam_id(student_id,@exam.id)
            examscore = ExamScore.find_by_student_id_and_exam_id(student_id,@exam.id)
            ExamScoreModification.create do |exam_score_modification|
              exam_score_modification.exam_scores_id  = examscore.id
              exam_score_modification.user_id         = current_user.id
              exam_score_modification.old_marks       = "0"
              exam_score_modification.new_marks       = examscore.marks
            end
          elsif details[:marks].to_s.downcase == "nc"
            ExamScore.create do |score|
              score.exam_id          = @exam.id
              score.student_id       = student_id
              score.nc            = details[:marks].to_s
              score.marks            = nil
              score.grading_level_id = details[:grading_level_id]
              score.remarks          = details[:remarks]
            end
            examscore = ExamScoreModification.find_by_student_id_and_exam_id(student_id,@exam.id)
            ExamScoreModification.create do |exam_score_modification|
              exam_score_modification.exam_scores_id  = examscore.id
              exam_score_modification.user_id         = current_user.id
              exam_score_modification.old_marks       = "0"
              exam_score_modification.new_marks       = examscore.marks
            end
          end
        else
          @error = true
        end
      else
        if details[:marks].to_f <= @exam.maximum_marks.to_f and details[:marks].to_f >= @exam.minimum_marks.to_f
          if details[:marks].to_s != "" and details[:marks].to_s.downcase != "nc"
            oldmarks = @exam_score.marks
            if@exam_score.update_attributes(details)
              @exam_score.nc = nil
              @exam_score.save
              examscore =   @exam_score
              ExamScoreModification.create do |exam_score_modification|
                exam_score_modification.exam_scores_id  = examscore.id
                exam_score_modification.user_id         = current_user.id
                exam_score_modification.old_marks       = oldmarks
                exam_score_modification.new_marks       = examscore.marks
              end
            else
              flash[:warn_notice] = "#{t('flash4')}"
              @error = nil
            end
          elsif details[:marks].to_s.downcase == "nc"
            oldmarks = @exam_score.marks

              @exam_score.nc            = details[:marks].to_s
              @exam_score.marks            = nil
              @exam_score.grading_level_id = details[:grading_level_id]
              @exam_score.remarks          = details[:remarks]
            if @exam_score.save
              examscore =   @exam_score
              ExamScoreModification.create do |exam_score_modification|
                exam_score_modification.exam_scores_id  = examscore.id
                exam_score_modification.user_id         = current_user.id
                exam_score_modification.old_marks       = oldmarks
                exam_score_modification.new_marks       = examscore.marks
              end
            else
              flash[:warn_notice] = "#{t('flash4')}"
              @error = nil
            end
          end
        else
          @error = true
        end
      end
    end

    flash[:warn_notice] = "#{t('flash2')}" if @error == true
    flash[:notice] = "#{t('flash3')}" if @error == false
    redirect_to [@exam_group, @exam]
	else
	flash[:warn_notice] = "Vous n'êtes pas autorisé à saisir les notes dans cette date"
	redirect_to [@exam_group, @exam]
	end
  end
def save_scores_all

    @error= false
    params[:exam].each_pair do |student_id, details|
	  @exam = Exam.find(params["st"+student_id])
      @exam_score = ExamScore.find(:first, :conditions => {:exam_id => @exam.id, :student_id => student_id} )
      if @exam_score.nil?
        if details[:marks].to_f <= @exam.maximum_marks.to_f and details[:marks].to_f >= @exam.minimum_marks.to_f
          if details[:marks].to_s != "NC" and details[:marks].to_s != ""
            ExamScore.create do |score|
              score.exam_id          = @exam.id
              score.student_id       = student_id
              score.marks            = details[:marks]
             # score.marks_ar         = details[:marks_ar]
              score.grading_level_id = details[:grading_level_id]
              score.remarks          = details[:remarks]
            end
          end
        else
          @error = true
        end
      else
        if details[:marks].to_f <= @exam.maximum_marks.to_f and details[:marks].to_f >= @exam.minimum_marks.to_f
          if details[:marks].to_s != "" and details[:marks].to_s != "NC"
            if @exam_score.update_attributes(details)
            else
              flash[:warn_notice] = "#{t('flash4')}"
              @error = nil
            end
          end
        else
          @error = true
        end
      end
    end
    flash[:warn_notice] = "#{t('flash2')}" if @error == true
    flash[:notice] = "#{t('flash3')}" if @error == false
    redirect_to :back
  end
def save_scores_all_ar
    @exam = Exam.find(params[:id])
    @error= false
    params[:exam].each_pair do |student_id, details|
      @exam_score = ExamScore.find(:first, :conditions => {:exam_id => @exam.id, :student_id => student_id} )
      if @exam_score.nil?
        if details[:marks].to_f <= @exam.maximum_marks.to_f and details[:marks].to_f >= @exam.minimum_marks.to_f
          if details[:marks].to_s != "NC" and details[:marks].to_s != ""
            ExamScore.create do |score|
              score.exam_id          = @exam.id
              score.student_id       = student_id
              score.marks_ar            = details[:marks]
             # score.marks_ar         = details[:marks_ar]
              score.grading_level_id = details[:grading_level_id]
              score.remarks          = details[:remarks]
            end
          end
        else
          @error = true
        end
      else
        if details[:marks_ar].to_f <= @exam.maximum_marks.to_f and details[:marks_ar].to_f >= @exam.minimum_marks.to_f
          if details[:marks].to_s != "" and details[:marks].to_s != "NC"
            if @exam_score.update_attributes(details)
            else
              flash[:warn_notice] = "#{t('flash4')}"
              @error = nil
            end
          end
        else
          @error = true
        end
      end
    end
    flash[:warn_notice] = "#{t('flash2')}" if @error == true
    flash[:notice] = "#{t('flash3')}" if @error == false
    redirect_to [@exam_group, @exam]
  end
  def save_scores_ar
    @exam = Exam.find(params[:id])
    @error= false
	@configStart = Configuration.get_config_value('StartNoteDate')
	@configEnd = Configuration.get_config_value('EndNoteDate')
	@configAuth = Configuration.get_config_value('Notear')
	logger.debug "****************Configuration*******************"
	logger.debug @configStart
	logger.debug @configEnd
	d1 = Date.strptime(@configStart, "%Y-%m-%d")
  d2 = Date.strptime(@configEnd, "%Y-%m-%d")
  logger.debug d1
  logger.debug d2
	if (d1 <= Date.today and Date.today <=  d2 and @configAuth == "1") or 1 == 1
    params[:exam].each_pair do |student_id, details|
      @exam_score = ExamScore.find(:first, :conditions => {:exam_id => @exam.id, :student_id => student_id} )
      if @exam_score.nil?
        if details[:marks_ar].to_f <= @exam.maximum_marks.to_f
          if details[:marks].to_s != "NC" and details[:marks].to_s != ""
            logger.debug "looola"
            ExamScore.create do |score|
              score.exam_id          = @exam.id
              score.student_id       = student_id
              #score.marks            = details[:marks]
              score.marks_ar         = details[:marks_ar]
              score.grading_level_id = details[:grading_level_id]
              score.remarks          = details[:remarks]
            end
          end
        else
          @error = true
        end
      else
        if details[:marks_ar].to_f <= @exam.maximum_marks.to_f
          logger.debug "11111111"
          if  details[:marks_ar].to_s.downcase != "nc" #and details[:marks_ar].to_s != ""
            logger.debug "22222222"
            if @exam_score.update_attributes(details)
              logger.debug "333333333"
            else
              flash[:warn_notice] = "#{t('flash4')}"
              @error = nil
            end
          else
            @exam_score.marks_ar = nil
            @exam_score.save
          end
        else
          @error = true
        end
      end
    end
    flash[:warn_notice] = "#{t('flash2')}" if @error == true
    flash[:notice] = "#{t('flash3')}" if @error == false
    redirect_to (:action => 'show_ar')
	else
	flash[:warn_notice] = "Vous n'étes pas autorisé à saisir les notes dans cette date"
	redirect_to (:action => 'show_ar')
	end
  end

  def generate_token(length = 10)
    require 'securerandom'
    rand_str = ''
    begin
      rand_str =  10.times.map{rand(10)}.join  #rand(length)
    end while (CodeExam.exists?(:code => rand_str.to_s) or ((rand_str.count rand_str) != 10 ))
    return rand_str
  end

  def export_model
    require 'faster_csv'
        require 'i18n'
#        @sms=SchoolModuleSubject.find(params[:sms])
        @exam=Exam.find(params[:exam_id])
        logger.debug @batch.full_name
    # @batch=@exam.subject.batch
    school_field = SchoolField.find_by_id(@batch.school_field_id)
    #@students=Student.find(:all, :conditions => {:batch_id=>Exam.find(params[:exam_id]).subject.batch.id}, :order => "ordre")
    @students = Student.find_all_by_batch_id(@batch.id) unless !Student.find_all_by_batch_id(@batch.id)
    @students += @batch.old_students
    @students=@students.uniq{|x| x.id}.sort_by {|st| st.last_name}

  annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => {:school_module_id => @exam.exam_group.module_id ,:batch_id=>@batch.id})
  if !annee_reserve_detail.empty?
    annee_reserve_detail.each do |ard|
      annee_reserve = ReserveYearStudent.find(ard.reserve_year_student_id)
      student_ar = Student.find_by_id(annee_reserve.student_id)
      batch_ar = Batch.find_by_id(student_ar.batch_id)
      scf_ar = SchoolField.find_by_id(batch_ar.school_field_id)
      scf = SchoolField.find_by_id(@batch.school_field_id)
      if((batch_ar.school_field_id == @batch.school_field_id) or scf_ar.field_root == scf.id)
        @students << Student.find_by_id(annee_reserve.student_id)
      end
      logger.debug "***************annee de reserve************************"
      logger.debug annee_reserve.student_id
    end

=begin    annee_reserve = ReserveYearStudent.find(annee_reserve_detail.reserve_year_student_id)
    @students << Student.find_by_id(annee_reserve.student_id)
    logger.debug "***************annee de reserve************************"
    logger.debug annee_reserve.student_id
=end
    end
   @students=@students.uniq{|x| x.id}

      else

    if params[:is_ratt]

        csv_string = FasterCSV.generate(:col_sep=>';') do | csv |
        csv << []
        if(school_field.code == "5")
          csv << ["Code", "Nom" , "Prenom", "Note AR", "Observation"]
        else
        csv << ["Code", "Nom" , "Prenom", "Note AR","Observation"]
        end
        code=0
        @students.each do | me |
          code_ex = CodeExam.find(:first, :conditions=>"student_id = #{me.id} and batch_id =#{@batch.id}")
        if(!code_ex)
               code=me.matricule
        else
               code=code_ex.code
        end

        @exam_score = @exam.score_for(me).marks_ar
        if @exam_score.to_f < 10

          @exascore=@exam_score?@exam_score:""
          if(school_field.code == "5")
            csv << [code,"","",@exascore,""]
          else
          csv << [code,me.last_name.to_s,me.first_name.to_s,@exascore,""]
          end

        end
        end
        end
    else
        csv_string = FasterCSV.generate(:col_sep=>';') do | csv |
        csv << []
        if(school_field.code == "5")
          csv << ["Code", "Nom" , "Prenom", "Note", "Observation"]
        else
        csv << ["Code", "Nom" , "Prenom", "Note", "Observation"]
        end
        code=0
        @students.each do | me |
          code_ex = CodeExam.find(:first, :conditions=>"student_id = #{me.id} and batch_id =#{@batch.id}")
        if(!code_ex)
               code=me.matricule
        else
               code=code_ex.code
        end

        @exam_score = @exam.score_for(me).marks

        @exascore=@exam_score?@exam_score:""
        if(school_field.code == "5")
          csv << [code,"","",@exascore,""]
        else
        csv << [code,me.last_name.to_s,me.first_name.to_s,@exascore,""]
        end
        end
        end
    end
    filename=Exam.find(params[:exam_id]).subject.id
   send_data Iconv.conv("iso-8859-1//IGNORE", "iso-8859-1", csv_string),
  :type => 'text/csv; charset=iso-8859-1; header=present',
  :disposition => "attachment; filename=#{filename}.csv"
end

  private
  def query_data
    @exam_group = ExamGroup.find(params[:exam_group_id], :include => :batch)
    @batch = @exam_group.batch
    @course = @batch.course
  end

  def restrict_employees_from_exam_edit
    if @current_user.employee?
      if !@current_user.privileges.map{|p| p.name}.include?("ExaminationControl")
        flash[:notice] = "#{t('flash_msg4')}"
        redirect_to :back
      else
        @allow_for_exams = true
      end
    end
  end
end
