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

class BatchTransfersController < ApplicationController
  before_filter :login_required
  filter_access_to :all

  def index
	@school_fields=SchoolField.find(:all, :order =>"name")
    @batches = Batch.active
  end

  def show
	@students_reus = []
	@students_red = []
    @batch = Batch.find params[:id], :include => [:students],:order => "students.last_name ASC"
	@batch_cible = []
	@batch_red = []
	sf_ids = []
	sf_ids << @batch.school_field_id
    SchoolField.find_all_by_field_root(@batch.school_field_id).each{|sff| sf_ids << sff.id}
    #@batches = Batch.active - @batch.to_a
    sf_ids.each do |sfsf|
    	logger.debug sfsf.to_s+"\n"
    end
    sf_ids.uniq.each do |sfsf|
		if (@batch.course_id == 2)
			logger.debug 2.to_s+' aaaaaaaaa\n'
		@batch_cible << Batch.find(:first, :conditions => "course_id = 3 and school_field_id = #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i + 1).to_s})")
		@batch_red << Batch.find(:first, :conditions => "course_id = 1 and school_field_id = #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i + 1).to_s})")
	        @batch_cible +=  Batch.find(:all,:conditions => "course_id = 3 and school_field_id = #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i + 1).to_s})")
                @batch_red +=  Batch.find(:all,:conditions => "course_id = 1 and school_field_id = #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i + 1).to_s})")
        elsif (@batch.course_id == 4)
        	logger.debug 4.to_s+' aaaaaaaaa\n'
		@batch_cible << Batch.find(:first, :conditions => "course_id = 5 and school_field_id = #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i + 1).to_s})")
		@batch_red << Batch.find(:first, :conditions => "course_id = 3 and school_field_id = #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i + 1).to_s})")
		school_fields = SchoolField.find(:all, :conditions => "field_root = #{sfsf}")
		school_fields.each do |sf|
			bt = Batch.find(:first, :conditions => "course_id = 5 and school_field_id = #{sf.id} and (year(start_date) = #{(@batch.get_batch_year.to_i + 1).to_s})")
			@batch_cible << bt unless bt.nil?
		end
                @batch_cible +=  Batch.find(:all,:conditions => "course_id = 5 and school_field_id = #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i + 1).to_s})")
                @batch_red +=  Batch.find(:all,:conditions => "course_id = 3 and school_field_id != #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i + 1).to_s})")
	elsif(@batch.course_id == 6)
		logger.debug 6.to_s+' aaaaaaaaa\n'
		@batch_red << Batch.find(:first, :conditions => "course_id = 5 and school_field_id = #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i + 1).to_s})")
	        @batch_red +=  Batch.find(:all,:conditions => "(course_id = 5 or course_id = 6) and school_field_id = #{sfsf} and (year(start_date) >= #{(@batch.get_batch_year.to_i + 1).to_s})")
        elsif (@batch.course_id == 1)
        	logger.debug 1.to_s+' aaaaaaaaa\n'
		@batch_cible << Batch.find(:first, :conditions => "course_id = 2 and school_field_id = #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i)+1})")
	        @batch_cible +=  Batch.find(:all,:conditions => "(course_id = 2 or course_id = 3) and school_field_id = #{sfsf} and (year(start_date) >= #{(@batch.get_batch_year.to_i + 1).to_s})")
        elsif (@batch.course_id == 3)
        	logger.debug 3.to_s+' aaaaaaaaa\n'
		@batch_cible << Batch.find(:first, :conditions => "course_id = 4 and school_field_id = #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i)+1})")
	        @batch_cible += Batch.find(:all, :conditions => "(course_id = 4 or course_id = 5) and school_field_id = #{sfsf} and (year(start_date) >= #{(@batch.get_batch_year.to_i)+1})")
        elsif (@batch.course_id == 5)
        	logger.debug 5.to_s+' aaaaaaaaa\n'
		@batch_cible << Batch.find(:first, :conditions => "course_id = 6 and school_field_id = #{sfsf} and (year(start_date) = #{(@batch.get_batch_year.to_i)+1})")
	        @batch_cible += Batch.find(:all, :conditions => "course_id = 6 and school_field_id = #{sfsf} and (year(start_date) >= #{(@batch.get_batch_year.to_i)+1})")
        end
    end
	@batch_red = @batch_red.uniq.compact
	@batch_cible = @batch_cible.uniq.compact
	# @batch_cible = @batch_cible.reject{|b| b.get_batch_year < @batch.get_batch_year}
	#@batch_cible +=  Batch.all
	#@batch_red +=  Batch.all
	@batch.students.each do |student|
		if(@batch.course_id == 1 or @batch.course_id == 3 or @batch.course_id == 5)
