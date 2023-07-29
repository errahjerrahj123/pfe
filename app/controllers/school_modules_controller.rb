class SchoolModulesController < ApplicationController
  # GET /school_modules
  # GET /school_modules.xml
  def index
    @school_modules = SchoolModule.all.sort_by { |sc| sc[:name].to_s }
	@groups=@school_modules.group_by{|mod| mod.module_type_id }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @school_modules }
    end
  end

  # GET /school_modules/1
  # GET /school_modules/1.xml
  def show
    @school_module = SchoolModule.find(params[:id])
	@subject_groups =@school_module.subject_groups(force_reload=false)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school_module }
    end
  end
  
  def show_element_list
      @school_module =SchoolModule.find(params[:module_id])
      @school_module_subjects=SchoolModuleSubject.find(:all,:conditions => {:school_year => params[:school_year], :school_module_id => params[:module_id]})
	  @sum_weighting=0
	  unless !@school_module_subjects 
	  @school_module_subjects.each do |sme|
	     @sum_weighting += sme.subject_weighting
	  end
	  end
=begin
     @subject_groups =[]
	 school_module_subjects.each do |ms|
	    @subject_groups << SubjectGroup.find(ms.subject_group_id)
	     end
=end
	render :update do |page|
	   page.replace_html 'subjects_list', :partial => 'element_list'
	end	  
  end

  # GET /school_modules/new
  # GET /school_modules/new.xml
  def new
    @school_module = SchoolModule.new
    @module_types = ModuleType.find(:all)
	@employees = Employee.find(:all)
	@employee_departments=EmployeeDepartment.find(:all)
    @school_fields = SchoolField.all	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school_module }
    end
  end

  # GET /school_modules/1/edit
  def edit
    @school_module = SchoolModule.find(params[:id])
	@module_types = ModuleType.find(:all)
	@employees = Employee.find(:all)
	@employee_departments=EmployeeDepartment.find(:all)
	@school_fields = SchoolField.all  
