class RequestdocStudentsController < ApplicationController
  #before_filter :login_required

#  before_filter :protect_other_student_data

  # GET /requestdoc_students
  # GET /requestdoc_students.xml
  def index
    @current_user = current_user
    @school_fields = []
    @batchs = []
    @school_years = []
	logger.debug "indeeex"
		logger.debug "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
	logger.debug params[:requestdoc]
	logger.debug "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
	if !params[:requestdoc].nil? and params[:requestdoc].to_s != ""
		RequestdocStudent.find(:all,:conditions => {:requestdoc_id => params[:requestdoc_id].to_i}).each do |s|
			@batchs.push(s.student.batch)
			@school_fields.push(s.student.batch.school_field)
			@school_years.push(s.school_year,session[:param_notes])
	    end
	else
	    RequestdocStudent.all.each do |s|
	    	if s.student
				@batchs.push(s.student.batch)
				@school_fields.push(s.student.batch.school_field)
				@school_years.push(s.school_year)
			end
	    end
	end
  	logger.debug "yea heere"
    @school_fields = @school_fields.uniq.sort_by {|s| s.name}
    @batchs = @batchs.uniq.sort_by {|s| s.name}
    @school_years = @school_years.uniq.sort
    if current_user.admin? #or current_user.privileges.map{|p| p.name}.include?("GestionDemandes")
	@requestdoc_students = RequestdocStudent.all.sort_by {|a| a.created_at}
    elsif current_user.employee?
    @school_fields = @school_fields.uniq.sort_by {|s| s.name}.reject{|r| r.employee_id != current_user.employee_record.id}
    sf_ids = []
    @school_fields.each{|s| sf_ids << s.id}
    SchoolField.find_all_by_employee_id(current_user.employee_record.id).each do |s|
    	sf_ids += SchoolField.find_all_by_parent_sf_id(s.id)
    	sf_ids << s.parent_sf_id
    	sf_ids += SchoolField.find_all_by_parent_sf_id(s.parent_sf_id)
    end
    @batchs = @batchs.uniq.sort_by {|s| s.name}.select{|b| (sf_ids.include? b.school_field_id) or b.employee_id == current_user.employee_record.id }
    @school_years = @school_years.uniq.sort
    b_ids = []
    @batchs.each{|b| b_ids << b.id}
   @requestdoc_students = RequestdocStudent.all.sort_by {|a| a.created_at}.select{|rs| sf_ids.include? rs.school_field_id}
    # @requestdoc_students = RequestdocStudent.all.sort_by {|a| a.created_at}.select{|rs| b_ids.include? rs.batch_id}
#   @requestdoc_students = []
    elsif current_user.student?
	logger.debug "ssstuuudent"
	@requestdoc_students = RequestdocStudent.find(:all, :conditions => {:student_id => Student.find_by_user_id(current_user.id).id}).sort_by {|a| a.updated_at}
    end
#    @requestdoc_students = RequestdocStudent.all

  end

  def filters
    @current_user = current_user
    @school_fields = []
    @batchs = []
    @school_years = []
    logger.debug params[:statut]
    logger.debug params[:statut].to_i
    logger.debug "stattut T"
    requestdoc_id =  params[:requestdoc]
    sf_id = params[:sf]
    sy = params[:sy]
    batch_id = params[:batch]
    statut = params[:statut]
    printed = params[:printed]

	@requestdoc_students = RequestdocStudent.all
#        @requestdoc_students = RequestdocStudent.find(:all, :conditions => {:requestdoc_id => params[:requestdoc].to_i, :statut => params[:statut], :school_year => params[:sy], :school_field_id => params[:sf], :batch_id => params[:batch]}).sort_by {|a| a.created_at}
	logger.debug "lol"
#	if params[:requestdoc] != "" and params[:statut].to_s != "" and params[:sy].to_s != "" and params[:sf].to_s != "" and params[:batch]!=""
	if !requestdoc_id.blank?
		@requestdoc_students = @requestdoc_students.reject{|r| r.requestdoc.id != requestdoc_id.to_i}
		if params[:doc_spec].to_s != ""
			if requestdoc_id.to_i == 5
				@requestdoc_students = @requestdoc_students.reject{|r| r.requestdoc.id != requestdoc_id.to_i or r.rdv_doc.to_s != params[:doc_spec].to_s}

			elsif requestdoc_id.to_i == 13
				@requestdoc_students = @requestdoc_students.reject{|r| r.requestdoc.id != requestdoc_id.to_i or r.doc_specification.to_s != params[:doc_spec].to_s}

			end
		end
	end
	if !printed.blank?
		if printed.to_i == 1
		@requestdoc_students = @requestdoc_students.reject{|r| r.last_print_date.nil?}
		elsif printed.to_i == 0
		@requestdoc_students = @requestdoc_students.reject{|r| !r.last_print_date.nil?}
		end
	end
	if !sf_id.blank?
		@requestdoc_students = @requestdoc_students.reject{|r| r.school_field_id != sf_id.to_i}
	end

	if !sy.blank?
		@requestdoc_students = @requestdoc_students.reject{|r| r.school_year != sy.to_i}
	end
	if !batch_id.blank?
		@requestdoc_students = @requestdoc_students.reject{|r| r.batch_id != batch_id.to_i}
	end
=begin
	if statut.to_s == "null"
		statut = "null"
	elsif statut.to_s == "1"
		statut = true
	elsif statut.to_s == "0"
		statut = false
	end
=end
	if !statut.blank?
			if statut.to_s == "null"
					@requestdoc_students = @requestdoc_students.reject{|r| r.statut != nil}
			else
					@requestdoc_students = @requestdoc_students.reject{|r| r.statut != statut.to_i}
			end
	end

    @school_fields = @school_fields.uniq.sort_by {|s| s.name}
    @batchs = @batchs.uniq.sort_by {|s| s.name}
    @school_years = @school_years.uniq.sort


=begin
	if params[:statut].blank?
        @requestdoc_students = RequestdocStudent.find(:all, :conditions => "requestdoc_id LIKE '#{requestdoc.to_s}' and school_year LIKE '%#{school_year}' and school_field_id LIKE '%#{school_field_id}' and batch_id LIKE '%#{batch_id}'").sort_by {|a| a.created_at}
		logger.debug "its blank"
	else
        @requestdoc_students = RequestdocStudent.find(:all, :conditions => "requestdoc_id LIKE '#{requestdoc.to_s}' and statut is #{statut} and school_year LIKE '%#{school_year}' and school_field_id LIKE '%#{school_field_id}' and batch_id LIKE '%#{batch_id}'").sort_by {|a| a.created_at}
		logger.debug "it ain't blank"
	end
