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

class StudentController < ApplicationController
  layout "main"   
  #filter_access_to :all
  #before_filter :login_required
  #before_filter :protect_other_student_data, :except =>[:show,:demand_reinscription, :online_registration_covmedical, :cnie_parent,:die_parent,:cov_medical_exist,:bank_exist, :confermer_inscription]

  before_action :find_student, only: [
  :academic_report, :academic_report_all, :admission3, :change_to_former,
  :delete, :edit, :add_guardian, :email, :remove, :reports, :profile,
  :guardians, :academic_pdf, :show_previous_details, :fees, :fee_details
]

skip_before_action :verify_authenticity_token, only: [:importstudent, :exportstudent]


def photo_students

  @batches = Batch.all

 if request.post?
  redirect_to :action => "photo_students_pdf", :id => params[:search][:batch_id_equals]
end

end

def photo_students_pdf
@students = []
b_id = params[:importfile][:batch_id_equals]
@batch = Batch.find_by_id(b_id)
@students += Student.find_all_by_batch_id(b_id)
BatchStudent.find_all_by_batch_id(b_id).each do |q|
@students << Student.find(q.student_id)
end
logger.debug @students.count
logger.debug @students.count
logger.debug @students.count
logger.debug @students.count
@students=@students.uniq.sort_by {|st| st.full_name.upcase}

  render :pdf => 'photo_students_pdf'

end

def student_card
  @students_ids = params[:student_ids]

   if @students_ids 
    @config1 = Configuration.find_by_sql("select * from student_card_configs where config_key = 'top' ;")
    @config2 = Configuration.find_by_sql("select * from student_card_configs where config_key = 'center' ;")
    @config3 = Configuration.find_by_sql("select * from student_card_configs where config_key = 'bottom-left' ;")
    @config4 = Configuration.find_by_sql("select * from student_card_configs where config_key = 'bottom-right' ;")

    @student = []
    @time = Time.now.strftime("%d/%m/%Y %H:%M")
    @students_ids.each do |st|
      @student << Student.find(st)

      student_card = StudentCard.find_by_student_id(st)
   
    if student_card
      
        student_card.update_attributes(:print_date => "#{Time.now.strftime("%d/%m/%Y %H:%M")}", :number_occurrences => student_card.number_occurrences + 1)
    

    else
      StudentCard.create(:student_id => st, :print_date => "#{Time.now.strftime("%d/%m/%Y %H:%M")}",:number_occurrences => 1 )  

    end
    end
   render :pdf=>"carte_etudiant",:orientation=> 'Landscape' ,:margin => { :bottom => 0 , :top => 0, :left => 0, :right => 0}

   end

   if params[:id]
    @config1 = Configuration.find_by_sql("select * from student_card_configs where config_key = 'top' ;")
    @config2 = Configuration.find_by_sql("select * from student_card_configs where config_key = 'center' ;")
    @config3 = Configuration.find_by_sql("select * from student_card_configs where config_key = 'bottom-left' ;")
    @config4 = Configuration.find_by_sql("select * from student_card_configs where config_key = 'bottom-right' ;")
    @student = Student.find(params[:id])

    student_card = StudentCard.find_by_student_id(params[:id])
    if student_card
      
        student_card.update_attributes(:print_date => "#{Time.now.strftime("%d/%m/%Y %H:%M")}", :number_occurrences => student_card.number_occurrences + 1)
     

    else
      StudentCard.create(:student_id => params[:id], :print_date => "#{Time.now.strftime("%d/%m/%Y %H:%M")}",:number_occurrences => 1 )  

    end
  render :pdf=>"carte_etudiant_#{@student.first_name}_#{@student.last_name}",:orientation=> 'Landscape' ,:margin => { :bottom => 0 , :top => 0, :left => 0, :right => 0}
   end

    # logger.debug "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS   #{@config1.inspect}"
end

def gestion_student_card
  @student = Student.find(params[:id])
  render :pdf=>"carte_etudiant_#{@student.first_name}_#{@student.last_name}",:orientation=> 'Landscape' ,:margin => { :bottom => 0 , :top => 0, :left => 0, :right => 0}
end

def sans_semestre
  if current_user.student
  exit
else
end
  @student = Student.find_by_id(params[:id])
  batches = BatchStudent.find_all_by_student_id(params[:id]).reject { |e| Batch.find_by_id(e.batch_id.to_i).nil? }
  batches_st = []
  batches_st << @student.batch
  batches.each do |b|
    batches_st << Batch.find_by_id(b.batch_id.to_i) unless Batch.find_by_id(b.batch_id.to_i).nil?
  end
  batches_st = batches_st.uniq
  min = batches_st[0].get_batch_year.to_i
  max = batches_st[0].get_batch_year.to_i

  batches_st.each do |bts|
    if bts.get_batch_year.to_i < min
      min = bts.get_batch_year.to_i
    elsif bts.get_batch_year.to_i > max
      max = bts.get_batch_year.to_i
    end
  end

  logger.debug min
  logger.debug max

  @final = {}
  years = (min..max).to_a
  years.each do |yr|
    temp = []
    batches_st.each do |bt|
      if bt.get_batch_year.to_i == yr.to_i
        temp << bt
      end
      logger.debug temp.uniq.inspect
      logger.debug temp.object_id
      if temp.count >= 3
        school_field_id = temp.group_by{ |b| b.school_field_id }.select { |k, v| v.size > 1 }.map(&:first)
        temp = temp.reject { |b| b.school_field_id.to_i != school_field_id[0].to_i }
      end
      @final[yr.to_s] = temp.uniq
    end
  end
  logger.debug "*********************calcul classement************************************************"
  #@range = []

  @final = @final.sort_by { |school_year, batches| school_year}.reverse
  logger.debug @final.inspect
  logger.debug "***************************************************************"


  render :pdf=>"rapport_annuel_#{@student.last_name}_#{@student.first_name}"
end

def avec_semestre_sans_rattr

  @student = Student.find_by_id(params[:id])
  batches = BatchStudent.find_all_by_student_id(params[:id]).reject { |e| Batch.find_by_id(e.batch_id.to_i).nil? }
  batches_st = []
  batches_st << @student.batch
  batches.each do |b|
    batches_st << Batch.find_by_id(b.batch_id.to_i) unless Batch.find_by_id(b.batch_id.to_i).nil?
  end
  batches_st = batches_st.uniq
  min = batches_st[0].get_batch_year.to_i
  max = batches_st[0].get_batch_year.to_i

  batches_st.each do |bts|
    if bts.get_batch_year.to_i < min
      min = bts.get_batch_year.to_i
    elsif bts.get_batch_year.to_i > max
      max = bts.get_batch_year.to_i
    end
  end

  logger.debug min
  logger.debug max

  @final = {}
  years = (min..max).to_a
  years.each do |yr|
    temp = []
    batches_st.each do |bt|
      if bt.get_batch_year.to_i == yr.to_i
        temp << bt
      end
      logger.debug temp.uniq.inspect
      logger.debug temp.object_id
      @final[yr.to_s] = temp.uniq
    end
  end

  render :pdf=>"avec_semestre_sans_rattr"
end


def sans_semestre_sans_rattr

  @student = Student.find_by_id(params[:id])
  batches = BatchStudent.find_all_by_student_id(params[:id]).reject { |e| Batch.find_by_id(e.batch_id.to_i).nil? }
  batches_st = []
  batches_st << @student.batch
  batches.each do |b|
    batches_st << Batch.find_by_id(b.batch_id.to_i) unless Batch.find_by_id(b.batch_id.to_i).nil?
  end
  batches_st = batches_st.uniq
  min = batches_st[0].get_batch_year.to_i
  max = batches_st[0].get_batch_year.to_i

  batches_st.each do |bts|
    if bts.get_batch_year.to_i < min
      min = bts.get_batch_year.to_i
    elsif bts.get_batch_year.to_i > max
      max = bts.get_batch_year.to_i
    end
  end

  logger.debug min
  logger.debug max

  @final = {}
  years = (min..max).to_a
  years.each do |yr|
    temp = []
    batches_st.each do |bt|
      if bt.get_batch_year.to_i == yr.to_i
        temp << bt
      end
      logger.debug temp.uniq.inspect
      logger.debug temp.object_id
      if temp.count >= 3
        school_field_id = temp.group_by{ |b| b.school_field_id }.select { |k, v| v.size > 1 }.map(&:first)
        temp = temp.reject { |b| b.school_field_id.to_i != school_field_id[0].to_i }
      end
      @final[yr.to_s] = temp.uniq
    end
  end
  @final = @final.sort_by { |school_year, batches| school_year}.reverse
  #logger.debug @final.inspect
  #exit
  render :pdf=>"rapport_annuel_sans_rattr_#{@student.last_name}_#{@student.first_name}"
end
def list_modules
@school_field_id = params[:filiere_id]
@course_id_n = params[:course_id]
if @course_id_n.to_i == 1
    @course_1 = 133
    @course_2 = 134

  elsif @course_id_n.to_i == 2
    @course_1 = 135
    @course_2 = 136
  end
@sfsm = SchoolFieldSchoolModule.find_all_by_school_field_id_and_school_year(@school_field_id,Time.now.year).select{|sf| sf.course_id.to_i ==   @course_1.to_i || sf.course_id.to_i ==   @course_2.to_i}
render(:update) do |page|
          page.replace_html 'list_modules', :partial=>'list_modules'
        end
end
def affect_modules
  @school_field_id = params[:school_field_id]
@course_id_n = params[:course_id]
@school_year = Time.now.year
list = params[:transfer]
@sfsm  = []
if @course_id_n.to_i == 1
    @course_1 = 133
    @course_2 = 134

  elsif @course_id_n.to_i == 2
    @course_1 = 135
    @course_2 = 136
  end
list.each do |li|
@sfsm << SchoolFieldSchoolModule.find(li)
end
Batch.find(8844).update_attributes(:school_field_id => @school_field_id)
flash[:notice] = "L'affectation a effectué avec succès"
redirect_to :controller => "student", :action => "reinscription_pedag"
end
def reinscription_pedag
  @school_fields = SchoolField.all
  @school_fields.each do |zz|
     batches = Batch.find_all_by_school_field_id(zz.id)
     if batches.empty?
         @school_fields.delete(zz)
     end
  end
  @school_field  = @school_fields.first
  if request.post?
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
      batch = Batch.find(8844)
      vetlse_opt = {:table_name => "VET_REGROUPE_LSE",:condition => "where COD_VRS_VET like '401' and COD_ETP like \'"+batch.code_etude.to_s+"\' ",:columns => "*"}.to_json
      @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
        :method         => :post,
        :headers        => options,
        :timeout        => 100, # milliseconds
        :body         => vetlse_opt )
        hydra = Typhoeus::Hydra.hydra
        hydra.queue(@request)
        hydra.run

        vetlse_opt = ActiveSupport::JSON.decode(@request.response.body)

        vetlse_opt.each do |vet|
          lseelp_opt = {:table_name => "ELP_REGROUPE_ELP",:condition => "where COD_LSE like \'"+vet["COD_LSE"].to_s+"\' ",:columns => "*"}.to_json
          @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
            :method         => :post,
            :headers        => options,
            :timeout        => 100, # milliseconds
            :body         => lseelp_opt )
            hydra = Typhoeus::Hydra.hydra
            hydra.queue(@request)
            hydra.run
            lseelp_opt = ActiveSupport::JSON.decode(@request.response.body)
            lseelp_opt.each do |lseelp|
              elp_p = {:table_name => "ELEMENT_PEDAGOGI",:condition => "where COD_ELP like \'"+lseelp["COD_ELP_FILS"].to_s+"\' and COD_NEL like 'AN'",:columns => "*"}.to_json
              @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
                :method         => :post,
                :headers        => options,
                :timeout        => 100, # milliseconds
                :body         => elp_p )
                hydra = Typhoeus::Hydra.hydra
                hydra.queue(@request)
                hydra.run
                elp_p = ActiveSupport::JSON.decode(@request.response.body)
                elp_p.each do |el|


                  ind_contrat_elps = {:table_name => "IND_CONTRAT_ELP",:condition => "where COD_ELP like \'"+el["COD_ELP"].to_s+"\' and COD_ANU = '2021' ",:columns => "*"}.to_json
                  @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
                    :method         => :post,
                    :headers        => options,
                    :timeout        => 100, # milliseconds
                    :body         => ind_contrat_elps )
                    hydra = Typhoeus::Hydra.hydra
                    hydra.queue(@request)
                    hydra.run
                    ind_contrat_elps  = ActiveSupport::JSON.decode(@request.response.body)
                    #print ind_contrat_elps.inspect
                    print "11111111"
                    print ind_contrat_elps.first.inspect
                    print "\n"
                    # la en doint creer la relation entre batch et students "insert into IND_CONTRAT_ELP"



    #IND_CONTRAT_ELP
    batch.all_students.each do |std|
    data = {:COD_ANU =>  Time.now.year,:COD_IND => std.matricule ,:COD_ETP => ind_contrat_elps.first["COD_ETP"] ,:COD_VRS_VET => ind_contrat_elps.first["COD_VRS_VET"], :COD_ELP =>ind_contrat_elps.first["COD_ELP"],}
    body = {:table_name =>"IND_CONTRAT_ELP" ,:data => data}.to_json
    @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/insert",
                                  :method         => :post,
                                  :headers        => options,
                                  :timeout        => 100, # milliseconds
                                  :body         => body )
                                  hydra = Typhoeus::Hydra.hydra
                                  hydra.queue(@request)
                                  hydra.run
                                  logger.debug "*************************"
                                  logger.debug "*************************"

    end
                    ct = 0
                    ind_contrat_elps.each do |el|
                      ct = ct + 1
                      if ct.to_i == 1
                      elp_fils_opt = {:table_name => "ELP_REGROUPE_ELP",:condition => "where COD_ELP_PERE like \'"+el["COD_ELP"].to_s+"\'",:columns => "*"}.to_json
                      @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
                        :method         => :post,
                        :headers        => options,
                        :timeout        => 100, # milliseconds
                        :body         => elp_fils_opt )
                        hydra = Typhoeus::Hydra.hydra
                        hydra.queue(@request)
                        hydra.run
                        print "les semestres exist "
                        elp_fils = ActiveSupport::JSON.decode(@request.response.body)
                        elp_fils.each do |ef|

                          efs = {:table_name => "ELEMENT_PEDAGOGI",:condition => "where COD_ELP like \'"+ef["COD_ELP_FILS"].to_s+"\'",:columns => "*"}.to_json
                          @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
                            :method         => :post,
                            :headers        => options,
                            :timeout        => 100, # milliseconds
                            :body         => efs )
                            hydra = Typhoeus::Hydra.hydra
                            hydra.queue(@request)
                            hydra.run
                            # print @request.response.body.to_s+"\n"
                            # efs = @request.response.body.to_a
                            efs = ActiveSupport::JSON.decode(@request.response.body)
                            efs.each do |element_peda|
                              ind_contrat_elps = {:table_name => "IND_CONTRAT_ELP",:condition => "where COD_ELP like \'"+element_peda["COD_ELP"].to_s+"\' and COD_ANU ='2021' ",:columns => "*"}.to_json
                              @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
                                :method         => :post,
                                :headers        => options,
                                :timeout        => 100, # milliseconds
                                :body         => ind_contrat_elps )
                                hydra = Typhoeus::Hydra.hydra
                                hydra.queue(@request)
                                hydra.run
                                ind_contrat_elps  = ActiveSupport::JSON.decode(@request.response.body)
                                print "insert into for 2022"
                                print "222222222"
                                print "\n"
                                print ind_contrat_elps.first
                                print "\n"


    #IND_CONTRAT_ELP
    batch.all_students.each do |std|
    data = {:COD_ANU =>  Time.now.year,:COD_IND => std.matricule ,:COD_ETP => ind_contrat_elps.first["COD_ETP"] ,:COD_VRS_VET => ind_contrat_elps.first["COD_VRS_VET"], :COD_ELP =>ind_contrat_elps.first["COD_ELP"],}
    body = {:table_name =>"IND_CONTRAT_ELP" ,:data => data}.to_json
    @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/insert",
                                  :method         => :post,
                                  :headers        => options,
                                  :timeout        => 100, # milliseconds
                                  :body         => body )
                                  hydra = Typhoeus::Hydra.hydra
                                  hydra.queue(@request)
                                  hydra.run
                                  logger.debug "*************************"
                                  logger.debug "*************************"

    end


                                ct1 = 0
                                ind_contrat_elps.each do |ind|
                                  ct1 = ct1 + 1
                                  if ct1.to_i == 1
                                  sem_fils_opt = {:table_name => "ELP_REGROUPE_ELP",:condition => "where COD_ELP_PERE like \'"+element_peda["COD_ELP"].to_s+"\'",:columns => "*"}.to_json
                                  @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
                                    :method         => :post,
                                    :headers        => options,
                                    :timeout        => 100, # milliseconds
                                    :body         => sem_fils_opt )
                                    hydra = Typhoeus::Hydra.hydra
                                    hydra.queue(@request)
                                    hydra.run
                                    sem_fils = ActiveSupport::JSON.decode(@request.response.body)
                                    sem_fils.each do |sem_son|
                                      print sem_son["COD_ELP_FILS"].to_s
                                      print "\n"
                                      mods = {:table_name => "ELEMENT_PEDAGOGI",:condition => "where COD_ELP like \'"+sem_son["COD_ELP_FILS"].to_s.to_s+"\'",:columns => "*"}.to_json
                                      @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
                                        :method         => :post,
                                        :headers        => options,
                                        :timeout        => 100, # milliseconds
                                        :body         => mods )
                                        hydra = Typhoeus::Hydra.hydra
                                        hydra.queue(@request)
                                        hydra.run
                                        mods = ActiveSupport::JSON.decode(@request.response.body).first
                                        mdl_fils_opt = {:table_name => "ELP_REGROUPE_ELP elpelp, ELEMENT_PEDAGOGI elp",:condition => "where elpelp.COD_ELP_PERE like \'"+mods["COD_ELP"].to_s+"\' and elp.COD_ELP like elpelp.COD_ELP_FILS ",:columns => "elp.COD_ELP, elp.LIB_ELP, elp.COD_PEL"}.to_json
                                        @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/table",
                                          :method         => :post,
                                          :headers        => options,
                                          :timeout        => 100, # milliseconds
                                          :body         => mdl_fils_opt )
                                          hydra = Typhoeus::Hydra.hydra
                                          hydra.queue(@request)
                                          hydra.run
                                          elements = ActiveSupport::JSON.decode(@request.response.body)
                                          elements.each do |e|
                                            print "insert into resultat elp  "
                                            print "\n"
                                            print e["LIB_ELP"]
                                            print "\n"


    #RESULTAT_ELP
    batch.all_students.each do |std|


    data = {:COD_ANU =>  Time.now.year,:COD_IND => std.matricule ,:COD_ELP =>  e["COD_ELP"] ,:COD_SES => e["COD_SES"], :COD_ADM =>e["COD_ADM"]}
    body = {:table_name =>"RESULTAT_ELP" ,:data => data}.to_json
    @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/insert",
                                  :method         => :post,
                                  :headers        => options,
                                  :timeout        => 100, # milliseconds
                                  :body         => body )
                                  hydra = Typhoeus::Hydra.hydra
                                  hydra.queue(@request)
                                  hydra.run
                                  logger.debug "*************************"
                                  logger.debug "*************************"

    end
                                          end
                                         end
                                        end
                                      end
                                    end

                                    end
                                  end
                                end
                              end
                            end
                          end