#			ydecision=YearlyDecision.find(:first, :conditions => "student_id = #{student.id} and school_year = #{@batch.get_batch_year.to_s} and batch_ids like '%#{(@batch.id.to_s << ',')}%'")
		  else
			batch_prec = Batch.find(:first, :conditions => "course_id = #{@batch.course_id-1} and school_field_id = #{@batch.school_field_id.to_s} and (year(start_date) = #{@batch.get_batch_year})")
			if(!batch_prec.nil?)
				ydecision=YearlyDecision.find(:first, :conditions => "student_id = #{student.id} and school_year = #{@batch.get_batch_year.to_s} and batch_ids like '%#{(batch_prec.id.to_s << ',' << @batch.id.to_s << ',')}%'")
			end
		  end
		  if(!ydecision.nil?)
		  if( ydecision.decision.to_s != "AnneeReserve" and ydecision.decision.to_s != "Exclu" and ydecision.decision.to_s != "Ajourne" and ydecision.decision.to_s != "Reoriente")
			@students_reus << student
		  else
			@students_red << student
		  end
		  else
		  @students_reus << student
		  end
	end

	@school_fields=SchoolField.find(:all, :order =>"name")

@batch_red = Batch.all
@batch_cicle = Batch.all

=begin
	 elsif(@current_user.employee?)
	 @school_fields=SchoolField.find_by_employee_id(@current_user.employee.id)
	 end
=end
      #@courses=Course.find(:all, :order => "code")
  end

=begin  def transfer
    unless params[:transfer][:students].nil?
      students = Student.find(params[:transfer][:students])
      students.each do |s|
        s.batch_students.create(:batch_id => s.batch.id)
        s.update_attribute(:batch_id, params[:transfer][:to])
        s.update_attribute(:has_paid_fees,0)
      end
    end
    batch = Batch.find(params[:id])
    @stu = Student.find_all_by_batch_id(batch.id)
    if @stu.empty?
      batch.update_attribute :is_active, false
      Subject.find_all_by_batch_id(batch.id).each do |sub|
          sub.employees_subjects.each do |emp_sub|
            emp_sub.delete
          end
      end
    end
    flash[:notice] = "#{t('flash1')}"
    redirect_to :controller => 'batch_transfers'
  end
=end

=begin  def transfer
	@batch_cible = Batch.find params[:transfer][:batch_cible] unless params[:transfer][:batch_red].nil?
	@batch_red = Batch.find params[:transfer][:batch_red] unless params[:transfer][:batch_red].nil?
	@batch_act = Batch.find params[:batch_act]
	unless params[:transfer][:students].nil? and params[:transfer][:batch_cible].nil? and params[:transfer][:batch_red].nil?
		 students = Student.find(params[:transfer][:students])
		 students.each do |s|
			if(!@batch_cible.nil? and !@batch_act.nil? and (@batch_act.course_id == 1 or @batch_act.course_id == 3 or @batch_act.course_id == 5) )
				s.batch_students.create(:batch_id => s.batch.id)
				s.update_attribute(:batch_id, @batch_cible.id)
				s.update_attribute(:has_paid_fees,0)
			elsif(!@batch_cible.nil? and !@batch_act.nil? and @batch_act.course_id != 6)
				batch_prec = Batch.find(:first, :conditions => "course_id = #{@batch_act.course_id-1} and school_field_id = #{@batch_act.school_field_id.to_s} and (year(start_date) = #{@batch_act.get_batch_year})")
				if (!batch_prec.nil?)
					ydecision=YearlyDecision.find(:first, :conditions => "student_id = #{s.id} and school_year = #{@batch_act.get_batch_year.to_s} and batch_ids like '%#{(batch_prec.id.to_s << ',' << @batch_act.id.to_s << ',')}%'")
					if(!ydecision.nil? and ydecision.decision.to_s != "AnneeReserve" and ydecision.decision.to_s != "Exclu" and ydecision.decision.to_s != "Ajourne" and ydecision.decision.to_s != "Reoriente")
						logger.debug '***********************cas du reussit*************************************'
						logger.debug ydecision.decision.to_s
						s.batch_students.create(:batch_id => s.batch.id)
						s.update_attribute(:batch_id, @batch_cible.id)
						s.update_attribute(:has_paid_fees,0)
					elsif(!ydecision.nil? and ydecision.decision.to_s == "AnneeReserve")
						s.batch_students.create(:batch_id => s.batch.id)
						s.update_attribute(:batch_id, @batch_red.id)
						s.update_attribute(:has_paid_fees,0)
					end
				end
			end
		 end
	end

	flash[:notice] = "#{t('flash1')}"
    redirect_to :controller => 'batch_transfers'
  end