=end
	@requestdoc_students.each do |s|
		if s.student
		@batchs.push(s.student.batch)
		@school_fields.push(s.student.batch.school_field)
		@school_years.push(s.school_year)
    end
  end
	if @batchs.nil?
		logger.debug "batchs is nil"
	else
		logger.debug "batch not nil"
	end
	if @batchs.empty?
		logger.debug "batchs is empty"
	else
		logger.debug "batch not empty"
	end
	@batchs.each do |b|
		logger.debug b.name
	end
    @school_fields = @school_fields.uniq.sort_by {|s| s.name}
    @batchs = @batchs.uniq.sort_by {|s| s.name}
    @school_years = @school_years.uniq.sort

#        @requestdoc_students = RequestdocStudent.find(:all, :conditions => "requestdoc_id LIKE '%#{params[:requestdoc].to_s}' and statut LIKE '%#{params[:statut]}' and school_year LIKE '%#{school_year}' and school_field_id LIKE '%#{school_field_id}' and batch_id LIKE '%#{batch_id}'").sort_by {|a| a.created_at}
#        @requestdoc_students = RequestdocStudent.find(:all, :conditions => "requestdoc_id LIKE '%#{params[:requestdoc].to_s}' and (statut is null or statut LIKE '%#{params[:statut]}') and school_year LIKE '%#{school_year}' and school_field_id LIKE '%#{school_field_id}' and batch_id LIKE '%#{batch_id}'").sort_by {|a| a.created_at}

if current_user.employee?
    @school_fields = @school_fields.uniq.sort_by {|s| s.name}.reject{|r| r.employee_id != current_user.employee_record.id}
    sf_ids = []
    @school_fields.each{|s| sf_ids << s.id}
    @batchs = @batchs.uniq.sort_by {|s| s.name}.select{|b| (sf_ids.include? b.school_field_id) or b.employee_id == current_user.employee_record.id }
    @school_years = @school_years.uniq.sort
    # @batchs.each{|b| b_ids << b.id}
   @requestdoc_students = @requestdoc_students.sort_by {|a| a.created_at}.select{|rs| sf_ids.include? rs.school_field_id}
     @requestdoc_students.each do |rs|
    	# logger.debug Batch.find(rs.batch_id).full_name+" \n"
    end
    logger.debug "loool"
   #@requestdoc_students = []
end
	if params[:es_type] or params[:requestdoc] != ""

            render(:update) do |page|
              page.replace_html 'tablle', :partial=>"student_list_statut"
              page.replace_html 'types', :partial=>"types"
              page.replace_html 'filters_sfs', :partial=>"filters_sfs"
              page.replace_html 'filters_batchs', :partial=>"filters_batchs"
            end
	else

            render(:update) do |page|
              page.replace_html 'types', :partial=>"types"
              page.replace_html 'tablle', :partial=>"student_list"
              page.replace_html 'filters_sfs', :partial=>"filters_sfs"
              page.replace_html 'filters_batchs', :partial=>"filters_batchs"
            end
	end
  end

  # GET /requestdoc_students/1
  # GET /requestdoc_students/1.xml
  def show
    @current_user = current_user
	logger.debug "qssstuuudent"
#    if current_user.admin?
	@requestdoc_student = RequestdocStudent.find(params[:id])

 #   end
	render(:update) do |page|
          page.replace_html 'modal-box', :partial => 'show'
          page << "Modalbox.show($('modal-box'), {title: 'Demande Document n° #{@requestdoc_student.id}', width: 400, height:600});"
        end

  end

  # GET /requestdoc_students/new
  # GET /requestdoc_students/new.xml
def choice
	@current_user = current_user
     requestdoc_id = params[:requestdoc_id].to_i
     if requestdoc_id.nil?
		requestdoc_id = params
     end
        st_nb_max = RequestdocStudent.count(:all, :conditions => {:student_id => Student.find_by_user_id(current_user.id).id, :requestdoc_id => requestdoc_id})
        rd_nb_max = Requestdoc.find(requestdoc_id)
      	logger.debug Student.find_by_user_id(current_user.id).id
      	logger.debug st_nb_max.to_i
	logger.debug rd_nb_max.nb_max.to_i
	  if st_nb_max.to_i>rd_nb_max.nb_max.to_i
		logger.debug "yeaaa fttii"
                flash[:notice] = "Vous avez depassé le nombre max des #{rd_nb_max.name} qui est #{rd_nb_max.nb_max}"
	  else
		flash[:notice] = nil
    	end

     case requestdoc_id
        when 1

        @all_batchs = []
        old_one = nil
        current_user.student_record.all_batches.uniq.each do |b|


#        	unless old_one.nil?

#	        	if b.course.course_name == old_one.course.course_name
        	# start of delibparams

        	# checking
        		logger.debug "hola!"
        		logger.debug b.full_name
        		logger.debug b.id
        		logger.debug b.school_field_id
				sf_id = b.school_field_id
        		logger.debug sf_id
				c_ids = "#{b.course.id}"
#				c_ids = "#{old_one.course.id},#{b.course.id}"
				sy = (b.get_batch_year)
				# delib = DelibParam.find(:first, :conditions => "school_field_id = #{sf_id} and school_year = #{sy} and course_ids like '%#{c_ids}%'")
				# if delib.nil?
				# 	if !SchoolField.find(b.school_field_id).field_root.nil?
				# 		sf_id = SchoolField.find(b.school_field_id).field_root
				# 	end
				# delib = DelibParam.find(:first, :conditions => "school_field_id = #{sf_id} and school_year = #{sy} and course_ids like '%#{c_ids}%'")

				# end

				# attributing it
				# if delib.nil?
				# 	is_param_delib=false
				# else
				# 	is_param_delib=true
				# end
        	# end of delib params
	        		# @all_batchs += [{:year_name => "#{b.course.course_name} - #{b.name}", :batchs_ids => "#{b.id},#{old_one.id}", :school_year => b.get_batch_year,:is_delib => is_param_delib}]
	        		@all_batchs += [{:year_name => "#{b.course.course_name} - #{b.name}", :batchs_ids => "#{b.id},#{old_one.id}", :school_year => b.get_batch_year}]