end
end
def reinscription
  @school_fields = SchoolField.all
  @school_fields.each do |zz|
     batches = Batch.find_all_by_school_field_id(zz.id)
     if batches.empty?
         @school_fields.delete(zz)
     end
  end
  @school_field  = @school_fields.first
  if request.post?
    if params[:commit] == "Exporter"
    require 'faster_csv'
         require 'i18n'
         exportfile = params[:exportfile]
@school_field = SchoolField.find(exportfile[:school_field])
         exportfile[:year] = Time.now.year.to_i  - 1
         if  exportfile[:niveau].to_i == 1
           @course_1 = Course.find_by_code("SM01").id
              @course_2 = Course.find_by_code("SM02").id
         else
           @course_1 = Course.find_by_code("SM03").id
              @course_2 = Course.find_by_code("SM04").id
         end
    @students = []
    logger.debug "////////////////////////////////////////////"
       batches = Batch.find_by_sql("select * from batches where school_field_id = #{exportfile[:school_field]} and (course_id = #{@course_1} or course_id = #{@course_2})").select{ |t| t.get_batch_year == 2021}
       logger.debug "////////////////////////////////////////////"

      batches.each do |b|
        @students += b.all_students
      end

    csv_string = FasterCSV.generate(:col_sep=>';') do | csv |

              csv << ["Code_Etudiant","Nom","Prenom","Code Année","Code SESSION","Code Diplome","Code Etape_1","Code Version Etape_1","	Code Diplome  Etape_1",	"CodeVersion Diplome  Etape_1",	"Code Etape_2",	"Code Version Etape_2",	"Code Diplome  Etape_2",	"CodeVersion Diplome  Etape_2",	"Code Etape_3",	"Code Version Etape_3",	"Code Diplome  Etape_3",	"CodeVersion Diplome  Etape_3",	"Temoin_Etape1_Pemiere",	"Temoin_Etape2_Pemiere",	"Temoin_Etape3_Pemiere"	,"TEM_INSERT_IAE_ETP_1",	"TEM_INSERT_IAE_ETP_2"	,"TEM_INSERT_IAE_ETP_3",	"TEM_UPDATE_IAE_PRM_3","SM01","Q01","SM02","Q02"]
            @students.each do |os|
              tab = [os.matricule,os.last_name,os.first_name,2022,"ANNUELLE"]
              BatchStudent.find_all_by_student_id(os.id).collect(&:batch).group_by(&:start_date).sort.each do |year,bs|
                count = 0
                bs.each do |b|
                  count  = count + 1
                  if count == 2
                tab += [b.school_field.code,b.code_etude,401]
              end
              end
              end
              if  exportfile[:niveau].to_i == 1
                tab += [@school_field.code,401,""]
else
  tab += [@school_field.code,401,""]

end
              csv << tab

end
end
filename="Re_inscription_#{@school_field.code}_ANNUELLE_2022"
send_data Iconv.conv("iso-8859-1//IGNORE", "iso-8859-1", csv_string),
:type => 'text/csv; charset=iso-8859-1; header=present',
:disposition => "attachment; filename=#{filename}.csv"
else
   uploaded_io = params[:importfile_fichier]
     File.open(Rails.root.join('public', 'uploads','File', uploaded_io.original_filename), 'wb') do |file|
       file.write(uploaded_io.read)
     end
    filename="#{RAILS_ROOT}/public/uploads/File/"+uploaded_io.original_filename

    require 'faster_csv'
    @n=0
    i = 0




#file_path = "filename.csv"  my_array = []    File.open(file_path).each do |line| # `foreach` instead of `open..each` does the same    begin           CSV.parse(line) do |row|        my_array << row      end    rescue CSV::MalformedCSVError => er      puts er.message      counter += 1      next    end    counter += 1    puts "#{counter} read success"  end



    FasterCSV.foreach(filename,  :col_sep =>';', :row_sep => :auto) do |row|
      logger.debug "///////////////////////////////"
      logger.debug row[0]
      logger.debug "///////////////////////////////"
      student = Student.find_by_matricule(row[0])
      if student
batch = student.batch


if batch.course.code.to_s == "SM02"
  logger.debug "******************************************"
  logger.debug "******************************************"
  logger.debug "******************************************"
  logger.debug "******************************************"
  logger.debug "******************************************"
  new_course = Course.find_by_code("SM03")
  new_batch = Batch.find_all_by_school_field_id_and_course_id(batch.school_field,new_course.id).select{|b| b.get_batch_year.to_i == Time.now.year.to_i}

  if new_batch.count >  0
    new_batch = new_batch.first
  else
    logger.debug "******************************************"
    start_date = "#{Time.now.year}/09/01".to_date
    end_date = "#{Time.now.year + 1}/06/30".to_date
    new_batch = Batch.new(:name => "Semestre 3 #{batch.school_field.name}/#{Time.now.year}",:code_etude => row[10],:course_id => new_course.id ,:school_field_id => batch.school_field.id,:start_date => start_date ,:end_date => end_date,:cycle_id => 6 )
    new_batch.save
    logger.debug "******************************************"

    logger.debug new_batch.errors.full_messages
    logger.debug "******************************************"

  end
  BatchStudent.create(:batch_id => student.batch.id,:student_id => student.id)

  student.update_attributes(:batch_id =>new_batch.id )
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
  uri = URI("http://ump-oujda.tk/api/apogee/table")
  options = {'Content-Type' => 'application/json','X-Auth-Token' => token}
  logger.debug student.matricule
    logger.debug Time.now.year
  logger.debug row[10]
  logger.debug batch.school_field.code


#INS_INFO_ANU
data = {:COD_ANU =>  Time.now.year.to_i - 1 ,:COD_IND => student.matricule ,:COD_THB => 4 }
body = {:table_name =>"INS_INFO_ANU" ,:data => data}.to_json
@request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/insert",
                              :method         => :post,
                              :headers        => options,
                              :timeout        => 100, # milliseconds
                              :body         => body )
                              hydra = Typhoeus::Hydra.hydra
                              hydra.queue(@request)
                              hydra.run
                              logger.debug "*************************"
                              logger.debug "*************************"
logger.debug @request.response.body

data = {:COD_ANU =>  Time.now.year.to_i - 1 ,:COD_IND => student.matricule,:COD_PRU => "NO",:COD_RGI => "1",:COD_SOC =>  "NO", :COD_STU => "01",:COD_TPE_ANT => "23",:COD_DEP_ANT=> "053",:COD_UTI => "MMELHAOUI"}
body = {:table_name =>"INS_ADM_ANU" ,:data => data}.to_json
@request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/insert",
                              :method         => :post,
                              :headers        => options,
                              :timeout        => 100, # milliseconds
                              :body         => body )
                              hydra = Typhoeus::Hydra.hydra
                              hydra.queue(@request)
                              hydra.run
                              logger.debug "*************************"
                              logger.debug "*************************"
logger.debug @request.response.body

  data = {:NBR_INS_DIP=> 1,:COD_NAT_TIT_ACC_IAE => "A",:TEM_TLS_IAE => "O",:TEM_IAE_PRM => "N",:TEM_CHG_SUR_ETP =>"O",:TEM_INS_ELP_ATMQ_IAE => "N",:NBR_INS_ETP => 1,:NBR_INS_CYC => 1,:ETA_PMT_IAE => "P",:DAT_CRE_IAE=> Time.now.to_date.strftime("%d-%m-%Y"),:ETA_IAE => "E",:COD_PRU => "NO",:COD_IND =>student.matricule,:COD_ANU => Time.now.year.to_i - 1,:COD_ETP => row[10],:COD_VRS_VET => 401,:COD_DIP => batch.school_field.code,:COD_VRS_VDI => 401,:COD_CGE => "TGE",:COD_CMP => "EST",:COD_UTI => "IIDRISSI",:NUM_OCC_IAE => 1}
  bod = {:data => data ,:table_name => "INS_ADM_ETP"}.to_json
  @request = Typhoeus::Request.new("http://ump-oujda.tk/api/apogee/insert",
                              :method         => :post,
                              :headers        => options,
                              :timeout        => 100, # milliseconds
                              :body         => bod )
                              hydra = Typhoeus::Hydra.hydra
                              hydra.queue(@request)
                              hydra.run
                              logger.debug "*************************"
                              logger.debug "*************************"
logger.debug @request.response.body

elsif batch.course.code.to_s == "SM04"
    end
  end
  end
  end
end
end
def export_online_students
   require 'faster_csv'
        require 'i18n'
   @status = params[:status].to_s.downcase

if params[:status]
  @online_students = OnlineStudent.find_all_by_status(@status)
elsif params[:categorie]


  @online_students = OnlineStudent.all.select{ |s| s.reinscription.to_i == params[:categorie].to_i }
  elsif params[:start_date]
    @start_date = params[:start_date]
        @end_date = params[:end_date]

        @online_students = OnlineStudent.find(:all, :conditions => "( updated_at  >= '#{@start_date} 00:00:00' and  updated_at  <= '#{@end_date} 23:59:59')")
  elsif params[:start_date_in]
    @start_date = params[:start_date_in]
        @end_date = params[:end_date_in]

        @online_students = OnlineStudent.find(:all, :conditions => "( created_at  >= '#{@start_date} 00:00:00' and  created_at  <= '#{@end_date} 23:59:59')")
else
   @online_students = OnlineStudent.all
end



#    :admission_no,:matricule,:prenom_fr,:nom_fr

        @online_students = OnlineStudent.all.select{|s| s.updated_at.to_date.year == Time.now.to_date.year}.sort_by{ |ar| ar[:created_at]}
        csv_string = FasterCSV.generate(:col_sep=>';') do | csv |

                  csv << ["ID", "Nom" , "Prenom" , "Date d'inscription" , "Date de modification" ,"CIN", "Matricule", "Code massar " , "Filiere" , "Catégorie" , "Status"]
                  @online_students.each do |os|

                filier1 = ""
                if os.school_field_id
                filier1 =  Filiere_Entissab.find_by_ID_FIL(os.school_field_id).LIB_FIL
                end


                cat1 = ""

                    csv << [os.id,os.nom_fr,os.prenom_fr,os.created_at,os.updated_at,os.cin,os.matricule,os.code_massar,filier1,cat1,os.status]
                  end

    end
    filename="all_students"
   send_data Iconv.conv("iso-8859-1//IGNORE", "iso-8859-1", csv_string),
  :type => 'text/csv; charset=iso-8859-1; header=present',
  :disposition => "attachment; filename=#{filename}.csv"

end

def fichier_ia

    require 'faster_csv'
    require 'csv'

    csv_string = FasterCSV.generate(:col_sep=>';') do | csv |

     @onlin_students = OnlineStudent.all.select{|b| b.created_at.to_date.year == Time.now.to_date.year}

         csv << [ "COD_CMP", "code de diplome","LIB_DIP","COD_VRS_VDI","CNE","Date de naissance","SEXE","code de la province","code du pays", "handicape", "code serie de bac","Année Bac","code province du bac","code académie","num apogee","NOM","PRÉNOM","CIN","Lieu de naissance","BAC","ÉTAPE","Version étape","Date entrée établissement","Mention","NBR_INS_ETP","NBR_INS_CYC","NBR_INS_DIP","COD_DEP"]

      @onlin_students.each do |st|
        # @school_fields = SchoolField.find_by_sql("select * from school_fields where id = #{st.school_field_id}")
        @school_fields= SchoolField.find_by_id(st.school_field_id)
        logger.debug "???????????????????????????????????????????????????#{@school_fields.inspect} "
        if @school_fields
       csv << [ "EAC", @school_fields.code_diplome,@school_fields.LIB_DIP,@online_fields.COD_VRS_VDI,st.code_massar.to_s,st.date_naissance,st.sexe,st.province,st.country, "handicape", st.num_baccalaureat,st.annee_bac,st.province_bac,"08",st.matricule,st.nom_fr.to_s,st.prenom_fr,st.cin,st.lieu_naissance_fr ,st.filiere_bac,"LAREIH","707",st.created_at.year,st.mention_bac,"2","2","2","074"]
      else
      csv << [ "EAC", " "," ","",st.code_massar.to_s,st.date_naissance,st.sexe,st.province,st.country, "handicape", st.num_baccalaureat,st.annee_bac,st.province_bac,"08",st.matricule,st.nom_fr.to_s,st.prenom_fr,st.cin,st.lieu_naissance_fr ,st.filiere_bac,"LAREIH","707",st.created_at.year,st.mention_bac,"2","2","2","074"]

      end
    end
    end

    filename="fichier IA"
   send_data Iconv.conv("iso-8859-1//IGNORE", "iso-8859-1", csv_string),
    :type => 'text/csv; charset=iso-8859-1; header=present',
    :disposition => "attachment; filename=#{filename}.csv"