end

  # POST /school_modules
  # POST /school_modules.xml
  def create
    @school_module = SchoolModule.new(params[:school_module])

    respond_to do |format|
      if @school_module.save
        flash[:notice] = 'SchoolModule was successfully created.'
        format.html { redirect_to(@school_module) }
        format.xml  { render :xml => @school_module, :status => :created, :location => @school_module }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school_module.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /school_modules/1
  # PUT /school_modules/1.xml
  def update
    @school_module = SchoolModule.find(params[:id])

    respond_to do |format|
      if @school_module.update_attributes(params[:school_module])
        flash[:notice] = 'SchoolModule was successfully updated.'
        format.html { redirect_to(@school_module) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school_module.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /school_modules/1
  # DELETE /school_modules/1.xml
  def destroy
    ActiveRecord::Base.establish_connection
    sql="delete from school_field_school_modules where school_module_id=#{params[:id]}"
    ActiveRecord::Base.connection.execute(sql)
    sql="delete from school_module_subjects where school_module_id=#{params[:id]}"
    ActiveRecord::Base.connection.execute(sql)
    sql="delete from exam_groups where module_id=#{params[:id]}"
    ActiveRecord::Base.connection.execute(sql)
    @school_module = SchoolModule.find(params[:id])
    @school_module.destroy

    respond_to do |format|
      format.html { redirect_to(school_modules_url) }
      format.xml  { head :ok }
    end
  end
  
  #getting list of subjects in relation with this school module 
  def get_subjects
     @school_module = SchoolModule.find(params[:module_id])
     @subject_groups =SubjectGroup.find(:all, :order => "name")
	 render :update do |page|
	   page.replace_html 'subjects_add_list', :partial => 'subjects_add_list'
	   page.show 'search_elem'
	end
  end
    def get_subject_by_search
	@school_module = SchoolModule.find(params[:module_id])
      typed_text=params[:typed_text]
	  if(params[:typed_text].to_s.length > 0)
	  @subject_groups=SubjectGroup.find(:all, :conditions => [" name like ?","#{typed_text}%"])
	  else
	  @subject_groups=SubjectGroup.find(:all)
	  end
	 render :update do |page|
	 page.replace_html 'subjects_add_list', :partial => 'subjects_add_list'
	 end
	 
  end
  
  def show_all_modules
       @school_module=SchoolModule.find(:all)
	@courses=Course.find(:all, :order => "code")
	   
	   
  end
  
  def show_modules_list
     @sf_sm=SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => params[:course_id], :school_year => params[:school_year]}, :order => "school_module_id")
	 @sm_ids=[]
	 @sf_sm.each do |sf|
	    @sm_ids << sf.school_module_id  
	 end
	 @school_modules=SchoolModule.find(:all, :order => "name")
	 @school_fields=SchoolField.find(:all)
	 @school_year=params[:school_year]
	 @course_id=params[:course_id]
	  render :update do |page|
	 page.replace_html 'modules_list', :partial => 'all_modules_list'
	 end
  
  end
  
  def show_module_details
      @act=params[:act]
	  school_module_id=params[:school_module_id]
	  @school_module_id=school_module_id
	  @school_year=params[:school_year]
	  if(@act=='1')
      @sm_sub=SchoolModuleSubject.find(:all, :conditions => {:school_module_id => params[:school_module_id], :school_year => params[:school_year]})	  
	  render :update do |page|
	  page.show "show_details_#{school_module_id}"
	  page.replace_html "show_details_#{school_module_id}", :partial => 'show_details'
	  page.replace_html "action_#{school_module_id}", :partial => 'show_hide'
	  end
	  else
	  render :update do |page|
	     page.hide "show_details_#{school_module_id}"
		 page.replace_html "action_#{school_module_id}", :partial => 'show_hide'
      end  
	  end
     
	  
  end
  
  def hide_module_details
    school_module_id=params[:school_module_id]
	
  
  end
    def show_all_element_result
	  @act=params[:act]
	  # @button_name=params[:button_name]
      @school_module_id=params[:school_module_id]
	  @school_field_id=params[:school_field_id]
	  @school_year=params[:school_year]
	  @course1=params[:course1]
	  @course2=params[:course2]
	  @student_id=params[:student_id]
	  if(@act=='1')
	  @courses=[]
	  @courses << params[:course1]
         @courses << params[:course2]
	  @batches=[]
	 
	  @courses.each do |course|
		               
		               bt= Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s}").reject {|x| x.get_batch_year != @school_year.to_i}
					   if (bt)
					   @batches+=bt
	                end
					end
	
	    @exams=[]
		found = 0
		@annee_reserve_detail = []
		@annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id =#{@student_id} and school_year = #{@school_year} " )
		if(@annee_reserve != nil )
		    @annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve.id}" )
			
		end
		@annee_reserve_detail.each do |ar|
		if(ar.school_module_id == @school_module_id)
		found = 1
		end
		end
	   @batches.each do |bat|
					 bat_anc= Batch.find(:all, :conditions => "course_id = #{bat.course.id.to_s} and school_field_id = #{@school_field_id.to_s}").reject {|x| x.get_batch_year != @school_year.to_i-1}.first
					 if ((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?))
	                 exam_groups=ExamGroup.find(:all, :conditions => {:batch_id => bat.id, :module_id => @school_module_id})
					 else
					 exam_groups=ExamGroup.find(:all, :conditions => {:batch_id => bat_anc.id, :module_id => @school_module_id})
					 end
					 if(exam_groups)
					    exam_groups.each do |ex_gr|
						       @exams +=ex_gr.exams
							   end
					 end
	   
	   
	   end
	   
	  @exam_groups=[]
	  @batches.each do |batch|
	  bat_anc= Batch.find(:all, :conditions => "course_id = #{batch.course.id.to_s} and school_field_id = #{@school_field_id.to_s}").reject {|x| x.get_batch_year != @school_year.to_i-1}.first
	  if (!((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?)))
	  @exam_groups+=ExamGroup.find(:all, :conditions => {:batch_id => batch.id, :module_id => @school_module_id})
	  else
	  @exam_groups+=ExamGroup.find(:all, :conditions => {:batch_id => bat_anc.id, :module_id => @school_module_id})
	  end
	  end
	  @test_rachetage=false
	  @exam_groups.each do |exp|
	  if(Rachetage.find_by_exam_group_id_and_student_id(exp.id,@student_id))
	  @test_rachetage=true
	  end
	  end
	   
	  render :update do |page|
	        page.show "show_elements_result_#{@school_module_id}"
               
		 page.replace_html "show_elements_result_#{@school_module_id}", :partial => 'show_all_element_result'
		 page.replace_html "action_#{@school_module_id}", :partial => 'element_result_show_hide'
		 
      end
	else
		  render :update do |page|
           
	        page.hide "show_elements_result_#{@school_module_id}"
		  page.replace_html "action_#{@school_module_id}", :partial => 'element_result_show_hide'
      end 
	
	end
  end
  
  
  def search_ajax_student_ar
    
      if params[:query].length>= 3
	  
        @school_modules = SchoolModule.find(:all,
          :conditions => ["name LIKE ? OR code LIKE ?  ",
            "#{params[:query]}%","#{params[:query]}%" ]) unless params[:query] == ''
		@groups=@school_modules.group_by{|mod| mod.module_type_id }
      end
      render :layout => false
    
  
end
end