#	        	end
#	        end
	        old_one = b
        end
logger.debug "********************"
logger.debug "********************"
logger.debug "********************"
logger.debug @all_batchs.inspect
logger.debug "********************"
logger.debug "********************"
logger.debug "********************"

		@batch_years = []
		by_tmp = []
               logger.debug current_user.student.id
#		Student.find_by_user_id(current_user.id).batch_students.each do |b|
		Student.find_by_user_id(current_user.id).batch_students.each do |b|
			b_y = b.batch.get_batch_year.to_i
			b_m = b.batch.start_date.year.to_i
			if (b_y == Time.now.year and b_m <= 7) or b_y < Time.now.year
				year = b.batch.get_batch_year
			end
			#if all_batch_years.last == year
			by_tmp.push(year)
		end
		by_tmp.push(Student.find_by_user_id(current_user.id).batch.get_batch_year)
		by_tmp = by_tmp.uniq
		by_tmp.each{|byy| logger.debug byy.to_s+" --- " }
		@batch_years = by_tmp
		by_tmp.length.times do |i|
			if by_tmp[i] == by_tmp[i+1]
				@batch_years.push(by_tmp[i])
			end
		end

            render(:update) do |page|
              page.replace_html 'next-div', :partial=>"releve_to_niveau"
            end

        when 2
            render(:update) do |page|
              page.replace_html 'next-div', :partial=>"certif_sco"
            end
          logger.debug "lool 2"
        when 4
	    yd = YearlyDecision.find(:all, :conditions => "student_id = #{Student.find_by_user_id(current_user.id).id} and (decision like 'Adm%' or decision like 'diplo%')")
	    @years = []
	    yd.each do |a|
		@years.push(a.school_year,session[:param_notes])
		logger.debug a.school_year
	    end
		@years = @years.uniq

            render(:update) do |page|
              page.replace_html 'next-div', :partial=>"attes_reus"
            end
          logger.debug "lool 3"
        when 8
	  @got_scholarship = false
	  if Student.find_by_user_id(current_user.id).bourse
		logger.debug Student.find_by_user_id(current_user.id).bourse
		@got_scholarship = true
	  end
          logger.debug "lool 4"
	    render(:update) do |page|
              page.replace_html 'next-div', :partial=>"ab_to_niveau"
            end
	when 5
	    render(:update) do |page|
              page.replace_html 'next-div', :partial=>"rdv"
            end
	when 3
	    render(:update) do |page|
              page.replace_html 'next-div', :partial=>"dem_spe"
            end

     when 13

	    render(:update) do |page|
              page.replace_html 'next-div', :partial=>"reclamation"
            end

     when 14

        @all_batchs = []
        old_one = nil
        current_user.student_record.all_batches.uniq.each do |b|
        	unless old_one.nil?
	        	if b.course.course_name == old_one.course.course_name
	        		@all_batchs += [{:year_name => "#{b.course.course_name} - #{b.name}", :batchs_ids => "#{b.id},#{old_one.id}", :school_year => b.get_batch_year}]
	        	end
	        end
	        old_one = b
        end
		@batch_years = []
		by_tmp = []
               logger.debug current_user.student.id
#		Student.find_by_user_id(current_user.id).batch_students.each do |b|
		Student.find_by_user_id(current_user.id).batch_students.each do |b|
			b_y = b.batch.get_batch_year.to_i
			b_m = b.batch.start_date.year.to_i
			if (b_y == Time.now.year and b_m <= 7) or b_y < Time.now.year
				year = b.batch.get_batch_year
			end
			#if all_batch_years.last == year
			by_tmp.push(year)
		end
		by_tmp.length.times do |i|
			if by_tmp[i] == by_tmp[i+1]
				@batch_years.push(by_tmp[i])
			end
		end

	    render(:update) do |page|
              page.replace_html 'next-div', :partial=>"structuration"
            end

     end
end

def rd_submit_btn
	render(:update) do |page|
          page.replace_html 'ne-next-step', :partial=>"rd_submit_btn"
    end
end

def rd_submit_choice
     requestdoc_id = params[:requestdoc_id].to_i
     if params[:requestdoc_id].nil?
    	requestdoc_id = params[:rdv][:requestdoc_id].to_i

     end
     school_year = params[:school_year].to_i
     logger.debug current_user.id
     student = Student.find_by_user_id(current_user.id)
	if !params[:requestdoc_id].nil? and !params[:school_year].nil?
		logger.debug "yeaaaaay"
	elsif !params[:requestdoc_id].nil?
		logger.debug "yoaaaaay"
	end

     case requestdoc_id
        when 1
		flash[:notice] = "La demande de #{Requestdoc.find(requestdoc_id).name} est effectuéee"
        motif = params[:releve][:motif].to_s
        	# logger.debug Batch.find(params[:rel][:batches].split(',')[0]).get_batch_year
    	params[:rel][:batches].each do |b|
		    school_year = Batch.find(b.split(',')[0]).get_batch_year
			RequestdocStudent.create(:student_id => student.id,:requestdoc_id => requestdoc_id,:motif => motif, :school_year => school_year, :statut => nil, :school_field_id => student.batch.school_field.id, :batch_ids => b)
    		logger.debug b
    	end
    	redirect_to :action => 'index'
    	when 14
		flash[:notice] = "La demande de #{Requestdoc.find(requestdoc_id).name} est effectuéee"

        	# logger.debug Batch.find(params[:rel][:batches].split(',')[0]).get_batch_year
    	params[:rel][:batches].each do |b|
	    	school_year = Batch.find(b.split(',')[0]).get_batch_year
			RequestdocStudent.create(:student_id => student.id,:requestdoc_id => requestdoc_id, :school_year => school_year, :statut => nil, :school_field_id => student.batch.school_field.id, :batch_ids => b)
    		logger.debug b
    	end
        	logger.debug "lop"
#		@requestdoc_students = RequestdocStudent.find(:all, :conditions => {:student_id => Student.find_by_user_id(current_user.id).id}).sort_by {|a| a.updated_at}
#		render :controller => 'requestdoc_student', :action => 'index'
		redirect_to :action => 'index'