end



     def registration_form_list

    @rtype_rcourse_evasam_history =    RtypeRcourseEvasamHistory.find_all_by_regi_type_regi_course_id(params[:regi_type_regi_course_id])

    logger.debug "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH"
     logger.debug "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH"
     logger.debug  @rtype_rcourse_evasam_history.inspect
     logger.debug params[:regi_type_regi_course_id]
      logger.debug "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH"
       logger.debug "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH"
        render(:update) do |page|
          page.replace_html 'registration_form_list', :partial=>'registration_form_list'
        end
  end

  def choose_registration
  end
  def apooge
    redirect_to "https://website.com"

  end
  def choose_registration_course
   @regi_type_regi_course  =  RegiTypeRegiCourse.find_all_by_registration_type_id(params[:registration_type_id] )
   render(:update) do |page|
          page.replace_html 'choose_registration_course', :partial=>'choose_registration_course'
        end

  end


   def attestation_reussite
    render :pdf => 'attestation_reussite' ,:margin => { :left => 30 , :right => 30 }
   end

   def diplome
    render :pdf => 'diplome_1',:orientation => "landscape" ,:header => false , :footer => false ,:margin => { :top =>5 , :bottom => 5, :left => 10, :right => 10 }
   end


   def diplome_license_education
     render :pdf => 'diplome_1',:orientation => "landscape" ,:header => false , :footer => false ,:margin => { :top =>5 , :bottom => 5, :left => 10, :right => 10 }

   end


  def type_inscription
      @registration_types = RegistrationType.all

  end


  def cancel

      RegistrationType.find(params[:id]).update_attributes(:hide => true )
     @registration_types = RegistrationType.all
       render(:update) do |page|
          page.replace_html 'registration_type_listi', :partial=>'registration_type_listi'
        end
  end

  def done

    RegistrationType.find(params[:id]).update_attributes(:hide => false )
     @registration_types = RegistrationType.all
       render(:update) do |page|
          page.replace_html 'registration_type_listi', :partial=>'registration_type_listi'
        end
  end

  def academic_report_all
    @user = current_user
    @prev_student = @student.previous_student
    @next_student = @student.next_student
    @course = @student.course
    @examtypes = ExaminationType.find( ( @course.examinations.collect { |x| x.examination_type_id } ).uniq )

    @graph = open_flash_chart_object(965, 350, "/student/graph_for_academic_report?course=#{@course.id}&student=#{@student.id}")
    @graph2 = open_flash_chart_object(965, 350, "/student/graph_for_annual_academic_report?course=#{@course.id}&student=#{@student.id}")
  end

  def index_ins
    @students = OnlineStudent.all.select{|b| b.created_at.to_date.year == Time.now.to_date.year}
     @config_start_date = Configuration.find_by_config_key('InscriptionStartDate')
      @config_end_date = Configuration.find_by_config_key('InscriptionEndDate')

      #@start_date = @config_start_date.config_value.to_date
      #@end_date = @config_end_date.config_value.to_date
  end
  def decision
    @id = params[:id].to_i

        render(:update) do |page|
          page.replace_html 'modal-box', :partial => 'decision_ins'
          page << "Modalbox.show($('modal-box'), {title: 'Décision :', width: 350});"
        end
  end
  def set_decision_ins

    @status = params[:decision].to_s.downcase
    @online_student = OnlineStudent.find(params[:id].to_i)
    school_year = @online_student.year_ump
    fe = Filiere_Entissab.find_by_ID_FIL(@online_student.school_field_id)
    sf = SchoolField.find_by_COD_DIP(fe.COD_DIP)
    batchs = Batch.find_all_by_school_field_id(sf.id)
    batchs.reject{|b| b.get_batch_year != school_year }
    if batchs.empty?
      cod_etp = VdiFractionnerVet.find_all_by_COD_DIP_and_COD_SIS_DAA_MIN(fe.COD_DIP,1).COD_ETP
      c = Course.find(130)
      new_bat = Batch.new(:course_id => c.id,:name => c.course_name+" "+sf.name+" "+school_year.to_s+"/"+(school_year+1).to_s,:start_date =>Date.parse("09/01"+(school_year).to_s),:end_date => Date.parse("06/30"+(school_year+1).to_s),:is_active => true, :is_deleted => false, :schooL_field_id => sf.id,:cycle_id => 6,:code_etape => cod_etp)
    end
    batchs = batchs.select{|b| b.course.id == 130}.first
    batch_id = batchs.id
    if @status.first.downcase == "v"
      @online_student.update_attributes(:status =>@status.to_s.downcase )
      @student = Student.new(:first_name=>@online_student.prenom_fr,:last_name=>@online_student.nom_fr,:type_concours =>@online_student.type_concours, :rang_concours =>@online_student.rang_concours ,
      :prenom_ar =>@online_student.prenom_ar , :nom_ar=>@online_student.nom_ar , :cin =>@online_student.cin , :cin_debut =>@online_student.cin_debut , :cin_lieu =>@online_student.cin_lieu , :lieu_naissance_ar =>@online_student.lieu_naissance_ar , :num_baccalaureat =>@online_student.num_baccalaureat , :lycee =>@online_student.lycee , :ville_bac =>@online_student.ville_bac , :pays_bac =>@online_student.pays_bac , :type_bac =>@online_student.type_bac, :type_ens =>@online_student.type_ens, :annee_bac =>@online_student.annee_bac , :mention_bac =>@online_student.mention_bac , :bourse =>@online_student.bourse , :bourse_org =>@online_student.bourse_org , :contractuel =>@online_student.contractuel , :contrat_org =>@online_student.contrat_org , :num_bourse_contrat =>@online_student.num_bourse_contrat , :nbre_freres =>@online_student.nbre_freres , :prob_sante => @online_student.prob_sante, :admission_date => Time.now, :date_of_birth => @online_student.date_naissance, :gender => @online_student.sexe, :birth_place=> @online_student.lieu_naissance_fr, :address_line1 => @online_student.adresse, :city => @online_student.ville_bac, :photo => @online_student.photo, :matricule=>@online_student.cin, :batch_id =>batch_id)
      @last_admitted_student = Student.find(:last)
      @student.admission_no = @last_admitted_student.admission_no.next
      @student.save
    end
    logger.debug @status

    if @status
      render(:update) { |page| page.replace_html "st_#{@online_student.id}", :text => "#{@status}" }
    end
  end
  def set_status_ins
    logger.debug "==============================================================="
    logger.debug params[:choix]
     logger.debug "==============================================================="
    if params[:online_student][:status]

      @online_student = OnlineStudent.find_by_id(params[:online_student][:id].to_i)

            @online_student.status = params[:online_student][:status].to_s.downcase