=end

def transfer
	exist_res = params[:existe_res]
	existe_red = params[:existe_red]
	@batch_cible = Batch.find params[:transfer][:batch_cible] unless params[:transfer][:batch_cible].nil?
	@batch_red = Batch.find params[:transfer][:batch_red] unless params[:transfer][:batch_red].to_i == 0
	@batch_act = Batch.find params[:batch_act]
	if(exist_res)
		unless params[:transfer_res].nil?
                      if (params[:transfer_res][:students] and params[:transfer][:batch_cible])
			 students = Student.find(params[:transfer_res][:students])
			 students.each do |s|
				s.batch_students.create(:batch_id => s.batch.id)
				s.update_attribute(:batch_id, params[:transfer][:batch_cible])
				s.update_attribute(:has_paid_fees,0)
        @batch = 	@batch_cible
        @exam_groups = @batch.exam_groups
        @exam_groups.each do |exg|
            code  = "#{s.id}#{rand.to_s[2..5]}"
            CodeExam.create(:student_id=>s.id,:batch_id=>@batch.id,:exam_group_id =>exg.id ,:code=>code.to_s)



        end
			 end
                      end
		end
	end
	if(existe_red)
		unless params[:transfer_red].nil?
                     if ( !params[:transfer_red][:students].nil? and !params[:transfer][:batch_red].nil?)
			 students = Student.find(params[:transfer_red][:students])
			 students.each do |s|
				s.batch_students.create(:batch_id => s.batch.id)
				s.update_attribute(:batch_id, params[:transfer][:batch_red])
				s.update_attribute(:has_paid_fees,0)
        @exam_groups = @batch.exam_groups
        @exam_groups.each do |exg|
          @student_list.each do |std|
            code  = "#{std.id}#{rand.to_s[2..5]}"
            CodeExam.create(:student_id=>s,:batch_id=>@batch.id,:exam_group_id =>exg.id ,:code=>code.to_s)

          end

        end
			 end
                     end
		end
	end

	flash[:notice] = "#{t('flash1')}"
    redirect_to :controller => 'batch_transfers'
end

  def graduation
    @batch = Batch.find params[:id], :include => [:students]
    unless params[:ids].nil?
      @ids = params[:ids]
      @id_lists = @ids.map { |st_id| ArchivedStudent.find_by_admission_no(st_id) }
    end
    if request.post?
      student_id_list = params[:graduate][:students]
        @student_list = student_id_list.map { |st_id| Student.find(st_id) }

        @admission_list = []
        @student_list.each do |s|
          @admission_list.push s.admission_no
        end
        @student_list.each { |s| s.archive_student(params[:graduate][:status_description]) }
        @stu = Student.find_all_by_batch_id(@batch.id)
        if @stu.empty?
          @batch.update_attribute :is_active, false
          @batch.employees_subjects.destroy_all