#         redirect_to(requestdoc_students_url)
#            render(:update) do |page|
#             page.replace_html 'next-div', :partial=>"releve_to_niveau"
#          end

        when 2

        motif = params[:releve][:motif].to_s


		RequestdocStudent.create(:student_id => student.id,:requestdoc_id => requestdoc_id,:motif => motif ,:school_year => student.batch.get_batch_year, :statut => nil, :school_field_id => student.batch.school_field.id, :batch_id => student.batch.id)
		flash[:notice] = "La demande de #{Requestdoc.find(requestdoc_id).name} est effectuéee"
		redirect_to :action => 'index'
        when 4
        motif = params[:releve][:motif].to_s

		RequestdocStudent.create(:student_id => student.id,:requestdoc_id => requestdoc_id, :motif => motif,:school_year => student.batch.get_batch_year, :statut => nil, :school_field_id => student.batch.school_field.id, :batch_id => student.batch.id)
		flash[:notice] = "La demande de #{Requestdoc.find(requestdoc_id).name} est effectuéee"
		redirect_to :action => 'index'
        when 8

        motif = params[:releve][:motif].to_s
		RequestdocStudent.create(:student_id => student.id,:requestdoc_id => requestdoc_id, :motif => motif,:school_year => student.batch.get_batch_year, :statut => nil, :school_field_id => student.batch.school_field.id, :batch_id => student.batch.id)
		flash[:notice] = "La demande de #{Requestdoc.find(requestdoc_id).name} est effectuéee"
		redirect_to :action => 'index'
        when 5
 		requestdoc_id = params[:rdv][:requestdoc_id]
 		rdv_date_p = params[:rdv][:rdv_date_p]
 		rdv_doc = params[:rdv][:rdv_doc]
 		motif = params[:releve][:motif].to_s
 		Student.find_by_user_id(current_user.id).update_attributes(:phone1 => params[:rdv][:phone])
		RequestdocStudent.create(:date_rdv_p => rdv_date_p, :rdv_doc => rdv_doc, :student_id => student.id,:requestdoc_id => requestdoc_id, :motif => motif,:statut => nil, :school_year => Time.now.year, :school_field_id => student.batch.school_field.id, :batch_id => student.batch.id)
		flash[:notice] = "La demande de #{Requestdoc.find(requestdoc_id).name} est effectuéee"
		redirect_to :action => 'index'
        when 13
		doc_specification = params[:rdv][:doc_specification]
		details = params[:rdv][:details]
    	RequestdocStudent.create(:details => details, :doc_specification => doc_specification,:student_id => student.id, :requestdoc_id => requestdoc_id, :statut => nil, :school_year => Time.now.year, :school_field_id => student.batch.school_field.id, :batch_id => student.batch.id)
		flash[:notice] = "La demande de #{Requestdoc.find(requestdoc_id).name} est effectuéee"
		redirect_to :action => 'index'
        when 3
		RequestdocStudent.create(:student_id => student.id,:requestdoc_id => requestdoc_id, :observation => params[:observation][:id].to_s,:motif => params[:releve][:motif].to_s, :school_year => student.batch.get_batch_year, :statut => nil, :school_field_id => student.batch.school_field.id, :batch_id => student.batch.id)
		Reminder.create(:sender=>student.user.id,:recipient=>1, :subject=>"Demande spéciale de #{student.full_name}.", :body=>"#{params[:observation]}" , :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
		flash[:notice] = "La demande de #{Requestdoc.find(requestdoc_id).name} est effectuéee"
#		@requestdoc_students = RequestdocStudent.all.sort_by {|a| a.created_at}
		# render :js => "window.location = '/requestdoc_students'"
		redirect_to :action => 'index'
=begin
   respond_to do |format|
        format.html { render :action => "index" }
        format.xml  { render :xml => @requestdoc_students, :status => :unprocessable_entity }
    end
=end
#		return render :controller => 'requestdoc_students', :action => "index"
#		redirect_to :action => 'index'
     end
end

def new
    @request_docs = Requestdoc.all


end
=begin
def all_requesteddocs
	@all_requesteddocs = params[:all_requesteddocs]

	logger.debug @all_requesteddocs
	render :pdf=>'all_requesteddocs'
end
=end
def all_releve
require 'securerandom'
require 'rqrcode'

	@all_requesteddocs = params[:all_requesteddocs]
	@all_requesteddocs.each do |a|
		logger.debug a
	end
	logger.debug "yyyyyaaa"
	logger.debug @all_requesteddocs
#pub	render :pdf=>'releves'
# render :pdf=>'all_requesteddocs
all_requesteddocs = @all_requesteddocs
#all_requesteddocs.each do |a|all_requesteddocs
#	@all_requesteddocs = a
	respond_to do |format|
	  # format.html # show.html.erb
	  #generqte hex code for file qnd check if it exsits
	  file_hex = SecureRandom.hex
	  bfh = RequestdocStudent.find_all_by_file_hex(file_hex)
	  if !bfh.empty?
	  	not_found = false
	  	while !not_found
	  		file_hex = SecureRandom.hex
	  		tmpo = RequestdocStudent.find_all_by_file_hex(file_hex)
	  		if !tmpo.empty?
	  			not_found = true
	  		end
	  	end
	  end

	  #generqte hex code for code qnd check if it exsits
	  code_hex = SecureRandom.hex
	  bfh = RequestdocStudent.find_all_by_code_hex(code_hex)
	  if !bfh.empty?
	  	not_found = false
	  	while !not_found
	  		code_hex = SecureRandom.hex
	  		tmpo = RequestdocStudent.find_all_by_code_hex(code_hex)
	  		if !tmpo.empty?
	  			not_found = true
	  		end
	  	end
	  end

	  @qr = RQRCode::QRCode.new( 'https://aat-erp.ml/system/docs/rn/'+file_hex+'.pdf', :size => 10, :level => :h, :style => "width:100px;height:100px;")
	  logger.debug "\n"
	  @qr = @qr.as_svg(:offset => 0, :color => '000',:shape_rendering => 'crispEdges',:module_size => 2)
	  @qr = @qr.gsub('width="627" height="627"', ' width="100" height="100" class="scaled"')
	  # @qr = @qr.gsub('width="11" height="11"', 'width="2" height="2"')
	  # @qr = @qr.gsub('<td class="', '<td class="qrtd ')
	  # @qr = @qr.as_html.gsub('<table', '<table class="qrtable"')
	  # @qr = @qr.gsub('<td class="', '<td class="qrtd ')

	  logger.debug @qr
	  logger.debug "\n"
	  RequestdocStudent.find(@all_requesteddocs.first).update_attributes(:file_hex => file_hex, :code_hex => code_hex)
	  format.pdf do
	    render :pdf => "#{file_hex}",:save_to_file => Rails.root.join('public/system/docs/rn', "#{file_hex}.pdf")
	  end
#	end
end

end
def all_certif
# 	@all_requesteddocs = params[:all_requesteddocs]

# 	logger.debug @all_requesteddocs
# 	respond_to do |format|
# 	  # format.html # show.html.erb
# 	  #generqte hex code for file qnd check if it exsits
# 	  file_hex = SecureRandom.hex
# 	  bfh = RequestdocStudent.find_all_by_file_hex(file_hex)
# 	  if !bfh.empty?
# 	  	not_found = false
# 	  	while !not_found
# 	  		file_hex = SecureRandom.hex
# 	  		tmpo = RequestdocStudent.find_all_by_file_hex(file_hex)
# 	  		if !tmpo.empty?
# 	  			not_found = true
# 	  		end
# 	  	end
# 	  end


# 	  #generqte hex code for code qnd check if it exsits
# 	  code_hex = SecureRandom.hex
# 	  bfh = RequestdocStudent.find_all_by_code_hex(code_hex)
# 	  if !bfh.empty?
# 	  	not_found = false
# 	  	while !not_found
# 	  		code_hex = SecureRandom.hex
# 	  		tmpo = RequestdocStudent.find_all_by_code_hex(code_hex)
# 	  		if !tmpo.empty?
# 	  			not_found = true
# 	  		end
# 	  	end
# 	  end

# 	  RequestdocStudent.find(@all_requesteddocs.first).update_attributes(:file_hex => file_hex, :code_hex => code_hex)
# 	  format.pdf do
# 	    render :pdf => "#{file_hex}",:save_to_file => Rails.root.join('public/system/docs/rn', "#{file_hex}.pdf")
# 	  end
# #	end
# end

require 'securerandom'
require 'rqrcode'




require "open-uri"




	@all_requesteddocs = params[:all_requesteddocs]
	@all_requesteddocs.each do |a|
		logger.debug a
	end
	logger.debug "yyyyyaaa"
	logger.debug @all_requesteddocs
#pub	render :pdf=>'releves'
# render :pdf=>'all_requesteddocs
all_requesteddocs = @all_requesteddocs
#all_requesteddocs.each do |a|all_requesteddocs
#	@all_requesteddocs = a
	respond_to do |format|
	  # format.html # show.html.erb
	  #generqte hex code for file qnd check if it exsits
	  file_hex = SecureRandom.hex
	  bfh = RequestdocStudent.find_all_by_file_hex(file_hex)
	  if !bfh.empty?
	  	not_found = false
	  	while !not_found
	  		file_hex = SecureRandom.hex
	  		tmpo = RequestdocStudent.find_all_by_file_hex(file_hex)
	  		if !tmpo.empty?
	  			not_found = true
	  		end
	  	end
	  end

	  #generqte hex code for code qnd check if it exsits
	  code_hex = SecureRandom.hex
	  bfh = RequestdocStudent.find_all_by_code_hex(code_hex)
	  if !bfh.empty?
	  	not_found = false
	  	while !not_found
	  		code_hex = SecureRandom.hex
	  		tmpo = RequestdocStudent.find_all_by_code_hex(code_hex)
	  		if !tmpo.empty?
	  			not_found = true
	  		end
	  	end
	  end
    @url = 'http://ana-erp.tk/system/docs/rn/'+file_hex+'.pdf'
    File.open("#{RAILS_ROOT}/public/system/qrcodes/#{file_hex}.png", 'wb') do |fo|
      fo.write open("https://chart.googleapis.com/chart?chs=545x545&cht=qr&chl=#{@url}&choe=UTF-8").read
    end

# @url = "https://kyan.com"
# 	  @qr = "https://chart.googleapis.com/chart?chs=545x545&cht=qr&chl=#{@url}&choe=UTF-8"
# 	  logger.debug "\n"
# 	  @qr = @qr.as_svg(:offset => 0, :color => '000',:shape_rendering => 'crispEdges',:module_size => 2)
# 	  @qr = @qr.gsub('width="627" height="627"', ' width="100" height="100" class="scaled"')
# 	  # @qr = @qr.gsub('width="11" height="11"', 'width="2" height="2"')
# 	  # @qr = @qr.gsub('<td class="', '<td class="qrtd ')
# 	  # @qr = @qr.as_html.gsub('<table', '<table class="qrtable"')
# 	  # @qr = @qr.gsub('<td class="', '<td class="qrtd ')
#
# 	  logger.debug @qr
# 	  logger.debug "\n"
	  RequestdocStudent.find(@all_requesteddocs.first).update_attributes(:file_hex => file_hex, :code_hex => code_hex)
    @file_hex = file_hex
	  format.pdf do
	    render :pdf => "#{file_hex}",:save_to_file => Rails.root.join('public/system/docs/rn', "#{file_hex}.pdf")
	  end
#	end
end

end
def all_ar
	# @all_requesteddocs = params[:all_requesteddocs]

	# logger.debug @all_requesteddocs
	# render :pdf=>'attestations_de_reussite'
require 'securerandom'
require 'rqrcode'

	@all_requesteddocs = params[:all_requesteddocs]
	@all_requesteddocs.each do |a|
		logger.debug a
	end
	logger.debug "yyyyyaaa"
	logger.debug @all_requesteddocs
#pub	render :pdf=>'releves'
# render :pdf=>'all_requesteddocs
all_requesteddocs = @all_requesteddocs
#all_requesteddocs.each do |a|all_requesteddocs
#	@all_requesteddocs = a
	respond_to do |format|
	  # format.html # show.html.erb
	  #generqte hex code for file qnd check if it exsits
	  file_hex = SecureRandom.hex
	  bfh = RequestdocStudent.find_all_by_file_hex(file_hex)
	  if !bfh.empty?
	  	not_found = false
	  	while !not_found
	  		file_hex = SecureRandom.hex
	  		tmpo = RequestdocStudent.find_all_by_file_hex(file_hex)
	  		if !tmpo.empty?
	  			not_found = true
	  		end
	  	end
	  end

	  #generqte hex code for code qnd check if it exsits
	  code_hex = SecureRandom.hex
	  bfh = RequestdocStudent.find_all_by_code_hex(code_hex)
	  if !bfh.empty?
	  	not_found = false
	  	while !not_found
	  		code_hex = SecureRandom.hex
	  		tmpo = RequestdocStudent.find_all_by_code_hex(code_hex)
	  		if !tmpo.empty?
	  			not_found = true
	  		end
	  	end
	  end

	  @qr = RQRCode::QRCode.new( 'https://aat-erp.ml/system/docs/rn/'+file_hex+'.pdf', :size => 10, :level => :h, :style => "width:100px;height:100px;")
	  logger.debug "\n"
	  @qr = @qr.as_svg(:offset => 0, :color => '000',:shape_rendering => 'crispEdges',:module_size => 2)
	  @qr = @qr.gsub('width="627" height="627"', ' width="100" height="100" class="scaled"')
	  # @qr = @qr.gsub('width="11" height="11"', 'width="2" height="2"')
	  # @qr = @qr.gsub('<td class="', '<td class="qrtd ')
	  # @qr = @qr.as_html.gsub('<table', '<table class="qrtable"')
	  # @qr = @qr.gsub('<td class="', '<td class="qrtd ')

	  logger.debug @qr
	  logger.debug "\n"
	  RequestdocStudent.find(@all_requesteddocs.first).update_attributes(:file_hex => file_hex, :code_hex => code_hex)
	  format.pdf do
	    render :pdf => "#{file_hex}",:save_to_file => Rails.root.join('public/system/docs/rn', "#{file_hex}.pdf")
	  end
#	end
end
end

def all_ab
	# @all_requesteddocs = params[:all_requesteddocs]

	# logger.debug @all_requesteddocs
	# render :pdf=>'attestatioons_de_bourse'

require 'securerandom'
require 'rqrcode'

	@all_requesteddocs = params[:all_requesteddocs]
	@all_requesteddocs.each do |a|
		logger.debug a
	end
	logger.debug "yyyyyaaa"
	logger.debug @all_requesteddocs
#pub	render :pdf=>'releves'
# render :pdf=>'all_requesteddocs
all_requesteddocs = @all_requesteddocs
#all_requesteddocs.each do |a|all_requesteddocs
#	@all_requesteddocs = a
	respond_to do |format|
	  # format.html # show.html.erb
	  #generqte hex code for file qnd check if it exsits
	  file_hex = SecureRandom.hex
	  bfh = RequestdocStudent.find_all_by_file_hex(file_hex)
	  if !bfh.empty?
	  	not_found = false
	  	while !not_found
	  		file_hex = SecureRandom.hex
	  		tmpo = RequestdocStudent.find_all_by_file_hex(file_hex)
	  		if !tmpo.empty?
	  			not_found = true
	  		end
	  	end
	  end

	  #generqte hex code for code qnd check if it exsits
	  code_hex = SecureRandom.hex
	  bfh = RequestdocStudent.find_all_by_code_hex(code_hex)
	  if !bfh.empty?
	  	not_found = false
	  	while !not_found
	  		code_hex = SecureRandom.hex
	  		tmpo = RequestdocStudent.find_all_by_code_hex(code_hex)
	  		if !tmpo.empty?
	  			not_found = true
	  		end
	  	end
	  end

	  @qr = RQRCode::QRCode.new( 'https://aat-erp.ml/system/docs/rn/'+file_hex+'.pdf', :size => 10, :level => :h, :style => "width:100px;height:100px;")
	  logger.debug "\n"
	  @qr = @qr.as_svg(:offset => 0, :color => '000',:shape_rendering => 'crispEdges',:module_size => 2)
	  @qr = @qr.gsub('width="627" height="627"', ' width="100" height="100" class="scaled"')
	  # @qr = @qr.gsub('width="11" height="11"', 'width="2" height="2"')
	  # @qr = @qr.gsub('<td class="', '<td class="qrtd ')
	  # @qr = @qr.as_html.gsub('<table', '<table class="qrtable"')
	  # @qr = @qr.gsub('<td class="', '<td class="qrtd ')

	  logger.debug @qr
	  logger.debug "\n"
	  RequestdocStudent.find(@all_requesteddocs.first).update_attributes(:file_hex => file_hex, :code_hex => code_hex)
	  format.pdf do
	    render :pdf => "#{file_hex}",:save_to_file => Rails.root.join('public/system/docs/rn', "#{file_hex}.pdf")
	  end
#	end
end
end

def all_struct
	# @all_requesteddocs = params[:all_requesteddocs]

	# logger.debug @all_requesteddocs
	# render :pdf=>'Structuration_des_éléments_de_modules'
require 'securerandom'
require 'rqrcode'

	@all_requesteddocs = params[:all_requesteddocs]
	@all_requesteddocs.each do |a|
		logger.debug a
	end
	logger.debug "yyyyyaaa"
	logger.debug @all_requesteddocs
#pub	render :pdf=>'releves'
# render :pdf=>'all_requesteddocs
all_requesteddocs = @all_requesteddocs
#all_requesteddocs.each do |a|all_requesteddocs
#	@all_requesteddocs = a
	respond_to do |format|
	  # format.html # show.html.erb
	  #generqte hex code for file qnd check if it exsits
	  file_hex = SecureRandom.hex
	  bfh = RequestdocStudent.find_all_by_file_hex(file_hex)
	  if !bfh.empty?
	  	not_found = false
	  	while !not_found
	  		file_hex = SecureRandom.hex
	  		tmpo = RequestdocStudent.find_all_by_file_hex(file_hex)
	  		if !tmpo.empty?
	  			not_found = true
	  		end
	  	end
	  end

	  #generqte hex code for code qnd check if it exsits
	  code_hex = SecureRandom.hex
	  bfh = RequestdocStudent.find_all_by_code_hex(code_hex)
	  if !bfh.empty?
	  	not_found = false
	  	while !not_found
	  		code_hex = SecureRandom.hex
	  		tmpo = RequestdocStudent.find_all_by_code_hex(code_hex)
	  		if !tmpo.empty?
	  			not_found = true
	  		end
	  	end
	  end

	  @qr = RQRCode::QRCode.new( 'https://aat-erp.ml/system/docs/rn/'+file_hex+'.pdf', :size => 10, :level => :h, :style => "width:100px;height:100px;")
	  logger.debug "\n"
	  @qr = @qr.as_svg(:offset => 0, :color => '000',:shape_rendering => 'crispEdges',:module_size => 2)
	  @qr = @qr.gsub('width="627" height="627"', ' width="100" height="100" class="scaled"')
	  # @qr = @qr.gsub('width="11" height="11"', 'width="2" height="2"')
	  # @qr = @qr.gsub('<td class="', '<td class="qrtd ')
	  # @qr = @qr.as_html.gsub('<table', '<table class="qrtable"')
	  # @qr = @qr.gsub('<td class="', '<td class="qrtd ')

	  logger.debug @qr
	  logger.debug "\n"
	  RequestdocStudent.find(@all_requesteddocs.first).update_attributes(:file_hex => file_hex, :code_hex => code_hex)
	  format.pdf do
	    render :pdf => "#{file_hex}",:save_to_file => Rails.root.join('public/system/docs/rn', "#{file_hex}.pdf")
	  end
#	end
end
end

def print_requestdoc
	@all_requesteddocs = params[:all_requesteddocs]
	@all_requesteddocs.each do |a|
		RequestdocStudent.find(a.to_i).update_attributes(:last_print_date => Time.now)
	end
	case RequestdocStudent.find(@all_requesteddocs.first.to_i).requestdoc_id.to_i
	when 1
		redirect_to :controller => 'requestdoc_students', :action => 'all_releve', :all_requesteddocs => @all_requesteddocs
	when 2
		redirect_to :controller => 'requestdoc_students', :action => 'all_certif', :all_requesteddocs => @all_requesteddocs
	when 3
		redirect_to :controller => 'requestdoc_students', :action => 'all_ar', :all_requesteddocs => @all_requesteddocs
	when 4
		redirect_to :controller => 'requestdoc_students', :action => 'all_ab', :all_requesteddocs => @all_requesteddocs
	when 12
		redirect_to :controller => 'requestdoc_students', :action => 'all_ab', :all_requesteddocs => @all_requesteddocs
	when 14
		redirect_to :controller => 'requestdoc_students', :action => 'all_struct', :all_requesteddocs => @all_requesteddocs
	end

end

def multi_edit
	if @requestdoc_ids.nil?
		@requestdoc_ids = params[:transfer]
		logger.debug @requestdoc_ids
	end
	@doctype = RequestdocStudent.find(@requestdoc_ids.first).requestdoc.id
	@doctype = RequestdocStudent.find(@requestdoc_ids.first).requestdoc.id
	@docslength = @requestdoc_ids.length

	@type = RequestdocStudent.find(params[:transfer].first.to_i).requestdoc_id
	logger.debug "typppppppppppe"
	logger.debug @type
	if params[:commit].to_s == "Traiter" or params[:commit].to_s == "Mettre à  jour"
	logger.debug "qsdqsdq"
	if params[:requestdoc_student] and @requestdoc_ids
		logger.debug "leveel"
		logger.debug params.inspect
		logger.debug params[:requestdoc_student][:statut]
		logger.debug "lazekazeomkazme"
		@all_requesteddocs = []
		if params[:requestdoc_student][:statut].to_i == 1
			logger.debug "loooooooooaaaaaoooooool"
			@requestdoc_ids.each do |rds_id|
				requesteddoc = RequestdocStudent.find(rds_id)
				@all_requesteddocs.push(RequestdocStudent.find(rds_id))
					logger.debug "acol"

				if requesteddoc.requestdoc.id == 8
					logger.debug rds_id
					logger.debug "loca"
					if !params[:mt_classe].nil?
							school_field_id = requesteddoc.student.all_batches.reject{|b| b.get_batch_year.to_i != requesteddoc.school_year }.uniq.first.school_field_id
						 	bourse_mt = DelibParam.find(:first, :conditions => {:school_field_id => school_field_id, :school_year  => requesteddoc.school_year }).bourse_mt
							RequestdocStudent.find(rds_id).update_attributes(:signed =>params[:requestdoc_student][:signed],:edited_by => current_user.id,:bourse_mt => bourse_mt, :statut => params[:requestdoc_student][:statut], :recovery_date => params[:requestdoc_student][:recovery_date], :observation => params[:requestdoc_student][:observation])
					else
							RequestdocStudent.find(rds_id).update_attributes(:signed =>params[:requestdoc_student][:signed],:edited_by => current_user.id,:bourse_mt => params[:requestdoc_student][:bourse_mt], :statut => params[:requestdoc_student][:statut], :recovery_date => params[:requestdoc_student][:recovery_date], :observation => params[:requestdoc_student][:observation])
					end
				elsif requesteddoc.requestdoc.id == 5
					requesteddoc.update_attributes(:start_time => params[:requestdoc_student][:start_time],:end_time => params[:requestdoc_student][:end_time],:edited_by => current_user.id,:delib_date => params[:requestdoc_student][:delib_date], :statut => params[:requestdoc_student][:statut], :recovery_date => params[:requestdoc_student][:recovery_date], :observation => params[:requestdoc_student][:observation])
				else
					RequestdocStudent.find(rds_id).update_attributes(:signed =>params[:requestdoc_student][:signed],:edited_by => current_user.id,:delib_date => params[:requestdoc_student][:delib_date], :statut => params[:requestdoc_student][:statut], :recovery_date => params[:requestdoc_student][:recovery_date], :observation => params[:requestdoc_student][:observation])
				end
				if requesteddoc.requestdoc.id == 5
					if !requesteddoc.observation.nil? and requesteddoc.observation.to_s != ""
						msg = "Vous avez un rendez-vous le #{requesteddoc.recovery_date} entre #{requesteddoc.start_time.strftime('%H:%M')} et #{requesteddoc.end_time.strftime('%H:%M')}. Vous avez demander le document \"#{requesteddoc.rdv_doc}\". Observation : \" #{requesteddoc.observation}\" "
					else
						msg = "Vous avez un rendez-vous le #{requesteddoc.recovery_date} entre #{requesteddoc.start_time.strftime('%H:%M')} et #{requesteddoc.end_time.strftime('%H:%M')}. Vous avez demander le document \"#{requesteddoc.rdv_doc}\"."
					end
				else
						msg = "Votre document est disponible vous pouvez le récupérer entre 9H00 et 17H00 du Lundi au vendredi (Vous devez récupérer le document dans 48 heures aprés sa disponibilité  sans compter les jours ouvrables sinon le document sera détruit)
Vous avez demander le document \"#{requesteddoc.requestdoc.name}\""
				end
				Reminder.create(:sender=>1,:recipient=>requesteddoc.student.user.id, :subject=>"Demande : #{requesteddoc.requestdoc.name} est pret", :body=>msg , :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
				if requesteddoc.student.email.length>0
					#FEDENAMailer::deliver_email("no-reply@enim.ac.ma", [requesteddoc.student.email], "Demande : #{requesteddoc.requestdoc.name} est pret", msg)
				end
			end
#			render :pdf=>'all_requesteddocs'
		 flash[:notice] = "mise a jour avec succès"
		if @doctype == 12 or @doctype == 5 or @doctype == 13 or @doctype == 3
			redirect_to :action => 'index'
		else
			logger.debug @all_requesteddocs.inspect
		respond_to do |format|
                        format.html { redirect_to :action => "print_requestdoc",:all_requesteddocs => @all_requesteddocs }
                end
		end
=begin
		if @all_requesteddocs.first.requestdoc.id == 1
			respond_to do |format|
			        format.html { redirect_to :action => "all_requesteddocs",:all_requesteddocs => @all_requesteddocs }
			end
		else
		end
=end

		elsif params[:requestdoc_student][:statut].to_i == 0
			@requestdoc_ids.each do |rds_id|
				requesteddoc = RequestdocStudent.find(rds_id)
				RequestdocStudent.find(rds_id).update_attributes(:edited_by => current_user.id,:statut => params[:requestdoc_student][:statut], :reject_cause => params[:requestdoc_student][:reject_cause], :observation => params[:requestdoc_student][:observation])
				Reminder.create(:sender=>1,:recipient=>requesteddoc.student.user.id, :subject=>"Document #{requesteddoc.requestdoc.name} est pret", :body=>"lorem ipsum dolor ..." , :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
			end
			 flash[:notice] = "mise a jour avec succès"

		redirect_to :controller => 'requestdoc_students', :action => ''


                elsif params[:requestdoc_student][:statut].to_i == 3
                        @requestdoc_ids.each do |rds_id|

                            requesteddoc = RequestdocStudent.find(rds_id)
                                RequestdocStudent.find(rds_id).update_attributes(:edited_by => current_user.id,:validated_by => current_user.id,:statut => params[:requestdoc_student][:statut], :reject_cause => params[:requestdoc_student][:reject_cause], :observation => params[:requestdoc_student][:observation])
  #                              Reminder.create(:sender=>1,:recipient=>requesteddoc.student.user.id, :subject=>"Document #{requesteddoc.requestdoc.name} est pret", :bo$
                        end
                         flash[:notice] = "mise a jour avec succès"

                redirect_to :controller => 'requestdoc_students', :action => ''

		end
	end
	elsif params[:commit].to_s == "Imprimer"
#		@all_requesteddocs = []
#		@requestdoc_ids.each do |rds_id|
#			 @all_requesteddocs.push(RequestdocStudent.find(rds_id))
#		end
		@all_requesteddocs = @requestdoc_ids
		logger.debug @all_requesteddocs.inspect
		redirect_to :controller => 'requestdoc_students', :action => 'print_requestdoc', :all_requesteddocs => @all_requesteddocs
	end
	logger.debug params[:commit]
end

def multi_edit_conf
	@requestdoc_ids = params[:transfer]
	@doctype = params[:doctype]
	if params[:statut].to_i == 0
		render(:update) do |page|
          		page.replace_html 'next-step', :partial => 'reject'
		end
	elsif params[:statut].to_i == 1
		render(:update) do |page|
          		page.replace_html 'next-step', :partial => 'approve'
		end
	elsif params[:statut].to_i == 3
		render(:update) do |page|
          		page.replace_html 'next-step', :partial => 'validate'
		end
        elsif params[:statut].to_s == "null"
                render(:update) do |page|
                        page.replace_html 'next-step', :partial => 'next-step'
                end

	end

end
  # GET /requestdoc_students/1/edit
  def edit
    if request.post?
	respond_to do |format|
	format.html { render :action => "edit" }
        format.xml  { render :xml => @requestdoc_student.errors, :status => :unprocessable_entity }
      end

	logger.debug params[:transfer]
=begin
        render(:update) do |page|
          page.replace_html 'modal-box', :partial => 'edit'
          page << "Modalbox.show($('modal-box'), {title: 'Demande Document n° #{}', width: 400, height:600});"
        end
=end
    end
#    @requestdoc_student = RequestdocStudent.find(params[:id])
#    logger.debug params.headers
    logger.debug "must be up there"


  end

  # POST /requestdoc_students
  # POST /requestdoc_students.xml
  def create
    @requestdoc_student = RequestdocStudent.new(params[:requestdoc_student])

    respond_to do |format|
      if @requestdoc_student.save
        flash[:notice] = 'RequestdocStudent was successfully created.'
        format.html { redirect_to(@requestdoc_student) }
        format.xml  { render :xml => @requestdoc_student, :status => :created, :location => @requestdoc_student }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @requestdoc_student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /requestdoc_students/1
  # PUT /requestdoc_students/1.xml
  def update
    @requestdoc_student = RequestdocStudent.find(params[:id])

    respond_to do |format|
      if @requestdoc_student.update_attributes(params[:requestdoc_student])
        if @requestdoc_student.statut == 1
		logger.debug "message tranna be sent"
	  Reminder.create(:sender=>1,:recipient=>@requestdoc_student.student.user.id, :subject=>"Document #{@requestdoc_student.requestdoc.name} est pret", :body=>"lorem ipsum dolor ..." , :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)

		logger.debug "message sent"
	end
	flash[:notice] = 'Mise à jour demande document bien effectuée.'

        format.html { redirect_to(@requestdoc_student) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @requestdoc_student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /requestdoc_students/1
  # DELETE /requestdoc_students/1.xml
  def destroy
    @requestdoc_student = RequestdocStudent.find(params[:id])
    @requestdoc_student.destroy

    respond_to do |format|
      format.html { redirect_to(requestdoc_students_url) }
      format.xml  { head :ok }
    end
  end
end