@online_student.update_attributes(:status =>params[:online_student][:status].to_s.downcase )
      if @online_student.save

        if !params[:online_student][:raison].nil?
          # msg = "Votre demande a été refusé car: #{params[:online_student][:raison].to_s}"
          # if !@online_student.email.nil?
          #   FEDENAMailer::deliver_email("no-reply@ifd.ma", [@online_student.email], "Demande d'inscription", msg)
          # end
              flash[:notice] = "Mise a jour avec succès"
              redirect_to :controller => "student", :action => "index_ins"

        else
          if params[:online_student][:status].to_s.downcase == "en cours"

              flash[:notice] = "Mise a jour avec succès"
              redirect_to :controller => "student", :action => "index_ins"

          else

          @last_admitted_student = Student.find(:last)
          @student = Student.find_by_sql("select * from students where email like '"+@online_student.email+"'").first
          if @student.nil?
          @student = Student.new
          admission_date = Date.today

          @student.admission_no = @last_admitted_student.admission_no.next
          @student.admission_date = admission_date
          @student.matricule = @online_student.matricule.to_i
          @student.middle_name = @online_student.deuxieme_prenom.to_s
          @student.first_name = @online_student.prenom_fr.to_s
          @student.last_name = @online_student.nom_fr.to_s
          @student.cin = @online_student.cin.to_s
          @student.cin_debut = @online_student.cin_debut.to_date unless @online_student.cin_debut.nil?
          @student.cin_lieu = @online_student.cin_lieu.to_s
          @student.birth_place = @online_student.lieu_naissance_fr.to_s
          @student.date_of_birth = @online_student.date_naissance.to_date unless @online_student.date_naissance.nil?
          @student.batch_id = @online_student.batch_id.to_i
          @student.blood_group = @online_student.group_sang.to_s
          @student.student_category_id = @online_student.student_category_id.to_i
          @student.address_line1 = @online_student.address_line1.to_s
          @student.address_line2 = @online_student.address_line2.to_s
          @student.city = @online_student.city.to_s
          @student.state = @online_student.region.to_s
          @student.pin_code = @online_student.zip.to_s
          @student.country_id = @online_student.country_id.to_i
          @student.phone1 = @online_student.tel.to_s
          @student.phone2 = @online_student.tel_pro.to_s
          @student.email = @online_student.email.to_s
        #  @student.photo = @online_student.photo
  else
  #  @student.update_attributes(:direction  => @online_student.direction)
    if params[:choix].to_i == 1
  BatchStudent.create(:student_id => @student.id, :batch_id => @student.batch_id)
  @student.update_attributes(:batch_id => @online_student.batch_id)


    end
  end
          if @student.save
              msg = "Votre demande a été accepté"
              Reminder.create(:sender=>1,:recipient=>@student.user_id, :subject=>"Demande d'inscription", :body=>msg , :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)

              # if !@online_student.email.nil?
              #     FEDENAMailer::deliver_email("no-reply@ifd.ma", [@student.email], "Demande d'inscription", msg)
              # end
              flash[:notice] = "Mise a jour avec succès"
              redirect_to :controller => "student", :action => "index_ins"
          end
          logger.debug(@student.errors.full_messages)
          end
        end





      end

    end
  end
  def view_online_student
     @online_student = OnlineStudent.find_by_id(params[:id].to_i)

        render(:update) do |page|
          page.replace_html 'modal-box2', :partial => 'view_online_student'
          page << "Modalbox.show($('modal-box2'), {title: 'Student :', width: 450});"
        end
  end
  def edit_infos
  @school_fields=SchoolField.find(:all, :order =>"name")

      @courses=Course.find(:all, :order => "code")
  end
  def select_batch2
     @school_field_id=params[:school_field_id]
   @course_id=params[:course_id]
   @school_year=params[:school_year]
     if(@school_field_id != nil and @school_field_id != '')
     @batches=Batch.find(:all, :conditions => "course_id = #{@course_id} and school_field_id = #{@school_field_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
  else
   @batches=Batch.find(:all, :conditions => "course_id = #{@course_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
  end
   render(:update) do |page|
      page.replace_html 'batch_selection2', :partial=>'batch_selection2'
    end
  end
  def list_students_by_course2
    @batch_id = params[:batch_id]
    @students = Student.find_all_by_batch_id(params[:batch_id], :order => 'last_name ASC')
    render(:update) { |page| page.replace_html 'students2', :partial => 'students_model' }
  end
  def export_model_info
    @batch_id = params[:batch_id]
    @batch = Batch.find_by_id(@batch_id.to_i)
    @students = []
    @students = @batch.students
    @students += @batch.old_students

    @students = @students.uniq

    nombatch="export"
    require 'faster_csv'

    csv_string =FasterCSV.generate(:col_sep=>';',:encoding => 'UTF8',:headers=>true) do | csv |
      csv << ["MATRICULE","CODE APOGEE","CIN","CNE", "NOM en Français" , "PRENOM en Français","ANNEE SCOLAIRE","FILIERE","OPTION", "EMAIL OFFICIEL","TELEPHONE OFFICIEL", "NOM en Arabe" , "PRENOM en Arabe","TELEPHONE DE SECOURS", "EMAIL DE SECOURS","GENRE","NATIONALITE","DATE DE NAISSANCE","LIEU DE NAISSANCE EN ARABE","VILLE DE NAISSANCE EN ARABE","LIEU DE NAISSANCE EN Français","VILLE DE NAISSANCE EN Français","ADDRESSE ","ADDRESSE DE SECOURS","VILLE ADRESSE","PROVINCE ADRESSE","Nom Pére","Profession Pére","Situation Profession Pére","TEL Pére","Nom Mére","Profession Mére","Situation Profession Mére","TEL Mére","Série BAC","Année BAC","Mention Bac","Lycée BAC","Ville BAC","Province BAC","Pays BAC","Voie d'admission","Diplome d'admission","FILIERE DIPLOME","Classement dans diplome","code CNC","Année Diplome","Etablissement diplome","Ville diplome","Centre d'origine du diplome","Type enseignement","pays enseignement","BOURSE","BOURSE ORGANISME", "photo"]
    @students.each do | me |
     #csv << [me.admission_no,me.matricule,me.last_name,me.first_name]
     annee=me.batch.start_date.strftime("%Y")+"/"+me.batch.end_date.strftime("%Y")
     annee=@batch.get_batch_year

     school_field =  nil
     if me.batch.school_field
       school_field = me.batch.school_field.name
     else
           school_field =  nil

     end
       nationality =  nil
     if me.nationality
       nationality = me.nationality.name
     else
           nationality=  nil

     end

     adr = nil
          if !me.address_line1.nil?

     adr = me.address_line1.gsub("\r","").gsub("\n","").gsub(",","").to_s
   end
     if !me.address_line2.nil?
      adr = me.address_line1.gsub("\r","").gsub("\n","").gsub(",","").to_s + " " + me.address_line2.gsub("\r","").gsub("\n","").gsub(",","").to_s
     end


     if me.bourse==true
      br = "Oui"
     else
      br = "Non"
     end
     #csv << [me.matricule, me.apogee, me.cin.to_s, me.num_baccalaureat.to_s, me.last_name, me.first_name, annee, school_field, "--", me.email.to_s, me.phone1.to_s, me.nom_ar, me.prenom_ar, me.phone2.to_s, me.email2.to_s, me.gender, nationality, me.date_of_birth.strftime("%d/%m/%Y"), me.lieu_naissance_ar, me.lieu_naissance_ar, me.birth_place, me.birth_place, adr, me.address_secours, me.city, me.state, me.father_full_name, me.father_job, me.father_job_status, me.father_phone, me.mother_full_name, me.mother_job, me.mother_job_status, me.mother_phone, me.type_bac, me.annee_bac, me.mention_bac.to_s, me.lycee, me.ville_bac, me.province_bac, me.pays_bac, me.type_concours, me.diplome_admission, me.filiere_diplome, me.rang_concours, me.code_cnc, me.annee_diplome, me.etablissement_dip, me.ville_dip, me.centre_dip, me.type_enseignement, me.pays_enseignement, br, me.bourse_org.to_s.upcase, me.photo_file_name]

if  me.apogee == ""
  me.apogee = nil
  end
if me.cin == ""
      me.cin =  nil
  end
 if me.num_baccalaureat.to_s == ""
      me.num_baccalaureat =  nil
  end
 if me.num_baccalaureat.to_s == ""
      me.num_baccalaureat =  nil
  end
   if me.phone2.to_s == ""
      me.phone2 =  nil
  end
   if me.phone1.to_s == ""
      me.phone1 =  nil
  end
   if me.email.to_s == ""
      me.email =  nil
  end

    if nationality.to_s == ""
      nationality =  nil
  end
    if me.address_line1.to_s == ""
      me.address_line1 =  nil
    else
        if me.address_line1

       me.address_line1  = me.address_line1.gsub("\r","").gsub("\n","").gsub(",","")
     end
  end
  if me.address_line2 == ""
          me.address_line2 =  nil
else
  if me.address_line2
         me.address_line2  = me.address_line2.gsub("\r","").gsub("\n","").gsub(",","")
       end

  end
    if annee == ""
          annee =  nil

  end

        if br == ""
                  br = nil

        end
          if me.bourse_org == ""
           me.bourse_org = nil
          end
          if me.state == ""
            me.state = nil
          end
          sf2 = ""
                      if me.batch.school_field.field_root
 sf2 = SchoolField.find(me.batch.school_field.field_root).name
else
 sf2 = me.batch.school_field.name
end
      #csv << [me.matricule,me.apogee,me.cin.to_s,me.num_baccalaureat.to_s,me.last_name,me.first_name,annee,school_field,"--",me.email,me.phone1.to_s,me.nom_ar,me.prenom_ar,me.phone2,me.email,me.gender,nationality,me.date_of_birth,me.birth_place,me.address_line1.to_s.upcase,me.city.to_s.upcase,me.lieu_naissance_ar,me.city.to_s.upcase,me.address_line1.to_s.upcase,me.address_line2.to_i,me.state.to_i,"np","pp","spp","tp","nm","pm","spm","tm",me.type_bac,me.annee_bac,me.mention_bac.to_s.upcase,me.lycee,me.ville_bac,me.pays_bac,me.pays_bac,me.type_concours,"diplome","filere diplome",me.rang_concours,"code cnc","anne","Etablissement","ville","cod","private","pays",me.bourse.to_s.upcase,me.bourse_org.to_i, me.id.to_s]
          csv << [me.matricule, me.apogee, me.cin.to_s, me.num_baccalaureat.to_s, me.last_name, me.first_name, annee, school_field, sf2, me.email, me.phone1, me.nom_ar, me.prenom_ar, me.phone2, me.gender, nationality, me.date_of_birth, me.lieu_naissance_ar, me.lieu_naissance_ar, me.birth_place, me.birth_place, me.city, me.state, me.type_bac, me.annee_bac, me.mention_bac, me.lycee, me.ville_bac, me.province_bac,  me.pays_bac,  me.type_concours, me.diplome_admission, me.filiere_diplome, me.rang_concours, me.code_cnc, me.annee_diplome, me.etablissement_dip, me.ville_dip, me.centre_dip, me.type_enseignement, me.pays_enseignement, br, me.bourse_org, me.id.to_s+'.jpg']

     nombatch=@batch.name
    end
   end
    filename=nombatch




   send_data Iconv.conv("iso-8859-1//IGNORE", "ISO-8859-1", csv_string),
  :type => 'text/csv; charset=iso-8859-1; header=present',
  :disposition => "attachment; filename=#{filename}.csv"





  end

  def filter_by_school_field
      @school_field_id = params[:school_field_id].to_s.downcase


      @online_students = OnlineStudent.find_all_by_school_field_id(@school_field_id)

      @online_students_existe = @online_students


        render(:update) { |page| page.replace_html 'table_change', :partial => 'liste_students' }

  end

  def import_model_info
    @batch = Batch.find_by_id(params[:batch_id].to_i)
     uploaded_io = params[:importfile_fichier]
     File.open(Rails.root.join('public', 'uploads','File', uploaded_io.original_filename), 'wb') do |file|
       file.write(uploaded_io.read)
     end
    filename="#{RAILS_ROOT}/public/uploads/File/"+uploaded_io.original_filename

    require 'faster_csv'
    @n=0
    i = 0




#file_path = "filename.csv"  my_array = []    File.open(file_path).each do |line| # `foreach` instead of `open..each` does the same    begin           CSV.parse(line) do |row|        my_array << row      end    rescue CSV::MalformedCSVError => er      puts er.message      counter += 1      next    end    counter += 1    puts "#{counter} read success"  end



    FasterCSV.foreach(filename,  :col_sep =>';', :row_sep => :auto) do |row|
      i = i + 1
if i > 1
      student = Student.find_by_matricule(row[0])
      logger.debug "***********************"
      logger.debug row[1].to_s

if row[1].to_s == ""
else
  student.apogee = row[1].to_s
  end
  if row[9].to_s == ""
  else
    logger.debug "heeeeeeeeeeeeeeeeeeeeeeeeeeeeeera"
    student.email = row[9].to_s
    student.update_attributes(:email =>row[9] )
    end
if row[2].to_s == ""
else
      student.cin = row[2].to_s
  end

  if row[10].to_s == ""
else
      student.phone1 = row[10].to_s
  end
  if row[13].to_s == ""
else
      student.phone2 = row[13].to_s
  end
  if row[14].to_s == ""
else
      student.email2 = row[14].to_s
  end
  if row[15].to_s == ""
else
      student.gender = row[15].to_s.upcase
  end
  if row[17].to_s == ""
else
  logger.debug "*****************"
  logger.debug row[17]
  #student.date_of_birth = row[17]

      student.date_of_birth = Date.strptime("#{row[17]}", "%d/%m/%Y")
  end
    if row[3].to_s == ""
else
      student.num_baccalaureat = row[3].to_s
  end
    if row[18].to_s == ""
else
      student.lieu_naissance_ar = row[18].to_s
  end
    if row[20].to_s == ""
else
      student.birth_place = row[20].to_s
  end
   if row[22].to_s == ""
else
      student.address_line1 = row[22].to_s
  end
   if row[23].to_s == ""
else
      student.address_secours = row[23].to_s
  end
    if row[24].to_s == ""
else
      student.city = row[24].to_s
  end
    if row[25].to_s == ""
else
      student.state = row[25].to_s
  end
   if row[26].to_s == ""
else
      student.father_full_name = row[26].to_s
  end
     if row[27].to_s == ""
else
      student.father_job = row[27].to_s
  end
     if row[28].to_s == ""
else
      student.father_job_status = row[28].to_s
  end
   if row[29].to_s == ""
else
      student.father_phone = row[29].to_s
  end
     if row[30].to_s == ""
else
      student.mother_full_name = row[30].to_s
  end
   if row[31].to_s == ""
else
      student.mother_job = row[31].to_s
  end
     if row[32].to_s == ""
else
      student.mother_job_status = row[32].to_s
  end
     if row[33].to_s == ""
else
      student.mother_phone = row[33].to_s
  end



    if row[34].to_s == ""
else
     student.type_bac = row[34].to_s
  end

    if row[35].to_s == ""
else
     student.annee_bac = row[35].to_s
  end
    if row[36].to_s == ""
else
     student.mention_bac = row[36].to_s
  end
    if row[37].to_s == ""
else
     student.lycee = row[37].to_s
  end
    if row[38].to_s == ""
else
     student.ville_bac = row[38].to_s
  end
    if row[39].to_s == ""
else
     student.province_bac = row[39].to_s
  end
    if row[40].to_s == ""
else
     student.pays_bac = row[40].to_s
  end
  if row[41].to_s == ""
else
     student.type_concours = row[41].to_s
  end
    if row[42].to_s == ""
else
     student.diplome_admission = row[42].to_s
  end
    if row[43].to_s == ""
else
     student.filiere_diplome = row[43].to_s
  end
 if row[44].to_s == ""
else
     student.rang_concours = row[44]
  end
if row[45].to_s == ""
else
     student.code_cnc = row[45].to_s
  end
  if row[46].to_s == ""
else
     student.annee_diplome = row[46]
  end
    if row[47].to_s == ""
else
     student.etablissement_dip = row[47].to_s
  end
    if row[48].to_s == ""
else
     student.ville_dip = row[48].to_s
  end
    if row[49].to_s == ""
else
     student.centre_dip = row[49].to_s
  end
    if row[50].to_s == ""
else
     student.type_enseignement = row[50].to_s
  end
    if row[51].to_s == ""
else
     student.pays_enseignement = row[51].to_s
  end
     if row[52].to_s.downcase == "oui"
       #student.bourse = true
     else
       #student.bourse = false
     end
     if row[53]
     student.bourse_org = row[53].to_s
   end
if student.save
  logger.debug "apooooooooooooooooge"

  @n = @n + 1
  end

    end
  end

    flash[:notice] = "Importation de fichier effectue. Nombre de lignes :"+@n.to_s
    redirect_to :action => "edit_infos"
  end
 def admission1
  logger.debug"************#{params[:student]}***************"
  
 logger.debug"kkkkkkkkkkkkkkkkkkkk"
@selected_value = Country.default_country
  @application_sms_enabled = SmsSettings.find_by(settings_key: "ApplicationEnabled")
  @last_admitted_student = Student.last
@config = ::Configuration.find_by!(config_key: 'AdmissionNumberAutoIncrement')
  @categories = StudentCategory.active

  if request.post?
    @student = Student.new(student_params)
    if @student.save
       @status = true
    user = User.new
    user.first_name = @student.first_name
     user.last_name =  @student.last_name
      user.username = @student.matricule
      user.email = @student.email
       user.password = @student.matricule.to_s + "123"
        user.student = true
         user.role = 'student'
        user.save  
    else       
      # Save failed, log the errors
      error_messages = @student.errors.full_messages.join(", ")
      Rails.logger.error("Failed to save student. Errors: #{error_messages}")
    end
    # if @config.config_value.to_i == 1
    #   # @exist = Student.find_by(admission_no: student_params[:admission_no])
    # logger.debug ", #{@exist}  QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ #{student_params[:admission_no]}"
    #   if @exist.nil?
    #     if @student.save
    #       @status = true
    #     end
    #   else
    #     @last_admitted_student = Student.last
    #     @student.admission_no = @last_admitted_student.admission_no.next
    #     @status = @student.save
    #   end
    # else
      # @status = @student.save
    # end

    # if @status
    #   sms_setting = SmsSetting.new
    #   logger.debug ", #{sms_setting.application_sms_active}  QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ #{ @student.is_sms_enabled}"
    #   if sms_setting.application_sms_active && @student.is_sms_enabled
    #     recipients = []
    #     message = "#{t('student_admission_done')} #{@student.admission_no} #{t('password_is')} #{@student.admission_no}123"
    #     if sms_setting.student_sms_active
    #       recipients.push @student.phone2 unless @student.phone2.blank?
    #     end
    #     unless recipients.empty?
    #       SmsManagerJob.perform_later(message, recipients)
    #     end
    #   end
   redirect_to controller: "student", action: "profile", id: @student.id
    # end
  end
end

 def admission2
    @student = Student.find_by(id: params[:id])

    if @student.nil?
      # Handle the case when student is not found
      # Redirect or show an error message
    else
      @guardian = Guardian.new(guardian_params)

      if request.post? && @guardian.save
        redirect_to student_admission2_path(id: @student.id)
      end
    end
  end



  def admission3
    @student = Student.find(params[:id])
    @parents = @student.guardians
    if @parents.empty?
      redirect_to :controller => "student", :action => "previous_data", :id => @student.id
    end
    return if params[:immediate_contact].nil?
    if request.post?
      sms_setting = SmsSetting.new()
      @student = Student.update(@student.id, :immediate_contact_id => params[:immediate_contact][:contact])
      if sms_setting.application_sms_active and @student.is_sms_enabled
        recipients = []
        message = "#{t('student_admission_done')}  #{@student.admission_no} #{t('password_is')} #{@student.admission_no}123"
        if sms_setting.parent_sms_active
          guardian = Guardian.find(@student.immediate_contact_id)
          recipients.push guardian.mobile_phone unless guardian.mobile_phone.nil?
        end
        unless recipients.empty?
          Delayed::Job.enqueue(SmsManager.new(message,recipients))
        end
      end
      redirect_to :action => "previous_data", :id => @student.id
    end
  end
def importstudent
      @batches = Batch.all

   if request.post?
     uploaded_io = params[:importfile_fichier]
     File.open(Rails.root.join('public', 'uploads','File', uploaded_io.original_filename), 'wb') do |file|
       file.write(uploaded_io.read)
     end
    filename="#{RAILS_ROOT}/public/uploads/File/"+uploaded_io.original_filename
    require 'faster_csv'
   @n=0

   FasterCSV.foreach(filename,  :col_sep =>';', :row_sep =>:auto) do |row|
     c=Classroom.new
     #c.admission_no=row[0]
     #Rails.logger.info row[0] + " XXXXXX " + row[1] + " XXXXXXX " + row[2]


     c.name=row[0]
     c.alias=row[1]
     c.code=row[2]
     c.capacity=row[3]
     c.zone=row[4]
     c.surface=row[8]

     if TypeClassroom.find_by_label("#{row[5]}")
     else
     	tc = TypeClassroom.new(:label => row[5]).save

     	     c.type_classroom_id=tc.id

     end
     c.save
         Rails.logger.info c.errors.full_messages.to_sentence

     end
     flash[:notice] = "Importation de fichier effectue. Nombre de lignes :"
    end



  end
  def history
     #@student = Student.find(params[:id])
     #@batch=@student.batch
     #@course=Course.find_by_id(@batch)
     @student = Student.find(params[:id])
   @batch_student = BatchStudent.find_all_by_student_id(@student.id)
   logger.debug @batch_student
  
end
  def historique_pdf
    @student = Student.find(params[:id])
   @batch_student = BatchStudent.find_all_by_student_id(@student.id)
   
  #logger.debug "***********************#{@battch.inspect}**************"
  #logger.debug "***********************#{@couuurse.inspect}**************"
  #logger.debug "***********************#{@count.inspect}**************"
  #logger.debug "***********************#{@yearly.inspect}**************"
    render :pdf=>'historique_pdf'

  end

def historique_csv
  require 'faster_csv'
   @student = Student.find(params[:id])
   @batch_student = BatchStudent.find_all_by_student_id(@student.id)
    c=0
   csv_string = FasterCSV.generate(:col_sep=>';') do | csv |
               csv << []
               csv << [@student.full_name]
               csv << ["", "Semestre", "Classe" , "Notes", "Décision"]
 
           @batch_student.each do |bs| 
          
              batch= Batch.find(:first, :conditions => {:id =>bs.batch_id})
              course= Course.find(:first, :conditions => {:id =>batch.course_id})
              @batchs1 = Batch.find(:all, :conditions => "course_id = #{batch.course_id.to_s} and school_field_id = #{batch.school_field_id.to_s} and (year(start_date)= #{batch.get_batch_year.to_s} or (year(start_date)=#{(batch.get_batch_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != batch.get_batch_year.to_i }
              @batch_ids = ""
             @batchs1.each do |bat|
             sbat = bat.id.to_s
             @batch_ids += sbat + ","
            end

    @batches = @batchs1

    if (@student)
      infos_modules = []
      number_modules = 0
      @batches.each do |batchh|
        @batch_ids += batch.id.to_s + ","
        modules = []
        sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => batchh.school_field_id, :course_id => batchh.course_id, :school_year => batchh.get_batch_year })
        sf_sm.each do |sfssm|
          modules << SchoolModule.find(sfssm.school_module_id)
        end
        modules = modules.uniq
        infos_modules[batchh.id] = {}
        infos_modules[batchh.id]['modules'] = modules

        modules.each do |md|
          sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
          exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(batchh.id, md.id)
          pond = 0
          p = 0
          tsp = 0
          tnsp = 0
          spec_pond = 0
          non_spec_pond = 0

          exams_groups.each do |exg|
            exams = exg.exams
            exams.each do |ex|
              if (ExamScore.find_by_exam_id(ex.id))
                sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{batch.get_batch_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
                if (sfsm.specialite == true)
                  tsp += sme.subject_weighting unless sme.subject_weighting.nil?
                else
                  tnsp += sme.subject_weighting unless sme.subject_weighting.nil?
                end
                p += sme.subject_weighting unless sme.subject_weighting.nil?
              end
            end
          end
          non_spec_pond += tnsp
          spec_pond += tsp
          pond += p
          infos_modules[batchh.id][md.id] = {}
          infos_modules[batchh.id][md.id]['non_spec_pond'] = non_spec_pond
          infos_modules[batchh.id][md.id]['spec_pond'] = spec_pond
          infos_modules[batchh.id][md.id]['pond'] = pond
          infos_modules[batchh.id][md.id]['sfsm'] = sfsm
          number_modules += 1
        end
      end
      infos_modules[0] = {}
      infos_modules[0]['number_modules'] = number_modules
      @yearly_infos = @student.check_student_result_h(@batches, batch.get_batch_year, infos_modules)
     
    end
    if @yearly_infos['average_of_year'] !=-1 && @yearly_infos
    csv << [c+=1, course.section_name, batch.name, sprintf("%.2f", @yearly_infos['average_of_year_session_normale'])  ,  @yearly_infos['decision'] ]
    else
    csv << [c+=1, course.section_name, batch.name, "Pas encore traité" ,  "Pas encore traité"  ]
    end
    end
     
   end       

    send_data Iconv.conv('iso-8859-1//IGNORE', 'utf-8', csv_string),
     :type => 'text/csv; charset=iso-8859-1; header=present',
     :disposition => "attachment; filename=historique_csv.csv"

  logger.debug"******************#{@battch.inspect}****************"
  logger.debug"okuuuuuuuuuuuuuuuuuuuuuuuuuuuuurrrr"
  logger.debug"******************#{@couuurse.inspect}****************"
end
  def importstudent_employee
      @batches = Batch.all

   if request.post?
     uploaded_io = params[:importfile_fichier]
     File.open(Rails.root.join('public', 'uploads','File', uploaded_io.original_filename), 'wb') do |file|
       file.write(uploaded_io.read)
     end
    filename="#{RAILS_ROOT}/public/uploads/File/"+uploaded_io.original_filename
    require 'faster_csv'
   @n=0

   FasterCSV.foreach(filename,  :col_sep =>';', :row_sep =>:auto) do |row|
        @last_admitted_employee = Employee.find(:last)
     c=Employee.new
     #c.admission_no=row[0]
     #Rails.logger.info row[0] + " XXXXXX " + row[1] + " XXXXXXX " + row[2]
     if row[4].to_i != 0
     	 c.employee_number = row[4]
     else
     c.employee_number = @last_admitted_employee.employee_number.next
 end

     c.last_name=row[0]
     c.first_name=row[1]
     c.middle_name=row[3]
     if EmployeeCategory.find_by_name("#{row[5]}")
     	     c.employee_category_id=EmployeeCategory.find_by_name("#{row[5]}").id

     end
     c.save
         Rails.logger.info c.errors.full_messages.to_sentence

     end
     flash[:notice] = "Importation de fichier effectue. Nombre de lignes :"
    end



  end
 def importstudent_good
   @batches = Batch.all
   Rails.logger.info "KOMPL 50"
   if request.post?
     uploaded_io = params[:importfile_fichier]
     File.open(Rails.root.join('public', 'uploads','File', uploaded_io.original_filename), 'wb') do |file|
       file.write(uploaded_io.read)
     end
    filename="#{RAILS_ROOT}/public/uploads/File/"+uploaded_io.original_filename
    require 'faster_csv'
   @n=0
   if(params[:importfile][:batch_id_equals].to_i > 0)

   FasterCSV.foreach(filename,  :col_sep =>';', :row_sep =>:auto) do |row|
        @last_admitted_student = Student.find(:last)
     c=Student.new
     #c.admission_no=row[0]
     #Rails.logger.info row[0] + " XXXXXX " + row[1] + " XXXXXXX " + row[2]
     c.admission_no = @last_admitted_student.admission_no.next
     c.matricule=row[0]
     c.cne=row[3]
     c.last_name=row[4]
     c.nom_ar=row[11]
     c.first_name=row[5]
     c.prenom_ar=row[12]
     c.cin=row[2]
     c.rang_concours=row[43]
    # c.gender=row[15]
     c.address_line1=row[21].to_s + ' province:' + row[24].to_s + ' ' + row[23].to_s
     c.phone1=row[10].to_s
c.city=row[23].to_s
c.birth_place=row[19].to_s + ' province:' + row[20].to_s
c.email=row[9]
c.type_bac=row[33]
c.annee_bac=row[34]
c.mention_bac=row[35]
c.lycee=row[36]
#c.type_ens=row[27]
c.ville_bac=row[37]
     c.batch_id=params[:importfile][:batch_id_equals] #Batch.find(:first, :conditions => ["school_field_id = #{Batch.find(params[:importfile][:batch_id_equals]} and Year(start_date)= #{Time.now.year.to_s} and course_id=1"]).id

     #if !row[3].nil?
     #  c.admission_date=row[3]
     #  else
     #  c.admission_date=Time.now.strftime("%Y-%m-%d")
     #end
    #c.date_of_birth = row[16].to_s.length
     c.admission_date=Time.now.strftime("%Y-%m-%d")
     #c.date_of_birth="1990-01-01"
     #c.gender="m"
     s=Student.find_by_matricule(row[0])
     if !s
       if  c.save
     @guardian1 = Guardian.new(:first_name => row[29], :last_name => row[29], :occupation => row[31], :mobile_phone => row[32], :relation => 'PERE',  :ward_id => c.id)
     @guardian2 = Guardian.new(:first_name => row[25], :last_name => row[25], :occupation => row[35], :mobile_phone => row[36], :relation => 'MERE',  :ward_id => c.id)

     if row[29]
     if @guardian1.save
     c=Student.update(c.id, :immediate_contact_id => @guardian1.id)
     end
     end
     if row[33]
     if @guardian2.save
     if c.immediate_contact_id == nil
     c=Student.update(c.id, :immediate_contact_id => @guardian2.id)
     end
     end
     end
     @n=@n+1
     end
     end
     Rails.logger.info c.errors.full_messages.to_sentence
     flash[:notice] = "Importation de fichier effectue. Nombre de lignes :"+@n.to_s
    end

   end
  end
  end
  def exportstudent
   @batches = Batch.all
   nombatch="export"
   if request.post?
   require 'faster_csv'
   @students = []
   @students += Student.find(:all, :conditions=> "batch_id ="+params[:importfile][:batch_id_equals].to_s)
   bs = BatchStudent.find_all_by_batch_id(params[:importfile][:batch_id_equals])
   bs.each{|r| @students << Student.find(r.student_id) }
   @students  = @students.uniq
#   @students = Student.find(:all, :conditions=> "batch_id ="+params[:search][:batch_id_equals])
   if @students.size.to_i>0
  csv_string = FasterCSV.generate(:col_sep=>';') do | csv |
    csv << []
    csv << [@students[0].batch.name]
   # csv << ["Numé séenciel", "Matricule", "Nom" , "Prenom", "Classe", "Annéscolaire"]
    csv << ["Numero sequenciel", "Matricule", "Nom" , "Prenom", "Classe", "Annee scolaire"]
    @students.each do | me |
     #csv << [me.admission_no,me.matricule,me.last_name,me.first_name]
     annee=me.batch.start_date.strftime("%Y")+"/"+me.batch.end_date.strftime("%Y")
     csv << [me.admission_no,me.matricule,me.last_name,me.first_name,me.batch.name,annee]
     nombatch=me.batch.name
    end
   end
    filename=nombatch
   send_data Iconv.conv('iso-8859-1//IGNORE', 'utf-8', csv_string),
  :type => 'text/csv; charset=iso-8859-1; header=present',
  :disposition => "attachment; filename=#{filename}.csv"

  end
  else

  end
  end

  def bulk_upload_students
       require 'csv'
       if request.post?
             @parsed_file=CSV::Reader.parse(params[:dump][:file])
             n=0
             @parsed_file.each do |row|
             c=Student.new
             c.admission_no=row[0]
             c.batch_id=row[1]
             c.admission_date=row[2]
             c.first_name= row[3]
			 c.date_of_birth=row[4]
			 c.gender=row[5]
             if c.save
                    n=n+1
                    GC.start if n%50==0
             end
             end
             flash[:notice]="CSV Import Successful, #{n} new records added to data base"
       end
  end
  def admission3_1
    @student = Student.find(params[:id])
    @parents = @student.guardians
    if @parents.empty?
      redirect_to :controller => "student", :action => "admission4", :id => @student.id
    end
    return if params[:immediate_contact].nil?
    if request.post?
      sms_setting = SmsSetting.new()
      @student = Student.update(@student.id, :immediate_contact_id => params[:immediate_contact][:contact])
      if sms_setting.application_sms_active and @student.is_sms_enabled
        recipients = []
        message = "#{t('student_admission_done')}   #{@student.admission_no} #{t('password_is')}#{@student.admission_no}123"
        if sms_setting.parent_sms_active
          guardian = Guardian.find(@student.immediate_contact_id)
          recipients.push guardian.mobile_phone unless guardian.mobile_phone.nil?
        end
        unless recipients.empty?
          Delayed::Job.enqueue(SmsManager.new(message,recipients))
        end
      end
      redirect_to :action => "profile", :id => @student.id
    end
  end

  def previous_data
    @student = Student.find(params[:id])
    @previous_data = StudentPreviousData.new params[:student_previous_details]
    @previous_subject = StudentPreviousSubjectMark.find_all_by_student_id(@student)
    if request.post?
      @previous_data.save
      redirect_to :action => "admission4", :id => @student.id
    else
      return
    end
  end

  def previous_data_edit
    @student = Student.find(params[:id])
    @previous_data = StudentPreviousData.find_by_student_id(params[:id])
    @previous_subject = StudentPreviousSubjectMark.find_all_by_student_id(@student)
    if request.post?
      @previous_data.update_attributes(params[:previous_data])
      redirect_to :action => "show_previous_details", :id => @student.id
    end
  end

  def previous_subject
    @student = Student.find(params[:id])
    render(:update) do |page|
      page.replace_html 'subject', :partial=>"previous_subject"
    end
  end

  def save_previous_subject
    @previous_subject = StudentPreviousSubjectMark.new params[:student_previous_subject_details]
    @previous_subject.save
    #@all_previous_subject = StudentPreviousSubjectMark.find(:all,:conditions=>"student_id = #{@previous_subject.student_id}")
  end

  def delete_previous_subject
    @previous_subject = StudentPreviousSubjectMark.find(params[:id])
    @student =Student.find(@previous_subject.student_id)
    if@previous_subject.delete
      @previous_subject=StudentPreviousSubjectMark.find_all_by_student_id(@student.id)
    end
    #@all_previous_subject = StudentPreviousSubjectMark.find(:all,:conditions=>"student_id = #{@previous_subject.student_id}")
  end

  def admission4
    @student = Student.find(params[:id])
    @additional_fields = StudentAdditionalField.find(:all, :conditions=> "status = true")
    if @additional_fields.empty?
      flash[:notice] = "#{t('flash9')} #{@student.first_name} #{@student.last_name}."
      redirect_to :controller => "student", :action => "profile", :id => @student.id
    end
    if request.post?
      params[:student_additional_details].each_pair do |k, v|
        StudentAdditionalDetail.create(:student_id => params[:id],
          :additional_field_id => k,:additional_info => v['additional_info'])
      end
      flash[:notice] = "#{t('flash9')} #{@student.first_name} #{@student.last_name}."
      redirect_to :controller => "student", :action => "profile", :id => @student.id
    end
  end

  def edit_admission4
    @student = Student.find(params[:id])
    @additional_fields = StudentAdditionalField.find(:all, :conditions=> "status = true")
    @additional_details = StudentAdditionalDetail.find_all_by_student_id(@student)

    if @additional_details.empty?
      redirect_to :controller => "student",:action => "admission4" , :id => @student.id
    end
    if request.post?

      params[:student_additional_details].each_pair do |k, v|
        row_id=StudentAdditionalDetail.find_by_student_id_and_additional_field_id(@student.id,k)
        unless row_id.nil?
          additional_detail = StudentAdditionalDetail.find_by_student_id_and_additional_field_id(@student.id,k)
          StudentAdditionalDetail.update(additional_detail.id,:additional_info => v['additional_info'])
        else
          StudentAdditionalDetail.create(:student_id=>@student.id,:additional_field_id=>k,:additional_info=>v['additional_info'])
        end
      end
      flash[:notice] = "#{t('student_text')} #{@student.first_name} #{t('flash2')}"
      redirect_to :action => "profile", :id => @student.id
    end
  end
  def add_additional_details
    @additional_details = StudentAdditionalField.find(:all)
    @additional_field = StudentAdditionalField.new(params[:additional_field])
    if request.post? and @additional_field.save
      flash[:notice] = "#{t('flash1')}"
      redirect_to :controller => "student", :action => "add_additional_details"
    end
  end

  def edit_additional_details
    @additional_details = StudentAdditionalField.find(params[:id])
    if request.post? and @additional_details.update_attributes(params[:additional_details])
      flash[:notice] = "#{t('flash2')}"
      redirect_to :action => "add_additional_details"
    end
  end

  def delete_additional_details
    students = StudentAdditionalDetail.find(:all ,:conditions=>"additional_field_id = #{params[:id]}")
    if students.blank?
      StudentAdditionalField.find(params[:id]).destroy
      @additional_details = StudentAdditionalField.find(:all)
      flash[:notice]="#{t('flash13')}"
      redirect_to :action => "add_additional_details"
    else
      flash[:notice]="#{t('flash14')}"
      redirect_to :action => "add_additional_details"
    end
  end

  def change_to_former
    @dependency = @student.former_dependency
    if request.post?
      @student.archive_student(params[:remove][:status_description])
      render :update do |page|
        page.replace_html 'remove-student', :partial => 'student_tc_generate'
      end
    end
  end

  def generate_tc_pdf
    @student = ArchivedStudent.find_by_admission_no(params[:id])
    @father = ArchivedGuardian.find_by_ward_id(@student.id, :conditions=>"relation = 'father'")
    @mother = ArchivedGuardian.find_by_ward_id(@student.id, :conditions=>"relation = 'mother'")
    @immediate_contact = ArchivedGuardian.find_by_ward_id(@student.immediate_contact_id) \
      unless @student.immediate_contact_id.nil? or @student.immediate_contact_id == ''
    render :pdf=>'generate_tc_pdf'
    #        respond_to do |format|
    #            format.pdf { render :layout => false }
    #        end
  end

  def generate_all_tc_pdf
    @ids = params[:stud]
    @students = @ids.map { |st_id| ArchivedStudent.find(st_id) }

    render :pdf=>'generate_all_tc_pdf'
  end

  def destroy
    student = Student.find(params[:id])
    unless student.check_dependency
      student.destroy
      flash[:notice] = "#{t('flash10')}. #{student.admission_no}."
      redirect_to :controller => 'user', :action => 'dashboard'
    else
      flash[:warn_notice] = "#{t('flash15')}"
      redirect_to  :action => 'remove', :id=>student.id
    end
  end

  def edit
    @student = Student.find(params[:id])
    @student_user = @student.user
    @student_categories = StudentCategory.active
    @batches = Batch.active
    @application_sms_enabled = SmsSetting.find_by_settings_key("ApplicationEnabled")

    if request.post?
      unless params[:student][:image_file].blank?
        unless params[:student][:image_file].size.to_f > 280000
          if @student.update_attributes(params[:student])
            unless @student.changed.include?('admission_no')
              @student_user.update_attributes(:username=> @student.admission_no,:password => "#{@student.admission_no.to_s}123",:first_name=> @student.first_name , :last_name=> @student.last_name, :email=> @student.email, :role=>'Student')
            else
              @student_user.update_attributes(:username=> @student.admission_no,:first_name=> @student.first_name , :last_name=> @student.last_name, :email=> @student.email, :role=>'Student')
            end
            flash[:notice] = "#{t('flash3')}"
            redirect_to :controller => "student", :action => "profile", :id => @student.id
          end
        else
          flash[:notice] = "#{t('flash_msg11')}"
          redirect_to :controller => "student", :action => "edit", :id => @student.id
        end
      else
        if @student.update_attributes(params[:student])
          unless @student.changed.include?('admission_no')
            @student_user.update_attributes(:username=> @student.admission_no,:password => "#{@student.admission_no.to_s}123",:first_name=> @student.first_name , :last_name=> @student.last_name, :email=> @student.email, :role=>'Student')
          else
            @student_user.update_attributes(:username=> @student.admission_no,:first_name=> @student.first_name , :last_name=> @student.last_name, :email=> @student.email, :role=>'Student')
          end
          flash[:notice] = "#{t('flash3')}"
          redirect_to :controller => "student", :action => "profile", :id => @student.id
        end
      end
    end
  end


  def edit_guardian
    @parent = Guardian.find(params[:id])
    @student = Student.find(@parent.ward_id)
    @countries = Country.all
    if request.post? and @parent.update_attributes(params[:parent_detail])
      if @parent.email.blank?
        @parent.email= "noreplyp#{@parent.ward.admission_no}@FEDENA.com"
        @parent.save
      end
      if @parent.id  == @student.immediate_contact_id
        unless @parent.user.nil?
          User.update(@parent.user.id, :first_name=> @parent.first_name, :last_name=> @parent.last_name, :email=> @parent.email, :role =>"Parent")
        else
          @parent.create_guardian_user(@student)
        end
      end
      flash[:notice] = "#{t('student.flash4')}"
      redirect_to :controller => "student", :action => "guardians", :id => @student.id
    end
  end

  def email
    sender = current_user.email
    if request.post?
      recipient_list = []
      case params['email']['recipients']
      when 'Student'
        recipient_list << @student.email
      when 'Guardian'
        recipient_list << @student.immediate_contact.email unless @student.immediate_contact.nil?
      when 'Student & Guardian'
        recipient_list << @student.email
        recipient_list << @student.immediate_contact.email unless @student.immediate_contact.nil?
      end
      FEDENAMailer::deliver_email(sender, recipient_list, params['email']['subject'], params['email']['message'])
      flash[:notice] = "#{t('flash12')} #{recipient_list.join(', ')}"
      redirect_to :controller => 'student', :action => 'profile', :id => @student.id
    end
  end

  def exam_report
    @user = current_user
    @examtype = ExaminationType.find(params[:exam])
    @course = Course.find(params[:course])
    @student = Student.find(params[:student]) if params[:student]
    @student ||= @course.students.first
    @prev_student = @student.previous_student
    @next_student = @student.next_student
    @subjects = @course.subjects_with_exams
    @results = {}
    @subjects.each do |s|
      exam = Examination.find_by_subject_id_and_examination_type_id(s, @examtype)
      res = ExaminationResult.find_by_examination_id_and_student_id(exam, @student)
      @results[s.id.to_s] = { 'subject' => s, 'result' => res } unless res.nil?
    end
    @graph = open_flash_chart_object(770, 350, "/student/graph_for_exam_report?course=#{@course.id}&examtype=#{@examtype.id}&student=#{@student.id}")
  end

  def update_student_result_for_examtype
    @student = Student.find(params[:student])
    @examtype = ExaminationType.find(params[:examtype])
    @course = @student.course
    @prev_student = @student.previous_student
    @next_student = @student.next_student
    @subjects = @course.subjects_with_exams
    @results = {}
    @subjects.each do |s|
      exam = Examination.find_by_subject_id_and_examination_type_id(s, @examtype)
      res = ExaminationResult.find_by_examination_id_and_student_id(exam, @student)
      @results[s.id.to_s] = { 'subject' => s, 'result' => res } unless res.nil?
    end
    @graph = open_flash_chart_object(770, 350, "/exam/graph_for_student_exam_result?course=#{@course.id}&examtype=#{@examtype.id}&student=#{@student.id}")
    render(:update) { |page| page.replace_html 'exam-results', :partial => 'student_result_for_examtype' }
  end

  def previous_years_marks_overview
    @student = Student.find(params[:student])
    @all_courses = @student.all_courses
    @graph = open_flash_chart_object(770, 350, "/student/graph_for_previous_years_marks_overview?student=#{params[:student]}&graphtype=#{params[:graphtype]}")
  end

  def reports
 @current_user = current_user

      @batch = @student.batch

      @school_field_id=@batch.school_field_id unless @student.batch.nil?
          @school_year=@batch.get_batch_year unless @student.batch.nil?
          @old_batches = @student.graduated_batches.reject {|x| x.get_batch_year != @school_year.to_i}
    if(@old_batches.length > 0)
    @course1=@old_batches.first.course.id
    @course2=@student.batch.course.id
    else
    @course2=0
    @course1=@student.batch.course.id unless @student.batch.nil?
    end
   @batchs1=Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i} unless @student.batch.nil?
   @batchs2=Batch.find(:all, :conditions => "course_id = #{@course2.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i} unless @student.batch.nil?
          @sf_sm1 =SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => @course1, :school_year => @school_year, :school_field_id => @school_field_id})
          @sf_sm2 =SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => @course2, :school_year => @school_year, :school_field_id => @school_field_id})
          @batch_ids=""
          @nbre_modules=SchoolModule.nbre_modules(@batchs1,@school_year)+SchoolModule.nbre_modules(@batchs2,@school_year) unless @student.batch.nil?
          if(@student.batch != nil)
          @batchs1.each do |bat|
                        sbat=bat.id.to_s
                                        @batch_ids+=sbat+","
           end
      @batchs2.each do |bat|
                        sbat=bat.id.to_s
                                        @batch_ids+=sbat+","
           end
           @student_orders= YearlyDecision.find_by_sql("SELECT distinct(student_id),avg_year FROM `yearly_decisions` WHERE ( batch_ids like '%"+@batch_ids+"%') ORDER BY avg_year DESC;")