#          flash[:notice]="Graduated selected students successfully."
#          redirect_to :controller=>'batch_transfers' and return
        end
        flash[:notice]= "#{t('flash2')}"
        redirect_to :action=>"graduation", :id=>params[:id], :ids => @admission_list
      end
    end

  def subject_transfer
    @batch = Batch.find(params[:id])
    @elective_groups = @batch.elective_groups.all(:conditions => {:is_deleted => false})
    @normal_subjects = @batch.normal_batch_subject
    @elective_subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=>["elective_group_id IS NOT NULL AND is_deleted = false"])
  end

  def get_previous_batch_subjects
    @batch = Batch.find(params[:id])
    course = @batch.course
    all_batches = course.batches(:order=>'id asc')
    all_batches.reject! {|b| b.is_deleted?}
    all_batches.reject! {|b| b.subjects.empty?}
    @previous_batch = all_batches[all_batches.size-2]
    unless @previous_batch.blank?
    @previous_batch_normal_subject = @previous_batch.normal_batch_subject
    @elective_groups = @previous_batch.elective_groups.all(:conditions => {:is_deleted => false})
    @previous_batch_electives = Subject.find_all_by_batch_id(@previous_batch.id,:conditions=>["elective_group_id IS NOT NULL AND is_deleted = false"])
    render(:update) do |page|
      page.replace_html 'previous-batch-subjects', :partial=>"previous_batch_subjects"
    end
    else
      render(:update) do |page|
        page.replace_html 'msg', :text=>"<p class='flash-msg'>#{t('batch_transfers.flash4')}</p>"
      end
    end
  end

  def update_batch

	@school_field_id=params[:school_field_id]
	 @school_year=params[:school_year]
	 @course_id=params[:course_name].to_i
	 if(@school_field_id != nil and @school_field_id != '')
     @batches=Batch.find(:all, :conditions => "course_id = #{@course_id} and school_field_id = #{@school_field_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
	else
	 @batches=Batch.find(:all, :conditions => "course_id = #{@course_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
	end

    #@batches = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false, :is_active => true })

    render(:update) do |page|
      page.replace_html 'update_batch', :partial=>'list_courses'
    end

  end

  def update_batch2

	@school_field_id=params[:school_field_id]
	 @school_year=params[:school_year]
	 @course_id=params[:course_name].to_i
	 if(@school_field_id != nil and @school_field_id != '')
     @batches=Batch.find(:all, :conditions => "course_id = #{@course_id} and school_field_id = #{@school_field_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
	else
	 @batches=Batch.find(:all, :conditions => "course_id = #{@course_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
	end

    #@batches = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false, :is_active => true })

    render(:update) do |page|
      page.replace_html 'update_batch', :partial=>'update_batch'
    end

  end

  def assign_previous_batch_subject
    subject = Subject.find(params[:id])
    batch = Batch.find(params[:id2])
    sub_exists = Subject.find_by_batch_id_and_name(batch.id,subject.name, :conditions => { :is_deleted => false})
    if sub_exists.nil?
      if subject.elective_group_id == nil
        Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
          :max_weekly_classes=>subject.max_weekly_classes,:credit_hours=>subject.credit_hours,:elective_group_id=>subject.elective_group_id,:is_deleted=>false)
      else
        elect_group_exists = ElectiveGroup.find_by_name_and_batch_id(ElectiveGroup.find(subject.elective_group_id).name,batch.id)
        if elect_group_exists.nil?
          elect_group = ElectiveGroup.create(:name=>ElectiveGroup.find(subject.elective_group_id).name,
            :batch_id=>batch.id,:is_deleted=>false)
          Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
            :max_weekly_classes=>subject.max_weekly_classes,:credit_hours=>subject.credit_hours,:elective_group_id=>elect_group.id,:is_deleted=>false)
        else
          Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
            :max_weekly_classes=>subject.max_weekly_classes,:credit_hours=>subject.credit_hours,:elective_group_id=>elect_group_exists.id,:is_deleted=>false)
        end
      end
      render(:update) do |page|
        page.replace_html "prev-subject-name-#{subject.id}", :text=>""
        page.replace_html "errors", :text=>"#{subject.name}  #{t('has_been_added_to_batch')}:#{batch.name}"
      end
    else
      render(:update) do |page|
        page.replace_html "prev-subject-name-#{subject.id}", :text=>""
        page.replace_html "errors", :text=>"<div class=\"errorExplanation\" ><p>#{batch.name} #{t('already_has_subject')} #{subject.name}</p></div>"
      end
    end
  end

  def assign_all_previous_batch_subjects
    msg = ""
    err = ""
    batch = Batch.find(params[:id])
    course = batch.course
    all_batches = course.batches(:order=>'id asc')
    all_batches.reject! {|b| b.is_deleted?}
    all_batches.reject! {|b| b.subjects.empty?}
    @previous_batch = all_batches[all_batches.size-2]
    subjects = Subject.find_all_by_batch_id(@previous_batch.id,:conditions=>'is_deleted=false')
    subjects.each do |subject|
      sub_exists = Subject.find_by_batch_id_and_name(batch.id,subject.name, :conditions => { :is_deleted => false})
      if sub_exists.nil?
        if subject.elective_group_id.nil?
          Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
            :max_weekly_classes=>subject.max_weekly_classes,:credit_hours=>subject.credit_hours,:elective_group_id=>subject.elective_group_id,:is_deleted=>false)
        else
          elect_group_exists = ElectiveGroup.find_by_name_and_batch_id(ElectiveGroup.find(subject.elective_group_id).name,batch.id)
          if elect_group_exists.nil?
            elect_group = ElectiveGroup.create(:name=>ElectiveGroup.find(subject.elective_group_id).name,
              :batch_id=>batch.id,:is_deleted=>false)
            Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
              :max_weekly_classes=>subject.max_weekly_classes,:credit_hours=>subject.credit_hours,:elective_group_id=>elect_group.id,:is_deleted=>false)
          else
            Subject.create(:name=>subject.name,:code=>subject.code,:batch_id=>batch.id,:no_exams=>subject.no_exams,
              :max_weekly_classes=>subject.max_weekly_classes,:credit_hours=>subject.credit_hours,:elective_group_id=>elect_group_exists.id,:is_deleted=>false)
          end
        end
        msg += "<li> #{t('the_subject')} #{subject.name}  #{t('has_been_added_to_batch')} #{batch.name}</li>"
      else
        err +=   "<li>#{t('batch')} #{batch.name} #{t('already_has_subject')} #{subject.name}" + "</li>"
      end
    end
    @batch = batch
    course = batch.course
    all_batches = course.batches
    @previous_batch = all_batches[all_batches.size-2]
    @previous_batch_normal_subject = @previous_batch.normal_batch_subject
    @elective_groups = @previous_batch.elective_groups
    @previous_batch_electives = Subject.find_all_by_batch_id(@previous_batch.id,:conditions=>["elective_group_id IS NOT NULL AND is_deleted = false"])
    render(:update) do |page|
      page.replace_html 'previous-batch-subjects', :text=>"<p>#{t('subjects_assigned')}</p> "
      unless msg.empty?
        page.replace_html "msg", :text=>"<div class=\"flash-msg\"><ul>" +msg +"</ul></p>"
      end
      unless err.empty?
        page.replace_html "errors", :text=>"<div class=\"errorExplanation\" ><p>#{t('following_errors_found')} :</p><ul>" +err + "</ul></div>"
      end
    end

  end



  def new_subject
    @subject = Subject.new
    @batch = Batch.find params[:id] if request.xhr? and params[:id]
    @elective_group = ElectiveGroup.find params[:id2] unless params[:id2].nil?
    respond_to do |format|
      format.js { render :action => 'new_subject' }
    end
  end

  def create_subject
    @subject = Subject.new(params[:subject])
    @batch = @subject.batch
    if @subject.save
      @subjects = @subject.batch.normal_batch_subject
      @normal_subjects = @subjects
      @elective_groups = ElectiveGroup.find_all_by_batch_id(@batch.id)
      @elective_subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=>["elective_group_id IS NOT NULL AND is_deleted = false"])
    else
      @error = true
    end
  end

end