end

           #(:all,:conditions => " batch_ids like '%#{@batch_ids}%'", :order => "avg_year DESC")

        if (params[:student_id])
      @student=Student.find(params[:student_id])
      @yd=YearlyDecision.find(:first, :conditions => " student_id = #{@student.id} and school_year =#{@school_year} and batch_ids like '%#{@batch_ids}%'")
           @exams1=[]
           @exams2=[]
        else
        @students=Student.find_all_by_batch_id(@batchs1[0].id) unless @student.batch.nil?
        @students += @batchs1[0].old_students unless @student.batch.nil?
        @students=@students.uniq{|x| x.id} unless @student.batch.nil?

end

=begin
    @batch = @student.batch
    @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
    @normal_subjects = Subject.find_all_by_batch_id(@batch.id,:conditions=>"no_exams = false AND elective_group_id IS NULL AND is_deleted = false")
    @student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>{:batch_id=>@batch.id})
    @elective_subjects = []
    @student_electives.each do |e|
      @elective_subjects.push Subject.find(e.subject_id)
    end
    @subjects = @normal_subjects+@elective_subjects
    @exam_groups = @batch.exam_groups
    @exam_groups.reject!{|e| e.result_published==false}
    @old_batches = @student.graduated_batches

=end

#       @school_field_id=@student.batch.school_field_id
#     @school_year=@student.batch.get_batch_year
#     @old_batches = @student.graduated_batches.reject {|x| x.get_batch_year != @school_year.to_i}
#     if(@old_batches.length > 0)
#     @course1=@old_batches.first.course.id
#     @course2=@student.batch.course.id
#     else
#     @course2=0
#     @course1=@student.batch.course.id
#     end




#     @batchs1=Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
#     @batchs2=Batch.find(:all, :conditions => "course_id = #{@course2.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
#     @sf_sm1 =SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => @course1, :school_year => @school_year, :school_field_id => @school_field_id})
#     @sf_sm2 =SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => @course2, :school_year => @school_year, :school_field_id => @school_field_id})
#     @batch_ids=""
#     @nbre_modules=SchoolModule.nbre_modules(@batchs1,@school_year)+SchoolModule.nbre_modules(@batchs2,@school_year)
#     @batchs1.each do |bat|
#                   sbat=bat.id.to_s
#           @batch_ids+=sbat+","
#      end
#       @batchs2.each do |bat|
#                   sbat=bat.id.to_s
#           @batch_ids+=sbat+","
#      end
#      @student_orders= YearlyDecision.find(:all,:conditions => " batch_ids like '%#{@batch_ids}%'", :order => "avg_year DESC")
#      @annee_reserve_detail = []
#     @annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id =#{@student.id} and school_year = #{@school_year} " )
#     if(@annee_reserve != nil )
#         @annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve.id}" )

#            end
#   if (params[:student_id])
#       @student=Student.find(params[:student_id])
#       @yd=YearlyDecision.find(:first, :conditions => " student_id = #{@student.id} and school_year =#{@school_year} and batch_ids like '%#{@batch_ids}%'")
#      @exams1=[]
#      @exams2=[]
#   else
#   @students=Student.find_all_by_batch_id(@batchs1[0].id)
#   @students += @batchs1[0].old_students
# =begin
#         bs = BatchStudent.find_all_by_batch_id(@batchs1[0].id)

#                 unless bs.empty?
#                                bs.each do |bst|
#                                      student = Student.find(bst.student_id)
#                                      @students << student unless student.nil?
#                                 end
#                 end
# =end
#               @students=@students.uniq{|x| x.id}

#   end
  end

  def search_ajax
    if params[:option] == "active"
      if params[:query].length>= 3
        @students = Student.find(:all,
          :conditions => ["matricule like ? or first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ?
                            OR admission_no = ? OR (concat(first_name, \" \", last_name) LIKE ? ) ",
            "%#{params[:query]}%","%#{params[:query]}%","%#{params[:query]}%",
            "%#{params[:query]}%", "%#{params[:query]}%","%#{params[:query]}%" ],
          :order => "batch_id asc,first_name asc",:include =>  [{:batch=>:course}]) unless params[:query] == ''
      else
        @students = Student.find(:all,
          :conditions => ["admission_no = ? " , params[:query]],
          :order => "batch_id asc,first_name asc",:include =>  [{:batch=>:course}]) unless params[:query] == ''
      end
      render :layout => false
    elsif(params[:option] == "online")
          if params[:query].length>= 3
        @students = OnlineStudent.find(:all,
          :conditions => ["nom_fr LIKE ? OR prenom_fr LIKE ? OR cin LIKE ?
                            OR num_baccalaureat = ? OR (concat(prenom_fr, \" \", nom_fr) LIKE ? ) ",
            "%#{params[:query]}%","%#{params[:query]}%","%#{params[:query]}%",
            "%#{params[:query]}%", "%#{params[:query]}%" ]) unless params[:query] == ''
      else
        @students = OnlineStudent.find(:all,
          :conditions => ["num_baccalaureat = ? " , params[:query]]) unless params[:query] == ''
      end
      render :partial => "search_ajax_online"
        else
      if params[:query].length>= 3
        @archived_students = ArchivedStudent.find(:all,
          :conditions => ["first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ?
                            OR admission_no = ? OR (concat(first_name, \" \", last_name) LIKE ? ) ",
            "%#{params[:query]}%","%#{params[:query]}%","%#{params[:query]}%",
            "%#{params[:query]}%", "%#{params[:query]}%" ],
          :order => "batch_id asc,first_name asc",:include =>  [{:batch=>:course}]) unless params[:query] == ''
      else
        @archived_students = ArchivedStudent.find(:all,
          :conditions => ["admission_no = ? " , params[:query]],
          :order => "batch_id asc,first_name asc",:include =>  [{:batch=>:course}]) unless params[:query] == ''
      end
      @students = @students.uniq.compact unless @students.nil?
      @archived_students = @archived_students.uniq.compact
      render :partial => "search_ajax"
    end
  end

  def student_annual_overview
    @graph = open_flash_chart_object(770, 350, "/student/graph_for_student_annual_overview?student=#{params[:student]}&year=#{params[:year]}")
  end

  def subject_wise_report
    @student = Student.find(params[:student])
    @subject = Subject.find(params[:subject])
    @examtypes = @subject.examination_types
    @graph = open_flash_chart_object(770, 350, "/student/graph_for_subject_wise_report_for_one_subject?student=#{params[:student]}&subject=#{params[:subject]}")
  end

  def add_guardian
    @parent_info = Guardian.new(params[:parent_detail])
    @countries = Country.all
    if request.post? and @parent_info.save
      flash[:notice] = "#{t('flash5')} #{@parent_info.ward.full_name}"
      redirect_to :controller => "student" , :action => "admission3_1", :id => @parent_info.ward_id
    end
  end

  def list_students_by_course
    @students = Student.find_all_by_batch_id(params[:batch_id], :order => 'last_name ASC')
    render(:update) { |page| page.replace_html 'students', :partial => 'students_by_course' }
  end

   def profile
    @current_user = current_user

    if @student
      @address = "#{@student.address_line1} #{@student.address_line2}"
      @additional_fields = StudentAdditionalField.where(status: true).to_a
      #@sms_module = Rails.configuration.available_modules
      #@sms_setting = SmsSetting.new
      @previous_data = StudentPreviousData.find_by(student_id: @student.id)
      @immediate_contact = Guardian.find_by(id: @student.immediate_contact_id)
    else
      # Handle the case when the student is not found
      # Redirect or show an error message
    end
  end

  def profile_pdf
    @current_user = current_user
    @student = Student.find(params[:id])
    @address = @student.address_line1.to_s + ' ' + @student.address_line2.to_s
    @additional_fields = StudentAdditionalField.all(:conditions=>"status = true")
    @sms_module = Configuration.available_modules
    @sms_setting = SmsSetting.new
    @previous_data = StudentPreviousData.find_by_student_id(@student.id)
    @immediate_contact = Guardian.find(@student.immediate_contact_id) \
      unless @student.immediate_contact_id.nil? or @student.immediate_contact_id == ''

    render :pdf=>'profile_pdf'
  end

  def attestation_scolarite
	@current_user = current_user
    @student = Student.find(params[:id])
	render :pdf => 'attestation'
  end
  def demande_sa
  @current_user = current_user
    @student = Student.find(params[:id])
  render :pdf => 'demande_stage2'
  end
  def demande_pfe
  @current_user = current_user
    @student = Student.find(params[:id])
  render :pdf => 'demande_stage'
  end

  def show_previous_details
    @previous_data = StudentPreviousData.find_by_student_id(@student.id)
    @previous_subjects = StudentPreviousSubjectMark.find_all_by_student_id(@student.id)
  end

def show
  @student = Student.find_by(admission_no: params[:id])
  if @student.present? && @student.photo.attached?
    send_data @student.photo.download, filename: @student.photo.filename.to_s, disposition: :inline
  else
  
  end
end


  def guardians
    @parents = @student.guardians
  end

  def del_guardian
    @guardian = Guardian.find(params[:id])
    @student = @guardian.ward
    if @guardian.is_immediate_contact?
      if @guardian.destroy
        flash[:notice] = "#{t('flash6')}"
        redirect_to :controller => 'student', :action => 'admission3', :id => @student.id
      end
    else
      if @guardian.destroy
        flash[:notice] = "#{t('flash6')}"
        redirect_to :controller => 'student', :action => 'profile', :id => @student.id
      end
    end
  end

  def academic_pdf
    @course = @student.old_courses.find_by_academic_year_id(params[:year]) if params[:year]
    @course ||= @student.course
    @subjects = Subject.find_all_by_course_id(@course, :conditions => "no_exams = false")
    @examtypes = ExaminationType.find( ( @course.examinations.collect { |x| x.examination_type_id } ).uniq )

    @arr_total_wt = {}
    @arr_score_wt = {}

    @subjects.each do |s|
      @arr_total_wt[s.name] = 0
      @arr_score_wt[s.name] = 0
    end

    @course.examinations.each do |x|
      @arr_total_wt[x.subject.name] += x.weightage
      ex_score = ExaminationResult.find_by_examination_id_and_student_id(x.id, @student.id)
      @arr_score_wt[x.subject.name] += ex_score.marks * x.weightage / x.max_marks unless ex_score.nil?
    end

    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

  def categories
    @student_categories = StudentCategory.active
    @student_category = StudentCategory.new(params[:student_category])
    if request.post? and @student_category.save
      flash[:notice] = "#{t('flash7')}"
      redirect_to :action => 'categories'
    end
  end

  def category_delete
    if @student_category = StudentCategory.update(params[:id], :is_deleted=>true)
      @student_category.empty_students
    end
    @student_categories = StudentCategory.active
  end

  def category_edit
    @student_category = StudentCategory.find(params[:id])

  end

  def category_update
    @student_category = StudentCategory.find(params[:id])
    @student_category.update_attribute(:name, params[:name])
    @student_categories = StudentCategory.active
  end

  def view_all
	@school_fields=SchoolField.find(:all, :order =>"name")
=begin
	 elsif(@current_user.employee?)
	 @school_fields=SchoolField.find_by_employee_id(@current_user.employee.id)
	 end
=end
      @courses=Course.find(:all, :order => "code")
    #@batches = Batch.active
  end



  def select_batch
     @school_field_id=params[:school_field_id]
	 @course_id=params[:course_id]
	 @school_year=params[:school_year]
     if(@school_field_id != nil and @school_field_id != '')
     @batches=Batch.find(:all, :conditions => "course_id = #{@course_id} and school_field_id = #{@school_field_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
	else
	 @batches=Batch.find(:all, :conditions => "course_id = #{@course_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
	end
	 render(:update) do |page|
      page.replace_html 'batch_selection', :partial=>'batch_selection'
    end
	end

#********* essalhi *******
  def search_by_date_of_birth
    if params[:date_of_birth]
      
    @students = Student.find_all_by_date_of_birth( params[:date_of_birth])
    
    render(:update) do |page|
      page.replace_html 'information', :partial=>'date_of_birth'
    end
    end
    
  end

 def search_cartes
    if params[:option] == "active"
      if params[:query].length>= 3
        @students = Student.find(:all,
          :conditions => ["matricule like ? or first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ?
                            OR admission_no = ? OR (concat(first_name, \" \", last_name) LIKE ? ) ",
            "%#{params[:query]}%","%#{params[:query]}%","%#{params[:query]}%",
            "%#{params[:query]}%", "%#{params[:query]}%","%#{params[:query]}%" ],
          :order => "batch_id asc,first_name asc",:include =>  [{:batch=>:course}]) unless params[:query] == ''
      else
        @students = Student.find(:all,
          :conditions => ["admission_no = ? " , params[:query]],
          :order => "batch_id asc,first_name asc",:include =>  [{:batch=>:course}]) unless params[:query] == ''
      end
      render :layout => false
    elsif(params[:option] == "online")
          if params[:query].length>= 3
        @students = OnlineStudent.find(:all,
          :conditions => ["nom_fr LIKE ? OR prenom_fr LIKE ? OR cin LIKE ?
                            OR num_baccalaureat = ? OR (concat(prenom_fr, \" \", nom_fr) LIKE ? ) ",
            "%#{params[:query]}%","%#{params[:query]}%","%#{params[:query]}%",
            "%#{params[:query]}%", "%#{params[:query]}%" ]) unless params[:query] == ''
      else
        @students = OnlineStudent.find(:all,
          :conditions => ["num_baccalaureat = ? " , params[:query]]) unless params[:query] == ''
      end
       render :partial => "search_cartes"
        else
      if params[:query].length>= 3
        @archived_students = ArchivedStudent.find(:all,
          :conditions => ["first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ?
                            OR admission_no = ? OR (concat(first_name, \" \", last_name) LIKE ? ) ",
            "%#{params[:query]}%","%#{params[:query]}%","%#{params[:query]}%",
            "%#{params[:query]}%", "%#{params[:query]}%" ],
          :order => "batch_id asc,first_name asc",:include =>  [{:batch=>:course}]) unless params[:query] == ''
      else
        @archived_students = ArchivedStudent.find(:all,
          :conditions => ["admission_no = ? " , params[:query]],
          :order => "batch_id asc,first_name asc",:include =>  [{:batch=>:course}]) unless params[:query] == ''
      end
      @students = @students.uniq.compact unless @students.nil?
      @archived_students = @archived_students.uniq.compact
      render :partial => "search_cartes"
    end
  end

  def view_cartes
  @school_fields=SchoolField.find(:all, :order =>"name")
  logger.debug "LLLLLLLLLLLLLLLLLLLLLLLLLLLL #{ @school_fields.inspect}"
=begin
   elsif(@current_user.employee?)
   @school_fields=SchoolField.find_by_employee_id(@current_user.employee.id)
   end
=end
      @courses=Course.find(:all, :order => "code")
    #@batches = Batch.active
  end



  def select_batch_cartes
     @school_field_id=params[:school_field_id]
   @course_id=params[:course_id]
   @school_year=params[:school_year]
     if(@school_field_id != nil and @school_field_id != '')
     @batches=Batch.find(:all, :conditions => "course_id = #{@course_id} and school_field_id = #{@school_field_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
  else
   @batches=Batch.find(:all, :conditions => "course_id = #{@course_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
  end
   render(:update) do |page|
      page.replace_html 'batch_selection', :partial=>'batch_selection_cartes'
    end
  end

    def batch_selection_cartes
    @archived_students = Student.find_all_by_batch_id(params[:batch_id], :order => 'last_name ASC')
    render(:update) { |page| page.replace_html 'students', :partial => 'search_cartes' }
  end

  def parameter_carte
    
    @info = params[:info]
    @info1 = params[:info1]
    @info2 = params[:info2]
    @info3 = params[:info3]
    @delet1 = StudentCardConfig.find_by_sql("select * from student_card_configs where config_key = 'top' ORDER BY  config_order ASC;")
    @delet2 = StudentCardConfig.find_by_sql("select * from student_card_configs where config_key = 'center' ORDER BY  config_order ASC;")
    @delet3 = StudentCardConfig.find_by_sql("select * from student_card_configs where config_key = 'bottom-left' ORDER BY  config_order ASC;")
    @delet4 = StudentCardConfig.find_by_sql("select * from student_card_configs where config_key = 'bottom-right' ORDER BY  config_order ASC;")
   @hash =Hash.new
   @hash["Prénom"] = "first_name"
   @hash["Nom"] = "last_name"
   @hash["Date de naissance"] = "date_of_birth"
   @hash["Lieu de naissance"] = "birth_place"
   @hash["Code massar"] = "code_massar"
   @hash["Cin"] = "cin"
   @hash["Classe"] = "batch_id"
   @hash["Date d'admission"] = "admission_date"
   @hash["Niveau"] = "batch.course"
   @hash["Code apogée"] = "matricule"
   @hash["Filière"] = "batch.school_field.name"
   @hash["Année universitaire"] = "Année universitaire"
   @hash["Numero d'inscription"] = "admission_no"
   

# x = "batch.school_field.nameI3"
# logger.debug x.split("I")

 @config = StudentCardConfig.all
#info1
if @config 
  a = 0 
  if @info
    @delet2 = StudentCardConfig.find_by_sql("select * from student_card_configs where config_key = 'center' ORDER BY  config_order ASC;")

    @delet2.each do |dl|
      dl.delete
    end
     @info.each do |f|
    # @config.each do |con|
      @hash.each {|key, value|
        if key == f
    # logger.debug "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL#{ Configuration.find_by_config_value("select * from student_card_configs where config_key = 'parameter_carte' and config_value LIKE '2I#{value}I%';").inspect}"
          # if value == con.config_value.split("I")[1]
           StudentCardConfig.create(:config_key => "center" , :config_value => value ,:config_order => a)
           # @delet = Configuration.find_by_config_value("select * from student_card_configs where config_key = 'parameter_carte' and config_value LIKE '2I#{value}I%';")
           #    logger.debug "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK  #{value} #{@delet.inspect} create  #{a}" 
           # end

        end
      }
    # end
    a += 1
    end
        
  end

else

i = 0 
  @info.each do |f|
    # @config.each do |con|
      @hash.each {|key, value|
        if key == f
          # if value == con.config_value.split("I")[1]
           StudentCardConfig.create(:config_key => "center" , :config_value => value ,:config_order => i)
              logger.debug "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK #{value} create  #{i}" 
          # end

        end
      }
    # end
    i += 1
  end


end

#INFO1
if @config 
  a = 0 
  if @info1
    @delet = StudentCardConfig.find_by_sql("select * from student_card_configs where config_key = 'top' ORDER BY  config_order ASC;")

    @delet.each do |dl|
      dl.delete
    end
     @info1.each do |f|
    # @config.each do |con|
      @hash.each {|key, value|
        if key == f
    logger.debug "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL#{ StudentCardConfig.find_by_config_value("select * from student_card_configs where config_key = 'parameter_carte' and config_value LIKE '1I#{value}I%';").inspect}"
          # if value == con.config_value.split("I")[1]
           StudentCardConfig.create(:config_key => "top" , :config_value => value ,:config_order => a)
           # @delet = StudentCardConfig.find_by_config_value("select * from student_card_configs where config_key = 'parameter_carte' and config_value LIKE '2I#{value}I%';")
           #    logger.debug "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK  #{value} #{@delet.inspect} create  #{a}" 
           # end

        end
      }
    # end
    a += 1
    end
        
  end

else

i = 0 
  @info1.each do |f|
    # @config.each do |con|
      @hash.each {|key, value|
        if key == f
          # if value == con.config_value.split("I")[1]
          StudentCardConfig.create(:config_key => "top" , :config_value => value ,:config_order => i)
              logger.debug "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK #{value} create  #{i}" 
          # end

        end
      }
    # end
    i += 1
  end


end


#INFO2
if @config 
  a = 0 
  if @info2
    @delet = StudentCardConfig.find_by_sql("select * from student_card_configs where config_key = 'bottom-left' ORDER BY  config_order ASC;")

    @delet.each do |dl|
      dl.delete
    end
     @info2.each do |f|
    # @config.each do |con|
      @hash.each {|key, value|
        if key == f
    logger.debug "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL#{ StudentCardConfig.find_by_config_value("select * from student_card_configs where config_key = 'bottom-left' and config_value LIKE '3I#{value}I%';").inspect}"
          # if value == con.config_value.split("I")[1]
            StudentCardConfig.create(:config_key => "bottom-left" , :config_value => value ,:config_order => a)
           # @delet = StudentCardConfig.find_by_config_value("select * from student_card_configs where config_key = 'parameter_carte' and config_value LIKE '2I#{value}I%';")
           #    logger.debug "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK  #{value} #{@delet.inspect} create  #{a}" 
           # end

        end
      }
    # end
    a += 1
    end
        
  end

else

i = 0 
  @info2.each do |f|
    # @config.each do |con|
      @hash.each {|key, value|
        if key == f
          # if value == con.config_value.split("I")[1]
           StudentCardConfig.create(:config_key => "bottom-left" , :config_value => value ,:config_order => i)
              logger.debug "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK #{value} create  #{i}" 
          # end

        end
      }
    # end
    i += 1
  end


end




#INFO3
if @config 
  a = 0 
  if @info3
    @delet = StudentCardConfig.find_by_sql("select * from student_card_configs where config_key = 'bottom-right' ORDER BY  config_order ASC;")

    @delet.each do |dl|
      dl.delete
    end
     @info3.each do |f|
    # @config.each do |con|
      @hash.each {|key, value|
        if key == f
    logger.debug "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL#{ StudentCardConfig.find_by_config_value("select * from student_card_configs where config_key = 'bottom-right' and config_value LIKE '4I#{value}I%';").inspect}"
          # if value == con.config_value.split("I")[1]
           StudentCardConfig.create(:config_key => "bottom-right" , :config_value => value ,:config_order => a)
           # @delet = StudentCardConfig.find_by_config_value("select * from student_card_configs where config_key = 'parameter_carte' and config_value LIKE '2I#{value}I%';")
           #    logger.debug "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK  #{value} #{@delet.inspect} create  #{a}" 
           # end

        end
      }
    # end
    a += 1
    end
        
  end

else

i = 0 
  @info3.each do |f|
    # @config.each do |con|
      @hash.each {|key, value|
        if key == f
          # if value == con.config_value.split("I")[1]
           StudentCardConfig.create(:config_key => "bottom-right" , :config_value => value ,:config_order => i)
              logger.debug "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK #{value} create  #{i}" 
          # end

        end
      }
    # end
    i += 1
  end



end





  end




  def advanced_search
    @batches = Batch.all
    @search = Student.search(params[:search])
    if params[:search]
      unless params[:advv_search][:course_id].empty?
        if params[:search][:batch_id_equals].empty?
          batches = Batch.find_all_by_course_id(params[:advv_search][:course_id]).collect{|b|b.id}
        end
      end
      if batches.is_a?(Array)

        @students = []
        batches.each do |b|
          params[:search][:batch_id_equals] = b
          if params[:search][:is_active_equals]=="true"
            @search = Student.search(params[:search])
            @students+=@search.all
          elsif params[:search][:is_active_equals]=="false"
            @search = ArchivedStudent.search(params[:search])
            @students+=@search.all
          else
            @search1 = Student.search(params[:search]).all
            @search2 = ArchivedStudent.search(params[:search]).all
            @students+=@search1+@search2
          end
        end
        params[:search][:batch_id_equals] = nil
      else
        if params[:search][:is_active_equals]=="true"
          @search = Student.search(params[:search])
          @students = @search.all
        elsif params[:search][:is_active_equals]=="false"
          @search = ArchivedStudent.search(params[:search])
          @students = @search.all
        else
          @search1 = Student.search(params[:search]).all
          @search2 = ArchivedStudent.search(params[:search]).all
          @students = @search1+@search2
        end
      end

      @students.each do |student|
        logger.debug student.full_name
      end

      logger.debug @students.count

      @searched_for = ''
      @searched_for += "<span>#{t('name')}: </span>" + params[:search][:first_name_or_middle_name_or_last_name_like].to_s unless params[:search][:first_name_or_middle_name_or_last_name_like].empty?
      @searched_for += " <span>#{t('admission_no')}: </span>" + params[:search][:admission_no_equals].to_s unless params[:search][:admission_no_equals].empty?
      unless params[:advv_search][:course_id].empty?
        course = Course.find(params[:advv_search][:course_id])
        batch = Batch.find(params[:search][:batch_id_equals]) unless (params[:search][:batch_id_equals]).blank?
        @searched_for += "<span>#{t('course_text')}: </span>" + course.full_name
        @searched_for += "<span>#{t('batch')}: </span>" + batch.full_name unless batch.nil?
      end
      @searched_for += "<span>#{t('category')}: </span>" + StudentCategory.find(params[:search][:student_category_id_equals]).name.to_s unless params[:search][:student_category_id_equals].empty?
      unless  params[:search][:gender_equals].empty?
        if  params[:search][:gender_equals] == 'm'
          @searched_for += "<span>#{t('gender')}: </span>#{t('male')}"
        elsif  params[:search][:gender_equals] == 'f'
          @searched_for += " <span>#{t('gender')}: </span>#{t('female')}"
        else
          @searched_for += " <span>#{t('gender')}: </span>#{t('all')}"
        end
      end
      @searched_for += "<span>#{t('blood_group')}: </span>" + params[:search][:blood_group_like].to_s unless params[:search][:blood_group_like].empty?
      @searched_for += "<span>#{t('nationality')}: </span>" + Country.find(params[:search][:nationality_id_equals]).name.to_s unless params[:search][:nationality_id_equals].empty?
      @searched_for += "<span>#{t('year_of_admission')}: </span>" +  params[:advv_search][:doa_option].to_s + ' '+ params[:adv_search][:admission_date_year].to_s unless  params[:advv_search][:doa_option].empty?
      @searched_for += "<span>#{t('year_of_birth')}: </span>" +  params[:advv_search][:dob_option].to_s + ' ' + params[:adv_search][:birth_date_year].to_s unless  params[:advv_search][:dob_option].empty?
      if params[:search][:is_active_equals]=="true"
        @searched_for += "<span>#{t('present_student')}</span>"
      elsif params[:search][:is_active_equals]=="false"
        @searched_for += "<span>#{t('former_student')}</span>"
      else
        @searched_for += "<span>#{t('all_students')}</span>"
      end
    end
  end



  #  def adv_search
  #    @batches = []
  #    @search = Student.search(params[:search])
  #    if params[:search]
  #      if params[:search][:is_active_equals]=="true"
  #        @search = Student.search(params[:search])
  #        @students = @search.all
  #      elsif params[:search][:is_active_equals]=="false"
  #        @search = ArchivedStudent.search(params[:search])
  #        @students = @search.all
  #      else
  #        @search = Student.search(params[:search])
  #        @students = @search.all
  #      end
  #    end
  #  end

  def list_doa_year
    doa_option = params[:doa_option]
    if doa_option == "Equal to"
      render :update do |page|
        page.replace_html 'doa_year', :partial=>"equal_to_select"
      end
    elsif doa_option == "Less than"
      render :update do |page|
        page.replace_html 'doa_year', :partial=>"less_than_select"
      end
    else
      render :update do |page|
        page.replace_html 'doa_year', :partial=>"greater_than_select"
      end
    end
  end

  def doa_equal_to_update
    year = params[:year]
    @start_date = "#{year}-01-01".to_date
    @end_date = "#{year}-12-31".to_date
    render :update do |page|
      page.replace_html 'doa_year_hidden', :partial=>"equal_to_doa_select"
    end
  end

  def doa_less_than_update
    year = params[:year]
    @start_date = "1900-01-01".to_date
    @end_date = "#{year}-01-01".to_date
    render :update do |page|
      page.replace_html 'doa_year_hidden', :partial=>"less_than_doa_select"
    end
  end

  def doa_greater_than_update
    year = params[:year]
    @start_date = "2100-01-01".to_date
    @end_date = "#{year}-12-31".to_date
    render :update do |page|
      page.replace_html 'doa_year_hidden', :partial=>"greater_than_doa_select"
    end
  end

  def list_dob_year
    dob_option = params[:dob_option]
    if dob_option == "Equal to"
      render :update do |page|
        page.replace_html 'dob_year', :partial=>"equal_to_select_dob"
      end
    elsif dob_option == "Less than"
      render :update do |page|
        page.replace_html 'dob_year', :partial=>"less_than_select_dob"
      end
    else
      render :update do |page|
        page.replace_html 'dob_year', :partial=>"greater_than_select_dob"
      end
    end
  end

  def dob_equal_to_update
    year = params[:year]
    @start_date = "#{year}-01-01".to_date
    @end_date = "#{year}-12-31".to_date
    render :update do |page|
      page.replace_html 'dob_year_hidden', :partial=>"equal_to_dob_select"
    end
  end

  def dob_less_than_update
    year = params[:year]
    @start_date = "1900-01-01".to_date
    @end_date = "#{year}-01-01".to_date
    render :update do |page|
      page.replace_html 'dob_year_hidden', :partial=>"less_than_dob_select"
    end
  end

  def dob_greater_than_update
    year = params[:year]
    @start_date = "2100-01-01".to_date
    @end_date = "#{year}-12-31".to_date
    render :update do |page|
      page.replace_html 'dob_year_hidden', :partial=>"greater_than_dob_select"
    end
  end

  def list_batches
    unless params[:course_id] == ''
      @batches = Batch.find(:all, :conditions=>"course_id = #{params[:course_id]}",:order=>"id DESC")
    else
      @batches = []
    end
    render(:update) do |page|
      page.replace_html 'course_batches', :partial=> 'list_batches'
    end
  end

 def list_import_batches
      unless params[:course_id] == ''
      @batches = Batch.find(:all, :conditions=>"course_id = #{params[:course_id]}",:order=>"id DESC")
    else
      @batches = []
    end
    render(:update) do |page|
      page.replace_html 'course_batches', :partial=> 'list_import_batches'
    end

 end



  def advanced_search_pdf
    @searched_for = ''
    @searched_for += "<span>#{t('name')}</span>" + params[:search][:first_name_or_middle_name_or_last_name_like].to_s unless params[:search][:first_name_or_middle_name_or_last_name_like].empty?
    @searched_for += "<span>#{t('admission_no')}</span>" + params[:search][:admission_no_equals].to_s unless params[:search][:admission_no_equals].empty?
    unless params[:advv_search][:course_id].empty?
      course = Course.find(params[:advv_search][:course_id])
      batch = Batch.find(params[:search][:batch_id_equals]) unless (params[:search][:batch_id_equals]).blank?
      @searched_for += "<span>#{t('course_text')}</span>" + course.full_name
      @searched_for += "<span>#{t('batch')}</span>" + batch.full_name unless batch.nil?
    end
    @searched_for += "<span>#{t('category')}</span>" + StudentCategory.find(params[:search][:student_category_id_equals]).name.to_s unless params[:search][:student_category_id_equals].empty?
    unless  params[:search][:gender_equals].empty?
      if  params[:search][:gender_equals] == 'm'
        @searched_for += "<span>#{t('gender')}</span>#{t('male')}"
      elsif  params[:search][:gender_equals] == 'f'
        @searched_for += "<span>#{t('gender')}</span>#{t('female')}"
      else
        @searched_for += "<span>#{t('gender')}</span>#{t('all')}"
      end
    end
    @searched_for += "<span>#{t('blood_group')}</span>" + params[:search][:blood_group_like].to_s unless params[:search][:blood_group_like].empty?
    @searched_for += "<span>#{t('nationality')}</span>" + Country.find(params[:search][:nationality_id_equals]).name.to_s unless params[:search][:nationality_id_equals].empty?
    @searched_for += "<span>#{t('year_of_admission')}:</span>" +  params[:advv_search][:doa_option].to_s + ' '+ params[:adv_search][:admission_date_year].to_s unless  params[:advv_search][:doa_option].empty?
    @searched_for += "<span>#{t('year_of_birth')}:</span>" +  params[:advv_search][:dob_option].to_s + ' ' + params[:adv_search][:birth_date_year].to_s unless  params[:advv_search][:dob_option].empty?
    if params[:search][:is_active_equals]=="true"
      @searched_for += "<span>#{t('present_student')}</span>"
    elsif params[:search][:is_active_equals]=="false"
      @searched_for += "<span>#{t('former_student')}</span>"
    else
      @searched_for += "<span>#{t('all_students')}</span>"
    end

    unless params[:advv_search][:course_id].empty?
      if params[:search][:batch_id_equals].empty?
        batches = Batch.find_all_by_course_id(params[:advv_search][:course_id]).collect{|b|b.id}
      end
    end
    if batches.is_a?(Array)

      @students = []
      batches.each do |b|
        params[:search][:batch_id_equals] = b
        if params[:search][:is_active_equals]=="true"
          @search = Student.search(params[:search])
          @students+=@search.all
        elsif params[:search][:is_active_equals]=="false"
          @search = ArchivedStudent.search(params[:search])
          @students+=@search.all
        else
          @search1 = Student.search(params[:search]).all
          @search2 = ArchivedStudent.search(params[:search]).all
          @students+=@search1+@search2
        end
      end
      params[:search][:batch_id_equals] = nil
    else
      if params[:search][:is_active_equals]=="true"
        @search = Student.search(params[:search])
        @students = @search.all
      elsif params[:search][:is_active_equals]=="false"
        @search = ArchivedStudent.search(params[:search])
        @students = @search.all
      else
        @search1 = Student.search(params[:search]).all
        @search2 = ArchivedStudent.search(params[:search]).all
        @students = @search1+@search2
      end
    end
    render :pdf=>'generate_tc_pdf'

  end

  #  def new_adv
  #    if params[:adv][:option] == "present"
  #      @search = Student.search(params[:search])
  #      @students = @search.all
  #    end
  #  end

  def electives
    @batch = Batch.find(params[:id])
    @elective_subject = Subject.find(params[:id2])
    @students = @batch.students
    @elective_group = ElectiveGroup.find(@elective_subject.elective_group_id)
  end

  def assign_students
    @student = Student.find(params[:id])
    StudentsSubject.create(:student_id=>params[:id],:subject_id=>params[:id2],:batch_id=>@student.batch_id)
    @student = Student.find(params[:id])
    @elective_subject = Subject.find(params[:id2])
    render(:update) do |page|
      page.replace_html "stud_#{params[:id]}", :partial=> 'unassign_students'
      page.replace_html 'flash_box', :text => "<p class='flash-msg'>#{t('flash_msg39')}</p>"
    end
  end

  def assign_all_students
    @batch = Batch.find(params[:id])
    @students = @batch.students
    @students.each do |s|
      @assigned = StudentsSubject.find_by_student_id_and_subject_id(s.id,params[:id2])
      StudentsSubject.create(:student_id=>s.id,:subject_id=>params[:id2],:batch_id=>@batch.id) if @assigned.nil?
    end
    @elective_subject = Subject.find(params[:id2])
    render(:update) do |page|
      page.replace_html 'category-list', :partial=>"all_assign"
      page.replace_html 'flash_box', :text => "<p class='flash-msg'>#{t('flash_msg40')}</p>"
    end
  end

  def unassign_students
    StudentsSubject.find_by_student_id_and_subject_id(params[:id],params[:id2]).delete
    @student = Student.find(params[:id])
    @elective_subject = Subject.find(params[:id2])
    render(:update) do |page|
      page.replace_html "stud_#{params[:id]}", :partial=> 'assign_students'
      page.replace_html 'flash_box', :text => "<p class='flash-msg'>#{t('flash_msg41')}</p>"
    end
  end

  def unassign_all_students
    @batch = Batch.find(params[:id])
    @students = @batch.students
    @students.each do |s|
      @assigned = StudentsSubject.find_by_student_id_and_subject_id(s.id,params[:id2])
      @assigned.delete unless @assigned.nil?
    end
    @elective_subject = Subject.find(params[:id2])
    render(:update) do |page|
      page.replace_html 'category-list', :partial=>"all_assign"
      page.replace_html 'flash_box', :text => "<p class='flash-msg'>#{t('flash_msg42')}</p>"
    end
  end

  def fees
    @dates = FinanceFeeCollection.find_all_by_batch_id(@student.batch ,:joins=>'INNER JOIN finance_fees ON finance_fee_collections.id = finance_fees.fee_collection_id',:conditions=>"finance_fees.student_id = #{@student.id} and finance_fee_collections.is_deleted = 0")
    if request.post?
      @student.update_attributes(:has_paid_fees=>params[:fee][:has_paid_fees]) unless params[:fee].nil?
    end
  end

  def fee_details
    @date  = FinanceFeeCollection.find(params[:id2])
    @financefee = @student.finance_fee_by_date @date
    @fee_collection = FinanceFeeCollection.find(params[:id2])
    @due_date = @fee_collection.due_date

    unless @financefee.transaction_id.blank?
      @paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{@financefee.transaction_id}\")")
    end

    @fee_category = FinanceFeeCategory.find(@fee_collection.fee_category_id,:conditions => ["is_deleted = false"])
    @fee_particulars = @fee_collection.fees_particulars(@student)
    @currency_type = Configuration.find_by_config_key("CurrencyType").config_value

    @batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(@fee_collection.id)
    @student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.id)
    @category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(@fee_collection.id,@student.student_category_id)
    @total_discount = 0
    @total_discount += @batch_discounts.map{|s| s.discount}.sum unless @batch_discounts.nil?
    @total_discount += @student_discounts.map{|s| s.discount}.sum unless @student_discounts.nil?
    @total_discount += @category_discounts.map{|s| s.discount}.sum unless @category_discounts.nil?
    if @total_discount > 100
      @total_discount = 100
    end
  end

  def historique_classe
   @student = Student.find(params[:id])
   @batch_students = BatchStudent.find_all_by_student_id(@student.id)
   tud_histo = []
   @batch_students.each do |hist|
	found = 0
	tud_histo.each do |his2|
		if his2.batch_id == hist.batch_id
		 found = 1
		end
	end
	if found == 0
		tud_histo << hist
	end
   end
   @batch_students = tud_histo

  end


def demande_reinscriptions
    @demande_reinscriptions = RequestReinscription.find_all_by_school_year(Time.now.year)

    @all_status = { 0 => "refusée", 2 => "acceptée" }

end

def set_decision_tran
   @all_status = { "refusée" => 0, "acceptée" => 2 }
    @status = @all_status[params[:decision].to_s]
    @boursetransfert = RequestReinscription.find_by_id(params[:id].to_i)
    @boursetransfert.update_attributes(:status => @status)
    if @status
      render(:update) { |page| page.replace_html "btr_#{@boursetransfert.id}", :text => "#{params[:decision].to_s}" }
    end

end

def demand_reinscription
       @id = params[:id]
@school_year =Time.now.year

 # @student = Student.find(@id)

# @school_year= Student.find(@id).batch.get_batch_year




end


def online_registration_covmedical



    @sit_familial_id = params[:sit_familial_id]
    # logger.debug"UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
# logger.debug @school_year= Student.find(@id).batch.get_batch_year
# logger.debug @sit_familial_id
# logger.debug Time.now.year
# logger.debug AmoStudent.find(@id).student.full_name
# logger.debug"UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"



    @online_student = Student.find(params[:id])
    @id = @online_student.id
   # @sit_familial_id = @online_student.sit_familial_id

#  @student = Student.find(@id)

# @school_year= @student.batch.get_batch_year
@school_year =Time.now.year
   if @sit_familial_id.to_s == ""
    render(:update) do |page|
      page.replace_html 'vide', :text => 'Veuillez choisir le choix'
      page.replace_html 'online_registration_covmedical', :text => ''

    end
   else

    render(:update) do |page|
      page.replace_html 'online_registration_covmedical', :partial => 'online_registration_covmedical'
      page.replace_html 'vide', :text => ''
    end
  end

# end
end


def confermer_inscription
   # @online_student = Student.find(params[:id])
   @amo = params[:student]
   @id = params[:student][:student_id]
   # @school_year = params[:student][:school_year]


  @student = Student.find(@id)
@school_year =Time.now.year
# @school_year= @student.batch.get_batch_year





  # logger.debug"UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
  #     logger.debug @school_year
  #     logger.debug @id
  #     logger.debug @situation

  #     logger.debug"UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
  if AmoStudent.find_by_student_id_and_school_year(@id, @school_year)
    @amostudent = AmoStudent.find_by_school_year(@school_year)
    @amostudent.update_attributes(params[:student])
  else
    AmoStudent.create(params[:student])
    RequestReinscription.create(:student_id => @id , :status=>false, :school_year =>@school_year)

   end
 redirect_to :back
end


def cnie_parent
    if params[:cnie_pere]
      render(:update) do |page|
        @type = 1
        if params[:cnie_pere].to_s == "O"
          page.replace_html 'pere_cnie', :partial=>"cnie_parent"
        else
          page.replace_html 'pere_cnie', :partial=>"info_parent"

        end
        end
    else
        @type = 2
      render(:update) do |page|
        if params[:cnie_mere].to_s == "O"
          page.replace_html 'mere_cnie', :partial=>"cnie_parent"
        else
          page.replace_html 'mere_cnie', :partial=>"info_parent"

        end        end
    end
  end


   def die_parent
  if params[:die_father]
    render(:update) do |page|
      @type = 1
      if params[:die_father].to_s == "O"
        page.replace_html 'die_father', :partial=>"die_parent"
      else
        page.replace_html 'die_father', :text=>""

      end
      end
  else
      @type = 2
    render(:update) do |page|
      if params[:die_mother].to_s == "O"
        page.replace_html 'die_mother', :partial=>"die_parent"
      else
        page.replace_html 'die_mother', :text=>""

      end        end
  end
end


def cov_medical_exist
    if params[:cov_medi]
      render(:update) do |page|
        @type = 1
        if params[:cov_medi].to_s == "O"
          page.replace_html 'cov_medi', :partial=>"cov_medi"
        else
          page.replace_html 'cov_medi', :text=>""

        end
        end
      end
    end
    def bank_exist
      if params[:bank]
        render(:update) do |page|
          @type = 1
          if params[:bank].to_s == "O"
            page.replace_html 'bank', :partial=>"bank"
          else
            page.replace_html 'bank', :text=>""

          end
          end
        end
      end





  def ajax_destroy

	logger.info '***************supp batch class************'
	 batch_student = BatchStudent.find(:first, :conditions => {:student_id => params[:student_id] , :batch_id =>params[:batch_id]})
	 batch_student.destroy

	 redirect_to :controller => "student", :action => "historique_classe", :id => params[:student_id]
    end




  #  # Graphs
  #
  #  def graph_for_previous_years_marks_overview
  #    student = Student.find(params[:student])
  #
  #    x_labels = []
  #    data = []
  #
  #    student.all_courses.each do |c|
  #      x_labels << c.name
  #      data << student.annual_weighted_marks(c.academic_year_id)
  #    end
  #
  #    if params[:graphtype] == 'Line'
  #      line = Line.new
  #    else
  #      line = BarFilled.new
  #    end
  #
  #    line.width = 1; line.colour = '#5E4725'; line.dot_size = 5; line.values = data
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #
  #    y_axis = YAxis.new
  #    y_axis.set_range(0,100,20)
  #
  #    title = Title.new(student.full_name)
  #
  #    x_legend = XLegend.new("Academic year")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Total marks")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #    chart.set_title(title)
  #    chart.y_axis = y_axis
  #    chart.x_axis = x_axis
  #
  #    chart.add_element(line)
  #
  #    render :text => chart.to_s
  #  end
  #
  #  def graph_for_student_annual_overview
  #    student = Student.find(params[:student])
  #    course = Course.find_by_academic_year_id(params[:year]) if params[:year]
  #    course ||= student.course
  #    subs = course.subjects
  #    exams = Examination.find_all_by_subject_id(subs, :select => "DISTINCT examination_type_id")
  #    etype_ids = exams.collect { |x| x.examination_type_id }
  #    examtypes = ExaminationType.find(etype_ids)
  #
  #    x_labels = []
  #    data = []
  #
  #    examtypes.each do |et|
  #      x_labels << et.name
  #      data << student.examtype_average_marks(et, course)
  #    end
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #
  #    line = BarFilled.new
  #
  #    line.width = 1
  #    line.colour = '#5E4725'
  #    line.dot_size = 5
  #    line.values = data
  #
  #    y = YAxis.new
  #    y.set_range(0,100,20)
  #
  #    title = Title.new('Title')
  #
  #    x_legend = XLegend.new("Examination name")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Average marks")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #    chart.set_title(title)
  #    chart.set_x_legend(x_legend)
  #    chart.set_y_legend(y_legend)
  #    chart.y_axis = y
  #    chart.x_axis = x_axis
  #
  #    chart.add_element(line)
  #
  #    render :text => chart.to_s
  #  end
  #
  #  def graph_for_subject_wise_report_for_one_subject
  #    student = Student.find params[:student]
  #    subject = Subject.find params[:subject]
  #    exams = Examination.find_all_by_subject_id(subject.id, :order => 'date asc')
  #
  #    data = []
  #    x_labels = []
  #
  #    exams.each do |e|
  #      exam_result = ExaminationResult.find_by_examination_id_and_student_id(e, student.id)
  #      unless exam_result.nil?
  #        data << exam_result.percentage_marks
  #        x_labels << XAxisLabel.new(exam_result.examination.examination_type.name, '#000000', 10, 0)
  #      end
  #    end
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #
  #    line = BarFilled.new
  #
  #    line.width = 1
  #    line.colour = '#5E4725'
  #    line.dot_size = 5
  #    line.values = data
  #
  #    y = YAxis.new
  #    y.set_range(0,100,20)
  #
  #    title = Title.new(subject.name)
  #
  #    x_legend = XLegend.new("Examination name")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Marks")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #    chart.set_title(title)
  #    chart.set_x_legend(x_legend)
  #    chart.set_y_legend(y_legend)
  #    chart.y_axis = y
  #    chart.x_axis = x_axis
  #
  #    chart.add_element(line)
  #
  #    render :text => chart.to_s
  #  end
  #
  #  def graph_for_exam_report
  #    student = Student.find(params[:student])
  #    examtype = ExaminationType.find(params[:examtype])
  #    course = student.course
  #    subjects = course.subjects_with_exams
  #
  #    x_labels = []
  #    data = []
  #    data2 = []
  #
  #    subjects.each do |s|
  #      exam = Examination.find_by_subject_id_and_examination_type_id(s, examtype)
  #      res = ExaminationResult.find_by_examination_id_and_student_id(exam, student)
  #      unless res.nil?
  #        x_labels << s.name
  #        data << res.percentage_marks
  #        data2 << exam.average_marks * 100 / exam.max_marks
  #      end
  #    end
  #
  #    bargraph = BarFilled.new()
  #    bargraph.width = 1;
  #    bargraph.colour = '#bb0000';
  #    bargraph.dot_size = 5;
  #    bargraph.text = "Student's marks"
  #    bargraph.values = data
  #
  #    bargraph2 = BarFilled.new
  #    bargraph2.width = 1;
  #    bargraph2.colour = '#5E4725';
  #    bargraph2.dot_size = 5;
  #    bargraph2.text = "Class average"
  #    bargraph2.values = data2
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #
  #    y_axis = YAxis.new
  #    y_axis.set_range(0,100,20)
  #
  #    title = Title.new(student.full_name)
  #
  #    x_legend = XLegend.new("Academic year")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Total marks")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #    chart.set_title(title)
  #    chart.y_axis = y_axis
  #    chart.x_axis = x_axis
  #    chart.y_legend = y_legend
  #    chart.x_legend = x_legend
  #
  #    chart.add_element(bargraph)
  #    chart.add_element(bargraph2)
  #
  #    render :text => chart.render
  #  end
  #
  #  def graph_for_academic_report
  #    student = Student.find(params[:student])
  #    course = student.course
  #    examtypes = ExaminationType.find( ( course.examinations.collect { |x| x.examination_type_id } ).uniq )
  #    x_labels = []
  #    data = []
  #    data2 = []
  #
  #    examtypes.each do |e_type|
  #      total = 0
  #      max_total = 0
  #      exam = Examination.find_all_by_examination_type_id(e_type.id)
  #      exam.each do |t|
  #        res = ExaminationResult.find_by_examination_id_and_student_id(t.id, student.id)
  #        total += res.marks
  #        max_total += res.maximum_marks
  #      end
  #      class_max =0
  #      class_total = 0
  #      exam.each do |t|
  #        res = ExaminationResult.find_all_by_examination_id(t.id)
  #        res.each do |res|
  #          class_max += res.maximum_marks
  #          class_total += res.marks
  #        end
  #      end
  #      class_avg = (class_total*100/class_max).to_f
  #      percentage = ((total*100)/max_total).to_f
  #      x_labels << e_type.name
  #      data << percentage
  #      data2 << class_avg
  #    end
  #
  #    bargraph = BarFilled.new()
  #    bargraph.width = 1;
  #    bargraph.colour = '#bb0000';
  #    bargraph.dot_size = 5;
  #    bargraph.text = "Student's average"
  #    bargraph.values = data
  #
  #    bargraph2 = BarFilled.new
  #    bargraph2.width = 1;
  #    bargraph2.colour = '#5E4725';
  #    bargraph2.dot_size = 5;
  #    bargraph2.text = "Class average"
  #    bargraph2.values = data2
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #    y_axis = YAxis.new
  #    y_axis.set_range(0,100,20)
  #
  #    x_legend = XLegend.new("Examinations")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Percentage")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #
  #    chart.y_axis = y_axis
  #    chart.x_axis = x_axis
  #    chart.y_legend = y_legend
  #    chart.x_legend = x_legend
  #
  #    chart.add_element(bargraph)
  #    chart.add_element(bargraph2)
  #
  #    render :text => chart.render
  #  end
  #
  #  def graph_for_annual_academic_report
  #    student = Student.find(params[:student])
  #    student_all = Student.find_all_by_course_id(params[:course])
  #    total = 0
  #    sum = student_all.size
  #    student_all.each { |s| total += s.annual_weighted_marks(s.course.academic_year_id) }
  #    t = (total/sum).to_f
  #
  #    x_labels = []
  #    data = []
  #    data2 = []
  #
  #    x_labels << "Annual report".to_s
  #    data << student.annual_weighted_marks(student.course.academic_year_id)
  #    data2 << t
  #
  #    bargraph = BarFilled.new()
  #    bargraph.width = 1;
  #    bargraph.colour = '#bb0000';
  #    bargraph.dot_size = 5;
  #    bargraph.text = "Student's average"
  #    bargraph.values = data
  #
  #    bargraph2 = BarFilled.new
  #    bargraph2.width = 1;
  #    bargraph2.colour = '#5E4725';
  #    bargraph2.dot_size = 5;
  #    bargraph2.text = "Class average"
  #    bargraph2.values = data2
  #
  #    x_axis = XAxis.new
  #    x_axis.labels = x_labels
  #
  #    y_axis = YAxis.new
  #    y_axis.set_range(0,100,20)
  #
  #    x_legend = XLegend.new("Examinations")
  #    x_legend.set_style('{font-size: 14px; color: #778877}')
  #
  #    y_legend = YLegend.new("Weightage")
  #    y_legend.set_style('{font-size: 14px; color: #770077}')
  #
  #    chart = OpenFlashChart.new
  #
  #    chart.y_axis = y_axis
  #    chart.x_axis = x_axis
  #    chart.y_legend = y_legend
  #    chart.x_legend = x_legend
  #
  #    chart.add_element(bargraph)
  #    chart.add_element(bargraph2)
  #
  #    render :text => chart.render
  #
  #  end


  private
  def find_student
    
    @student = Student.find params[:id]

  end
def student_params
  params.require(:student).permit(:admission_no, :admission_date, :matricule, :first_name, :middle_name, :last_name, :batch_id, :date_of_birth, :gender, :blood_group, :birth_place, :nationality_id, :language, :student_category_id, :religion, :address_line1, :address_line2, :city, :state, :pin_code, :country_id, :phone1, :phone2, :email, :is_sms_enabled)
end

end
