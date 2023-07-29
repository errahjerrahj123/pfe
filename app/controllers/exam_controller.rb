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

class ExamController < ApplicationController
  before_filter :login_required
  before_filter :protect_other_student_data
  before_filter :restrict_employees_from_exam
  filter_access_to :all

  def index
  end
def export_marks_txt

@exam = Exam.find(params[:exam_id])
@exam_scores = @exam.exam_scores
batch = @exam.exam_group.batch
@school_year = batch.get_batch_year
cod_dip = batch.school_field.code
sf = batch.school_field
csv = "XX-APO_TITRES-XX"
csv += "\n"
csv += "apoC_annee  #{@school_year}/#{@school_year.to_i + 1} \n"
csv += "apoC_cod_dip	#{cod_dip} \n"
csv += "apoC_Cod_Exp	1 \n"
csv += 'apoC_Fichier_Exp	C:\Users\ump\Desktop\STUSTU-S3-Tectonique analytique.TXT \n'
csv += "apoC_lib_dip	#{sf.LIB_DIP} \n"
csv += "apoC_Titre1	Export Apogée du #{Time.now.to_date.strftime("%d/%m/%Y")} à #{Time.now.strftime("%H:%M")} \n"
csv += "apoC_Titre2	#{@exam.subject.name} - Epreuve  \n"
csv += "\n"
csv += "XX-APO_TYP_RES-XX"
csv += "\n"
csv += "15	ABI	ABJ	ACR	ACRT	ADM	ADMI	AJ	DEF	FS	NV	PAR	V	VAR	VAS	VT  \n"
csv += "17	ABI	ABJ	AC	ACR	ACRT	ADM	ADMI	AJ	AJAC	DEF	FS	NV	PAR	V	VAR	VAS	VT  \n"
csv += "18	ABI	ABJ	AC	ACR	ACRT	ADM	ADMI	AJ	DEF	FS	NCR	NV	PAR	RAT	V	VAR	VAS	VT \n"
csv += "7	ABI	ABJ	DEF	DIS	FS	VAS	VT \n"
csv += "ABI : Absence injustifiée	ABJ : Absence justifiée	ACR : Compensation Après Rattrapage	ACRT : Admis par compensation par transfert	ADM : Admis	ADMI : Admissible	AJ : Ajourné	DEF : Défaillant	FS : Fin de Scolarité	NV : Non Validé	PAR : Passage avec rattrapage	V : Validé	VAR : Validé après rattrapage	VAS : Validé sur l'ancien système	VT : Validé par Transfert  \n"
csv += "ABI : Absence injustifiée	ABJ : Absence justifiée	AC : Acquis Par Compensation	ACR : Compensation Après Rattrapage	ACRT : Admis par compensation par transfert	ADM : Admis	ADMI : Admissible	AJ : Ajourné	AJAC : Ajourné mais accès autorisé à étape sup.	DEF : Défaillant	FS : Fin de Scolarité	NV : Non Validé	PAR : Passage avec rattrapage	V : Validé	VAR : Validé après rattrapage	VAS : Validé sur l'ancien système	VT : Validé par Transfert \n"
csv += "ABI : Absence injustifiée	ABJ : Absence justifiée	AC : Acquis Par Compensation	ACR : Compensation Après Rattrapage	ACRT : Admis par compensation par transfert	ADM : Admis	ADMI : Admissible	AJ : Ajourné	DEF : Défaillant	FS : Fin de Scolarité	NCR : Non Convoqué au Rattrappage	NV : Non Validé	PAR : Passage avec rattrapage	RAT : Rattrapage	V : Validé	VAR : Validé après rattrapage	VAS : Validé sur l'ancien système	VT : Validé par Transfert  \n"
csv += "ABI : Absence injustifiée	ABJ : Absence justifiée	DEF : Défaillant	DIS : Dispense examen	FS : Fin de Scolarité	VAS : Validé sur l'ancien système	VT : Validé par Transfert  \n"
csv += "\n"
csv += "XX-APO_COLONNES-XX"
csv += "\n"
csv += "apoL_a01_code	Type Objet	Code	Version	Année	Session	Admission/Admissibilité	Type Rés.			Etudiant	Numéro \n"
csv += "apoL_a02_nom											Nom  \n"
csv += "apoL_a03_prenom											Prénom  \n"
csv += "apoL_a04_naissance									Session	Admissibilité	Naissance  \n"
csv += "APO_COL_VAL_DEB"
csv += "\n"
csv += "apoL_c0001	EPR	SFU23104EF		2021	2	1	N	SFU23104EF - Epr-TectAn	2	1	Note"
csv += "\n"
csv += "apoL_c0002	EPR	SFU23104EF		2021	2	1	B		2	1	Barème"
csv += "\n"
csv += "APO_COL_VAL_FIN"
csv += "\n"
csv += "apoL_c0003	APO_COL_VAL_FIN"
csv += "\n"
csv += "XX-APO_VALEURS-XX"
csv += "\n"
csv += "apoL_a01_code\tapoL_a02_nom\tapoL_a03_prenom\tapoL_a04_naissance\tapoL_c0001\tapoL_c0002 \n"
@exam_scores.each do |exam_score|
  student = Student.find(exam_score.student_id)
  csv += "#{student.matricule}\t#{student.last_name}\t#{student.first_name}\t#{student.date_of_birth.strftime("%d/%m/%Y").to_s}\t#{exam_score.marks.to_i}  \n"
end

send_data csv, :filename => "#{@exam.subject.name}.txt"
end
def all_modules_csv

    nombatch="export"
    require 'faster_csv'

      @type=params[:type]
      if(params[:type])
          @courses=Course.find(:all)
                @course_groups=@courses.group_by{|course| course.course_name}
                @group=[]
                @course_groups.each do |key,value|
                           chaine=""
               @course_groups[key].each do |course|
               chaine+=course.id.to_s+','
               end
               chaine+='0'
               @group << [key,chaine]
                end
              if(params[:type]=="Annuelle")
                        render(:update) do |page|
                                         page.replace_html 'type_div', :partial => 'annuelle'
                            end
              else
                        render(:update) do |page|
                                         page.replace_html 'type_div', :partial => 'semestrielle'
                  end

              end

    else
      if params[:school_field_id]
      @school_field_id=params[:school_field_id]
    else
      @school_field_id = " "
    end
           if params[:school_year]
        @school_year=params[:school_year].to_i
    else
         @month = Time.now.month
      @year = Time.now.year
 if(1 < @month.to_i || @month.to_i < 8)
    @school_year=@year.to_i - 1
  else
        @school_year=@year.to_i

  end
    end

    @course_ids=""
    @cids="1,2,3,4,5,6,7,8,9"
    @courses=(@cids.gsub('%2C',',')).split(",")
    @courses.each do |c|
    @course_ids+=c+'+'
    end
    @courses=@courses.reject{|c| c.to_i == 0}
    @course1=@courses[0]
    if(@courses[1])
    @course2=@courses[1]
    else
    @course2=-1.to_s
    end
    @batches=[]
    @sf_sm=[]


             @exam_groups=[]
           @students=[]
           batch_string=""
           @batch_ids=""
           ct = 0
           if params[:school_field_id]
             @batches =Batch.find_all_by_school_field_id(params[:school_field_id]).select{|b| b.get_batch_year.to_i == @school_year}

           else
           SchoolField.all.each do |f|
             ct = ct +1
             #if(  ct <= 2)
           @batches +=Batch.find_all_by_school_field_id(f.id).select{|b| b.get_batch_year.to_i == @school_year}
         #end
         end
       end
    @batches.each do |batch|
                      @students += Student.find_all_by_batch_id(batch.id) unless !Student.find_all_by_batch_id(batch.id)
                        @students += batch.old_students
              batch_string+=batch.id.to_s+','
              @batch_ids+=batch.id.to_s+","
    end


    @resultats=[]
    @valide_student_by_system=[]

    csv_string = FasterCSV.generate(:col_sep=>';',:encoding => 'U',:headers=>true) do | csv |
      csv << []

        all_sm_names = ""


          titres=[ "Filiére","Option", "Semestre" , "code module","responsale module","module","élément de module ","coefficient element module","volume horaire element","Professeur","État saisi notes Avant rattrapage","État notes  rattrapage","Situation de la saisi des notes","Date de derniere saisi"]
          logger.debug "hola hola"
          #csv << ["Numero sequenciel", "Matricule", "Nom" , "Prenom", "Classe", "Annee scolaire",all_sm_names]

          csv << titres

    @students=@students.uniq{|x| x.id}
    count = true
    @batches.each  do |bat|
#if bat.course_id == 1 || bat.course_id == 3 || bat.course_id == 5
  #csv << ([bat.name] << ' '  )

      #count = count + 1
      if count
      students = []
        @students = bat.old_students
      if bat.old_students.count == 0
                            @students = bat.students
       end
 if bat.students.count == 0
                            @students = bat.old_students
       end
                           @sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => bat.course.id.to_s, :school_year => @school_year, :school_field_id => bat.school_field_id})


   @sf_sm = @sf_sm.sort_by { |sf| sf.id }
   i = 0
   nm =[]
 if bat.course_id.to_i == 132 ||  bat.course_id.to_i == 134 ||  bat.course_id.to_i == 136
  i = 8
@sf_sm.each do |sf, index|
     #nm[i] = SchoolModule.find(sf.school_module_id).name
     i = i+1
     code = "M"+i.to_s
     em = SchoolModule.find(sf.school_module_id).employee_id
     if em.to_i != 92
      if SchoolModule.find(sf.school_module_id).employee_id
     employee = Employee.find(SchoolModule.find(sf.school_module_id).employee_id).first_name.to_s + " " + Employee.find(SchoolModule.find(sf.school_module_id).employee_id).last_name.to_s
end
else
  employee= ""
end
                  @exams=SchoolModule.find(sf.school_module_id).get_subjects_infos(bat.id)
                  elements = ""
                  employees = ""
                                    coefs = ""
                                    hours = ""

                  count_examscores = 0
                                    count_examscores2 = 0
                                                                        count_examscores3 = 0

@exam_scores = []
                  @exams.each do |e|
                       count_examscores = ExamScore.find_all_by_exam_id(e.id).count
                       count_examscores22 = ExamScore.find_all_by_exam_id(e.id).select{|s| s.marks ? s.marks < 12 : s.marks == nil}
count_examscores21 = []
count_examscores22.each do |exam_score|
moyenne_module_ar=SchoolModule.find(ExamGroup.find(e.exam_group_id).module_id).marks_infos(bat.id,exam_score.student_id,bat.start_date.year)["average"]

       if ((exam_score.marks.to_f<6 or (exam_score.marks.to_f<12 and moyenne_module_ar.to_f<12)) and exam_score.remarks != 'DISP')
count_examscores21 << exam_score
end
end
count_examscores2 =  count_examscores21.count
                  count_examscores3 =  count_examscores21.select{|s| s.marks_ar != nil }.count
   @exam_scores = ExamScore.find_all_by_exam_id(e.id).sort_by { |s| s.updated_at }
  coefs += "#{e.weightage}%-"

hours += "#{Subject.find(e.subject_id).subject_group.credit_hours}-"

elements +="#{Subject.find(e.subject_id).name}-"
employees = " "
Subject.find(e.subject_id).employees.each do |e1|
employees +="#{e1.full_name}-"
end
 @students = []
                  if bat.students.count > 0
  @students = bat.students
end
if bat.old_students.count > 0
  @students = bat.old_students
end
nb_element =  @students.count
pourcenatage_note_saisie = ((count_examscores.to_f / nb_element)*100)
if count_examscores3 == 0 || count_examscores2 == 0
pourcenatage_note_saisie_ap_ratt = 0
else
  pourcenatage_note_saisie_ap_ratt = ((count_examscores3.to_f / count_examscores2)* 100).to_i

  end
pourcenatage_note_saisie_ap_ratt = "#{pourcenatage_note_saisie_ap_ratt}%"
pourcenatage_note_saisie = "#{pourcenatage_note_saisie}%"


if SchoolField.find(bat.school_field_id).field_root
 sf1 = SchoolField.find(SchoolField.find(bat.school_field_id).field_root).name
 sf2 = SchoolField.find(bat.school_field_id).name
else
 sf1 = SchoolField.find(bat.school_field_id).name
 sf2 = SchoolField.find(bat.school_field_id).name
end
if @exam_scores.last


         csv << [sf1,sf2,Course.find_by_id(bat.course_id).section_name,code,employee,SchoolModule.find(sf.school_module_id).name,Subject.find(e.subject_id).name,e.weightage,Subject.find(e.subject_id).subject_group.credit_hours,employees,pourcenatage_note_saisie,pourcenatage_note_saisie_ap_ratt,"",@exam_scores.last.updated_at ]
else
           csv << [sf1,sf2,Course.find_by_id(bat.course_id).section_name,code,employee,SchoolModule.find(sf.school_module_id).name,Subject.find(e.subject_id).name,e.weightage,Subject.find(e.subject_id).subject_group.credit_hours,employees,pourcenatage_note_saisie,pourcenatage_note_saisie_ap_ratt,"","--" ]

end
                  end
                  @students = []
                  if bat.students.count > 0
  @students = bat.students
end
if bat.old_students.count > 0
  @students = bat.old_students
end
nb_element =  @exams.count * @students.count
if nb_element.to_i == 0
  pourcenatage_note_saisie= 0
else
pourcenatage_note_saisie = ((count_examscores.to_f / nb_element.to_f)*100)
end
if count_examscores3 == 0 || count_examscores2 == 0
pourcenatage_note_saisie_ap_ratt = 0
else
  pourcenatage_note_saisie_ap_ratt = ((count_examscores3.to_f / count_examscores2)* 100).to_i

  end
pourcenatage_note_saisie_ap_ratt = "#{pourcenatage_note_saisie_ap_ratt}%"
 if pourcenatage_note_saisie.to_i > 100
pourcenatage_note_saisie = "100%"
else
  pourcenatage_note_saisie = "#{pourcenatage_note_saisie.to_i}%"

  end
if @exam_scores.last
     # csv << [SchoolField.find(bat.school_field_id).name,"",Course.find_by_id(bat.course_id).section_name,code,employee,SchoolModule.find(sf.school_module_id).name,elements,coefs,hours,employees,pourcenatage_note_saisie,pourcenatage_note_saisie_ap_ratt,"",@exam_scores.last.updated_at ]
    else
           #csv << [SchoolField.find(bat.school_field_id).name,"",Course.find_by_id(bat.course_id).section_name,code,employee,SchoolModule.find(sf.school_module_id).name,elements,coefs,hours,employees,pourcenatage_note_saisie,pourcenatage_note_saisie_ap_ratt,"","--" ]

    end

 end
else
    @sf_sm.each do |sf, index|
     #nm[i] = SchoolModule.find(sf.school_module_id).name
     i = i+1
     code = "M"+i.to_s
     employee = ""
     if SchoolModule.find(sf.school_module_id).employee_id.to_i !=  184

if SchoolModule.find(sf.school_module_id).employee_id
     employee = Employee.find(SchoolModule.find(sf.school_module_id).employee_id).first_name.to_s + " " + Employee.find(SchoolModule.find(sf.school_module_id).employee_id).last_name.to_s
end
end
                  @exams=SchoolModule.find(sf.school_module_id).get_subjects_infos(bat.id)
                  elements = ""
                  employees = ""
                  coefs = ""
                                    hours = ""

                  count_examscores = 0
                                    count_examscores2 = 0
                                                                        count_examscores3 = 0

@exam_scores = []
                  @exams.each do |e|

                    count_examscores = ExamScore.find_all_by_exam_id(e.id).count
                                        count_examscores22 = ExamScore.find_all_by_exam_id(e.id).select{|s| s.marks ? s.marks < 12 : s.marks == nil}
 count_examscores21 = []
 count_examscores22.each do |exam_score|
    moyenne_module_ar=SchoolModule.find(ExamGroup.find(e.exam_group_id).module_id).marks_infos(bat.id,exam_score.student_id,bat.start_date.year)["average"]

                        if ((exam_score.marks.to_f<6 or (exam_score.marks.to_f<12 and moyenne_module_ar.to_f<12)) and exam_score.remarks != 'DISP')
 count_examscores21 << exam_score
end
end
count_examscores2 =  count_examscores21.count

                  count_examscores3 =  count_examscores21.select{|s| s.marks_ar != nil }.count

   @exam_scores = ExamScore.find_all_by_exam_id(e.id).sort_by { |s| s.updated_at }

coefs += "#{e.weightage}%-"
hours += "#{Subject.find(e.subject_id).subject_group.credit_hours}-"
logger.debug "******************************************************"
logger.debug coefs
logger.debug Subject.find(e.subject_id).subject_group_id
elements +="#{Subject.find(e.subject_id).name}-"
employees = " "
Subject.find(e.subject_id).employees.each do |e1|
employees +="#{e1.full_name}-"
end
if bat.students.count > 0
  @students = bat.students
end
if bat.old_students.count > 0
  @students = bat.old_students
end
nb_element =  @students.count
if count_examscores.to_f && nb_element
  if nb_element.to_i == 0
    pourcenatage_note_saisie= 0
  else
pourcenatage_note_saisie = ((count_examscores.to_f / nb_element)*100)
end
else
  pourcenatage_note_saisie = 0
end
if count_examscores3 == 0 || count_examscores2 == 0
pourcenatage_note_saisie_ap_ratt = 0
else
  pourcenatage_note_saisie_ap_ratt = ((count_examscores3.to_f / count_examscores2)* 100).to_i

  end
  pourcenatage_note_saisie_ap_ratt = "#{pourcenatage_note_saisie_ap_ratt.to_i}%"
   if pourcenatage_note_saisie.to_i > 100
pourcenatage_note_saisie = "100%"
else
  if pourcenatage_note_saisie.to_f.nan?
    pourcenatage_note_saisie = "0%"
  else
  pourcenatage_note_saisie = "#{pourcenatage_note_saisie.to_i}%"
end

  end
if SchoolField.find(bat.school_field_id).field_root
 sf1 = SchoolField.find(SchoolField.find(bat.school_field_id).field_root).name
 sf2 = SchoolField.find(bat.school_field_id).name
else
 sf1 = SchoolField.find(bat.school_field_id).name
 sf2 = SchoolField.find(bat.school_field_id).name
end
if @exam_scores.last

         csv << [sf1,sf2,Course.find_by_id(bat.course_id).section_name,code,employee,SchoolModule.find(sf.school_module_id).name,Subject.find(e.subject_id).name,e.weightage,Subject.find(e.subject_id).subject_group.credit_hours,employees,pourcenatage_note_saisie,pourcenatage_note_saisie_ap_ratt,"--",@exam_scores.last.updated_at ]
else
           csv << [sf1,sf2,Course.find_by_id(bat.course_id).section_name,code,employee,SchoolModule.find(sf.school_module_id).name,Subject.find(e.subject_id).name,e.weightage,Subject.find(e.subject_id).subject_group.credit_hours,employees,pourcenatage_note_saisie,pourcenatage_note_saisie_ap_ratt,"","","--" ]

end
                  end
                  @students = []
if bat.students.count > 0
  @students = bat.students
end
if bat.old_students.count > 0
  @students = bat.old_students
end
nb_element =  @exams.count * @students.count
if count_examscores.to_f && nb_element
pourcenatage_note_saisie = ((count_examscores.to_f / nb_element)*100)
else
  pourcenatage_note_saisie = 0
end
if count_examscores3 == 0 || count_examscores2 == 0
pourcenatage_note_saisie_ap_ratt = 100
else
  pourcenatage_note_saisie_ap_ratt = ((count_examscores3.to_f / count_examscores2)* 100).to_i

  end
logger.debug "******************************************************"
logger.debug count_examscores2
logger.debug count_examscores3

logger.debug nb_element

pourcenatage_note_saisie_ap_ratt = "#{pourcenatage_note_saisie_ap_ratt.to_i}%"
pourcenatage_note_saisie = "#{pourcenatage_note_saisie}%"
if @exam_scores.last
     # csv << [SchoolField.find(bat.school_field_id).name,"",Course.find_by_id(bat.course_id).section_name,code,employee,SchoolModule.find(sf.school_module_id).name,elements,coefs,hours,employees,pourcenatage_note_saisie,pourcenatage_note_saisie_ap_ratt,"",@exam_scores.last.updated_at ]
    else
      #     csv << [SchoolField.find(bat.school_field_id).name,"",Course.find_by_id(bat.course_id).section_name,code,employee,SchoolModule.find(sf.school_module_id).name,elements,coefs,hours,employees,pourcenatage_note_saisie,pourcenatage_note_saisie_ap_ratt,"","--" ]

    end
     end
end
 # csv << [bat.school_field_id,"","","",nm[0],nm[1],nm[2],nm[3],nm[4],nm[5],nm[6],nm[7],nm[8],nm[9],nm[10],nm[11],nm[12],nm[13],nm[14],nm[15]]





    end
         end

       end
    end

  filename=nombatch
     send_data csv_string,
  :type => 'text/csv; charset=iso-8859-1; header=present',
  :disposition => "attachment; filename=#{filename}.csv"

end
def export_all_marks_by_school_field
   nombatch="export"
    require 'faster_csv'

      @type=params[:type]
      if(params[:type])
          @courses=Course.find(:all)
                @course_groups=@courses.group_by{|course| course.course_name}
                @group=[]
                @course_groups.each do |key,value|
                           chaine=""
               @course_groups[key].each do |course|
               chaine+=course.id.to_s+','
               end
               chaine+='0'
               @group << [key,chaine]
                end
              if(params[:type]=="Annuelle")
                        render(:update) do |page|
                                         page.replace_html 'type_div', :partial => 'annuelle'
                            end
              else
                        render(:update) do |page|
                                         page.replace_html 'type_div', :partial => 'semestrielle'
                  end

              end

    else
      if params[:school_field_id]
      @school_field_id=params[:school_field_id]
    else
      @school_field_id = " "
    end
        if params[:school_year]
        @school_year=params[:school_year].to_i
    else
         @month = Time.now.month
      @year = Time.now.year
 if(1 < @month.to_i || @month.to_i < 8)
    @school_year=@year.to_i - 1
  else
        @school_year=@year.to_i

  end
    end

   @course_ids=""
    @cids="1,2,3,4,5,6,7,8,9"
    @courses=(@cids.gsub('%2C',',')).split(",")
    @courses.each do |c|
    @course_ids+=c+'+'
    end
    @courses=@courses.reject{|c| c.to_i == 0}
    @course1=@courses[0]
    if(@courses[1])
    @course2=@courses[1]
    else
    @course2=-1.to_s
    end
    @batches=[]
    @sf_sm=[]


             @exam_groups=[]
           @students=[]
           batch_string=""
           @batch_ids=""
           ct = 0
           if params[:school_field_id]
             @batches =Batch.find_all_by_school_field_id(params[:school_field_id]).select{|b| b.get_batch_year ==  @school_year}

           else
           SchoolField.all.each do |f|
             ct = ct +1
            # if(  ct <= 2)
           @batches +=Batch.find_all_by_school_field_id(f.id).select{|b| b.get_batch_year == @school_year}
         #end
         end
       end
    @batches.each do |batch|
                      @students += Student.find_all_by_batch_id(batch.id) unless !Student.find_all_by_batch_id(batch.id)
                        @students += batch.old_students
              batch_string+=batch.id.to_s+','
              @batch_ids+=batch.id.to_s+","
    end


    @resultats=[]
    @valide_student_by_system=[]

    csv_string = FasterCSV.generate(:col_sep=>';',:encoding => 'U',:headers=>true) do | csv |
      csv << []
      if(!@batches[1].nil?)
      #  csv << ([@sf_sm.count] << ' ' << Course.find_by_id([@batches[0].course_id]).section_name <<  Course.find_by_id([@batches[1].course_id]).section_name)

      else
        #csv << ([@sf_sm.count] << ' ' << Course.find_by_id([@batches[1].course_id]).section_name)
      end
        all_sm_names = ""


          titres=[ "Matricule","Apogee", "Nom" , "Prenom","M1","M2","M3","M4","M5","M6","M7","M8","M9","M10","M11","M12","M13","M14","M15","M16"]
          logger.debug "hola hola"
          #csv << ["Numero sequenciel", "Matricule", "Nom" , "Prenom", "Classe", "Annee scolaire",all_sm_names]

          csv << titres
=begin
      if(@course2 == -1.to_s)
        #csv << ["Numero sequenciel", "Matricule", "Nom" , "Prenom", "Classe", "Annee scolaire",SchoolModule.find(@sf_sm[0].school_module_id).name      "M1","M2","M3","M4","M5","M6","M7","M8"]
        sm_names = ""
        @sf_sm.each do |sfasm|
         sm_names += "#{SchoolModule.find(sfasm.school_module_id).name}"
        end
        csv << ["Numero sequenciel", "Matricule", "Nom" , "Prenom", "Classe", "Annee scolaire",SchoolModule.find(@sf_sm[0].school_module_id).name, SchoolModule.find(@sf_sm[1].school_module_id).name, SchoolModule.find(@sf_sm[2].school_module_id).name, SchoolModule.find(@sf_sm[3].school_module_id).name,SchoolModule.find(@sf_sm[4].school_module_id).name, SchoolModule.find(@sf_sm[5].school_module_id).name,SchoolModule.find(@sf_sm[6].school_module_id).name,SchoolModule.find(@sf_sm[7].school_module_id).name]


      elsif( @course1 != 5.to_s) and (@course2 != 6.to_s )
        csv << ["Numero sequenciel", "Matricule", "Nom" , "Prenom", "Classe", "Annee scolaire",SchoolModule.find(@sf_sm[0].school_module_id).name, SchoolModule.find(@sf_sm[1].school_module_id).name, SchoolModule.find(@sf_sm[2].school_module_id).name, SchoolModule.find(@sf_sm[3].school_module_id).name,SchoolModule.find(@sf_sm[4].school_module_id).name, SchoolModule.find(@sf_sm[5].school_module_id).name,SchoolModule.find(@sf_sm[6].school_module_id).name,SchoolModule.find(@sf_sm[7].school_module_id).name, SchoolModule.find(@sf_sm[8].school_module_id).name, SchoolModule.find(@sf_sm[9].school_module_id).name, SchoolModule.find(@sf_sm[10].school_module_id).name, SchoolModule.find(@sf_sm[11].school_module_id).name,SchoolModule.find(@sf_sm[12].school_module_id).name, SchoolModule.find(@sf_sm[13].school_module_id).name,SchoolModule.find(@sf_sm[14].school_module_id).name,SchoolModule.find(@sf_sm[15].school_module_id).name]



      else
        logger.debug @sf_sm.length
        if @sf_sm.length <= 2
          csv << ["Numero sequenciel", "Matricule", "Nom" , "Prenom", "Classe", "Annee scolaire",SchoolModule.find(@sf_sm[0].school_module_id).name, SchoolModule.find(@sf_sm[1].school_module_id).name]
        else
          all_sm_names = ""
          @sf_sm.each do |s|
            all_sm_names += "#{SchoolModule.find(s.school_module_id).name.gsub(",", " ")},"
          end
          logger.debug "hola hola"
          csv << ["Numero sequenciel", "Matricule", "Nom" , "Prenom", "Classe", "Annee scolaire",all_sm_names]
#         csv << ["Numero sequenciel", "Matricule", "Nom" , "Prenom", "Classe", "Annee scolaire",SchoolModule.find(@sf_sm[0].school_module_id).name, SchoolModule.find(@sf_sm[1].school_module_id).name, SchoolModule.find(@sf_sm[2].school_module_id).name, SchoolModule.find(@sf_sm[3].school_module_id).name,SchoolModule.find(@sf_sm[4].school_module_id).name, SchoolModule.find(@sf_sm[5].school_module_id).name,SchoolModule.find(@sf_sm[6].school_module_id).name,SchoolModule.find(@sf_sm[7].school_module_id).name, SchoolModule.find(@sf_sm[8].school_module_id).name]
        end
      end
=end
    @students=@students.uniq{|x| x.id}
    count = true
    @batches.each  do |bat|
if bat.course_id == 130 || bat.course_id == 133 || bat.course_id == 135
  csv << ([bat.name] << ' '  )

      #count = count + 1
      if count
      students = []
        @students = bat.old_students
      if bat.old_students.count == 0
                            @students = bat.students
       end
 if bat.students.count == 0
                            @students = bat.old_students
       end

      @students.each do |st|
      nombatch=st.batch.name
      @annee_reserve_detail = []
      @annee_reserve_detail_old = []
      @annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id =#{st.id} and school_year = #{@school_year} " )
      @annee_reserve_old = ReserveYearStudent.find(:first, :conditions => "student_id =#{st.id} and school_year = #{((@school_year.to_i)-1).to_s } " )
      if(@annee_reserve_old != nil)
        @annee_reserve_detail_old = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve_old.id}" )
      end
      if(@annee_reserve != nil )
          @annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve.id}" )
      end
      @resultats[st.id]={}
      annee_reserve = @annee_reserve
      annee_reserve_old = @annee_reserve_old
      ydecision=YearlyDecision.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")
      i=0
      nm = []
        if bat.course_id.to_i == 130
        bat_anc= Batch.find(:all, :conditions => "course_id = #{bat.course.id.to_i} and school_field_id = #{bat.school_field_id.to_s}").reject {|x| x.get_batch_year != (@school_year.to_i-1)}.first
end
        nombatch=bat.name
        if bat.course_id.to_i == 130
                     @sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => bat.course.id.to_s, :school_year => @school_year, :school_field_id => bat.school_field_id})
                     @sf_sm += SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => "132", :school_year => @school_year, :school_field_id => bat.school_field_id})
 logger.debug @sf_sm.count

end
if bat.course_id.to_i == 133
             @sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => bat.course.id.to_s, :school_year => @school_year, :school_field_id => bat.school_field_id})
             @sf_sm += SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => "134", :school_year => @school_year, :school_field_id => bat.school_field_id})

end
if bat.course_id.to_i == 135
             @sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => bat.course.id.to_s, :school_year => @school_year, :school_field_id => bat.school_field_id})
             @sf_sm += SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => "136", :school_year => @school_year, :school_field_id => bat.school_field_id})
end
    @sf_sm = @sf_sm.sort_by { |sf| sf.id }

        if(@sf_sm)
cts = 0
          @sf_sm.each do |fm|
            cts = cts + 1
            found = 0
            foundOld = 0
            md=SchoolModule.find(fm.school_module_id)
            @annee_reserve_detail.each do |ar|
              if(ar.school_module_id == md.id)
                  found = 1
              end
            end
            @annee_reserve_detail_old.each do |ar|
              if(ar.school_module_id == md.id)
                  found = 2
              end
            end
            if ((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?))
              logger.debug "*********************non anée de réserve#{fm.school_module_id}****************************"
              exam_group=ExamGroup.find(:first, :conditions => {:batch_id => bat.id, :module_id => md.id})

              if bat.course_id.to_i == 130 and cts > 4
                batch2 = Batch.find_all_by_school_field_id_and_course_id(bat.school_field_id,132).select{|b| b.get_batch_year == @school_year}
              exam_group=ExamGroup.find(:first, :conditions => {:batch_id => batch2.first.id, :module_id => md.id})
            end
            if bat.course_id.to_i == 133 and cts > 4
              logger.debug "*********************non anée de réserve#{fm.school_module_id}****************************"
              logger.debug "*********************non anée de réserve#{fm.school_module_id}****************************"
              logger.debug "*********************non anée de réserve#{fm.school_module_id}****************************"

              batch2 = Batch.find_all_by_school_field_id_and_course_id(bat.school_field_id,134).select{|b| b.get_batch_year == @school_year}
            exam_group=ExamGroup.find(:first, :conditions => {:batch_id => batch2.first.id, :module_id => md.id})
          end
          if bat.course_id.to_i == 135 and cts > 4
            batch2 = Batch.find_all_by_school_field_id_and_course_id(bat.school_field_id,136).select{|b| b.get_batch_year == @school_year}
          exam_group=ExamGroup.find(:first, :conditions => {:batch_id => batch2.first.id, :module_id => md.id})
        end
              if(!exam_group)
                  next
              end
            else
              logger.debug "*********************non anée de réserve1****************************"

              exam_group=ExamGroup.find(:first, :conditions => {:batch_id => bat_anc.id, :module_id => md.id})
              if(!exam_group)
                  next
              end
            end
            if foundOld == 1
              logger.debug "*********************non anée de réserve2****************************"

              if(md.marks_infos(bat_anc.id,st.id,@school_year)["decision"] != "NV")
                  exam_group=ExamGroup.find(:first, :conditions => {:batch_id => bat_anc.id, :module_id => md.id})
              end
            end
            test_rachetage=false

            if(Rachetage.find_by_exam_group_id_and_student_id(exam_group.id,st.id))
              test_rachetage=true
            end
            if ((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?))
              logger.debug "*********************non anée de réserve3****************************"
              results=md.marks_infos(bat.id,st.id,@school_year)

              if bat.course_id.to_i == 130 and cts > 4
                batch2 = Batch.find_all_by_school_field_id_and_course_id(bat.school_field_id,132).select{|b| b.get_batch_year == @school_year}
                results=md.marks_infos(batch2.first.id,st.id,@school_year)

            end
            if bat.course_id.to_i == 133 and cts > 4
              logger.debug "*********************non anée de réserve#{fm.school_module_id}****************************"
              logger.debug "*********************non anée de réserve#{fm.school_module_id}****************************"
              logger.debug "*********************non anée de réserve#{fm.school_module_id}****************************"

              batch2 = Batch.find_all_by_school_field_id_and_course_id(bat.school_field_id,134).select{|b| b.get_batch_year == @school_year}
              results=md.marks_infos(batch2.first.id,st.id,@school_year)

          end
              if bat.course_id.to_i == 135 and cts > 4
                batch2 = Batch.find_all_by_school_field_id_and_course_id(bat.school_field_id,136).select{|b| b.get_batch_year == @school_year}
                results=md.marks_infos(batch2.first.id,st.id,@school_year)

              end
              #results=md.marks_infos(batch2.first.id,st.id,@school_year)
              sf1 = ""
if bat.course_id.to_i == 130
            sf1 =  SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{bat.school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year} and (course_id=#{bat.course_id} or course_id=#{bat.course_id.to_i + 2})")
end
if bat.course_id.to_i == 133
            sf1 =  SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{bat.school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year} and (course_id=#{bat.course_id} or course_id=#{bat.course_id.to_i + 1})")
end
if bat.course_id.to_i == 135
            sf1 =  SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{bat.school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year} and (course_id=#{bat.course_id} or course_id=#{bat.course_id.to_i + 1})")
end
if sf1
              md_pond=sf1.coefficient

              end
            else
              results=md.marks_infos(bat_anc.id,st.id,@school_year.to_i)
              if bat.course_id.to_i == 130 and cts > 4
                batch2 = Batch.find_all_by_school_field_id_and_course_id(bat.school_field_id,132).select{|b| b.get_batch_year == @school_year}
                results=md.marks_infos(batch2.first.id,st.id,@school_year.to_i)

            end
            if bat.course_id.to_i == 133 and cts > 4
              logger.debug "*********************non anée de réserve#{fm.school_module_id}****************************"
              logger.debug "*********************non anée de réserve#{fm.school_module_id}****************************"
              logger.debug "*********************non anée de réserve#{fm.school_module_id}****************************"

              batch2 = Batch.find_all_by_school_field_id_and_course_id(bat.school_field_id,134).select{|b| b.get_batch_year == @school_year}
              results=md.marks_infos(batch2.first.id,st.id,@school_year.to_i)

          end
              if bat.course_id.to_i == 135 and cts > 4
                batch2 = Batch.find_all_by_school_field_id_and_course_id(bat.school_field_id,136).select{|b| b.get_batch_year == @school_year}
                results=md.marks_infos(batch2.first.id,st.id,@school_year.to_i)

              end
              sf1 = ""
if bat.course_id.to_i == 130
            sf1 =  SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{bat.school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year} and (course_id=#{bat.course_id} or course_id=#{bat.course_id.to_i + 2})")
end
if bat.course_id.to_i == 133
            sf1 =  SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{bat.school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year} and (course_id=#{bat.course_id} or course_id=#{bat.course_id.to_i + 1})")
end
if bat.course_id.to_i == 135
            sf1 =  SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{bat.school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year} and (course_id=#{bat.course_id} or course_id=#{bat.course_id.to_i + 1})")
end
if sf1
              md_pond=sf1.coefficient

              end
              if found == 2
                if(results["decision"] == "NV")
                  logger.debug "*********************non ané****************************"
                  logger.debug "*********************non ané****************************"
                  logger.debug "*********************non ané****************************"
                  logger.debug "*********************non ané****************************"
                  logger.debug "*********************non ané****************************"

                    results=md.marks_infos(bat.id,st.id,@school_year)
                    sf1 = ""
      if bat.course_id.to_i == 130
                  sf1 =  SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{bat.school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year} and (course_id=#{bat.course_id} or course_id=#{bat.course_id.to_i + 2})")
      end
      if bat.course_id.to_i == 133
                  sf1 =  SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{bat.school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year} and (course_id=#{bat.course_id} or course_id=#{bat.course_id.to_i + 1})")
      end
      if bat.course_id.to_i == 135
                  sf1 =  SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{bat.school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year} and (course_id=#{bat.course_id} or course_id=#{bat.course_id.to_i + 1})")
      end
      if sf1
                    md_pond=sf1.coefficient

                    end


              end
              end
            end
            logger.debug "*****************moyenne**********"
            logger.debug results["average"]
            if (results["average"])
              nm[i] = sprintf("%.2f",results["held_average"])
              i = i+1
            else
              nm[i] = 0.0
              i = i+1
            end

          end
         end
          annee='"'+@batches.first.start_date.strftime("%Y").to_s+"  "+@batches.first.end_date.strftime("%Y").to_s+'"'
         if @batches.first.name.include? '/'
        @batches.first.name.sub!('/', ' ')
         end
         clas=@batches.first.name.sub!('/', ' ')
         logger.debug nm.inspect

if(@course2 == -1.to_s)
        csv << [st.matricule,"",st.last_name,st.first_name,nm[0],nm[1],nm[2],nm[3],nm[4],nm[5],nm[6],nm[7]]

         elsif( @course1 != 135.to_s and @course2 != 136.to_s)
        csv << [st.matricule,"",st.last_name,st.first_name,nm[0],nm[1],nm[2],nm[3],nm[4],nm[5],nm[6],nm[7],nm[8],nm[9],nm[10],nm[11],nm[12],nm[13],nm[14],nm[15]]
         else
        csv << [st.matricule,"",st.last_name,st.first_name,nm[0],nm[1],nm[2],nm[3],nm[4],nm[5],nm[6],nm[7],nm[8]]
         end
         end

end

    end
         end

       end
    end

  filename=nombatch
     send_data csv_string,
  :type => 'text/csv; charset=iso-8859-1; header=present',
  :disposition => "attachment; filename=#{filename}.csv"
end
def list_modules
  logger.debug "*****************"
  logger.debug params[:school_field]
  render(:update) do |page|
    @type = params[:school_field]
    @school_year = params[:school_year]
                   page.replace_html 'all_student_modules', :partial=> 'all_student_modules_csv'
end
end
  def all_student_modules_csv

    nombatch = "export"
    require 'faster_csv'
    @type = params[:type]
    if (params[:type])
      @courses = Course.find(:all)
      @course_groups = @courses.group_by { |course| course.course_name }
      @group = []
      @course_groups.each do |key, value|
        chaine = ""
        @course_groups[key].each do |course|
          chaine += course.id.to_s + ','
        end
        chaine += '0'
        @group << [key, chaine]
      end
      if (params[:type] == "Annuelle")
        render(:update) do |page|
          page.replace_html 'type_div', :partial => 'annuelle'
        end
      else
        render(:update) do |page|
          page.replace_html 'type_div', :partial => 'semestrielle'
        end

      end

    else
      @school_field_id = params[:school_field_id]
      @school_year = params[:school_year]
      @course_ids = ""
      @cids = params[:course_ids]
      @courses = (params[:course_ids].gsub('%2C', ',')).split(",")
      @courses.each do |c|
        @course_ids += c + '+'
      end
      @courses = @courses.reject { |c| c.to_i == 0 }
      @course1 = @courses[0]
      if (@courses[1])
        @course2 = @courses[1]
      else
        @course2 = -1.to_s
      end
      @batches = []
      @sf_sm = []
      @courses.each do |course|

        bt = Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
        if (bt)
          @batches += bt
        end
        @sf_sm += SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => course.to_i, :school_year => @school_year, :school_field_id => @school_field_id })
      end

      @exam_groups = []
      @students = []
      batch_string = ""
      @batches.each do |batch|
        @students += Student.find_all_by_batch_id(batch.id) unless !Student.find_all_by_batch_id(batch.id)
        @students += batch.old_students
=begin
              bs = BatchStudent.find_all_by_batch_id(batch.id)
                          unless bs.empty?
                               bs.each do|bst|
                                     student = Student.find_by_id(bst.student_id)
                                     @students << student unless student.nil?
                                end
                          end
=end
        @students = @students.uniq { |x| x.id }
        batch_string += batch.id.to_s + ','
      end

      @batch_ids = ""
      @batches.each do |bat|
        sbat = bat.id.to_s
        @batch_ids += sbat + ","
      end

      @resultats = []
      @valide_student_by_system = []

      csv_string = FasterCSV.generate(:col_sep => ';') do |csv|
        csv << []
        if (!@batches[1].nil?)
          csv << ([@batches[0].name] << ' ' << Course.find_by_id([@batches[0].course_id]).section_name << Course.find_by_id([@batches[1].course_id]).section_name)
        else
          csv << ([@batches[0].name] << ' ' << Course.find_by_id([@batches[0].course_id]).section_name)
        end
        csv << ["Numero sequenciel", "Matricule", "Nom", "Prenom", "Classe", "Classement", "Annee scolaire", SchoolModule.find(@sf_sm[0].school_module_id).name, SchoolModule.find(@sf_sm[1].school_module_id).name, SchoolModule.find(@sf_sm[2].school_module_id).name, SchoolModule.find(@sf_sm[3].school_module_id).name, SchoolModule.find(@sf_sm[4].school_module_id).name, SchoolModule.find(@sf_sm[5].school_module_id).name, SchoolModule.find(@sf_sm[6].school_module_id).name, SchoolModule.find(@sf_sm[7].school_module_id).name, SchoolModule.find(@sf_sm[8].school_module_id).name,  SchoolModule.find(@sf_sm[9].school_module_id).name,  SchoolModule.find(@sf_sm[10].school_module_id).name,  SchoolModule.find(@sf_sm[11].school_module_id).name]

        # if (@course2 == -1.to_s)
        #   #csv << ["Numero sequenciel", "Matricule", "Nom" , "Prenom", "Classe", "Annee scolaire",SchoolModule.find(@sf_sm[0].school_module_id).name      "M1","M2","M3","M4","M5","M6","M7","M8"]
        #   if (!@sf_sm[0].nil? and !@sf_sm[1].nil? and !@sf_sm[2].nil? and !@sf_sm[3].nil? and !@sf_sm[4].nil? and !@sf_sm[5].nil? and !@sf_sm[6].nil? and !@sf_sm[7].nil?)
        #     csv << ["Numero sequenciel", "Matricule", "Nom", "Prenom", "Classe", "Classement", "Annee scolaire", SchoolModule.find(@sf_sm[0].school_module_id).name, SchoolModule.find(@sf_sm[1].school_module_id).name, SchoolModule.find(@sf_sm[2].school_module_id).name, SchoolModule.find(@sf_sm[3].school_module_id).name, SchoolModule.find(@sf_sm[4].school_module_id).name, SchoolModule.find(@sf_sm[5].school_module_id).name, SchoolModule.find(@sf_sm[6].school_module_id).name, SchoolModule.find(@sf_sm[7].school_module_id).name]
        #   end
        # elsif (@course1 != 5.to_s and @course2 != 6.to_s)
        #   if (!@sf_sm[0].nil? and !@sf_sm[1].nil? and !@sf_sm[2].nil? and !@sf_sm[3].nil? and !@sf_sm[4].nil? and !@sf_sm[5].nil? and !@sf_sm[6].nil? and !@sf_sm[7].nil? and !@sf_sm[8].nil? and !@sf_sm[9].nil? and !@sf_sm[10].nil? and !@sf_sm[11].nil? and !@sf_sm[12].nil? and !@sf_sm[13].nil? and !@sf_sm[14].nil? and !@sf_sm[15].nil?)
        #     csv << ["Numero sequenciel", "Matricule", "Nom", "Prenom", "Classe", "Classement", "Annee scolaire", SchoolModule.find(@sf_sm[0].school_module_id).name, SchoolModule.find(@sf_sm[1].school_module_id).name, SchoolModule.find(@sf_sm[2].school_module_id).name, SchoolModule.find(@sf_sm[3].school_module_id).name, SchoolModule.find(@sf_sm[4].school_module_id).name, SchoolModule.find(@sf_sm[5].school_module_id).name, SchoolModule.find(@sf_sm[6].school_module_id).name, SchoolModule.find(@sf_sm[7].school_module_id).name, SchoolModule.find(@sf_sm[8].school_module_id).name, SchoolModule.find(@sf_sm[9].school_module_id).name, SchoolModule.find(@sf_sm[10].school_module_id).name, SchoolModule.find(@sf_sm[11].school_module_id).name, SchoolModule.find(@sf_sm[12].school_module_id).name, SchoolModule.find(@sf_sm[13].school_module_id).name, SchoolModule.find(@sf_sm[14].school_module_id).name, SchoolModule.find(@sf_sm[15].school_module_id).name]
        #   end
        # else
        #   if (!@sf_sm[0].nil? and !@sf_sm[1].nil? and !@sf_sm[2].nil? and !@sf_sm[3].nil? and !@sf_sm[4].nil? and !@sf_sm[5].nil? and !@sf_sm[6].nil? and !@sf_sm[7].nil?)
        #     csv << ["Numero sequenciel", "Matricule", "Nom", "Prenom", "Classe", "Classement", "Annee scolaire", SchoolModule.find(@sf_sm[0].school_module_id).name, SchoolModule.find(@sf_sm[1].school_module_id).name, SchoolModule.find(@sf_sm[2].school_module_id).name, SchoolModule.find(@sf_sm[3].school_module_id).name, SchoolModule.find(@sf_sm[4].school_module_id).name, SchoolModule.find(@sf_sm[5].school_module_id).name, SchoolModule.find(@sf_sm[6].school_module_id).name, SchoolModule.find(@sf_sm[7].school_module_id).name, SchoolModule.find(@sf_sm[8].school_module_id).name]
        #   end
        # end
        @students.each do |st|
          @resultats[st.id] = {}
          @resultats[st.id]['avg_year'] = SchoolModule.average_of_year(@batches, st.id, @school_year)
        end
        @students.sort! { |a, b| @resultats[b.id]['avg_year'] <=> @resultats[a.id]['avg_year'] }
        i = 1
        @classement = []
        @students.each do |st|
          @classement[st.id] = i
          i = i + 1
        end
        @students.each do |st|

          nombatch = st.batch.name
          @annee_reserve_detail = []
          @annee_reserve_detail_old = []
          @annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id =#{st.id} and school_year = #{@school_year} ")
          @annee_reserve_old = ReserveYearStudent.find(:first, :conditions => "student_id =#{st.id} and school_year = #{((@school_year.to_i) - 1).to_s } ")
          if (@annee_reserve_old != nil)
            @annee_reserve_detail_old = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve_old.id}")
          end
          if (@annee_reserve != nil)
            @annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve.id}")

          end

          @resultats[st.id] = {}
          annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year}")
          annee_reserve_old = ReserveYearStudent.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year.to_i - 1}")
          ydecision = YearlyDecision.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")
          i = 0
          nm = []
          @batches.each do |bat|
            logger.debug "***********************batch*************************"
            logger.debug bat.course.id
            bat_anc = Batch.find(:first, :conditions => "course_id = #{bat.course.id.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{(@school_year.to_i - 1).to_s} or (year(start_date)=#{(@school_year).to_s} and month(start_date) < 8))")
            nombatch = bat.name
            if (@sf_sm)

              @sf_sm.each do |fm|
                found = 0
                foundOld = 0
                md = SchoolModule.find(fm.school_module_id)
                @annee_reserve_detail.each do |ar|
                  if (ar.school_module_id == md.id)
                    found = 1
                  end
                end
                @annee_reserve_detail_old.each do |ar|
                  if (ar.school_module_id == md.id)
                    foundOld = 1
                  end
                end
                if ((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?))
                  logger.debug "*********************non anée de réserve****************************"
                  exam_group = ExamGroup.find(:first, :conditions => { :batch_id => bat.id, :module_id => md.id })
                  if (!exam_group)
                    next
                  end
                else
                  exam_group = ExamGroup.find(:first, :conditions => { :batch_id => bat_anc.id, :module_id => md.id })
                  if (!exam_group)
                    next
                  end
                end
                if foundOld == 1
                  if (md.marks_infos(bat_anc.id, st.id, @school_year)["decision"] != "NV")
                    exam_group = ExamGroup.find(:first, :conditions => { :batch_id => bat_anc.id, :module_id => md.id })
                  end
                end
                test_rachetage = false

                if (Rachetage.find_by_exam_group_id_and_student_id(exam_group.id, st.id))
                  test_rachetage = true
                end
                if ((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?))
                  results = md.marks_infos(bat.id, st.id, @school_year)
                  md_pond = SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{@school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year} and (course_id=#{@course1} or course_id=#{@course2})").coefficient
                else
                  results = md.marks_infos(bat_anc.id, st.id, @school_year.to_i - 1)
                  md_pond = SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{@school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year.to_i - 1} and (course_id=#{@course1} or course_id=#{@course2})").coefficient

                  if foundOld == 1
                    if (md.marks_infos(bat_anc.id, st.id, @school_year)["decision"] != "NV")
                      results = md.marks_infos(bat_anc.id, st.id, @school_year.to_i - 1)
                      md_pond = SchoolFieldSchoolModule.find(:first, :conditions => "school_field_id = #{@school_field_id} and school_module_id =#{md.id} and school_year = #{@school_year} and (course_id=#{@course1} or course_id=#{@course2})").coefficient
                    end
                  end
                end
                logger.debug "*****************moyen**********"
                logger.debug results["average"]
                if (results["average"])
                  nm[i] = results["held_average"]
                  i = i + 1
                else
                  nm[i] = 0.0
                  i = i + 1
                end

              end
            end

          end

          annee = st.batch.start_date.strftime("%Y") + "/" + st.batch.end_date.strftime("%Y")
          if (@course2 == -1.to_s)
            csv << [st.admission_no, st.matricule, st.last_name, st.first_name, st.batch.name, @classement[st.id], annee, nm[0], nm[1], nm[2], nm[3], nm[4], nm[5], nm[6], nm[7]]
          elsif (@course1 != 5.to_s and @course2 != 6.to_s)
            csv << [st.admission_no, st.matricule, st.last_name, st.first_name, st.batch.name, @classement[st.id], annee, nm[0], nm[1], nm[2], nm[3], nm[4], nm[5], nm[6], nm[7], nm[8], nm[9], nm[10], nm[11], nm[12], nm[13], nm[14], nm[15]]
          else
            csv << [st.admission_no, st.matricule, st.last_name, st.first_name, st.batch.name, @classement[st.id], annee, nm[0], nm[1], nm[2], nm[3], nm[4], nm[5], nm[6], nm[7], nm[8]]
          end

        end

      end
    end
    filename = nombatch
    send_data Iconv.conv('iso-8859-1//IGNORE', 'utf-8', csv_string),
              :type => 'text/csv; charset=iso-8859-1; header=present',
              :disposition => "attachment; filename=#{filename}.csv"

  end

  def show_students_all_marks_all2
    if params[:is_code]
      @is_code = true
    else
      @is_code = false
    end

    if params[:orderbyname]
      @orderbyname = true
    else
      @orderbyname = false
    end

    @current_user = current_user
    @typed = params[:typed]
    @note_max = 0
    @note_min = 19
    @moyenne_class = 0
    @nombre_zero = 0
    @nombre_etudiant = 0
    @school_modules = []
    @resultas = []
    @resultats = []
    @school_field_id = params[:school_field_id]
    @course_ids = (params[:course_ids].gsub('%2C', ',')).split(",")
    @school_year = params[:school_year]

    @course_ids = ""

    @cids = params[:course_ids]
    @courses = (params[:course_ids].gsub('%2C', ',')).split(",")
    @courses.each do |c|
      @course_ids += c + '+'
    end
    @courses = @courses.reject { |c| c.to_i == 0 }
    @course1 = @courses[0]
    if (@courses[1])
      @course2 = @courses[1]
    else
      @course2 = -1.to_s
    end
    @batches = []
    @sf_sm = []
    @courses.each do |course|

      bt = Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
      if (bt)
        @batches += bt
      end
      @sf_sm += SchoolFieldSchoolModule.find_by_sql("select * from school_field_school_modules where course_id = #{course.to_i} and school_year = #{@school_year} and school_field_id = #{@school_field_id} ")

    end
    if @school_field_id.to_i == 10 and @school_year.to_i == 2020
      @batches = @batches.select { |b| b.is_active == true }
    else
      @batches = @batches
    end
    @batches = @batches.reject { |b| b.is_deleted }
    @course_ids.split("+").reject { |tf| tf.to_i == 0 }.each do |cr|
      @intem = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => cr.to_i, :school_field_id => @school_field_id, :school_year => params[:school_year] })
      if (@intem)
        @intem.each do |int|
          if @school_modules[cr.to_i].nil? or @school_modules[cr.to_i].empty?
            @school_modules[cr.to_i] = []
          end
          @school_modules[cr.to_i] << int.school_module_id
        end
      end
    end
    @batch = @batches.first
    @batch2 = @batches.last
    @bts = [@batch, @batch2]
    batch_string = @batch.id.to_s + ',' + @batch2.id.to_s + ','
    @students = Student.find_all_by_batch_id(@batch.id)
    @students = Student.find_all_by_batch_id(@batch2.id)
    if @batch
      @students += @batch.old_students
    end
    if @batch2
      @students += @batch2.old_students
    end
    @students = @students.uniq { |x| x.id }
    @exams = []
    @resultas = []
    @ponderations = []
    @course_ids.split("+").reject { |tf| tf.to_i == 0 }.each do |crr|
      if !@school_modules[crr.to_i].nil? and !SchoolModule.find(@school_modules[crr.to_i].first).name.nil? and SchoolModule.find(@school_modules[crr.to_i].first).name.first.upcase == "M" and 1 == 2
        @school_modules[crr.to_i].each do |smm|
          logger.debug SchoolModule.find(smm).name + "\n"
        end
        @school_modules[crr.to_i] = @school_modules[crr.to_i].sort_by { |sm| SchoolModule.find(sm).name.split("M")[1].split(":")[0] unless (SchoolModule.find(sm).name.nil? or SchoolModule.find(sm).name.split("M").nil? or SchoolModule.find(sm).name.split("M")[1].split(":")) }
      else
        if !@school_modules[crr.to_i].nil?
          @school_modules[crr.to_i] = @school_modules[crr.to_i].compact.sort_by { |sm| SchoolModule.find(sm).name }
        else
          @school_modules[crr.to_i] = []
        end
      end
    end
    @students.each do |st|
      @course_ids.split("+").reject { |tf| tf.to_i == 0 }.each do |crr|
        @school_modules[crr.to_i].each do |smd|
          @batches.each do |bbt|
            #hamza 2
            @exam_group = ExamGroup.find_by_sql("select * from exam_groups where batch_id=#{bbt.id} and module_id =#{smd} limit 1")[0] unless !ExamGroup.find_by_sql("select * from exam_groups where batch_id=#{bbt.id} and module_id =#{smd} limit 1")[0]
          end
          if @exam_group.nil?
            @school_modules[crr.to_i].delete(smd)
          end
          @exams[smd] = []
          @exams[smd] = @exam_group.exams unless @exam_group.nil?
          @resultas[st.id] = []
          @resultas[st.id][smd] = []

          @exams[smd].each do |ex|
            @ponderations[ex.id] = SchoolModuleSubject.find(:first, :conditions => { :school_module_id => smd, :subject_group_id => Subject.find(ex.subject_id).subject_group_id, :school_year => @school_year }).subject_weighting
            esco = ExamScore.find_by_sql("select marks,marks_ar FROM `exam_scores` WHERE (student_id = #{st.id} and  exam_id = #{ex.id}) limit 1")[0]
            mark = 0
            markar = 0
            if (esco)
              mark = esco.marks
              markar = esco.marks_ar
            end
            @resultas[st.id][smd][ex.id] = {}
            @resultas[st.id][smd][ex.id]['markv'] = mark
            @resultas[st.id][smd][ex.id]['markarv'] = markar
          end
        end
      end
    end

    not_max = 0
    student_not_max = -1
    @exam_groups = []
    @batch_ids = ""
    batch_string = ""
    infos_modules = []
    number_modules = 0
    @batches.each do |batch|
      @batch_ids += batch.id.to_s + ","
      modules = []
      sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => batch.school_field_id, :course_id => batch.course_id, :school_year => batch.get_batch_year })
      sf_sm.each do |sfssm|
        modules << SchoolModule.find(sfssm.school_module_id)
      end
      modules = modules.uniq
      infos_modules[batch.id] = {}
      infos_modules[batch.id]['modules'] = modules

      modules.each do |md|
        sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
        exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(batch.id, md.id)
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
              sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{@school_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
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

        infos_modules[batch.id][md.id] = {}
        infos_modules[batch.id][md.id]['non_spec_pond'] = non_spec_pond
        infos_modules[batch.id][md.id]['spec_pond'] = spec_pond
        infos_modules[batch.id][md.id]['pond'] = pond
        infos_modules[batch.id][md.id]['sfsm'] = sfsm
        number_modules += modules.count
      end
    end

    infos_modules[0] = {}
    infos_modules[0]['number_modules'] = number_modules

    @students.each do |st|

      @resultats[st.id] = {}
      annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year}")
      annee_reserve_old = ReserveYearStudent.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year.to_i - 1}")
      ydecision = YearlyDecision.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")
      if (1 == 0 and ydecision and !params[:typd] and annee_reserve.nil? and annee_reserve_old.nil? and ydecision.avg_year.to_i != -1)

        rslt = st.check_student_result_h(@batches, @school_year, infos_modules)
        @resultats[st.id]['decision'] = ydecision.decision
        @resultats[st.id]['avg_year'] = rslt["average_of_year"]
        @resultats[st.id]['nb_val'] = ydecision.nb_val
        @resultats[st.id]['nb_var'] = ydecision.nb_var
        @resultats[st.id]['nb_nv'] = ydecision.nb_nv
        @resultats[st.id]['nb_eliminat'] = ydecision.nb_eliminat
        @resultats[st.id]['check'] = 1
        @resultats[st.id]['elminatory_number_spec'] = rslt["elminatory_number_spec"]
      else
        annee_reserve_histo = ReserveYearStudent.find(:all, :conditions => "student_id = #{st.id}")
        nbr = 0
        annee_reserve_histo.each do |annhisto|
          nbr = nbr + 1
        end

        if (ydecision)
          @resultats[st.id]['decision'] = ydecision.decision
        end

        rslt = st.check_student_result_h(@batches, @school_year, infos_modules)
        moyenne = @resultats[st.id]['avg_year'] = rslt["average_of_year"] #SchoolModule.average_of_year(@batches,st.id,@school_year)
        moyenne_session_normale = @resultats[st.id]['avg_year_normale'] = rslt["average_of_year_session_normale"] #SchoolModule.average_of_year_session_normale(@batches,st.id,@school_year)

        ydecision = YearlyDecision.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")
        @resultats[st.id]['nb_val'] = rslt["valid_number"]
        @resultats[st.id]['nb_var'] = rslt["var_number"]
        @resultats[st.id]['nb_nv'] = rslt["nvalid_number"]
        @resultats[st.id]['nb_eliminat'] = rslt["elminatory_number"]
        @resultats[st.id]['elminatory_number_spec'] = rslt["elminatory_number_spec"]
        if (@resultats[st.id]['avg_year'] > not_max and (@course1.to_i == 5 or @course1.to_i == 6))
          student_not_max = st.id
          not_max = @resultats[st.id]['avg_year']
        end
        if (ydecision)
          @resultats[st.id]['check'] = 1
        else
          @resultats[st.id]['check'] = 0
        end
        @resultats[st.id]['decision'] = get_decision_by_student(@course1, moyenne_session_normale, @resultats[st.id]['nb_nv'], rslt["elminatory_number_spec"], nbr)

        if (ydecision)
          @resultats[st.id]['decision'] = ydecision.decision
        end
      end
      if (@resultats[st.id]['avg_year'] > @note_max)
        @note_max = @resultats[st.id]['avg_year']
      end
      if (@resultats[st.id]['avg_year'] < @note_min)
        @note_min = @resultats[st.id]['avg_year']
      end
      if (@resultats[st.id]['avg_year'] == 0)
        @nombre_zero = @nombre_zero + 1
      end
      @nombre_etudiant = @nombre_etudiant + 1
      @moyenne_class = @moyenne_class + @resultats[st.id]['avg_year']
    end
    if (@orderbyname)
      @students = @students.sort_by { |st| st.last_name[0..3] }
    else
    end
    i = 1
    @classement = []
    @students.each do |st|
      @classement[st.id] = i
      i = i + 1
    end
    render :pdf => 'show_students_all_marks_all2', :orientation => 'Portrait', :footer => false

  end

  def search_ajax_student_ar
    if params[:option] == "active"
      if params[:query].length >= 3
        @students = Student.find(:all,
                                 :conditions => ["first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ?
                            OR admission_no = ? OR (concat(first_name, \" \", last_name) LIKE ? ) ",
                                                 "#{params[:query]}%", "#{params[:query]}%", "#{params[:query]}%",
                                                 "#{params[:query]}", "#{params[:query]}"],
                                 :order => "batch_id asc,first_name asc", :include => [{ :batch => :course }]) unless params[:query] == ''
      else
        @students = Student.find(:all,
                                 :conditions => ["admission_no = ? ", params[:query]],
                                 :order => "batch_id asc,first_name asc", :include => [{ :batch => :course }]) unless params[:query] == ''
      end
      if @current_user.privileges.map { |p| p.name }.include?("Coordonateurfiliere")
        sfields = SchoolField.find_by_sql("select id from school_fields where employee_id=" + Employee.find_by_user_id(@current_user.id).id.to_s)
        sfar = []
        sfields.each do |sf|
          #logger.debug '*************************'+@students[0].batch.school_field_id.to_s+'hhhh'+ sf[:id].to_s
          sfar << sf[:id]
        end
        @students.reject! { |e| !sfar.include? e.batch.school_field_id }
      end
      render :layout => false
    else
      if params[:query].length >= 3
        @archived_students = ArchivedStudent.find(:all,
                                                  :conditions => ["first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ?
                            OR admission_no = ? OR (concat(first_name, \" \", last_name) LIKE ? ) ",
                                                                  "#{params[:query]}%", "#{params[:query]}%", "#{params[:query]}%",
                                                                  "#{params[:query]}", "#{params[:query]}"],
                                                  :order => "batch_id asc,first_name asc", :include => [{ :batch => :course }]) unless params[:query] == ''
      else
        @archived_students = ArchivedStudent.find(:all,
                                                  :conditions => ["admission_no = ? ", params[:query]],
                                                  :order => "batch_id asc,first_name asc", :include => [{ :batch => :course }]) unless params[:query] == ''
      end
      render :partial => "search_ajax_student_ar"
    end
  end

def show_student_diplome
  if params[:laureats]
    require 'faster_csv'
    require 'csv'
    csv_string = FasterCSV.generate(:col_sep=>';') do | csv |
      csv << [ "CDANN", "CDETAB","CDDIP","CODVRSDIP","CODAPO","PAI","CIN","CNE","PRENOM","NOM","DATNAIS", "SEXE", "CDPAYS","HAND","CDBAC"]
      if params[:students]
        params[:students].each do |s|
          @students = Student.find_by_sql("SELECT * FROM students WHERE id = #{s}")
          @students.each do |st|
           csv << [ "2019", st.etablissement_dip,"EUTTDAI","401",st.apogee,"2018",st.cin,st.code_massar,st.first_name,st.last_name,st.date_of_birth, st.gender, st.nationality_id,"NULL","CDBAC"]
          end
        end
      end
    end

    filename="bourse"
    send_data Iconv.conv("iso-8859-1//IGNORE", "iso-8859-1", csv_string),
    :type => 'text/csv; charset=iso-8859-1; header=present',
    :disposition => "attachment; filename=#{filename}.csv"


  else


    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    # @courses = Course.find(:all, :conditions => "code = 'SM03' or code = 'SM04'") #troisième année
    #@courses = Course.all.select{|e| e.id == 5 || e.id == 6 }

    @batches = []
    # @courses.each do |course|
    bt = Batch.find(:all, :conditions => "school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    # bt = Batch.find(:all, :conditions => "course_id = 135 and school_field_id = 1449 and (year(start_date)= 2017 or (year(start_date)=2018 and month(start_date) < 8))").reject { |x| x.get_batch_year != 2017}
    # logger.debug "1BBBBBBBBBBBBBBBBBBBBBBBBB #{bt.inspect} HHHHHHHHHHHHHHHHHHHH course_id = #{course.id} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s}"
    if (bt)
     @batches += bt
    end
    # end
    @students = []

    @batches.each do |batch|

      @students += Student.find_all_by_batch_id(batch.id) unless !Student.find_all_by_batch_id(batch.id)
      @students += BatchStudent.find_all_by_batch_id(batch.id).collect{|s| Student.find(s.student_id)}
      @students = @students.uniq

      #batch_string+=batch.id.to_s+','

    end
#********************************* essalhi*******************************************

# student = []
# student << Student.find(19470)
# student << Student.find(19471)
@moyeene = []
@students.each do |st|
@moyeene[st.id] = {}
  batches = st.all_batches.uniq
  # logger.debug "JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ   #{batches.inspect}"
  number_semester = 1
  batches.each do |b|


  if number_semester == 1
    bts = batches.first
  elsif number_semester == 2
    bts = batches.second
  elsif number_semester == 3
    bts = batches.third
  elsif number_semester == 4
    bts = batches.fourth
  elsif number_semester == 5
    bts = batches.fifth
  # elsif  number_semester == 6
  #    bts = bts.sixth
  end
# logger.debug "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM   #{bts.inspect}"
    # batches << st.all_batches.second
     if bts
    if st
      infos_modules = []
      number_modules = 0
      #batches.each do |bts|
      modules = []
      # print bts.get_batch_year
      # @school_year = bts.get_batch_year

      sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => bts.school_field_id, :course_id => bts.course_id, :school_year => bts.get_batch_year })
      sf_sm.each do |sfssm|
        # print SchoolModule.find(sfssm.school_module_id).name+"\n"
        modules << SchoolModule.find(sfssm.school_module_id) #unless SchoolModule.find(sfssm.school_module_id).nil?
      end
      print "EoF modules \n"
      modules = modules.uniq
      infos_modules[bts.id] = {}
      infos_modules[bts.id]['modules'] = modules #unless modules.nil?
      # puts infos_modules.inspect
      modules.each do |md|
        sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
        exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(bts.id, md.id)
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
            sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{@school_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
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
        infos_modules[bts.id][md.id] = {}
        infos_modules[bts.id][md.id]['non_spec_pond'] = non_spec_pond
        infos_modules[bts.id][md.id]['spec_pond'] = spec_pond
        infos_modules[bts.id][md.id]['pond'] = pond
        infos_modules[bts.id][md.id]['sfsm'] = sfsm
        number_modules += 1
      end
      # end
      infos_modules[0] = {}
      infos_modules[0]['number_modules'] = number_modules
      @yearly_infos = SchoolModule.modules_max_data_opt3([bts],st.id,@school_year, infos_modules)
      yt = st.check_student_result_h([bts], @school_year, infos_modules)
    end
  @moyeene[st.id]["S#{number_semester}"] =  sprintf("%.2f",@yearly_infos["average_of_year"])
  number_semester += 1
  end
end
end
#************************************************************************************

    @student_batch = []
    @resultats = []
    @moyen_annee = []
    @moyen_diplome = []
    @semester_average = []
    @students.each do |student|

      @resultats[student.id] = {}
      @moyen_annee[student.id] = {}
      @semester_average[student.id] = {}
      @student_batchs = BatchStudent.find_all_by_student_id(student.id)

      studnets_batches = []
      @student_batchs.each do |st_bt|
        max = st_bt
        @batch = Batch.find_by_id(st_bt.batch_id)

        @student_batchs.each do |st_bt2|
          @batch2 = Batch.find_by_id(st_bt2.batch_id)
          if @batch.course_id == @batch2.course_id and @batch.get_batch_year < @batch2.get_batch_year
            max = st_bt2
          # logger.debug "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW #{max} WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
          end
        end
        studnets_batches << max
      end
      @student_batchs = studnets_batches

      # =begin          @student_batchs.each do |st_bt|
      # a = 0
      # batch = Batch.find_by_id(st_bt.batch_id)
      # @student_batchs.each do |st_bt2|
      # b = 0
      # batch2 = Batch.find_by_id(st_bt2.batch_id)
      # if batch.course_id == batch2.course_id and a != b and batch.get_batch_year <= batch2.get_batch_year
      # @student_batchs.delete(st_bt)
      # end
      # end
      # end
      # =end


      @code = @student_batchs.empty?

      if (!@student_batchs.empty?)
        @student_batchs.each do |student_batch|
          ydecision = YearlyDecision.find(:first, :conditions => "student_id = #{student.id} and school_year = #{student_batch.batch.get_batch_year} and batch_ids like '%#{student_batch.batch.id.to_s}%'")
          if (ydecision)
            @resultats[student.id][student_batch.batch.course.code] = ydecision.avg_year
            if (student_batch.batch.course.code == 'SM03')
              @note_s3 = ydecision.avg_year
            end
          else
            bts = []
            bts << student_batch.batch
            @resultats[student.id][student_batch.batch.course.code] = SchoolModule.average_of_year(bts, student.id, student_batch.batch.get_batch_year)
            if (student_batch.batch.course.code == 'SM03')
              @note_s3 = SchoolModule.average_of_year(bts, student.id, student_batch.batch.get_batch_year)
            end
          end
        end
      end
      s5 = 0
      s6 = 0
      if (@resultats[student.id]['SM01'])
        @moyen_annee[student.id]['un'] = @resultats[student.id]['SM01']

        @semester_average[student.id]['S1'] = @resultats[student.id]['SM01']

      else
        @moyen_annee[student.id]['un'] = 0
      end
      if (@resultats[student.id]['SM02'])
        @moyen_annee[student.id]['un'] += @resultats[student.id]['SM02']

        @semester_average[student.id]['S2'] = @resultats[student.id]['SM02']

      else
        @moyen_annee[student.id]['un'] += 0
      end

      if (@resultats[student.id]['SM03'])
        @moyen_annee[student.id]['deux'] = @resultats[student.id]['SM03']

        @semester_average[student.id]['S3'] = @resultats[student.id]['SM03']

      else
        @moyen_annee[student.id]['deux'] = 0
      end
      if (@resultats[student.id]['SM04'])
        @moyen_annee[student.id]['deux'] += @resultats[student.id]['SM04']

        @semester_average[student.id]['S4'] = @resultats[student.id]['SM04']

      else
        @moyen_annee[student.id]['deux'] += 0
      end

      if (@resultats[student.id]['SM05'])
        s5 = 1
        @moyen_annee[student.id]['trois'] = @resultats[student.id]['SM05']

        @semester_average[student.id]['S5'] = @resultats[student.id]['SM05']

      else
        @moyen_annee[student.id]['trois'] = 0
      end
      if (@resultats[student.id]['SM06'])
        s6 = 1
        @moyen_annee[student.id]['trois'] += @resultats[student.id]['SM06']

        @semester_average[student.id]['S6'] = @resultats[student.id]['SM06']

      else
        @moyen_annee[student.id]['trois'] += 0
      end

      if s5 == 0 or s6 == 0
        ydecision = YearlyDecision.find(:first, :conditions => "student_id = #{student.id} and school_year = #{student.batch.get_batch_year} and batch_ids like '%#{student.batch.id.to_s}%'")
        if (ydecision)
          @code = false
          @resultats[student.id][student.batch.course.code] = ydecision.avg_year

        else
         @resultats[student.id][student.batch.course.code] = SchoolModule.average_of_semestre(student.batch, student.id, @school_year)
        end
        @resultats[student.id][student.batch.course.code]
        @semester_average[student.id]['S6'] = SchoolModule.average_of_semestre(student.batch, student.id, @school_year)
        @moyen_annee[student.id]['trois'] += @resultats[student.id][student.batch.course.code]
      end
      @moyen_diplome[student.id] = (0.25 * @moyen_annee[student.id]['un'] / 2) + (0.25 * @moyen_annee[student.id]['deux'] / 2) + (0.5 * @moyen_annee[student.id]['trois'] / 2)
      #@moyen_diplome[student.id] =  ((@moyen_annee[student.id]['un']) + (@moyen_annee[student.id]['deux']) + (2 *@moyen_annee[student.id]['trois']))/4

    end
    @students.sort! { |a, b| @moyen_diplome[b.id] <=> @moyen_diplome[a.id] }


    render(:update) do |page|
      page.replace_html 'show_student_diplome', :partial => 'show_student_diplome'
    end
  end

end

  def update_exam_form
    @batch = Batch.find(params[:batch])
    @name = params[:exam_option][:name]
    @type = params[:exam_option][:exam_type]
    @cce_exam_category_id = params[:exam_option][:cce_exam_category_id]
    @cce_exam_categories = CceExamCategory.all if @batch.cce_enabled?
    unless @name == ''
      @exam_group = ExamGroup.new
      @normal_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions => "no_exams = false AND elective_group_id IS NULL AND is_deleted = false")
      @elective_subjects = []
      elective_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions => "no_exams = false AND elective_group_id IS NOT NULL AND is_deleted = false")
      elective_subjects.each do |e|
        is_assigned = StudentsSubject.find_all_by_subject_id(e.id)
        unless is_assigned.empty?
          @elective_subjects.push e
        end
      end
      @all_subjects = @normal_subjects + @elective_subjects
      @all_subjects.each { |subject| @exam_group.exams.build(:subject_id => subject.id) }
      if @type == 'Marks' or @type == 'MarksAndGrades'
        render(:update) do |page|
          page.replace_html 'exam-form', :partial => 'exam_marks_form'
          page.replace_html 'flash', :text => ''
        end
      else
        render(:update) do |page|
          page.replace_html 'exam-form', :partial => 'exam_grade_form'
          page.replace_html 'flash', :text => ''
        end
      end

    else
      render(:update) do |page|
        page.replace_html 'flash', :text => "<div class='errorExplanation'><p>#{t('flash_msg9')}</p></div>"
      end
    end
  end

  def generate_code_exam_by_batch
    if params[:batch_id].to_s == "tous"
      @batches = Batch.find_all_by_course_id(params[:course_id]).select { |b| b.get_batch_year.to_i == params[:school_year.to_i] }
    else
      @batches = Batch.find_all_by_id(params[:batch_id])
    end
    @students = []
    @batches.each do |batch|
      @batch = batch
      if @batch.all_students.count > 0
        @students = @batch.all_students
      else
        @students = @batch.old_students
      end

      @students.each do |s|
        code = "#{s.id}#{rand.to_s[2..4]}#{batch.id}"
        CodeExam.create(:student_id => s.id, :batch_id => batch.id, :code => code.to_s)
      end
    end
    flash[:notice] = "les codes sont génereés"

    Exam.update(@exam.id, :is_published => true)
    redirect_to(:back)

  end

  def plannification_exams
  end

  def set_plannification
    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @course1 = params[:course_id]
    @batch_id = params[:batch_id]
    @tte_type = params[:tte_type_id]
    start_date = params[:start_date]
    end_date = params[:end_date]
    capacity_class = Batch.find(@batch_id).all_students.count
    @classrooms_avail1 = Classroom.all.select { |b| b.capacity_exam.to_i > capacity_class.to_i }
    @classrooms_avail2 = []
    @total = {}
    @ttes = TimetableEntry.all.reject { |tte| tte.day < start_date.to_date or tte.day > end_date.to_date or tte.tte_type_id != @tte_type.to_i }
    @ttes.each do |tt|
      @classrooms_avail2 << Classroom.find(tt.salle_id) unless tt.salle_id.nil?
    end
    @ttes.group_by { |batch| batch.day }.each do |day, tts|
      @total["#{day}"] = []
      tts.each do |tt|
        @total["#{day}"] << Classroom.find(tt.salle_id) unless tt.salle_id.nil?
      end
    end
    @total.each do |a, arrs|
      logger.debug arrs.inspect
      @total["#{a}"] = @classrooms_avail1 - @total["#{a}"]
      logger.debug arrs.inspect
    end
    logger.debug "**************************"
    logger.debug @ttes.count
    @classrooms_avail1 = @classrooms_avail1 - @classrooms_avail2
    @ttes2 = @ttes.select { |b| b.batch_id = @batch_id and tte_type_id = 6 }.group_by { |batch| batch.batch_id }
    @ttes = @ttes2
    logger.debug @ttes2.count
    logger.debug @total.inspect
    render(:update) do |page|
      page.replace_html 'exam-form', :partial => 'plan_exam'
    end
  end

  def publish
    @exam_group = ExamGroup.find(params[:id])
    @exams = @exam_group.exams
    @batch = @exam_group.batch
    @sms_setting_notice = ""
    @no_exam_notice = ""

    #unless @exams.empty?

    ExamGroup.update(@exam_group.id, :is_published => true) if params[:status] == "schedule"

    ExamGroup.update(@exam_group.id, :is_published => false) if params[:status] == "sch"
    #ExamGroup.update(@exam_group.id,:result_published=>true) if params[:status] == "result"
    #end
    if params[:is_group]
      exam_group = @exam_group
      module_group = ModuleGroup.find_by_school_year_and_course_id_and_school_module_id(exam_group.batch.get_batch_year, exam_group.batch.course.id, exam_group.module_id)
      if module_group
        module_group_batchs = ModuleGroupBatch.find_all_by_module_group_id(module_group.id).collect(&:batch_id)
        module_group_batchs.each do |mg|
          exg = ExamGroup.find_by_module_id_and_batch_id(exam_group.module_id, mg)
          if exg
            exg.update_attributes(:is_published => true) if params[:status] == "schedule"
            exg.update_attributes(:is_published => false) if params[:status] == "sch"
          end
        end
      end
    end
  end

  def grouping
    @batch = Batch.find(params[:id])
    @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
    @exam_groups.reject! { |e| e.exam_type == "Grades" }
    if request.post?
      unless params[:exam_grouping].nil?
        unless params[:exam_grouping][:exam_group_ids].nil?
          weightages = params[:weightage]
          total = 0
          weightages.map { |w| total += w.to_f }
          unless total == "100".to_f
            flash[:notice] = "#{t('flash9')}"
            return
          else
            GroupedExam.delete_all(:batch_id => @batch.id)
            exam_group_ids = params[:exam_grouping][:exam_group_ids]
            exam_group_ids.each_with_index do |e, i|
              GroupedExam.create(:exam_group_id => e, :batch_id => @batch.id, :weightage => weightages[i])
            end
          end
        end
      else
        GroupedExam.delete_all(:batch_id => @batch.id)
      end
      flash[:notice] = "#{t('flash1')}"
    end
  end

  #REPORTS

  def list_batch_groups
    unless params[:course_id] == ""
      @batch_groups = BatchGroup.find_all_by_course_id(params[:course_id])
      if @batch_groups.empty?
        render(:update) do |page|
          page.replace_html "batch_group_list", :text => ""
        end
      else
        render(:update) do |page|
          page.replace_html "batch_group_list", :partial => "select_batch_group"
        end
      end
    else
      render(:update) do |page|
        page.replace_html "batch_group_list", :text => ""
      end
    end
  end

  def generate_previous_reports
    if request.post?
      unless params[:report][:batch_ids].blank?
        @batches = Batch.find_all_by_id(params[:report][:batch_ids])
        @batches.each do |batch|
          batch.job_type = "2"
          Delayed::Job.enqueue(batch)
        end
        flash[:notice] = "Report generation in queue for batches #{@batches.collect(&:full_name).join(", ")}. <a href='/scheduled_jobs/Batch/2'>Click Here</a> to view the scheduled job."
      else
        flash[:notice] = "#{t('flash11')}"
        return
      end
    end
  end

  def select_inactive_batches
    unless params[:course_id] == ""
      @batches = Batch.find(:all, :conditions => { :course_id => params[:course_id], :is_active => false, :is_deleted => :false })
      if @batches.empty?
        render(:update) do |page|
          page.replace_html "select_inactive_batches", :text => "<p class='flash-msg'>#{t('exam.flash12')}</p>"
        end
      else
        render(:update) do |page|
          page.replace_html "select_inactive_batches", :partial => "inactive_batch_list"
        end
      end
    else
      render(:update) do |page|
        page.replace_html "select_inactive_batches", :text => ""
      end
    end
  end

  def generate_reports
    if request.post?
      unless !params[:report][:course_id].present? or params[:report][:course_id] == ""
        @course = Course.find(params[:report][:course_id])
        if @course.has_batch_groups_with_active_batches
          unless !params[:report][:batch_group_id].present? or params[:report][:batch_group_id] == ""
            @batch_group = BatchGroup.find(params[:report][:batch_group_id])
            @batches = @batch_group.batches
          end
        else
          @batches = @course.active_batches
        end
      end
      if @batches
        @batches.each do |batch|
          batch.job_type = "1"
          Delayed::Job.enqueue(batch)
        end
        flash[:notice] = "Report generation in queue for batches #{@batches.collect(&:full_name).join(", ")}. <a href='/scheduled_jobs/Batch/1'>Click Here</a> to view the scheduled job."
      else
        flash[:notice] = "#{t('flash11')}"
        return
      end
    end
  end

  def exam_wise_report
    @batches = Batch.active
    @exam_groups = []
  end

  def list_exam_types
    batch = Batch.find(params[:batch_id])
    @exam_groups = ExamGroup.find_all_by_batch_id(batch.id)
    render(:update) do |page|
      page.replace_html 'exam-group-select', :partial => 'exam_group_select'
    end
  end

  def generated_report
    if params[:student].nil?
      if params[:exam_report].nil? or params[:exam_report][:exam_group_id].empty?
        flash[:notice] = "#{t('flash2')}"
        redirect_to :action => 'exam_wise_report' and return
      end
    else
      if params[:exam_group].nil?
        flash[:notice] = "#{t('flash3')}"
        redirect_to :action => 'exam_wise_report' and return
      end
    end
    if params[:student].nil?
      @exam_group = ExamGroup.find(params[:exam_report][:exam_group_id])
      @batch = @exam_group.batch
      @students = @batch.students.by_first_name
      @student = @students.first unless @students.empty?
      if @student.nil?
        flash[:notice] = "#{t('flash_student_notice')}"
        redirect_to :action => 'exam_wise_report' and return
      end
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions => "elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id, :conditions => "batch_id = #{@batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
      @exams = []
      @subjects.each do |sub|
        exam = Exam.find_by_exam_group_id_and_subject_id(@exam_group.id, sub.id)
        @exams.push exam unless exam.nil?
      end
      @graph = open_flash_chart_object(770, 350,
                                       "/exam/graph_for_generated_report?batch=#{@student.batch.id}&examgroup=#{@exam_group.id}&student=#{@student.id}")
    else
      @exam_group = ExamGroup.find(params[:exam_group])
      @student = Student.find_by_id(params[:student])
      @batch = @student.batch
      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions => "elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id, :conditions => "batch_id = #{@student.batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
      @exams = []
      @subjects.each do |sub|
        exam = Exam.find_by_exam_group_id_and_subject_id(@exam_group.id, sub.id)
        @exams.push exam unless exam.nil?
      end
      @graph = open_flash_chart_object(770, 350,
                                       "/exam/graph_for_generated_report?batch=#{@student.batch.id}&examgroup=#{@exam_group.id}&student=#{@student.id}")
      if request.xhr?
        render(:update) do |page|
          page.replace_html 'exam_wise_report', :partial => "exam_wise_report"
        end
      else
        @students = Student.find_all_by_id(params[:student])
      end
    end
  end

  def generated_report_pdf
    @config = Configuration.get_config_value('InstitutionName')
    @exam_group = ExamGroup.find(params[:exam_group])
    @batch = Batch.find(params[:batch])
    @students = @batch.students.by_first_name
    render :pdf => 'generated_report_pdf'
  end

  def consolidated_exam_report
    @exam_group = ExamGroup.find(params[:exam_group])
    @batch = @exam_group.batch
  end

  def consolidated_exam_report_pdf
    @exam_group = ExamGroup.find(params[:exam_group])
    @batch = @exam_group.batch
    render :pdf => 'consolidated_exam_report_pdf',
           :page_size => 'A3'
    #        respond_to do |format|
    #            format.pdf { render :layout => false }
    #        end
  end

  def subject_rank
    @batches = Batch.active
    @subjects = []
  end

  def list_batch_subjects
    @subjects = Subject.find_all_by_batch_id(params[:batch_id], :conditions => "is_deleted=false")
    render(:update) do |page|
      page.replace_html 'subject-select', :partial => 'rank_subject_select'
    end
  end

  def student_subject_rank
    unless params[:rank_report][:subject_id] == ""
      @subject = Subject.find(params[:rank_report][:subject_id])
      @batch = @subject.batch
      @students = @batch.students.by_first_name
      unless @subject.elective_group_id.nil?
        @students.reject! { |s| !StudentsSubject.exists?(:student_id => s.id, :subject_id => @subject.id) }
      end
      @exam_groups = ExamGroup.find(:all, :conditions => { :batch_id => @batch.id })
      @exam_groups.reject! { |e| e.exam_type == "Grades" }
    else
      flash[:notice] = "#{t('flash4')}"
      redirect_to :action => 'subject_rank'
    end
  end

  def student_subject_rank_pdf
    @subject = Subject.find(params[:subject_id])
    @batch = @subject.batch
    @students = @batch.students.by_first_name
    unless @subject.elective_group_id.nil?
      @students.reject! { |s| !StudentsSubject.exists?(:student_id => s.id, :subject_id => @subject.id) }
    end
    @exam_groups = ExamGroup.find(:all, :conditions => { :batch_id => @batch.id })
    @exam_groups.reject! { |e| e.exam_type == "Grades" }
    render :pdf => 'student_subject_rank_pdf'
  end

  def subject_wise_report
    @batches = Batch.active
    @subjects = []
  end

  def list_subjects
    @subjects = Subject.find_all_by_batch_id(params[:batch_id], :conditions => "is_deleted=false")
    render(:update) do |page|
      page.replace_html 'subject-select', :partial => 'subject_select'
    end
  end

  def generated_report2
    #subject-wise-report-for-batch
    unless params[:exam_report][:subject_id] == ""
      @subject = Subject.find(params[:exam_report][:subject_id])
      @batch = @subject.batch
      @students = @batch.students
      @exam_groups = ExamGroup.find(:all, :conditions => { :batch_id => @batch.id })
    else
      flash[:notice] = "#{t('flash4')}"
      redirect_to :action => 'subject_wise_report'
    end
  end

  def generated_report2_pdf
    #subject-wise-report-for-batch
    @subject = Subject.find(params[:subject_id])
    @batch = @subject.batch
    @students = @batch.students
    @exam_groups = ExamGroup.find(:all, :conditions => { :batch_id => @batch.id })
    render :pdf => 'generated_report_pdf'

    #        respond_to do |format|
    #            format.pdf { render :layout => false }
    #        end
  end

  def student_batch_rank
    if params[:batch_rank].nil? or params[:batch_rank][:batch_id].empty?
      flash[:notice] = "#{t('select_a_batch_to_continue')}"
      redirect_to :action => 'batch_rank' and return
    else
      @batch = Batch.find(params[:batch_rank][:batch_id])
      @students = Student.find_all_by_batch_id(@batch.id)
      @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
      @ranked_students = @batch.find_batch_rank
    end
  end

  def student_batch_rank_pdf
    @batch = Batch.find(params[:batch_id])
    @students = Student.find_all_by_batch_id(@batch.id)
    @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
    @ranked_students = @batch.find_batch_rank
    render :pdf => "student_batch_rank_pdf"
  end

  def course_rank
  end

  def batch_groups
    unless params[:course_id] == ""
      @course = Course.find(params[:course_id])
      if @course.has_batch_groups_with_active_batches
        @batch_groups = BatchGroup.find_all_by_course_id(params[:course_id])
        render(:update) do |page|
          page.replace_html "batch_group_list", :partial => "batch_groups"
        end
      else
        render(:update) do |page|
          page.replace_html "batch_group_list", :text => ""
        end
      end
    else
      render(:update) do |page|
        page.replace_html "batch_group_list", :text => ""
      end
    end
  end

  def student_course_rank
    if params[:course_rank].nil? or params[:course_rank][:course_id] == ""
      flash[:notice] = "#{t('flash13')}"
      redirect_to :action => 'course_rank' and return
    else
      @course = Course.find(params[:course_rank][:course_id])
      if @course.has_batch_groups_with_active_batches and (!params[:course_rank][:batch_group_id].present? or params[:course_rank][:batch_group_id] == "")
        flash[:notice] = "#{t('flash14')}"
        redirect_to :action => 'course_rank' and return
      else
        if @course.has_batch_groups_with_active_batches
          @batch_group = BatchGroup.find(params[:course_rank][:batch_group_id])
          @batches = @batch_group.batches
        else
          @batches = @course.active_batches
        end
        @students = Student.find_all_by_batch_id(@batches)
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batches)
        @sort_order = ""
        unless !params[:sort_order].present?
          @sort_order = params[:sort_order]
        end
        @ranked_students = @course.find_course_rank(@batches.collect(&:id), @sort_order).paginate(:page => params[:page], :per_page => 25)
      end
    end
  end

  def student_course_rank_pdf
    @course = Course.find(params[:course_id])
    if @course.has_batch_groups_with_active_batches
      @batch_group = BatchGroup.find(params[:batch_group_id])
      @batches = @batch_group.batches
    else
      @batches = @course.active_batches
    end
    @students = Student.find_all_by_batch_id(@batches)
    @grouped_exams = GroupedExam.find_all_by_batch_id(@batches)
    @sort_order = ""
    unless !params[:sort_order].present?
      @sort_order = params[:sort_order]
    end
    @ranked_students = @course.find_course_rank(@batches.collect(&:id), @sort_order)
    render :pdf => "student_course_rank_pdf"
  end

  def manage_diplome
    @school_fields = SchoolField.find(:all)
    @courses = Course.find(:all)
    @course_groups = @courses.group_by { |course| course.course_name }
    @group = []
    @course_groups.each do |key, value|
      chaine = ""
      @course_groups[key].each do |course|
        chaine += course.id.to_s + ','
      end
      chaine += '0'
      @group << [key, chaine]
    end

  end

  def student_school_rank
    @courses = Course.all(:conditions => { :is_deleted => false })
    @batches = Batch.all(:conditions => { :course_id => @courses, :is_deleted => false, :is_active => true })
    @students = Student.find_all_by_batch_id(@batches)
    @grouped_exams = GroupedExam.find_all_by_batch_id(@batches)
    @sort_order = ""
    unless !params[:sort_order].present?
      @sort_order = params[:sort_order]
    end
    unless @courses.empty?
      @ranked_students = @courses.first.find_course_rank(@batches.collect(&:id), @sort_order).paginate(:page => params[:page], :per_page => 25)
    else
      @ranked_students = []
    end
  end

  def student_school_rank_pdf
    @courses = Course.all(:conditions => { :is_deleted => false })
    @batches = Batch.all(:conditions => { :course_id => @courses, :is_deleted => false, :is_active => true })
    @students = Student.find_all_by_batch_id(@batches)
    @grouped_exams = GroupedExam.find_all_by_batch_id(@batches)
    @sort_order = ""
    unless !params[:sort_order].present?
      @sort_order = params[:sort_order]
    end
    unless @courses.empty?
      @ranked_students = @courses.first.find_course_rank(@batches.collect(&:id), @sort_order)
    else
      @ranked_students = []
    end
    render :pdf => "student_school_rank_pdf"
  end

  def student_attendance_rank
    if params[:attendance_rank].nil? or params[:attendance_rank][:batch_id].empty?
      flash[:notice] = "#{t('select_a_batch_to_continue')}"
      redirect_to :action => 'attendance_rank' and return
    else
      if params[:attendance_rank][:start_date].to_date > params[:attendance_rank][:end_date].to_date
        flash[:notice] = "#{t('flash15')}"
        redirect_to :action => 'attendance_rank' and return
      else
        @batch = Batch.find(params[:attendance_rank][:batch_id])
        @students = Student.find_all_by_batch_id(@batch.id)
        @start_date = params[:attendance_rank][:start_date].to_date
        @end_date = params[:attendance_rank][:end_date].to_date
        @ranked_students = @batch.find_attendance_rank(@start_date, @end_date)
      end
    end
  end

  def student_attendance_rank_pdf
    @batch = Batch.find(params[:batch_id])
    @students = Student.find_all_by_batch_id(@batch.id)
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @ranked_students = @batch.find_attendance_rank(@start_date, @end_date)
    render :pdf => "student_attendance_rank_pdf"
  end

  def ranking_level_report
  end

  def select_mode
    unless params[:mode].nil? or params[:mode] == ""
      if params[:mode] == "batch"
        @batches = Batch.active
        render(:update) do |page|
          page.replace_html "course-batch", :partial => "batch_select"
        end
      else
        @courses = Course.active
        render(:update) do |page|
          page.replace_html "course-batch", :partial => "course_select"
        end
      end
    else
      render(:update) do |page|
        page.replace_html "course-batch", :text => ""
      end
    end
  end

  def select_batch_group
    unless params[:course_id].nil? or params[:course_id] == ""
      @course = Course.find(params[:course_id])
      if @course.has_batch_groups_with_active_batches
        @batch_groups = BatchGroup.find_all_by_course_id(params[:course_id])
      end
      @ranking_levels = RankingLevel.find_all_by_course_id(params[:course_id])
      render(:update) do |page|
        page.replace_html "batch_groups", :partial => "report_batch_groups"
      end
    else
      render(:update) do |page|
        page.replace_html "batch_groups", :text => ""
      end
    end
  end

  def select_type
    unless params[:report_type].nil? or params[:report_type] == "" or params[:report_type] == "overall"
      unless params[:batch_id].nil? or params[:batch_id] == ""
        @batch = Batch.find(params[:batch_id])
        @subjects = Subject.find(:all, :conditions => { :batch_id => @batch.id, :is_deleted => false })
        render(:update) do |page|
          page.replace_html "subject-select", :partial => "subject_list"
        end
      else
        render(:update) do |page|
          page.replace_html "subject-select", :text => ""
        end
      end
    else
      render(:update) do |page|
        page.replace_html "subject-select", :text => ""
      end
    end
  end

  def student_ranking_level_report
    if params[:ranking_level_report].nil? or params[:ranking_level_report][:mode] == ""
      flash[:notice] = "#{t('flash16')}"
      redirect_to :action => "ranking_level_report" and return
    else
      @mode = params[:ranking_level_report][:mode]
      if params[:ranking_level_report][:mode] == "batch"
        if params[:ranking_level_report][:batch_id] == ""
          flash[:notice] = "#{t('select_a_batch_to_continue')}"
          redirect_to :action => "ranking_level_report" and return
        else
          @batch = Batch.find(params[:ranking_level_report][:batch_id])
          if params[:ranking_level_report].nil? or params[:ranking_level_report][:ranking_level_id] == ""
            flash[:notice] = "#{t('flash17')}"
            redirect_to :action => "ranking_level_report" and return
          elsif params[:ranking_level_report][:report_type] == ""
            flash[:notice] = "#{t('flash18')}"
            redirect_to :action => "ranking_level_report" and return
          else
            @ranking_level = RankingLevel.find(params[:ranking_level_report][:ranking_level_id])
            @report_type = params[:ranking_level_report][:report_type]
            if params[:ranking_level_report][:report_type] == "subject"
              if params[:ranking_level_report][:subject_id] == ""
                flash[:notice] = "#{t('flash4')}."
                redirect_to :action => "ranking_level_report" and return
              else
                @students = @batch.students(:conditions => { :is_active => true, :is_deleted => true })
                @subject = Subject.find(params[:ranking_level_report][:subject_id])
                @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :batch_id => @batch.id, :subject_id => @subject.id, :score_type => "s" })
                unless @scores.empty?
                  if @batch.gpa_enabled?
                    @scores.reject! { |s| !((s.marks < @ranking_level.gpa if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.gpa if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.gpa if @ranking_level.marks_limit_type == "exact")) }
                  else
                    @scores.reject! { |s| !((s.marks < @ranking_level.marks if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.marks if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.marks if @ranking_level.marks_limit_type == "exact")) }
                  end
                else
                  flash[:notice] = "#{t('flash19')}"
                  redirect_to :action => "ranking_level_report" and return
                end
              end
            else
              @students = @batch.students(:conditions => { :is_active => true, :is_deleted => true })
              unless @ranking_level.subject_count.nil?
                unless @ranking_level.full_course == true
                  @subjects = @batch.subjects
                  @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :batch_id => @batch.id, :subject_id => @subjects.collect(&:id), :score_type => "s" })
                else
                  @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :score_type => "s" })
                end
                unless @scores.empty?
                  if @batch.gpa_enabled?
                    @scores.reject! { |s| !((s.marks < @ranking_level.gpa if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.gpa if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.gpa if @ranking_level.marks_limit_type == "exact")) }
                  else
                    @scores.reject! { |s| !((s.marks < @ranking_level.marks if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.marks if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.marks if @ranking_level.marks_limit_type == "exact")) }
                  end
                else
                  flash[:notice] = "#{t('flash19')}"
                  redirect_to :action => "ranking_level_report" and return
                end
              else
                unless @ranking_level.full_course == true
                  @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :batch_id => @batch.id, :score_type => "c" })
                else
                  @scores = []
                  @students.each do |student|
                    total_student_score = 0
                    avg_student_score = 0
                    marks = GroupedExamReport.find_all_by_student_id_and_score_type(student.id, "c")
                    unless marks.empty?
                      marks.map { |m| total_student_score += m.marks }
                      avg_student_score = total_student_score.to_f / marks.count.to_f
                      marks.first.marks = avg_student_score
                      @scores.push marks.first
                    end
                  end
                end
                unless @scores.empty?
                  if @batch.gpa_enabled?
                    @scores.reject! { |s| !((s.marks < @ranking_level.gpa if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.gpa if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.gpa if @ranking_level.marks_limit_type == "exact")) }
                  else
                    @scores.reject! { |s| !((s.marks < @ranking_level.marks if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.marks if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.marks if @ranking_level.marks_limit_type == "exact")) }
                  end
                else
                  flash[:notice] = "#{t('flash19')}"
                  redirect_to :action => "ranking_level_report" and return
                end
              end
            end
          end
        end
      else
        if params[:ranking_level_report][:course_id] == ""
          flash[:notice] = "#{t('flash13')}"
          redirect_to :action => "ranking_level_report" and return
        else
          @course = Course.find(params[:ranking_level_report][:course_id])
          if @course.has_batch_groups_with_active_batches and (!params[:ranking_level_report][:batch_group_id].present? or params[:ranking_level_report][:batch_group_id] == "")
            flash[:notice] = "#{t('flash14')}"
            redirect_to :action => "ranking_level_report" and return
          elsif params[:ranking_level_report].nil? or params[:ranking_level_report][:ranking_level_id] == ""
            flash[:notice] = "#{t('flash17')}"
            redirect_to :action => "ranking_level_report" and return
          else
            @ranking_level = RankingLevel.find(params[:ranking_level_report][:ranking_level_id])
            if @course.has_batch_groups_with_active_batches
              @batch_group = BatchGroup.find(params[:ranking_level_report][:batch_group_id])
              @batches = @batch_group.batches
            else
              @batches = @course.active_batches
            end
            @students = Student.find_all_by_batch_id(@batches.collect(&:id))
            unless @ranking_level.subject_count.nil?
              @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :score_type => "s" })
            else
              unless @ranking_level.full_course == true
                @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :score_type => "c" })
              else
                @scores = []
                @students.each do |student|
                  total_student_score = 0
                  avg_student_score = 0
                  marks = GroupedExamReport.find_all_by_student_id_and_score_type(student.id, "c")
                  unless marks.empty?
                    marks.map { |m| total_student_score += m.marks }
                    avg_student_score = total_student_score.to_f / marks.count.to_f
                    marks.first.marks = avg_student_score
                    @scores.push marks.first
                  end
                end
              end
            end
            unless @scores.empty?
              if @ranking_level.marks_limit_type == "upper"
                @scores.reject! { |s| !(((s.marks < @ranking_level.gpa unless @ranking_level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks < @ranking_level.marks unless @ranking_level.marks.nil?)) }
              elsif @ranking_level.marks_limit_type == "exact"
                @scores.reject! { |s| !(((s.marks == @ranking_level.gpa unless @ranking_level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks == @ranking_level.marks unless @ranking_level.marks.nil?)) }
              else
                @scores.reject! { |s| !(((s.marks >= @ranking_level.gpa unless @ranking_level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks >= @ranking_level.marks unless @ranking_level.marks.nil?)) }
              end
            else
              flash[:notice] = "#{t('flash20')}"
              redirect_to :action => "ranking_level_report" and return
            end
          end
        end
      end
    end
  end

  def student_ranking_level_report_pdf
    @ranking_level = RankingLevel.find(params[:ranking_level_id])
    @mode = params[:mode]
    if @mode == "batch"
      @batch = Batch.find(params[:batch_id])
      @report_type = params[:report_type]
      if @report_type == "subject"
        @students = @batch.students(:conditions => { :is_active => true, :is_deleted => true })
        @subject = Subject.find(params[:subject_id])
        @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :batch_id => @batch.id, :subject_id => @subject.id, :score_type => "s" })
        if @batch.gpa_enabled?
          @scores.reject! { |s| !((s.marks < @ranking_level.gpa if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.gpa if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.gpa if @ranking_level.marks_limit_type == "exact")) }
        else
          @scores.reject! { |s| !((s.marks < @ranking_level.marks if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.marks if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.marks if @ranking_level.marks_limit_type == "exact")) }
        end
      else
        @students = @batch.students(:conditions => { :is_active => true, :is_deleted => true })
        unless @ranking_level.subject_count.nil?
          unless @ranking_level.full_course == true
            @subjects = @batch.subjects
            @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :batch_id => @batch.id, :subject_id => @subjects.collect(&:id), :score_type => "s" })
          else
            @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :score_type => "s" })
          end
          if @batch.gpa_enabled?
            @scores.reject! { |s| !((s.marks < @ranking_level.gpa if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.gpa if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.gpa if @ranking_level.marks_limit_type == "exact")) }
          else
            @scores.reject! { |s| !((s.marks < @ranking_level.marks if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.marks if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.marks if @ranking_level.marks_limit_type == "exact")) }
          end
        else
          unless @ranking_level.full_course == true
            @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :batch_id => @batch.id, :score_type => "c" })
          else
            @scores = []
            @students.each do |student|
              total_student_score = 0
              avg_student_score = 0
              marks = GroupedExamReport.find_all_by_student_id_and_score_type(student.id, "c")
              unless marks.empty?
                marks.map { |m| total_student_score += m.marks }
                avg_student_score = total_student_score.to_f / marks.count.to_f
                marks.first.marks = avg_student_score
                @scores.push marks.first
              end
            end
          end
          if @batch.gpa_enabled?
            @scores.reject! { |s| !((s.marks < @ranking_level.gpa if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.gpa if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.gpa if @ranking_level.marks_limit_type == "exact")) }
          else
            @scores.reject! { |s| !((s.marks < @ranking_level.marks if @ranking_level.marks_limit_type == "upper") or (s.marks >= @ranking_level.marks if @ranking_level.marks_limit_type == "lower") or (s.marks == @ranking_level.marks if @ranking_level.marks_limit_type == "exact")) }
          end
        end
      end
    else
      @course = Course.find(params[:course_id])
      if @course.has_batch_groups_with_active_batches
        @batch_group = BatchGroup.find(params[:batch_group_id])
        @batches = @batch_group.batches
      else
        @batches = @course.active_batches
      end
      @students = Student.find_all_by_batch_id(@batches.collect(&:id))
      unless @ranking_level.subject_count.nil?
        @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :score_type => "s" })
      else
        unless @ranking_level.full_course == true
          @scores = GroupedExamReport.find(:all, :conditions => { :student_id => @students.collect(&:id), :score_type => "c" })
        else
          @scores = []
          @students.each do |student|
            total_student_score = 0
            avg_student_score = 0
            marks = GroupedExamReport.find_all_by_student_id_and_score_type(student.id, "c")
            unless marks.empty?
              marks.map { |m| total_student_score += m.marks }
              avg_student_score = total_student_score.to_f / marks.count.to_f
              marks.first.marks = avg_student_score
              @scores.push marks.first
            end
          end
        end
      end
      if @ranking_level.marks_limit_type == "upper"
        @scores.reject! { |s| !(((s.marks < @ranking_level.gpa unless @ranking_level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks < @ranking_level.marks unless @ranking_level.marks.nil?)) }
      elsif @ranking_level.marks_limit_type == "exact"
        @scores.reject! { |s| !(((s.marks == @ranking_level.gpa unless @ranking_level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks == @ranking_level.marks unless @ranking_level.marks.nil?)) }
      else
        @scores.reject! { |s| !(((s.marks >= @ranking_level.gpa unless @ranking_level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks >= @ranking_level.marks unless @ranking_level.marks.nil?)) }
      end
    end
    render :pdf => "student_ranking_level_report_pdf"
  end

  def transcript
    @batches = Batch.active
  end

  def student_transcript
    if params[:transcript].nil? or params[:transcript][:student_id] == ""
      flash[:notice] = "#{t('flash21')}"
      redirect_to :action => "transcript" and return
    else
      @batch = Batch.find(params[:transcript][:batch_id])
      if params[:flag].present? and params[:flag] == "1"
        @students = Student.find_all_by_id(params[:student_id])
        if @students.empty?
          @students = ArchivedStudent.find_all_by_former_id(params[:student_id])
          @students.each do |student|
            student.id = student.former_id
          end
        end
        @flag = "1"
      else
        @students = @batch.students.by_first_name
      end
      unless @students.empty?
        unless !params[:student_id].present? or params[:student_id].nil?
          @student = Student.find_by_id(params[:student_id])
          if @student.nil?
            @student = ArchivedStudent.find_by_former_id(params[:student_id])
            @student.id = @student.former_id
          end
        else
          @student = @students.first
        end
        @grade_type = @batch.grading_type
        batch_ids = BatchStudent.find_all_by_student_id(@student.id).map { |b| b.batch_id }
        batch_ids << @batch.id
        @batches = Batch.find_all_by_id(batch_ids)
      else
        flash[:notice] = "No Students in this Batch."
        redirect_to :action => "transcript" and return
      end
    end
  end

  def student_transcript_pdf
    @student = Student.find_by_id(params[:student_id])
    if @student.nil?
      @student = ArchivedStudent.find_by_former_id(params[:student_id])
      @student.id = @student.former_id
    end
    @batch = @student.batch
    @grade_type = @batch.grading_type
    batch_ids = BatchStudent.find_all_by_student_id(@student.id).map { |b| b.batch_id }
    batch_ids << @batch.id
    @batches = Batch.find_all_by_id(batch_ids)
    render :pdf => "student_transcript_pdf"
  end

  def load_batch_students
    unless params[:id].nil? or params[:id] == ""
      @batch = Batch.find(params[:id])
      @students = @batch.students.by_first_name
    else
      @students = []
    end
    render(:update) do |page|
      page.replace_html "student_selection", :partial => "student_selection"
    end
  end

  def combined_report
    @batches = Batch.active
  end

  def load_levels
    unless params[:batch_id] == ""
      @batch = Batch.find(params[:batch_id])
      @course = @batch.course
      @class_designations = @course.class_designations.all
      @ranking_levels = @course.ranking_levels.all.reject { |r| !(r.full_course == false) }
      render(:update) do |page|
        page.replace_html "levels", :partial => "levels"
      end
    else
      render(:update) do |page|
        page.replace_html "levels", :text => ""
      end
    end
  end

  def student_combined_report
    if params[:combined_report][:batch_id] == "" or (params[:combined_report][:designation_ids].blank? and params[:combined_report][:level_ids].blank?)
      flash[:notice] = "#{t('flash22')}"
      redirect_to :action => "combined_report" and return
    else
      @batch = Batch.find(params[:combined_report][:batch_id])
      @students = @batch.students
      unless params[:combined_report][:designation_ids].blank?
        @designations = ClassDesignation.find_all_by_id(params[:combined_report][:designation_ids])
      end
      unless params[:combined_report][:level_ids].blank?
        @levels = RankingLevel.find_all_by_id(params[:combined_report][:level_ids])
      end
    end
  end

  def student_combined_report_pdf
    @batch = Batch.find(params[:batch_id])
    @students = @batch.students
    unless params[:designations].blank?
      @designations = ClassDesignation.find_all_by_id(params[:designations])
    end
    unless params[:levels].blank?
      @levels = RankingLevel.find_all_by_id(params[:levels])
    end
    render :pdf => "student_combined_report_pdf" #, :show_as_html=>true
  end

  def select_report_type
    unless params[:batch_id].nil? or params[:batch_id] == ""
      @batch = Batch.find(params[:batch_id])
      @ranking_levels = RankingLevel.find_all_by_course_id(@batch.course_id)
      render(:update) do |page|
        page.replace_html "report_type_select", :partial => "report_type_select"
      end
    else
      render(:update) do |page|
        page.replace_html "report_type_select", :text => ""
      end
    end
  end

  def generated_report3
    #student-subject-wise-report
    @student = Student.find(params[:student])
    @batch = @student.batch
    @subject = Subject.find(params[:subject])
    @exam_groups = ExamGroup.find(:all, :conditions => { :batch_id => @batch.id })
    @exam_groups.reject! { |e| e.result_published == false }
    @graph = open_flash_chart_object(770, 350,
                                     "/exam/graph_for_generated_report3?subject=#{@subject.id}&student=#{@student.id}")
  end

  def final_report_type
    batch = Batch.find(params[:batch_id])
    @grouped_exams = GroupedExam.find_all_by_batch_id(batch.id)
    render(:update) do |page|
      page.replace_html 'report_type', :partial => 'report_type'
    end
  end

  def generated_report4
    if params[:student].nil?
      if params[:exam_report].nil? or params[:exam_report][:batch_id].empty?
        flash[:notice] = "#{t('select_a_batch_to_continue')}"
        redirect_to :action => 'grouped_exam_report' and return
      end
    else
      if params[:type].nil?
        flash[:notice] = "#{t('invalid_parameters')}"
        redirect_to :action => 'grouped_exam_report' and return
      end
    end
    #grouped-exam-report-for-batch
    if params[:student].nil?
      @type = params[:type]
      @batch = Batch.find(params[:exam_report][:batch_id])
      @students = @batch.students.by_first_name
      @student = @students.first unless @students.empty?
      if @student.blank?
        flash[:notice] = "#{t('flash5')}"
        redirect_to :action => 'grouped_exam_report' and return
      end
      if @type == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
        @exam_groups = []
        @grouped_exams.each do |x|
          @exam_groups.push ExamGroup.find(x.exam_group_id)
        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
        @exam_groups.reject! { |e| e.result_published == false }
      end
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions => "elective_group_id IS NULL AND is_deleted=false")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id, :conditions => "batch_id = #{@batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
      @subjects.reject! { |s| s.no_exams == true }
      exams = Exam.find_all_by_exam_group_id(@exam_groups.collect(&:id))
      subject_ids = exams.collect(&:subject_id)
      @subjects.reject! { |sub| !(subject_ids.include?(sub.id)) }
    else
      @student = Student.find(params[:student])
      @batch = @student.batch
      @type = params[:type]
      if params[:type] == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
        @exam_groups = []
        @grouped_exams.each do |x|
          @exam_groups.push ExamGroup.find(x.exam_group_id)
        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
        @exam_groups.reject! { |e| e.result_published == false }
      end
      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions => "elective_group_id IS NULL AND is_deleted=false")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id, :conditions => "batch_id = #{@student.batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
      @subjects.reject! { |s| s.no_exams == true }
      exams = Exam.find_all_by_exam_group_id(@exam_groups.collect(&:id))
      subject_ids = exams.collect(&:subject_id)
      @subjects.reject! { |sub| !(subject_ids.include?(sub.id)) }
      if request.xhr?
        render(:update) do |page|
          page.replace_html 'grouped_exam_report', :partial => "grouped_exam_report"
        end
      else
        @students = Student.find_all_by_id(params[:student])
      end
    end

  end

  def generated_report4_pdf
    #grouped-exam-report-for-batch
    if params[:student].nil?
      @type = params[:type]
      @batch = Batch.find(params[:exam_report][:batch_id])
      @student = @batch.students.first
      if @type == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
        @exam_groups = []
        @grouped_exams.each do |x|
          @exam_groups.push ExamGroup.find(x.exam_group_id)
        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
        @exam_groups.reject! { |e| e.result_published == false }
      end
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions => "elective_group_id IS NULL and is_deleted=false")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id, :conditions => "batch_id = #{@batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id, :conditions => { :is_deleted => false })
      end
      @subjects = general_subjects + elective_subjects
      @subjects.reject! { |s| s.no_exams == true }
      exams = Exam.find_all_by_exam_group_id(@exam_groups.collect(&:id))
      subject_ids = exams.collect(&:subject_id)
      @subjects.reject! { |sub| !(subject_ids.include?(sub.id)) }
    else
      @student = Student.find(params[:student])
      @batch = @student.batch
      @type = params[:type]
      if params[:type] == 'grouped'
        @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
        @exam_groups = []
        @grouped_exams.each do |x|
          @exam_groups.push ExamGroup.find(x.exam_group_id)
        end
      else
        @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
        @exam_groups.reject! { |e| e.result_published == false }
      end
      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions => "elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id, :conditions => "batch_id = #{@student.batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
      @subjects.reject! { |s| s.no_exams == true }
      exams = Exam.find_all_by_exam_group_id(@exam_groups.collect(&:id))
      subject_ids = exams.collect(&:subject_id)
      @subjects.reject! { |sub| !(subject_ids.include?(sub.id)) }
    end
    render :pdf => 'generated_report4_pdf',
           :orientation => 'Landscape'
    #    respond_to do |format|
    #      format.pdf { render :layout => false }
    #    end

  end

  def combined_grouped_exam_report_pdf
    @type = params[:type]
    @batch = Batch.find(params[:batch])
    @students = @batch.students.by_first_name
    if @type == 'grouped'
      @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
      @exam_groups = []
      @grouped_exams.each do |x|
        @exam_groups.push ExamGroup.find(x.exam_group_id)
      end
    else
      @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
      @exam_groups.reject! { |e| e.result_published == false }
    end
    render :pdf => 'combined_grouped_exam_report_pdf'
  end

  def previous_years_marks_overview
    @student = Student.find(params[:student])
    @all_batches = @student.all_batches
    @graph = open_flash_chart_object(770, 350,
                                     "/exam/graph_for_previous_years_marks_overview?student=#{params[:student]}&graphtype=#{params[:graphtype]}")
    respond_to do |format|
      format.pdf { render :layout => false }
      format.html
    end

  end

  def previous_years_marks_overview_pdf
    @student = Student.find(params[:student])
    @all_batches = @student.all_batches
    render :pdf => 'previous_years_marks_overview_pdf',
           :orientation => 'Landscape'

  end

  def academic_report
    #academic-archived-report
    @student = Student.find(params[:student])
    @batch = Batch.find(params[:year])
    if params[:type] == 'grouped'
      @grouped_exams = GroupedExam.find_all_by_batch_id(@batch.id)
      @exam_groups = []
      @grouped_exams.each do |x|
        @exam_groups.push ExamGroup.find(x.exam_group_id)
      end
    else
      @exam_groups = ExamGroup.find_all_by_batch_id(@batch.id)
    end
    general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions => "elective_group_id IS NULL and is_deleted=false and no_exams=false")
    student_electives = StudentsSubject.find_all_by_student_id(@student.id, :conditions => "batch_id = #{@batch.id}")
    elective_subjects = []
    student_electives.each do |elect|
      elective_subjects.push Subject.find(elect.subject_id)
    end
    @subjects = general_subjects + elective_subjects
  end

  def previous_batch_exams

  end

  def list_inactive_batches
    unless params[:course_id] == ""
      @batches = Batch.find(:all, :conditions => { :course_id => params[:course_id], :is_active => false, :is_deleted => false })
      render(:update) do |page|
        page.replace_html "inactive_batches", :partial => "inactive_batches"
      end
    else
      render(:update) do |page|
        page.replace_html "inactive_batches", :text => ""
      end
    end
  end

  def list_inactive_exam_groups
    unless params[:batch_id] == ""
      @exam_groups = ExamGroup.find(:all, :conditions => { :batch_id => params[:batch_id] })
      #@exam_groups.reject!{|e| !GroupedExam.exists?(:exam_group_id=>e.id,:batch_id=>params[:batch_id])}
      render(:update) do |page|
        page.replace_html "inactive_exam_groups", :partial => "inactive_exam_groups"
      end
    else
      render(:update) do |page|
        page.replace_html "inactive_exam_groups", :text => ""
      end
    end
  end

  def previous_exam_marks
    unless params[:exam_goup_id] == ""
      @exam_group = ExamGroup.find(params[:exam_group_id], :include => :exams)
      render(:update) do |page|
        page.replace_html "previous_exam_marks", :partial => "previous_exam_marks"
      end
    else
      render(:update) do |page|
        page.replace_html "previous_exam_marks", :text => ""
      end
    end
  end

  def edit_previous_marks
    @employee_subjects = []
    @employee_subjects = @current_user.employee_record.subjects.map { |n| n.id } if @current_user.employee?
    @exam = Exam.find params[:exam_id], :include => :exam_group
    @exam_group = @exam.exam_group
    @batch = @exam_group.batch
    unless @employee_subjects.include?(@exam.subject_id) or @current_user.admin? or @current_user.privileges.map { |p| p.name }.include?('ExaminationControl') or @current_user.privileges.map { |p| p.name }.include?('EnterResults')
      flash[:notice] = "#{t('flash_msg6')}"
      redirect_to :controller => "user", :action => "dashboard"
    end
    scores = ExamScore.find_all_by_exam_id(@exam.id)
    @students = []
    unless scores.empty?
      scores.each do |score|
        student = Student.find_by_id(score.student_id)
        @students.push [student.first_name, student.id, student] unless student.nil?
      end
    end
    @ordered_students = @students.sort
    @students = []
    @ordered_students.each do |s|
      @students.push s[2]
    end
    @config = Configuration.get_config_value('ExamResultType') || 'Marks'

    @grades = @batch.grading_level_list
  end

  def update_previous_marks
    @exam = Exam.find(params[:exam_id])
    @error = false
    params[:exam].each_pair do |student_id, details|
      exam_score = ExamScore.find(:first, :conditions => { :exam_id => @exam.id, :student_id => student_id })
      prev_score = ExamScore.find(:first, :conditions => { :exam_id => @exam.id, :student_id => student_id })
      unless exam_score.nil?
        unless details[:marks].to_f == exam_score.marks.to_f
          if (details[:marks].to_f <= @exam.maximum_marks.to_f and details[:marks_ar].to_f <= @exam.maximum_marks.to_f)
            if exam_score.update_attributes(details)
              PreviousExamScore.create(:student_id => prev_score.student_id, :exam_id => prev_score.exam_id, :marks => prev_score.marks, :grading_level_id => prev_score.grading_level_id, :remarks => prev_score.remarks, :is_failed => prev_score.is_failed)
            else
              flash[:warn_notice] = "#{t('flash8')}"
              @error = nil
            end
          else
            @error = true
          end
        end
      end
    end
    flash[:notice] = "#{t('flash6')}" if @error == true
    flash[:notice] = "#{t('flash7')}" if @error == false
    redirect_to :controller => "exam", :action => "edit_previous_marks", :exam_id => @exam.id
  end

  def create_exam
    privilege = current_user.privileges.map { |p| p.name }
    if current_user.admin or privilege.include?("ExaminationControl") or privilege.include?("EnterResults") or privilege.include?("ViewResults")
      @course = Course.find(:all, :conditions => { :is_deleted => false }, :order => 'code asc')
    elsif current_user.employee
      @course = current_user.employee_record.subjects.all(:group => 'batch_id').reject { |b| b.batch.nil? || b.batch.course.nil? }.map { |x| x.batch.course }.uniq { |p| p.id }
    end
  end

  def update_batch_ex_result
    @batch = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false, :is_active => true })

    render(:update) do |page|
      page.replace_html 'update_batch', :partial => 'update_batch_ex_result'
    end
  end

  def update_batch
    privilege = current_user.privileges.map { |p| p.name }
    @course_id = params[:course_name].to_i
    @school_year = params[:school_year]
    if current_user.employee and privilege.map { |p| p.name }.include?("Coordonateurfiliere")
        #@batch = current_user.employee_record.id)l(:group => 'batch_id').reject { |b| b.batch.nil? }.map { |x| x.batch }.reject { |n| n.course_id != @course_id }
        sfields = SchoolField.find_by_sql("select id from school_fields where employee_id=" + Employee.find_by_user_id(current_user.id).id.to_s)
        sfar = []
	temp_bats = [] 
       sfields.each do |sf|
          #logger.debug '*************************'+@students[0].batch.school_field_id.to_s+'hhhh'+ sf[:id].to_s
          sfar << sf[:id]
	  temp_bats += Batch.find_all_by_school_field_id_and_course_id(sf.id,@course_id)
        end
	@batch = temp_bats.uniq.reject { |b| b.get_batch_year != @school_year.to_i }
    elsif current_user.employee and !privilege.include?("ViewResults")
      @batch = current_user.employee_record.subjects.all(:group => 'batch_id').reject { |b| b.batch.nil? }.map { |x| x.batch }.reject { |n| n.course_id != @course_id }
      # @batch = @batch.reject {|n| n.is_active == false}
      @batch = @batch.reject { |b| b.get_batch_year < 2021 }
      @subject_group = current_user.employee_record.subjects.all(:group => 'subject_group_id').reject { |b| b.batch.nil? }.reject { |n| n.batch.course_id != @course_id }.map { |x| x.subject_group }
    else
      @batch = Batch.find_all_by_course_id(@course_id).select{|b| b.get_batch_year.to_i == @school_year.to_i} #, :conditions => { :is_deleted => false, :is_active => true })
    end
    render(:update) do |page|
      page.replace_html 'update_batch', :partial => 'update_batch'
    end

  end

  #GRAPHS

  def graph_for_generated_report
    student = Student.find(params[:student])
    examgroup = ExamGroup.find(params[:examgroup])
    batch = student.batch
    general_subjects = Subject.find_all_by_batch_id(batch.id, :conditions => "elective_group_id IS NULL")
    student_electives = StudentsSubject.find_all_by_student_id(student.id, :conditions => "batch_id = #{batch.id}")
    elective_subjects = []
    student_electives.each do |elect|
      elective_subjects.push Subject.find(elect.subject_id)
    end
    subjects = general_subjects + elective_subjects

    x_labels = []
    data = []
    data2 = []

    subjects.each do |s|
      exam = Exam.find_by_exam_group_id_and_subject_id(examgroup.id, s.id)
      res = ExamScore.find_by_exam_id_and_student_id(exam, student)
      unless res.nil?
        x_labels << s.code
        data << res.marks
        data2 << exam.class_average_marks
      end
    end

    bargraph = BarFilled.new()
    bargraph.width = 1;
    bargraph.colour = '#bb0000';
    bargraph.dot_size = 5;
    bargraph.text = "#{t('students_marks')}"
    bargraph.values = data

    bargraph2 = BarFilled.new
    bargraph2.width = 1;
    bargraph2.colour = '#5E4725';
    bargraph2.dot_size = 5;
    bargraph2.text = "#{t('class_average')}"
    bargraph2.values = data2

    x_axis = XAxis.new
    x_axis.labels = x_labels

    y_axis = YAxis.new
    y_axis.set_range(0, 100, 20)

    title = Title.new(student.full_name)

    x_legend = XLegend.new("#{t('subjects_text')}")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("#{t('marks')}")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.y_axis = y_axis
    chart.x_axis = x_axis
    chart.y_legend = y_legend
    chart.x_legend = x_legend

    chart.add_element(bargraph)
    chart.add_element(bargraph2)

    render :text => chart.render
  end

  def graph_for_generated_report3
    student = Student.find params[:student]
    subject = Subject.find params[:subject]
    exams = Exam.find_all_by_subject_id(subject.id, :order => 'start_time asc')
    exams.reject! { |e| e.exam_group.result_published == false }

    data = []
    x_labels = []

    exams.each do |e|
      exam_result = ExamScore.find_by_exam_id_and_student_id(e, student.id)
      unless exam_result.nil?
        data << exam_result.marks
        x_labels << XAxisLabel.new(exam_result.exam.exam_group.name, '#000000', 10, 0)
      end
    end

    x_axis = XAxis.new
    x_axis.labels = x_labels

    line = BarFilled.new

    line.width = 1
    line.colour = '#5E4725'
    line.dot_size = 5
    line.values = data

    y = YAxis.new
    y.set_range(0, 100, 20)

    title = Title.new(subject.name)

    x_legend = XLegend.new("#{t('examination_Name')}")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("#{t('marks')}")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
    chart.x_axis = x_axis

    chart.add_element(line)

    render :text => chart.to_s
  end

  def graph_for_previous_years_marks_overview
    student = Student.find(params[:student])

    x_labels = []
    data = []

    student.all_batches.each do |b|
      x_labels << b.name
      exam = ExamScore.new()
      data << exam.batch_wise_aggregate(student, b)
    end

    if params[:graphtype] == 'Line'
      line = Line.new
    else
      line = BarFilled.new
    end

    line.width = 1; line.colour = '#5E4725'; line.dot_size = 5; line.values = data

    x_axis = XAxis.new
    x_axis.labels = x_labels

    y_axis = YAxis.new
    y_axis.set_range(0, 100, 20)

    title = Title.new(student.full_name)

    x_legend = XLegend.new("#{t('academic_year')}")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("#{t('total_marks')}")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.y_axis = y_axis
    chart.x_axis = x_axis

    chart.add_element(line)

    render :text => chart.to_s
  end

  def student_marks

  end

  def deliberation
    if @current_user.admin?
      @school_fields = SchoolField.find(:all, :order => "name")
    else
      @school_fields = SchoolField.find(:all, :conditions => "employee_id = #{@current_user.employee_record.id}")
      if (@school_fields.length == 0)
        @school_fields = SchoolField.find_by_sql("select f.* from school_fields f,school_field_school_modules sf, school_modules sm where sf.school_module_id=sm.id and sf.school_field_id=f.id and sm.employee_id=#{@current_user.employee_record.id}")
        @school_fields = @school_fields.uniq { |x| x.id } #SchoolField.find(:all, :order => "name")
      end
    end
    @courses = Course.find(:all, :order => "code")

  end

  def select_batch
    @school_field_id = params[:school_field_id]
    @course_id = params[:course_id]
    @school_year = params[:school_year]
    @school_module_id = params[:school_module_id]
    @batches = Batch.find(:all, :conditions => "course_id = #{@course_id} and school_field_id = #{@school_field_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    render(:update) do |page|
      page.replace_html 'batch_selection', :partial => 'batch_selection'
    end
  end

  def select_batches
    @course_id = params[:course_id]
    @school_year = params[:school_year]

    @batches = Batch.find_all_by_course_id(@course_id).reject { |x| x.get_batch_year != @school_year.to_i }
    render(:update) do |page|
      if params[:all]
        page.replace_html 'batch_selection', :partial => 'batches_selection'

      else
        page.replace_html 'batch_selection', :partial => 'batch_selection'
      end
    end
  end

  def select_school_module
    @school_field_id = params[:school_field_id]
    @course_id = params[:course_id]
    @school_year = params[:school_year]
    @batch_id = params[:batch_id]
    if (@current_user.admin? or ((SchoolField.find(@school_field_id).employee_id.to_i) == (Employee.find_by_user_id(@current_user.id).id.to_i)))
      @sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course_id, :school_field_id => @school_field_id, :school_year => params[:school_year] })
    elsif @current_user.employee
      @employee = Employee.find(:first, :conditions => ["user_id=#{@current_user.id}"])
      @sf_sm = []
      @school_modules = SchoolModule.find(:all, :conditions => ["employee_id=#{@employee.id}"])
      @school_modules.each do |sm|
        @sf_sm += SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course_id, :school_field_id => @school_field_id, :school_year => params[:school_year], :school_module_id => sm.id })
      end
    end
    if (@course_id.to_s != '')
      batche = Batch.find(:all, :conditions => "course_id = #{@course_id} and school_field_id = #{@school_field_id} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").first
=begin  batche.students.each do |st|
        reserve_year_student = ReserveYearStudent.find(:first, :conditions => {:student_id => st.id , :school_year =>batche.get_batch_year})
        if(!reserve_year_student.nil?)
            reserve_year_student_details = ReserveYearStudentDetail.find(:all,:conditions => {:reserve_year_student_id => reserve_year_student.id })
            logger.debug '**************annee de reserve valider***********'
            if(!reserve_year_student_details.empty?)
                reserve_year_student_details.each do |ryd|
                    btr = Batch.find(ryd.batch_id)


                    if((!btr.nil?) and ((batche.course_id == 1 and btr.course_id == 1) or (batche.course_id == 2 and bta.course_id == 2) or (batche.course_id == 3 and bta.course_id == 3) or (batche.course_id == 4 and bta.course_id == 4)))
                        logger.debug '**************test valider***********'
                        if(batche.course_id == 1)
                        mod = SchoolFieldSchoolModule.find(:first, :conditions => {:course_id => 3, :school_field_id => @school_field_id, :school_year => params[:school_year], :school_module_id => ryd.school_module_id})
                        elsif (batche.course_id == 2)
                        mod = SchoolFieldSchoolModule.find(:first, :conditions => {:course_id => 4, :school_field_id => @school_field_id, :school_year => params[:school_year], :school_module_id => ryd.school_module_id})
                        elsif (batche.course_id == 3)
                        mod = SchoolFieldSchoolModule.find(:first, :conditions => {:course_id => 5, :school_field_id => @school_field_id, :school_year => params[:school_year], :school_module_id => ryd.school_module_id})
                        end
                        if(!mod.nil?)
                            @sf_sm << mod
                        end
                    end

                end
                end
            end
        end
=end
    end

    render(:update) do |page|
      page.replace_html 'school_module_selection', :partial => 'school_module_selection'
      #page.replace_html 'batch_selection', :text=>''
      page.replace_html 'students_modules_list', :text => ''
    end
  end
  def add_salle
  salle_id = params[:salle_id]
  tte_id = params[:tte_id]
  tte = TimetableEntry.find(tte_id)
  tte.update_attributes(:salle_ids => "#{tte.salle_ids}"+"#{salle_id},")
  slls = []
  liste_salle = ""
  slls = tte.salle_ids.split(",") unless tte.salle_ids.nil?
  slls.each do |sl|
  liste_salle = "#{liste_salle}"+"#{Classroom.find(sl).name},"
  end
  render(:update) do |page|
    page.replace_html "liste_salles_#{tte.id}", :text=>"#{liste_salle}"
  end
end
def add_surveillant
  employee_id = params[:employee_id]
  tte_id = params[:tte_id]
  tte = TimetableEntry.find(tte_id)
  if !(tte.employee_ids.split(",").include? employee_id)
      tte.update_attributes(:employee_ids => "#{tte.employee_ids}"+"#{employee_id},")
  end
  slls = []
  liste_salle = ""
  slls = tte.employee_ids.split(",") unless tte.employee_ids.nil?
  slls.each do |sl|
  liste_salle = "#{liste_salle}"+"#{Employee.find(sl).last_name},"
  end
  render(:update) do |page|
    page.replace_html "liste_employees_#{tte.id}", :text=>"#{liste_salle}"
  end
end

  def show_list_students
    tte_id = params[:tte_id]
    tte = TimetableEntry.find(tte_id)
    @slls = tte.salle_ids.split(",") unless tte.salle_ids.nil?
    if @slls.nil? 
      @slls = [tte.salle_id]
    end
    batch = Batch.find(tte.batch_id)
    count_students = batch.all_students.sort_by{|st| st.last_name}
    @total = {}
    range = 1
    count = 0
    @slls.each do |sl|
      @total["#{sl}"] = []
      salle = Classroom.find(sl)
  
        @total["#{sl}"]  = count_students[range..(range + salle.capacity_exam.to_i)]
        range = salle.capacity_exam.to_i +  2
  
    end
    logger.debug @total.inspect
    render :pdf=>'Liste_students'
  
  end
  def decharge
    tte_id = params[:tte_id]
    @tte = tte = TimetableEntry.find(tte_id)
    @tte_type = TimetableEntryType.find(tte.tte_type_id).name

    @slls = tte.salle_ids.split(",") unless tte.salle_ids.nil?
    if @slls.nil? 
      @slls = [tte.salle_id]
    end
    @batch = batch = Batch.find(tte.batch_id)
    count_students = batch.all_students.sort_by{|st| st.last_name}
    @total = {}
    range = 1
    count = 0
    @slls.each do |sl|
      @total["#{sl}"] = []
      salle = Classroom.find(sl)
  
        @total["#{sl}"]  = count_students[range..(range + salle.capacity_exam.to_i)]
        range = salle.capacity_exam.to_i +  2
  
    end
    @season = ''
    case tte.day.month
      when 12, 1, 2
        @season = "d'hiver"
      when 3, 4, 5
        @season = "du printemps"
      when 6, 7, 8
        @season = "d'été"
      else
        @season = "d'automne"
    end
    
    logger.debug @total.inspect
    render :pdf=>'Decharge_'
  
  end
  def pvsurveillance
    tte_id = params[:tte_id]
    @tte = tte = TimetableEntry.find(tte_id)
    @tte_type = TimetableEntryType.find(tte.tte_type_id).name

    @slls = tte.salle_ids.split(",") unless tte.salle_ids.nil?
    if @slls.nil? 
      @slls = [tte.salle_id]
    end
    @batch = batch = Batch.find(tte.batch_id)
    count_students = batch.all_students.sort_by{|st| st.last_name}
    @total = {}
    range = 1
    count = 0
    @slls.each do |sl|
      @total["#{sl}"] = []
      salle = Classroom.find(sl)
  
        @total["#{sl}"]  = count_students[range..(range + salle.capacity_exam.to_i)]
        range = salle.capacity_exam.to_i +  2
  
    end
    @employees = []
    begin 
       @employees << Employee.find(@tte.employee_id)
    rescue
      logger.debug "Employee #{@tte.employee_id} not found"
    end
    @tte.employee_ids.split(",").each do |eid|
      begin 
        @employees << Employee.find(eid)
      rescue
        logger.debug "Employee #{eid} not found"
      end
    end
    @employees = @employees.uniq
    @season = ''
    case tte.day.month
      when 12, 1, 2
        @season = "d'hiver"
      when 3, 4, 5
        @season = "du printemps"
      when 6, 7, 8
        @season = "d'été"
      else
        @season = "d'automne"
    end
    
    logger.debug @total.inspect
    render :pdf=>'Decharge_'
  
  end
  def show_students_all_marks_all

    @school_modules = []
    @resultas = []
    @school_field_id = params[:school_field_id]
    @course_ids = (params[:course_ids].gsub('%2C', ',')).split(",")
    @school_year = params[:school_year]
    @course_ids.each do |cr|
      @intem = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => cr.to_i, :school_field_id => @school_field_id, :school_year => params[:school_year] })
      if (@intem)
        @intem.each do |int|
          @school_modules << int.school_module_id
        end
      end
    end
    @batch = Batch.find(:all, :conditions => ["course_id=#{@course_ids[0]} and school_field_id=#{@school_field_id}"]).reject { |b| b.get_batch_year != @school_year.to_i }.first
    @batch2 = Batch.find(:all, :conditions => ["course_id=#{@course_ids[1]} and school_field_id=#{@school_field_id}"]).reject { |b| b.get_batch_year != @school_year.to_i }.first
    @students = Student.find_all_by_batch_id(@batch.id)
    if (!@students)
      @students = []
    end
    if @batch_id.nil?
      @batch_id = @batch.id
    end
    @students += Batch.find(@batch_id).old_students
=begin
  bs = BatchStudent.find_all_by_batch_id(@batch_id)
    unless bs.empty?
                               bs.each do|bst|
                                     student = Student.find(bst.student_id)
                                     @students << student unless student.nil?
                                end
    end
=end
    @students = @students.uniq { |x| x.id }
    @exams = []
    @school_modules.each do |smd|

      @exam_group = ExamGroup.find(:first, :conditions => { :batch_id => @batch.id, :module_id => smd })
      if (!@exam_group)
        @exam_group = ExamGroup.find(:first, :conditions => { :batch_id => @batch2.id, :module_id => smd })
      end
      @exams[smd] = @exam_group.exams
      @students.each do |st|
        if @resultas[st.id].nil?
          @resultas[st.id] = []
        end
        @resultas[st.id][smd] = []
        @exams[smd].each do |ex|
          esco = ExamScore.find(:first, :conditions => { :student_id => st.id, :exam_id => ex.id })
          mark = nil
          markar = nil
          if (esco)
            mark = esco.marks
            markar = esco.marks_ar
          end
          @resultas[st.id][smd][ex.id] = {}
          @resultas[st.id][smd][ex.id]['markv'] = mark
          @resultas[st.id][smd][ex.id]['markarv'] = markar
        end

      end

    end

    render :pdf => 'show_students_all_marks_all', :orientation => 'Landscape'

  end

  def show_students_all_marks
    @todo = params[:todo]
    @current_user = current_user
    @exam_group = ExamGroup.find(:first, :conditions => { :batch_id => params[:batch_id], :module_id => params[:school_module_id] })
    @exams = ExamGroup.find(:first, :conditions => { :batch_id => params[:batch_id], :module_id => params[:school_module_id] }).exams
    @school_module_id = params[:school_module_id]
    @school_field_id = params[:school_field_id]
    @course_id = params[:course_id]
    @school_module = SchoolModule.find(@school_module_id)
    @school_year = params[:school_year]
    @batch_id = params[:batch_id]
    @batch = Batch.find(params[:batch_id])
    @resultas = []
    @students = Student.find_all_by_batch_id(@batch.id)
    if (!@students)
      @students = []
    end
    @students += Batch.find(@batch_id).old_students
=begin
  bs = BatchStudent.find_all_by_batch_id(@batch_id)
    unless bs.empty?
                               bs.each do|bst|
                                     student = Student.find(bst.student_id)
                                     @students << student unless student.nil?
                                end
    end
=end
    if params[:group]
      exam_group = @exam_group
      module_group = ModuleGroup.find_by_school_year_and_course_id_and_school_module_id(exam_group.batch.get_batch_year, exam_group.batch.course.id, exam_group.module_id)
      if module_group
        module_group_batch = ModuleGroupBatch.find_by_module_group_id_and_batch_id(module_group.id, exam_group.batch.id)
        module_group_batchs = ModuleGroupBatch.find_all_by_module_group_id(module_group.id)
        module_group_batchs.each do |b|
          @students += Batch.find(b.batch_id).all_students
          if Batch.find(b.batch_id).all_students.count > 0
          else
            @students += Batch.find(b.batch_id).old_students
          end
        end
      end
    end
    @students = @students.uniq { |x| x.id }
    @students.each do |st|

      @resultas[st.id] = []
      if params[:group]
        subject = Subject.find_by_subject_group_id_and_batch_id(@exams.first.subject.subject_group_id, st.batch.id)
        if subject
          bat_id = st.batch.id
        else
          bat_id = BatchStudent.find_all_by_student_id(st.id).last.batch_id
          subject = Subject.find_by_subject_group_id_and_batch_id(@exams.first.subject.subject_group_id, bat_id)
        end
        @exams2 = ExamGroup.find_by_module_id_and_batch_id(@exams.first.exam_group.module_id, bat_id).exams
        @group = true
      else
        @exams2 = @exams
        @group = false
      end
      @exams2.each do |ex|
        esco = ExamScore.find(:first, :conditions => { :student_id => st.id, :exam_id => ex.id })
        mark = nil
        markar = nil
        if (esco)
          mark = esco.marks
          markar = esco.marks_ar
        end
        @resultas[st.id][ex.id] = {}
        @resultas[st.id][ex.id]['markv'] = mark
        @resultas[st.id][ex.id]['markarv'] = markar
      end

    end

    if (@todo == 'NORMAL')
      render(:update) do |page|
        page.replace_html 'students_modules_list', :partial => 'students_modules_list'
      end
    else
      #logger.debug @resultas.inspect
      render :pdf => 'show_students_all_marks', :orientation => 'Landscape'
    end

  end

  def yearly_deliberation
    if @current_user.admin? or @current_user.privileges.map { |p| p.name }.include?("DeliberationAnnuelle")
      @school_fields = SchoolField.find(:all, :order => "name")
    else
      @school_fields = SchoolField.find_by_sql("select * from school_fields where employee_id=#{@current_user.employee_record.id}")
      SchoolFieldEmployee.find_all_by_employee_id(@current_user.employee_record.id).each do |sf|
        @school_fields += SchoolField.find_by_sql("select * from school_fields where id=#{sf.school_field_id}")
      end
      @school_fields = @school_fields.uniq
    end

  end

  def handle_delib_params
    logger.debug("looplalalalalala");

    sf_id = params[:delib_params][:school_field_id]
    c_ids = params[:delib_params][:course_ids]
    sy = params[:delib_params][:school_year]
    av_sm = params[:delib_params][:average_school_module]
    av_year = params[:delib_params][:average_year]
    e_sm = params[:delib_params][:elim_school_module]
    e_s = params[:delib_params][:elim_subject]

    batches = []
    students = []

    dp = nil #DelibParam.find(:first, :conditions => {:school_field_id => sf_id, :course_ids => c_ids.to_s, :school_year => sy})
    if !dp.nil?
      logger.debug "holalalalalalaa"
      logger.debug "holalalalalalaa"
      logger.debug "holalalalalalaa"
      logger.debug "holalalalalalaa"
      logger.debug "holalalalalalaa"
      logger.debug params[:delib_params][:delib_date]
      logger.debug params[:delib_params][:delib_date]
      logger.debug params[:delib_params][:delib_date]
      logger.debug params[:delib_params][:delib_date]
      logger.debug params[:delib_params][:delib_date]
      logger.debug params[:delib_params][:delib_date]
      logger.debug params[:delib_params][:delib_date]
      logger.debug "holalalalalalaa"
      logger.debug "holalalalalalaa"
      logger.debug "holalalalalalaa"
      logger.debug "holalalalalalaa"
      logger.debug "holalalalalalaa"
      logger.debug "holalalalalalaa"
      # if default_av.to_i > 0
      #   params[:delib_params][:average_year] = params[:delib_params][:average_school_module] =  params[:delib_params][:plafond_ratt] = default_av
      # end
      dp.update_attributes(params[:delib_params])
      if dp.save
        flash[:notice] = "Mise à jour avec succès"
        logger.debug "Mise à jour avec succès"
      end
    else
      nil #DelibParam.create(params[:delib_params])
      flash[:notice] = "Créé avec succès"
      logger.debug "Créé avec succès"
    end
    option = params[:option][:choice].to_s unless params[:option].nil?
    if option != "date"

      logger.debug "loooooooooooaaaaaaaaoooooooool"

      logger.debug "loooooooooooaaaaaaaaoooooooool"
      logger.debug "loooooooooooaaaaaaaaoooooooool"
      logger.debug "loooooooooooaaaaaaaaoooooooool"
      logger.debug "loooooooooooaaaaaaaaoooooooool"
      logger.debug "loooooooooooaaaaaaaaoooooooool"
      logger.debug "loooooooooooaaaaaaaaoooooooool"
      c_ids.split(',').each do |course|
        bt = Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{sf_id.to_s}").reject { |x| x.get_batch_year != sy.to_i } #Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))")
        bt.each do |btch|
          batches << btch unless btch.get_batch_year != sy.to_i
        end
      end
      batch_string = ""
      batches.each do |batch|
        students += Student.find_all_by_batch_id(batch.id) unless !Student.find_all_by_batch_id(batch.id)
        students += batch.old_students
        batch_string += batch.id.to_s + ','
      end
      logger.debug batch_string
      logger.debug "lololol here batchs"

      yd = YearlyDecision.find(:first, :conditions => "school_year = #{sy} and batch_ids like '%#{batch_string}%'")

      if !yd.nil?
        logger.debug "it ain't nil"
        students.each do |st|

          ydd = YearlyDecision.find(:first, :conditions => "student_id = #{st.id} and school_year = #{sy} and batch_ids like '%#{batch_string}%'")
          if ydd
            ydd.destroy
          end
        end
      end
      logger.debug "loooooooooooaaaaaaaaoooooooool"
      logger.debug "loooooooooooaaaaaaaaoooooooool"
      logger.debug "loooooooooooaaaaaaaaoooooooool"
      logger.debug "loooooooooooaaaaaaaaoooooooool"
      logger.debug "loooooooooooaaaaaaaaoooooooool"
      logger.debug "loooooooooooaaaaaaaaoooooooool"
      logger.debug "loooooooooooaaaaaaaaoooooooool"
    end
    logger.debug "qsdqsdloooooooooooaaaaaaaaoooooooool"
    logger.debug "loooooooooooaaaaaaaaoooooooool"
    logger.debug "loooooooooooaaaaaaaaoooooooool"
    logger.debug "loooooooooooaaaaaaaaoooooooool"
    logger.debug "loooooooooooaaaaaaaaoooooooool"
    logger.debug "loooooooooooaaaaaaaaoooooooool"
    logger.debug "loooooooooooaaaaaaaaoooooooool"
    redirect_to :action => "all_student_modules", :school_field_id => sf_id, :course_ids => c_ids, :school_year => sy

  end

  def all_student_modules_maj_total

    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @course_ids = ""
    @typed = 0 #annuelle
    @cids = params[:course_ids]
    @courses = (params[:course_ids].gsub('%2C', ',')).split(",")
    @courses.each do |c|
      @course_ids += c + '+'
    end
    @courses = @courses.reject { |c| c.to_i == 0 }
    @courses = @courses.reject { |c| c.to_i == -1 }
    @course1 = @courses[0]
    if (@courses[1])
      @typed = 0 #annuelle
      @course2 = @courses[1]
    else
      @typed = 1
      @course2 = -1.to_s
    end
    logger.debug @courses.inspect
    logger.debug @typed

    @batches = []
    @sf_sm = []
    @courses.each do |course|
      bt = Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s}").reject { |x| x.get_batch_year != @school_year.to_i }
      bt.each do |btch|
        @batches << btch unless btch.get_batch_year != @school_year.to_i

      end
      @sf_sm += SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => course.to_i, :school_year => @school_year, :school_field_id => @school_field_id })
    end

    @exam_groups = []
    @students = []
    batch_string = ""
    @batches.each do |batch|
      @students += Student.find_all_by_batch_id(batch.id) unless !Student.find_all_by_batch_id(batch.id)
      @students += batch.old_students

      @students = @students.uniq { |x| x.id }
      batch_string += batch.id.to_s + ','
    end
    logger.debug @students.count
    @students = @students.uniq
    @batch_ids = ""

    @batch_ids = batch_string
    @resultats = []
    @valide_student_by_system = []

    @students.each do |st|
      #if st.id.to_i == 2305
      @resultats[st.id] = {}
      #ydecision=YearlyDecision.find(:all, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")

      if @typed.to_i == 1
        ydecision = YearlyDecision.find(:all, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '#{batch_string}'")
      else
        ydecision = YearlyDecision.find(:all, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")
      end

      rslt = st.check_student_result(@batches, @school_year, 4, session[:param_notes])
      moyenne = @resultats[st.id]['avg_year'] = rslt["average_of_year"]
      @resultats[st.id]['nb_val'] = rslt["valid_number"]
      @resultats[st.id]['nb_var'] = rslt["var_number"]
      @resultats[st.id]['nb_nv'] = rslt["nvalid_number"]
      @resultats[st.id]['nb_nv1'] = rslt["nvalid_number1"]
      @resultats[st.id]['nb_eliminat'] = rslt["elminatory_number"]
      @resultats[st.id]['elm_subj'] = rslt["eliminatory_subject"]
      logger.debug "=================================================================================="
      @resultats[st.id]['decision'] = get_decision_by_student(@course1, moyenne, @resultats[st.id]['nb_nv'], @resultats[st.id]['nb_nv1'], @resultats[st.id]['nb_eliminat'], @batches.first.id, @typed, @resultats[st.id]['elm_subj'])
      logger.debug @resultats[st.id]['decision']
      if !ydecision.nil? and !ydecision.empty?
        ydecision.each do |yd|
          yd.destroy
        end
      end

      #ydecision.destroy unless !ydecision

      @yearly_decision = YearlyDecision.new(:student_id => st.id, :school_year => @school_year, :batch_ids => @batch_ids, :decision => @resultats[st.id]['decision'], :avg_year => moyenne, :nb_val => @resultats[st.id]['nb_val'], :nb_var => @resultats[st.id]['nb_var'], :nb_nv => @resultats[st.id]['nb_nv'], :nb_eliminat => @resultats[st.id]['nb_eliminat'])

      if (@yearly_decision.save)
        @resultats[st.id]['check'] = 1
      end

      #end
    end

    @students.sort! { |a, b| @resultats[b.id]['avg_year'] <=> @resultats[a.id]['avg_year'] }

    if !batch_string.nil? and batch_string.to_s != ""
      #@yds = YearlyDecision.find(:last, :conditions => "school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")

      if @typed.to_i == 1
        @yds = YearlyDecision.find(:last, :conditions => "school_year = #{@school_year} and batch_ids like '#{batch_string}'")
      else
        @yds = YearlyDecision.find(:last, :conditions => "school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")
      end

    end
    logger.debug @yds.inspect
    logger.debug "***************************************"
    render(:update) do |page|
      page.replace_html 'all_student_modules', :partial => 'all_student_modules'
    end

  end


def show_students_all_marks_all_h
  if params[:is_code]
    @is_code = true
  else
    @is_code = false
  end
  @current_user =current_user
    @typed=params[:typed]
logger.debug @typed.to_s+" asdasdasd"
logger.debug @typed.to_s+" asdasdasd"
    @note_max = 0
    @note_min = 19
    @moyenne_class = 0
    @nombre_zero = 0
    @nombre_etudiant = 0
    @school_modules=[]
    @resultas=[]
    @resultats=[]
    @school_field_id=params[:school_field_id]
    @course_ids=(params[:course_ids].gsub('%2C',',')).split(",")
    @school_year=params[:school_year]

    @course_ids=""

    @cids=params[:course_ids]
    @courses=(params[:course_ids].gsub('%2C',',')).split(",")
    @courses.each do |c|
                    @course_ids+=c+'+'
             end
    @courses=@courses.reject{|c| c.to_i == 0}
    @course1=@courses[0]
    if(@courses[1])
    @course2=@courses[1]
    else
    @course2=-1.to_s
    end
    @batches=[]
    @sf_sm=[]
    @courses.each do |course|

                   bt= Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
             if (bt)
             @batches+=bt
             end
    end
    # @batches = @batches.reject { |b| b.id.to_i == 2265 }

if @school_field_id.to_i == 10 and @school_year.to_i >= 2020
  @batches = @batches.select{|b| b.is_active == true}
else
  @batches = @batches
end
  @batches = @batches.reject{|b| b.is_deleted}
    logger.debug @course_ids
    @course_ids.split("+").reject{|tf| tf.to_i == 0}.each do |cr|
      logger.debug "lol "+cr.to_s+" lol "
      logger.debug "lol "+cr.to_s+" lol "
      logger.debug "lol "+cr.to_s+" lol "
      logger.debug "lol "+cr.to_s+" lol "
     @intem= SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => cr.to_i, :school_field_id => @school_field_id, :school_year => params[:school_year]})
       if(@intem)
         @intem.each do |int|
            if @school_modules[cr.to_i].nil? or @school_modules[cr.to_i].empty?
              @school_modules[cr.to_i] = []
            end
            @school_modules[cr.to_i] << int.school_module_id
            # @school_modules << int.school_module_id
         end
       end
    end
    @batch = @batches.first
    @batch2 = @batches.last
    # logger.debug @batch.full_name
    # logger.debug @batch2.full_name
    @bts = [@batch,@batch2]
    # @batch = Batch.find(:all, :conditions => ["course_id=#{@course_ids[0]} and school_field_id=#{@school_field_id}"]).reject{|b| b.get_batch_year != @school_year.to_i}.first
    # @batch2 = Batch.find(:all, :conditions => ["course_id=#{@course_ids[1]} and school_field_id=#{@school_field_id}"]).reject{|b| b.get_batch_year != @school_year.to_i}.first
    batch_string=@batch.id.to_s+','+@batch2.id.to_s+','
    # @batches=[@batch,@batch2]
    @students = Student.find_all_by_batch_id(@batch.id)
    @students = Student.find_all_by_batch_id(@batch2.id)
    if @batch
    @students += @batch.old_students
  end
    if @batch2
    @students += @batch2.old_students
  end
=begin
  if(!@students)
  @students=[]
  end

  @students = BatchStudent.find_all_by_batch_id(@batch_id)

    unless bs.empty?
                               bs.each do|bst|
                                     student = Student.find(bst.student_id)
                                     @students << student unless student.nil?
                                end
    end
=end
  @students=@students.uniq{|x| x.id}
  #@students=@students[0..10]
  @exams=[]
  @resultas = []
  @ponderations=[]
  @course_ids.split("+").reject{|tf| tf.to_i == 0}.each do |crr|
    if !@school_modules[crr.to_i].nil? and !SchoolModule.find(@school_modules[crr.to_i].first).name.nil? and SchoolModule.find(@school_modules[crr.to_i].first).name.first.upcase == "M" and 1 == 2
      @school_modules[crr.to_i].each do |smm|
      logger.debug SchoolModule.find(smm).name+"\n"
    end
    @school_modules[crr.to_i] = @school_modules[crr.to_i].sort_by{|sm| SchoolModule.find(sm).name.split("M")[1].split(":")[0] unless (SchoolModule.find(sm).name.nil? or SchoolModule.find(sm).name.split("M").nil? or SchoolModule.find(sm).name.split("M")[1].split(":"))}
    else
      if !@school_modules[crr.to_i].nil?
          @school_modules[crr.to_i] = @school_modules[crr.to_i].compact.sort_by{|sm| SchoolModule.find(sm).name}
        else
        @school_modules[crr.to_i]=[]
      end
    end
  end



  @students.each do |st|
    @course_ids.split("+").reject{|tf| tf.to_i == 0}.each do |crr|
            if !@school_modules[crr.to_i].nil?

    @school_modules[crr.to_i].each do |smd|
      @batches.each do |bbt|
        @exam_group=ExamGroup.find(:first, :conditions => {:batch_id => bbt.id, :module_id => smd})
        if(@exam_group)
         break
         @exam_group=ExamGroup.find(:first, :conditions => {:batch_id => bbt.id, :module_id => smd})
        end
      end
      if @exam_group.nil?
          @school_modules[crr.to_i].delete(smd)
      end
      @exams[smd] = []
      @exams[smd]=@exam_group.exams unless @exam_group.nil?

      if @resultas[st.id].nil?
          @resultas[st.id] = []
      end
      @resultas[st.id][smd]=[]
         @exams[smd].each do |ex|
            begin
            @ponderations[ex.id]=SchoolModuleSubject.find(:first, :conditions => {:school_module_id => smd, :subject_group_id => Subject.find(ex.subject_id).subject_group_id, :school_year => @school_year}).subject_weighting
              esco=ExamScore.find(:first, :conditions => {:student_id=>st.id, :exam_id => ex.id})
            rescue

            end
            mark=0
            markar=0
            if(esco)
              mark=esco.marks
              markar=esco.marks_ar
            end
                                       @resultas[st.id][smd][ex.id]={}
              @resultas[st.id][smd][ex.id]['markv']= mark
                                      @resultas[st.id][smd][ex.id]['markarv']= markar
           end
      end


end
  end
    end#crouse

        not_max = 0
    student_not_max = -1

@students.each  do |st|
              logger.debug "S--------------------------------------\n"
              logger.debug "S--------------------------------------\n"
              logger.debug "S--------------------------------------\n"
              logger.debug "S--------------------------------------\n"
              logger.debug "S--------------------------------------\n"
              logger.debug "S--------------------------------------\n"
              logger.debug st.full_name+"\n"
              logger.debug "S--------------------------------------\n"
              logger.debug "S--------------------------------------\n"
              logger.debug "S--------------------------------------\n"
              logger.debug "S--------------------------------------\n"
              logger.debug "S--------------------------------------\n"
              logger.debug "S--------------------------------------\n"

                      @resultats[st.id]={}
              annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year}")
              annee_reserve_old = ReserveYearStudent.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year.to_i-1}")
              ydecision=YearlyDecision.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")
                      if(ydecision and !params[:typd] and annee_reserve.nil? and annee_reserve_old.nil? and ydecision.avg_year.to_i != -1)
 logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug st.full_name+"\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"
              logger.debug "Y--------------------------------------\n"

                           #ydecision.each do |yd|
                            rslt=st.check_student_result(@batches,@school_year,4)
                      @resultats[st.id]['decision']=ydecision.decision
                    # @resultats[st.id]['avg_year']=ydecision.avg_year
                    @resultats[st.id]['avg_year']=SchoolModule.average_of_year(@batches,st.id,@school_year)
                    @resultats[st.id]['nb_val']=ydecision.nb_val
                    @resultats[st.id]['nb_var']=ydecision.nb_var
                    @resultats[st.id]['nb_nv']=ydecision.nb_nv
                    @resultats[st.id]['nb_eliminat']=ydecision.nb_eliminat
                    moyenne_session_normale=@resultats[st.id]['avg_year_normale']=rslt["average_of_year_session_normale"]#SchoolModule.average_of_year_session_normale(@batches,st.id,@school_year)
                    @resultats[st.id]['check']=1
                      #end

                    @resultats[st.id]['elminatory_number_spec']=rslt["elminatory_number_spec"]
              else
              annee_reserve_histo = ReserveYearStudent.find(:all, :conditions => "student_id = #{st.id}")
              nbr = 0
              annee_reserve_histo.each do |annhisto|
              nbr = nbr + 1
              end

              if(ydecision)
                @resultats[st.id]['decision']=ydecision.decision
              end

              rslt=st.check_student_result(@batches,@school_year,4)
              moyenne=@resultats[st.id]['avg_year']=rslt["average_of_year"] #SchoolModule.average_of_year(@batches,st.id,@school_year)
              moyenne_session_normale=@resultats[st.id]['avg_year_normale']=rslt["average_of_year_session_normale"] #SchoolModule.average_of_year_session_normale(@batches,st.id,@school_year)
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              logger.debug st.full_name+" Moyen "+moyenne.to_s+" Moy Avant"+moyenne_session_normale.to_s+"\n"
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              logger.debug "M--------------------------------------\n"
              ydecision=YearlyDecision.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")
              @resultats[st.id]['nb_val']=rslt["valid_number"]
              @resultats[st.id]['nb_var']=rslt["var_number"]
              @resultats[st.id]['nb_nv']=rslt["nvalid_number"]
              @resultats[st.id]['nb_eliminat']=rslt["elminatory_number"]
              @resultats[st.id]['elminatory_number_spec']=rslt["elminatory_number_spec"]

              if (@resultats[st.id]['avg_year'] > not_max and (@course1.to_i == 5 or @course1.to_i == 6))
              student_not_max = st.id
              not_max = @resultats[st.id]['avg_year']
              end

              if (ydecision)
              @resultats[st.id]['check']=1
              else
              @resultats[st.id]['check']=0
              end
              @resultats[st.id]['decision']=get_decision_by_student(@course1, moyenne_session_normale, @resultats[st.id]['nb_nv'], @resultats[st.id]['nb_eliminat'],rslt["average_of_spec_module"], rslt["average_of_non_spec_module"], rslt["found_spec_module"], rslt["elminatory_number_spec"], nbr )

              if(ydecision)
                @resultats[st.id]['decision']=ydecision.decision
              end


=begin
              if(moyenne >= 12 and @resultats[st.id]['nb_nv']==0)
                 @resultats[st.id]['decision']='admis'
              else
                 @resultats[st.id]['decision']='En cours'
              end
=end
              #//if (moyenne >= 12 and @resultats[st.id]['nb_nv']==0)
              #@valide_student_by_system[st.id]={}
              #@valide_student_by_system[st.id]['decision']=st.check_student_result(@batches,@school_year,4)["decision"]
              #@valide_student_by_system[st.id]['avg_year']=st.check_student_result(@batches,@school_year,4)["average_of_year"]
              #@valide_student_by_system[st.id]['nb_val']=st.check_student_result(@batches,@school_year,4)["valid_number"]
              #@valide_student_by_system[st.id]['nb_var']=st.check_student_result(@batches,@school_year,4)["var_number"]
              #@valide_student_by_system[st.id]['nb_nv']=st.check_student_result(@batches,@school_year,4)["nvalid_number"]
              #@valide_student_by_system[st.id]['nb_eliminat']=st.check_student_result(@batches,@school_year,4)["elminatory_number"]
              #//@yearly_decision = YearlyDecision.new(:student_id => st.id, :school_year => @school_year, :batch_ids => @batch_ids, :decision => 'admis', :avg_year => moyenne, :nb_val => @resultats[st.id]['nb_val'], :nb_var => @resultats[st.id]['nb_var'], :nb_nv => @resultats[st.id]['nb_nv'])
              #//if (@yearly_decision.save) then @resultats[st.id]['check']=1
              #//end
              #//end

              end

              if(@resultats[st.id]['avg_year'] > @note_max)
              @note_max = @resultats[st.id]['avg_year']
              end
              if(@resultats[st.id]['avg_year'] < @note_min)
              @note_min = @resultats[st.id]['avg_year']
              end
              if(@resultats[st.id]['avg_year'] == 0)
              @nombre_zero = @nombre_zero + 1
              end
              @nombre_etudiant = @nombre_etudiant + 1
              @moyenne_class = @moyenne_class + @resultats[st.id]['avg_year']

    end
    @students.sort! { |a,b| @resultats[b.id]['avg_year_normale'] <=> @resultats[a.id]['avg_year_normale'] }
    @students.sort! { |a,b| @resultats[b.id]['avg_year'] <=> @resultats[a.id]['avg_year'] }
    i = 1
  @classement = []
 @students.each do |st|
      @classement[st.id] = i
      i = i + 1
    end
  render :pdf=>'show_students_all_marks_all',:orientation=> 'landscape', :footer => false




  end



  def all_student_modules_maj

    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @course_ids = ""
    @typed = 0 #annuelle
    @cids = params[:course_ids]
    @courses = (params[:course_ids].gsub('%2C', ',')).split(",")
    @courses.each do |c|
      @course_ids += c + '+'
    end
    @courses = @courses.reject { |c| c.to_i == 0 }
    @courses = @courses.reject { |c| c.to_i == -1 }
    @course1 = @courses[0]
    if (@courses[1])
      @typed = 0 #annuelle
      @course2 = @courses[1]
    else
      @typed = 1
      @course2 = -1.to_s
    end
    @batches = []
    @sf_sm = []
    @courses.each do |course|
      bt = Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s}").reject { |x| x.get_batch_year != @school_year.to_i }
      bt.each do |btch|
        @batches << btch unless btch.get_batch_year != @school_year.to_i

      end
      @sf_sm += SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => course.to_i, :school_year => @school_year, :school_field_id => @school_field_id })
    end

    @exam_groups = []
    @students = []
    batch_string = ""
    @batches.each do |batch|
      @students += Student.find_all_by_batch_id(batch.id) unless !Student.find_all_by_batch_id(batch.id)
      @students += batch.old_students

      @students = @students.uniq { |x| x.id }
      batch_string += batch.id.to_s + ','
    end
    logger.debug @students.count
    @students = @students.uniq
    @batch_ids = ""

    @batch_ids = batch_string
    @resultats = []
    @valide_student_by_system = []

    @students.each do |st|
      @resultats[st.id] = {}
      #ydecision=YearlyDecision.find(:last, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")

      if @typed.to_i == 1
        ydecision = YearlyDecision.find(:last, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '#{batch_string}'")
      else
        ydecision = YearlyDecision.find(:last, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")
      end

      rslt = st.check_student_result(@batches, @school_year, 4, session[:param_notes])
      moyenne = @resultats[st.id]['avg_year'] = rslt["average_of_year"]
      @resultats[st.id]['nb_val'] = rslt["valid_number"]
      @resultats[st.id]['nb_var'] = rslt["var_number"]
      @resultats[st.id]['nb_nv'] = rslt["nvalid_number"]
      @resultats[st.id]['nb_nv1'] = rslt["nvalid_number1"]
      @resultats[st.id]['nb_eliminat'] = rslt["elminatory_number"]
      @resultats[st.id]['elm_subj'] = rslt["eliminatory_subject"]
      if (ydecision)
        @resultats[st.id]['decision'] = ydecision.decision
      else
        @resultats[st.id]['decision'] = get_decision_by_student(@course1, moyenne, @resultats[st.id]['nb_nv'], @resultats[st.id]['nb_nv1'], @resultats[st.id]['nb_eliminat'], @batches.first.id, @typed, @resultats[st.id]['elm_subj'])
      end

      ydecision.destroy unless !ydecision
      @yearly_decision = YearlyDecision.new(:student_id => st.id, :school_year => @school_year, :batch_ids => @batch_ids, :decision => @resultats[st.id]['decision'], :avg_year => moyenne, :nb_val => @resultats[st.id]['nb_val'], :nb_var => @resultats[st.id]['nb_var'], :nb_nv => @resultats[st.id]['nb_nv'], :nb_eliminat => @resultats[st.id]['nb_eliminat'])

      if (@yearly_decision.save)
        @resultats[st.id]['check'] = 1
      end

    end

    @students.sort! { |a, b| @resultats[b.id]['avg_year'] <=> @resultats[a.id]['avg_year'] }

    if !batch_string.nil? and batch_string.to_s != ""
      # @yds = YearlyDecision.find(:last, :conditions => "school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")

      if @typed.to_i == 1
        @yds = YearlyDecision.find(:last, :conditions => "school_year = #{@school_year} and batch_ids like '#{batch_string}'")
      else
        @yds = YearlyDecision.find(:last, :conditions => "school_year = #{@school_year} and batch_ids like '%#{batch_string}%'")
      end

    end

    render(:update) do |page|
      page.replace_html 'all_student_modules', :partial => 'all_student_modules'
    end

  end

  def all_student_modules
    @current_user = current_user
    @note_max = 0
    @note_min = 19
    @moyenne_class = 0
    @nombre_zero = 0
    @nombre_etudiant = 0
    @delib_type = params[:delib_type]
    @type = params[:type]
    if (params[:type])
      id_cycle = params[:cycle_id] unless params[:cycle_id].nil?
      if current_user.admin?
#        @courses = Course.find_by_sql("select * from courses where cycle_id = #{id_cycle} or #{id_cycle} is null")
        @courses = Course.find_by_sql("select * from courses where cycle_id is null")
      elsif current_user.employee and current_user.privileges.map { |p| p.name }.include?("Coordonateurfiliere") and current_user.employee_record.school_field.id == 1
#        @courses = Course.find_by_sql("select * from courses where cycle_id = #{id_cycle} or #{id_cycle} is null").reject { |c| c.id < 20 }
        @courses = Course.find_by_sql("select * from courses where cycle_id is null").reject { |c| c.id < 20 }

      else
#        @courses = Course.find_by_sql("select * from courses where cycle_id = #{id_cycle} or #{id_cycle} is null")
        @courses = Course.find_by_sql("select * from courses where cycle_id is null")

      end
      @courses = @courses.sort_by { |b| b.code }
      @course_groups = @courses.group_by { |course| course.course_name }

      @group = []
      @course_groups.each do |key, value|
        chaine = ""
        @course_groups[key].each do |course|
          chaine += course.id.to_s + ','
        end
        chaine += '0'
        @group << [key, chaine]
      end

      if (params[:type] == "Annuelle")
        render(:update) do |page|
          page.replace_html 'type_div', :partial => 'annuelle'
        end
      else
        render(:update) do |page|
          page.replace_html 'type_div', :partial => 'semestrielle'
        end
      end

    else
      @school_field_id = params[:school_field_id]

      @school_year = params[:school_year]
      @course_ids = ""
      @cids = params[:course_ids]
      @courses = (params[:course_ids].gsub('%2C', ',')).split(",")
      @courses.each do |c|
        @course_ids += c + '+'
      end
      @courses = @courses.reject { |c| c.to_i == 0 }
      @course1 = @courses[0]

      critere_calcul_mr = NoteMax.find(:first, :conditions => { :course_id => @courses[0], :school_year => @school_year, :school_field_id => @school_field_id })
      if (!critere_calcul_mr)
        critere_calcul_mr = NoteMax.find(:first, :conditions => "course_id = #{@courses[0]} and school_year = #{@school_year} and school_field_id is null")

      end
      if (!critere_calcul_mr)
        critere_calcul_mr = NoteMax.find(:first, :conditions => "school_year = #{@school_year} and school_field_id is null and course_id is null")
      end

      @moyenne_validation = 10
      @note_e_elem = 5
      @note_e_mod = 9

      if (!critere_calcul_mr.nil?)
        @moyenne_validation = critere_calcul_mr.moyenne
        @note_e_elem = critere_calcul_mr.note_ele_element
        @note_e_mod = critere_calcul_mr.note_ele_module
      end

      if (@courses[1])
        @course2 = @courses[1]
      else
        @course2 = -1.to_s
      end
      @batches = []
      @sf_sm = []
      @courses.each do |course|
        bt = Batch.find_by_sql("select * from batches where course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
        # bt= Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))").reject {|x| x.get_batch_year != @school_year.to_i}
        if (bt)
          @batches += bt
        end
        @sf_sm += SchoolFieldSchoolModule.find_by_sql("select * from school_field_school_modules where course_id = #{course.to_i} and school_year = #{@school_year} and school_field_id = #{@school_field_id} ")
      end

      @exam_groups = []
      @students = []
      @batch_ids = ""
      batch_string = ""

      infos_modules = []
      number_modules = 0
      @batches.each do |batch|
        @students += Student.find_by_sql("select id,first_name,last_name,matricule from students where batch_id = #{batch.id}") unless !Student.find_by_sql("select id,first_name,last_name from students where batch_id = #{batch.id}")
        @students += batch.old_students
        @students = @students.uniq { |x| x.id }
        @batch_ids += batch.id.to_s + ","

        modules = []
        sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => batch.school_field_id, :course_id => batch.course_id, :school_year => batch.get_batch_year })
        sf_sm.each do |sfssm|
          modules << SchoolModule.find(sfssm.school_module_id)
        end
        modules = modules.uniq
        infos_modules[batch.id] = {}
        infos_modules[batch.id]['modules'] = modules

        modules.each do |md|
          sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
          exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(batch.id, md.id)
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
                sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{@school_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
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
          infos_modules[batch.id][md.id] = {}
          infos_modules[batch.id][md.id]['non_spec_pond'] = non_spec_pond
          infos_modules[batch.id][md.id]['spec_pond'] = spec_pond
          infos_modules[batch.id][md.id]['pond'] = pond
          infos_modules[batch.id][md.id]['sfsm'] = sfsm
          number_modules += modules.count
        end
      end

      @valide_student_by_system = []
      not_max = 0
      student_not_max = -1
      @resultats = []
      infos_modules[0] = {}
      infos_modules[0]['number_modules'] = number_modules
      @students.each do |st|
        @resultats[st.id] = {}
        annee_reserves = ReserveYearStudent.find_by_sql("select * from reserve_year_students where student_id = #{st.id}")
        annee_reserve = annee_reserves.select { |ar| ar.school_year == @school_year }.first
        annee_reserve_old = annee_reserves.select { |ar| ar.school_year == (@school_year.to_i - 1) }.first
        ydecision = YearlyDecision.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{@batch_ids}%'")

        if (1 == 0 and ydecision and !params[:typd] and annee_reserve.nil? and annee_reserve_old.nil? and ydecision.avg_year.to_i != -1)
          @resultats[st.id]['decision'] = ydecision.decision
          @resultats[st.id]['avg_year'] = ydecision.avg_year
          @resultats[st.id]['nb_val'] = ydecision.nb_val
          @resultats[st.id]['nb_var'] = ydecision.nb_var
          @resultats[st.id]['nb_nv'] = ydecision.nb_nv
          @resultats[st.id]['nb_eliminat'] = ydecision.nb_eliminat
          @resultats[st.id]['check'] = 1
        else
          annee_reserve_histo = annee_reserves
          nbr = annee_reserve_histo.count
          modules_max_data = SchoolModule.modules_max_data_opt3(@batches, st.id, @school_year, infos_modules)
          @resultats[st.id]['avg_year'] = modules_max_data['average_of_year']
          @resultats[st.id]['avg_year_normale'] = modules_max_data['average_of_year_session_normale']
          @resultats[st.id]['nb_val'] = modules_max_data["number_validate_modules"]
          @resultats[st.id]['nb_var'] = modules_max_data["number_validate_modules_after_pass"]
          @resultats[st.id]['nb_nv'] = modules_max_data["number_non_validate_modules"]
          @resultats[st.id]['nb_eliminat'] = modules_max_data["eliminatoire_modules"]
          @resultats[st.id]['elminatory_number_spec'] = modules_max_data["eliminatoire_modules_spec"]
          if (@resultats[st.id]['avg_year'] > not_max and (@course1.to_i == 5 or @course1.to_i == 6))
            student_not_max = st.id
            not_max = @resultats[st.id]['avg_year']
          end

          if (ydecision)
            @resultats[st.id]['decision'] = ydecision.decision
            @resultats[st.id]['check'] = 1
          else
            @resultats[st.id]['check'] = 0
            @resultats[st.id]['decision'] = "" #get_decision_by_student(@course1, @resultats[st.id]['avg_year_normale'], @resultats[st.id]['nb_nv'], @resultats[st.id]['elminatory_number_spec'], nbr)
          end

          if (params[:typd])
            ydecision.destroy unless !ydecision
            @yearly_decision = YearlyDecision.new(:student_id => st.id, :school_year => @school_year, :batch_ids => @batch_ids, :decision => @resultats[st.id]['decision'], :avg_year => @resultats[st.id]['avg_year'], :nb_val => @resultats[st.id]['nb_val'], :nb_var => @resultats[st.id]['nb_var'], :nb_nv => @resultats[st.id]['nb_nv'], :nb_eliminat => @resultats[st.id]['nb_eliminat'], :range_o => @resultats[st.id]['range_o'])
            if (@yearly_decision.save)
              @resultats[st.id]['check'] = 1
            end
          end

        end
        @resultats[st.id]['nb_val'] = @resultats[st.id]['nb_val'].to_i
        @resultats[st.id]['nb_var'] = @resultats[st.id]['nb_var'].to_i
        @resultats[st.id]['avg_year'] = @resultats[st.id]['avg_year'].to_f
        if (@resultats[st.id]['avg_year'] > @note_max)
          @note_max = @resultats[st.id]['avg_year']
        end
        if (@resultats[st.id]['avg_year'] < @note_min)
          @note_min = @resultats[st.id]['avg_year']
        end
        if (@resultats[st.id]['avg_year'] == 0)
          @nombre_zero = @nombre_zero + 1
        end
        @nombre_etudiant = @nombre_etudiant + 1
        @moyenne_class = @moyenne_class + @resultats[st.id]['avg_year']

      end

      if (@nombre_etudiant != 0)
        @moyenne_class = @moyenne_class / @nombre_etudiant
      end
      if (student_not_max != -1)
        if (@resultats[student_not_max]['avg_year'] >= 16)
          @resultats[student_not_max]['decision'] = 'AdmisAF'
        end
      end
      @classement = []
      @students.sort! { |a, b| @resultats[b.id]['avg_year'] <=> @resultats[a.id]['avg_year'] }
      i = 1
      @students.each do |st|
        @classement[st.id] = i
        i = i + 1
      end

      @students.sort! { |a, b| @resultats[b.id]['avg_year_normale'] <=> @resultats[a.id]['avg_year_normale'] }
      if (params[:todoo] == 'nv')
        @students.sort! { |a, b| @resultats[b.id]['nb_nv'] <=> @resultats[a.id]['nb_nv'] }
      elsif (params[:todoo] == 'av')
        @students.sort! { |a, b| @resultats[b.id]['avg_year'] <=> @resultats[a.id]['avg_year'] }
      elsif (params[:todoo] == 'dj')
        @students.sort! { |a, b| @resultats[b.id]['decision'] <=> @resultats[a.id]['decision'] }
      elsif (params[:todoo] == 'nm')
        @students.sort! { |a, b| a.last_name <=> b.last_name }
      end
      if (params[:nv])
        @decision = params[:deci]
        @nv = params[:nv]
        if (@decision != "Tout" and @nv != "Tout")
          @students.reject! { |n| @resultats[n.id]['decision'] != @decision }
          @students.reject! { |n| @resultats[n.id]['nb_nv'].to_i != @nv.to_i }
        elsif (@decision != "Tout")
          @students.reject! { |n| @resultats[n.id]['decision'] != @decision }
        elsif (@nv != "Tout")
          @students.reject! { |n| @resultats[n.id]['nb_nv'].to_i != @nv.to_i }
        end
      end
      if (params[:todo])
        render :pdf => 'all_student_modules', :orientation => 'Landscape'
      else
        @batch_ids = @batch_ids
        @bts = @batch_ids.split(/,/)
        @btc1 = @bts[0]
        @btc2 = @bts[1]
        render(:update) do |page|
          page.replace_html 'all_student_modules', :partial => 'all_student_modules'
        end
      end

    end
  end

  def get_decision_by_student (course, average, nb_nv, nb_nv_spec, nbr_annr)
    if (average >= 16 and nb_nv < 2 and nb_nv_spec < 1)
      if (course.to_i != 5 and course.to_i != 6)
        return 'AdmisAF'
      else
        return 'Diplome'
      end
    elsif (average >= 10 and nb_nv < 2)
      if (course.to_i == 5 or course.to_i == 6)
        return 'Diplome'
      else
        return 'Admis'
      end
    elsif (average >= 10 and nb_nv >= 2)
      if (nbr_annr == 0)
        return 'AnneeReserve'
      elsif (nbr_annr == 1)
        return 'Reoriente'
      else
        return 'AnneeBlanche'
      end
    elsif (average >= 10 and nb_nv_spec >= 2)
      if (nbr_annr == 0)
        return 'AnneeReserve'
      elsif (nbr_annr == 1)
        return 'Reoriente'
      else
        return 'AnneeBlanche'
      end
    elsif (average < 10)
      if (nbr_annr == 0)
        return 'AnneeReserve'
      elsif (nbr_annr == 1)
        return 'Reoriente'
      else
        return 'AnneeBlanche'
      end
    end
  end

  # def get_decision_by_student(course, average, nb_nv, nb_eliminat, average_sepec_module, average_non_spec_module, found_spec_module, nb_nv_spec, nbr_annr)
  #   if(average >= 16 and nb_nv <2 and nb_nv_spec < 1)
  #       if(course.to_i!=5 and course.to_i!=6)
  #       logger.debug '*******************n est pas troisieme annee********************'
  #       return 'AdmisAF'
  #     else
  #       return 'Diplome'
  #     end
  #   elsif (average >= 10 and nb_nv <2 )
  #     if(course.to_i==5 or course.to_i==6)
  #       return 'Diplome'
  #     else
  #       return 'Admis'
  #     end
  #   elsif(average >= 10 and nb_nv >= 2)
  #     if(nbr_annr == 0)
  #       return 'AnneeReserve'
  #     elsif(nbr_annr == 1)
  #       return 'Reoriente'
  #     else
  #       return 'AnneeBlanche'
  #     end
  #   elsif(average >= 10 and nb_nv_spec >= 2)
  #     if(nbr_annr == 0)
  #       return 'AnneeReserve'
  #     elsif(nbr_annr == 1)
  #       return 'Reoriente'
  #     else
  #       return 'AnneeBlanche'
  #     end
  #   elsif(average < 10 )
  #     if(nbr_annr == 0)
  #       return 'AnneeReserve'
  #     elsif(nbr_annr == 1)
  #       return 'Reoriente'
  #     else
  #       return 'AnneeBlanche'
  #     end
  #   end
  # end


  # def get_decision_by_student(course, average, nb_nv, nb_nv1, nb_eliminat, batch_id, type, elm_subj)
  #   bat = Batch.find(batch_id)
  #   school_year = bat.get_batch_year
  #   sfid = bat.school_field_id
  #   dpara = nil #DelibParam.find(:first, :conditions => "school_field_id = #{sfid} and school_year = #{school_year} and course_ids like \"%#{course}%\"")
  #   av = 12
  #   max_failed = 4
  #   elimsm = 0
  #   if !dpara.nil?
  #     if !dpara.max_failed_school_module.nil?
  #       max_failed = dpara.max_failed_school_module
  #     end
  #     if !dpara.average_year.nil?
  #       av = dpara.average_year
  #     end
  #     if !dpara.elim_school_module.nil?
  #       elimsm = dpara.elim_school_module
  #     end
  #   end
  #
  #   if type.to_i == 1
  #     if elm_subj == true
  #       return 'NV'
  #     else
  #       if (average.to_i >= 12)
  #         if (nb_eliminat.to_i == 0) #if 22
  #           if (course.to_i == 3 or course.to_i == 7) # troisième année
  #             if (nb_nv.to_i < 3)
  #               return 'Valide'
  #             else
  #               return 'NV'
  #             end
  #           else
  #             if (nb_nv.to_i <= max_failed)
  #               return 'Valide'
  #             else
  #               return 'NV'
  #             end
  #           end
  #         else
  #           return 'NV'
  #         end
  #
  #       else
  #         return 'NV'
  #       end
  #     end
  #   else
  #     if elm_subj == true
  #       return 'Redouble'
  #     else
  #
  #       if (course.to_i == 3 or course.to_i == 7) # troisième année
  #         if (average.to_i >= 13)
  #           if (nb_eliminat.to_i == 0)
  #             if (nb_nv.to_i <= max_failed)
  #
  #               if (nb_nv.to_i > 2)
  #                 if (nb_nv1 <= 2)
  #                   return 'DiplomePD'
  #                 else
  #                   return 'Redouble'
  #                 end
  #               else
  #                 if (average.to_i >= 16)
  #                   return 'DiplomeAFJ'
  #                 else
  #                   return 'Diplome'
  #                 end
  #               end
  #
  #             else
  #               #if(nb_nv1.to_i <= max_failed)
  #               #return 'Rachetead'
  #               #else
  #               return 'Redouble'
  #               #end
  #             end
  #           else
  #             return 'Redouble'
  #           end
  #         else
  #           #if(average.to_i >= av and nb_nv1.to_i <= max_failed)
  #           #return 'Rachetead'
  #           #else
  #           return 'Redouble'
  #           #end
  #         end
  #       else
  #         if (average.to_i >= 12)
  #           if (nb_eliminat.to_i == 0)
  #             if (nb_nv.to_i <= max_failed)
  #               #  if(course.to_i==3 or course.to_i==7)# troisième année
  #               #   if(nb_nv.to_i > 2 )
  #               #     if(nb_nv1 <= 2)
  #               #         return 'DiplomePD'
  #               #     else
  #               #         return 'Redouble'
  #               #     end
  #               #   else
  #               #   if(average.to_i >=16)
  #               #    return 'DiplomeAFJ'
  #               #   else
  #               #    return 'Diplome'
  #               #   end
  #               # end
  #               #else
  #
  #               if (average >= 16)
  #                 return 'AdmisAFJ'
  #               else
  #                 return 'Admis'
  #               end
  #               #end
  #             else
  #               if (nb_nv1.to_i <= max_failed)
  #                 return 'Rachetead'
  #               else
  #                 return 'Redouble'
  #               end
  #             end
  #           else
  #             return 'Redouble'
  #           end
  #         else
  #           if (average.to_i >= av and nb_nv1.to_i <= max_failed)
  #             return 'Rachetead'
  #           else
  #             return 'Redouble'
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

  def show_students_result_details

    @note_max = params[:note_max]
    @note_min = params[:note_min]
    @moyenne_class = params[:moyenne_class]
    @nombre_zero = params[:nombre_zero]
    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @student = Student.find(params[:student_id])
    @years = YearlyDecision.find(:all, :conditions => "student_id = #{@student.id}")
    @courses = []
    @course1 = params[:course1]
    @course2 = params[:course2]
    @courses << params[:course1]
    @courses << params[:course2]
    @batches = []
    @range = params[:range]
    @sf_sm = []
    @sf_sm2 = []
    @sf_sm_rs = []
    @sf_tmp = []
    @batches2 = []
    @annee_reserve_detail = []
    @annee_reserve_detail_old = []
    @annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id =#{@student.id} and school_year = #{@school_year} ")
    @annee_reserve_old = ReserveYearStudent.find(:first, :conditions => "student_id =#{@student.id} and school_year = #{((@school_year.to_i) - 1).to_s } ")
    if (@annee_reserve_old != nil)
      @annee_reserve_detail_old = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve_old.id}")
    end
    if (@annee_reserve != nil)
      @annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve.id}")
      @courses.each do |course|
        bt = Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s}").reject { |x| x.get_batch_year != @school_year.to_i - 1 }
        if (bt)
          @batches2 += bt
        end
      end
    end
    @courses.each do |course|

      bt = Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
      if (bt)
        @batches += bt
      end
      @sf_sm += SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => course.to_i, :school_year => @school_year, :school_field_id => @school_field_id })
    end

    @batch_ids = ""
    @batches.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end
    batch_string = ""
    @batches.each do |batch|

      batch_string += batch.id.to_s + ','
    end

    todo = params[:todo]
    @is_checked = true
    if (todo == 'new')
      @button_name = t('validate')
    else
      @button_name = t('update')
      @is_checked = false
    end
    @ydecision = YearlyDecision.find(:first, :conditions => " student_id = #{@student.id} and school_year =#{@school_year} and batch_ids like '%#{batch_string}%'")
    render(:update) do |page|
      page.replace_html 'modal-box', :partial => 'show_student_result_details'
      page << "Modalbox.show($('modal-box'), {title: 'Détails des notes', width: 1400, height:600});"
    end

  end

  def display_rest_info
    @school_year = params[:school_year]
    @school_field_id = params[:school_field_id]
    @course1 = params[:course1]
    @course2 = params[:course2]
    @nbr_VAL = params[:nb_val]
    @nbr_VAR = params[:nb_var]
    @nbr_NV = params[:nb_nv]
    @nbr_EL = params[:nb_el]
    @year_average = params[:year_average]
    @student_id = params[:student_id]
    @student = Student.find(@student_id)
    decision = params[:decision]
    render(:update) do |page|
      if (!decision.include? "cours")
        page.replace_html "result_#{@student_id}", :text => "#{@student.get_decision_name(decision)}"
        page.replace_html "val_#{@student_id}", :text => "#{@nbr_VAL.to_s}"
        page.replace_html "var_#{@student_id}", :text => "#{@nbr_VAR.to_s}"
        page.replace_html "nv_#{@student_id}", :text => "#{@nbr_NV.to_s}"
        page.replace_html "el_#{@student_id}", :text => "#{@nbr_EL.to_s}"
        page.replace_html "val_tot_#{@student_id}", :text => "#{@nbr_VAL.to_i + @nbr_VAR.to_i}"
        page.replace_html "moy_#{@student_id}", :text => "#{sprintf("%.4f", @year_average)}"
        page.replace_html "act_#{@student_id}", :partial => "update_decision"
        page.replace_html "check_#{@student_id}", :partial => "check"

      end
    end

  end

  def update_mark
    #@button_name=params[:button_name]
    @course1 = params[:course1]
    @course2 = params[:course2]
    @school_year = params[:school_year]
    @school_field_id = params[:school_field_id]
    @courses = []
    @courses << params[:course1]
    @courses << params[:course2]
    @batches = []
    @courses.each do |course|

      bt = Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s}").reject { |x| x.get_batch_year != @school_year.to_i } #Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))")
      bt.each do |btch|
        @batches << btch unless btch.get_batch_year != @school_year.to_i

      end
    end

    @exam_score = ExamScore.find(params[:exam_score_id])
    @school_module = SchoolModule.find(params[:school_module_id])
    test = params[:test]
    @new_mark = params[:new_mark]
    @subject_id = Exam.find(@exam_score.exam_id).subject_id
    render(:update) do |page|
      new_dec = ""
      new_held_avg = 0
      if (test == '0')
        if @exam_score.update_attribute(:marks, @new_mark)
          new_avg = 0
          # new_avg_ar=0

          @batches.each do |bat|
            new_results = @school_module.marks_infos(bat.id, @exam_score.student_id, @school_year, session[:param_notes])
            #avg=@school_module.average(bat.id,@exam_score.student_id,@school_year,session[:param_notes])
            #avg_ar=@school_module.average_after_pass(bat.id,@exam_score.student_id,@school_year,session[:param_notes])
            #dec=@school_module.module_decision(bat.id,@exam_score.student_id,@school_year,session[:param_notes])
            #held_avg=@school_module.held_average(bat.id,@exam_score.student_id,@school_year,session[:param_notes])
            if (new_results["average"])
              new_avg = new_results["average"]
              #new_avg_ar=avg_ar
              new_dec = new_results["decision"]
              new_held_avg = new_results["held_average"]
            end
          end
          page.replace_html "divmark_#{@subject_id}", :partial => "mark_change"
          page.replace_html "avg_#{@school_module.id}", :text => "#{new_avg}"
          #page.replace_html "avg_ar_#{@school_module.id}", :text => "#{new_avg_ar}"
          #page.replace_html "held_avg_#{@school_module.id}", :text => "#{new_held_avg}"
          #page.replace_html "md_decision_#{@school_module.id}", :text => "#{new_dec}"
        end
      else
        if @exam_score.update_attribute(:marks_ar, @new_mark)
          new_avg_ar = 0
          @batches.each do |bat|
            avg = @school_module.average(bat.id, @exam_score.student_id, @school_year, session[:param_notes])
            avg_ar = @school_module.average_after_pass(bat.id, @exam_score.student_id, @school_year, session[:param_notes])
            dec = @school_module.module_decision(bat.id, @exam_score.student_id, @school_year, session[:param_notes])
            held_avg = @school_module.held_average(bat.id, @exam_score.student_id, @school_year, session[:param_notes])
            if (avg != -1)
              #new_avg=avg
              new_avg_ar = avg_ar
              new_dec = dec
              new_held_avg = held_avg
            end
          end
          page.replace_html "divmarkar_#{@subject_id}", :partial => "markar_change"
          page.replace_html "avg_ar_#{@school_module.id}", :text => "#{new_avg_ar}"
        end
      end
      #new_dec=@school_module.module_decision(bat.id,@exam_score.student_id,@school_year,session[:param_notes])
      #new_held_avg=@school_module.held_average(bat.id,@exam_score.student_id,@school_year,session[:param_notes])
      page.replace_html "held_avg_#{@school_module.id}", :text => "#{new_held_avg}"
      page.replace_html "md_decision_#{@school_module.id}", :text => "#{new_dec}"
      @average_of_year = SchoolModule.average_of_year(@batches, @exam_score.student_id, @school_year, session[:param_notes])
      @validate_modules = SchoolModule.validate_modules(@batches, @exam_score.student_id, @school_year, session[:param_notes])
      @validate_modules_after_pass = SchoolModule.validate_modules_after_pass(@batches, @exam_score.student_id, @school_year, session[:param_notes])
      @non_validate_modules = SchoolModule.non_validate_modules(@batches, @exam_score.student_id, @school_year, session[:param_notes]).first
      page.replace_html "student_result_change", :partial => "student_result_change"
      page.replace_html "final_action", :partial => "final_action"
      page.replace_html "stat_val_#{@exam_score.student_id}", :partial => "stat_val"
      page.replace_html "stat_nval_#{@exam_score.student_id}", :partial => "stat_nval"
      page.replace_html "stat_var_#{@exam_score.student_id}", :partial => "stat_var"
    end
  end

  def manage_bulletin_old
    @current_user = current_user
    #@school_fields=SchoolField.find(:all)
    if @current_user.admin?
      @school_fields = SchoolField.find(:all, :order => "name")
    else
      @school_fields = SchoolField.find_by_sql("select * from school_fields where employee_id=#{@current_user.employee_record.id}")
      SchoolFieldEmployee.find_all_by_employee_id(@current_user.employee_record.id).each do |sf|
        @school_fields += SchoolField.find_by_sql("select * from school_fields where id=#{sf.school_field_id}")
      end
      @school_fields = @school_fields.uniq
    end

    @courses = Course.find(:all)
    @course_groups = @courses.group_by { |course| course.course_name }
    @group = []
    @course_groups.each do |key, value|
      chaine = ""
      @course_groups[key].each do |course|
        chaine += course.id.to_s + ','
      end
      chaine += '0'
      @group << [key, chaine]
    end

  end

  def manage_bulletin

    @school_fields_option = []

    if (@current_user.admin?)
      #@school_fields=SchoolField.find(:all)
      @school_fields = SchoolField.find(:all, :conditions => "field_root IS  NULL", :order => "name")

    elsif (@current_user.privileges.map { |p| p.name }.include?("Coordonateurfiliere"))
      empl = Employee.find_by_user_id(@current_user.id)
      @school_fields = SchoolField.find(:all, :conditions => "employee_id = #{empl.id}")
    end
    @courses = Course.find(:all)
    @course_groups = @courses.group_by { |course| course.course_name }
    @group = []
    @course_groups.each do |key, value|
      chaine = ""
      @course_groups[key].each do |course|
        chaine += course.id.to_s + ','
      end
      chaine += '0'
      @group << [key, chaine]
    end

  end

  def display_filiere_option_viewall
    @school_year = school_year = params[:school_year]
    school_field_id = params[:filiere_id]
    @school_fields_option = SchoolField.find_by_sql("select distinct sf.* from school_fields sf, school_field_school_modules sfm where sf.id=sfm.school_field_id and sfm.school_year=#{school_year} and sf.field_root = #{school_field_id}")
    @school_fields_option.each do |zz|
      batches = Batch.find_all_by_school_field_id(zz.id).reject { |t| t.get_batch_year != @school_year.to_i }
      if batches.empty?
        @school_fields_option.delete(zz)
      end
    end
    #@school_fields_option = SchoolField.find(:all, :conditions => " field_root = #{school_field_id} ")
    #@school_fields_option = SchoolField.first.getFieldbyCourses(params["course_ids"]
    render(:update) do |page|
      page.replace_html 'select_filiere_option_viewall', :partial => 'select_filiere_option_viewall'
    end
  end

  def course_selection_manage_bulletin
    id_ecole = params[:school_id] unless params[:school_id].nil?
    # id_cycle = params[:cycle_id] unless params[:cycle_id].nil?
    id_cycle = 6 #initialiser cycle_id par defaut cycle_id = 6
    if current_user.admin?
      @courses = Course.find(:all, :conditions => "(cycle_id = #{id_cycle} or #{id_cycle} is null)")
    elsif current_user.employee and current_user.privileges.map { |p| p.name }.include?("Coordonateurfiliere") and current_user.employee_record.school_field.id == 1
      @courses = Course.find(:all, :conditions => "(cycle_id = #{id_cycle} or #{id_cycle} is null)").reject { |c| c.id < 20 }
    else
      @courses = Course.find(:all, :conditions => "(cycle_id = #{id_cycle} or #{id_cycle} is null)").reject { |c| c.id > 20 }
    end
    @courses = @courses.sort_by { |b| b.code }
    # @courses=Course.find(:all, :conditions => "(cycle_id = #{id_cycle} or #{id_cycle} is null)")
    @course_groups = @courses.group_by { |course| course.course_name }
    @group = []
    @course_groups.each do |key, value|
      chaine = ""
      @course_groups[key].each do |course|
        chaine += course.id.to_s + ','
      end
      chaine += '0'
      @group << [key, chaine]
    end
    render(:update) do |page|
      page.replace_html 'course_selection_manage', :partial => 'course_selection_manage'
    end
  end

  def show_student_list
    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @courses = params[:course_ids].split(",")
    @courses = @courses.reject { |c| c.to_i == 0 }
    @course1 = @courses[0]

    if (@courses[1])
      @course2 = @courses[1]
    else
      @course2 = -1.to_s
    end

    @batches = []
    @courses.each do |course|
      bt = Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
      if (bt)
        @batches += bt
      end
    end
    @students = []
    @batch_ids = ""
    infos_modules = []
    number_modules = 0
    @batch_ids = ""
    @batches.each do |batch|
      @students += Student.find_by_sql("select id,matricule,last_name,first_name from students where batch_id = #{batch.id}") unless !Student.find_by_sql("select id,matricule,last_name,first_name from students where batch_id = #{batch.id}")
      @students += batch.old_students
      @students = @students.uniq { |x| x.id }
      @batch_ids += batch.id.to_s + ","

      modules = []
      sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => batch.school_field_id, :course_id => batch.course_id, :school_year => batch.get_batch_year })
      sf_sm.each do |sfssm|
        modules << SchoolModule.find(sfssm.school_module_id)
      end
      modules = modules.uniq
      infos_modules[batch.id] = {}
      infos_modules[batch.id]['modules'] = modules

      modules.each do |md|
        sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
        exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(batch.id, md.id)
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
              sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{@school_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
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
        infos_modules[batch.id][md.id] = {}
        infos_modules[batch.id][md.id]['non_spec_pond'] = non_spec_pond
        infos_modules[batch.id][md.id]['spec_pond'] = spec_pond
        infos_modules[batch.id][md.id]['pond'] = pond
        infos_modules[batch.id][md.id]['sfsm'] = sfsm
        number_modules += modules.count
      end
    end

    @resultats = []
    infos_modules[0] = {}
    infos_modules[0]['number_modules'] = number_modules
    @students.each do |st|
      @resultats[st.id] = {}
      # annee_reserves = ReserveYearStudent.find_by_sql("select * from reserve_year_students where student_id = #{st.id}")
      # annee_reserve = annee_reserves.select { |ar| ar.school_year == @school_year }.first
      # annee_reserve_old = annee_reserves.select { |ar| ar.school_year == (@school_year.to_i - 1) }.first
      # ydecision = YearlyDecision.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{@batch_ids}%'")
      # if (1 == 0 and ydecision and !params[:typd] and annee_reserve.nil? and annee_reserve_old.nil? and ydecision.avg_year.to_i != -1)
      #   @resultats[st.id]['decision'] = ydecision.decision
      #   @resultats[st.id]['avg_year'] = ydecision.avg_year
      # else
      modules_max_data = SchoolModule.modules_max_data_opt3(@batches, st.id, @school_year, infos_modules)
      @resultats[st.id]['avg_year'] = modules_max_data['average_of_year'].to_f
      @resultats[st.id]['avg_year_normale'] = modules_max_data['average_of_year_session_normale'].to_f
      # end
    end

    @classement = []

    @students.sort! { |a, b| @resultats[b.id]['avg_year'] <=> @resultats[a.id]['avg_year'] }
    i = 1
    @students.each do |st|
      @classement[st.id] = i
      i = i + 1
    end
    @nbr_students = i - 1
    @students.sort! { |a, b| a.last_name <=> b.last_name }
    render(:update) do |page|
      page.replace_html 'show_student_list', :partial => 'show_student_list'
    end
  end

  def show_student_releve_old
    @todo = params[:todo]
    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @course1 = params[:course1]
    @course2 = params[:course2]

    @batchs1 = Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @batchs2 = Batch.find(:all, :conditions => "course_id = #{@course2.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @sf_sm1 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course1, :school_year => @school_year, :school_field_id => @school_field_id })
    @sf_sm2 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course2, :school_year => @school_year, :school_field_id => @school_field_id })
    @batch_ids = ""

    logger.debug "------------------------------------------------------"
    logger.debug @batchs1.inspect
    logger.debug "------------------------------------------------------"
    logger.debug @batchs2.inspect
    logger.debug "------------------------------------------------------"
    logger.debug @sf_sm1.inspect
    logger.debug "------------------------------------------------------"
    logger.debug @sf_sm2.inspect
    logger.debug "------------------------------------------------------"

    @nbre_modules = SchoolModule.nbre_modules(@batchs1, @school_year, session[:param_notes]) + SchoolModule.nbre_modules(@batchs2, @school_year, session[:param_notes])
    @batchs1.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end
    @batchs2.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end
    @student_orders = YearlyDecision.find_by_sql("SELECT distinct(student_id),avg_year,nb_val FROM `yearly_decisions` WHERE ( batch_ids like '%" + @batch_ids + "%' and school_year=#{@school_year})").sort_by { |sk| [sk.avg_year, sk.nb_val] }.reverse

    #@student_orders = YearlyDecision.find(:all,:conditions => " batch_ids like '%#{@batch_ids}%'").sort_by{|s| Student.find_by_id(s.student_id).last_name}

    # @student_orders = @student_orders.sort_by{|sk| sk.avg_year}.reverse
    logger.debug @batch_ids

    @all_students = []

    @batchs1.each do |b|
      sts = b.students
      sts += b.old_students
      sts += b.all_students
      sts = sts.uniq
      sts.each do |s|
        @all_students << s
      end
    end

    @batchs2.each do |b|
      stss = b.students
      stss += b.old_students
      stss += b.all_students
      stss = stss.uniq
      stss.each do |s|
        @all_students << s
      end
    end

    @batches = []
    @batchs1.each do |b|
      @batches << b unless b.nil?
    end

    @batchs2.each do |b|
      @batches << b unless b.nil?
    end

    @all_students = @all_students.uniq
    @st_orders = @all_students
    @resultats = []
    @st_orders.each do |st|
      @resultats[st.id] = {}
      ydecision = YearlyDecision.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{@batch_ids}%'")
      if (ydecision)
        @resultats[st.id]['avg_year'] = ydecision.avg_year
      else
        rslt = st.check_student_result(@batches, @school_year, 4, session[:param_notes])
        moyenne = @resultats[st.id]['avg_year'] = rslt["average_of_year"]
      end
    end

    @st_orders.sort! { |a, b| @resultats[b.id]['avg_year'] <=> @resultats[a.id]['avg_year'] }

    if (params[:student_id])

      @student = Student.find(params[:student_id])
      if @course1.to_i == 3
        classment = []
        tot_f = 0
        @flg = 0
        Batch.find_all_by_school_field_id_and_course_id(@school_field_id, 3).reject { |b| b.get_batch_year != @school_year.to_i }.each do |b|
          logger.debug b.inspect
          redouble = @student.redouble(b.id)
          sts = b.students
          sts += b.old_students
          sts += b.all_students
          if !redouble.nil?
            sts << @student
          end
          sts = sts.uniq
          tot_f += sts.count
          sts.each do |s|
            note = SchoolModule.average_of_year([b], s.id, @school_year, session[:param_notes])
            #note = s.check_student_result([b],@school_year,4,session[:param_notes])["average_of_year"]
            classment << { :id => s.id, :note => note }
          end
        end
        classment = classment.sort_by { |c| c[:note] }.reverse
        logger.debug classment.inspect
        logger.debug @student.id
        logger.debug @school_field_id
        @cla_field = classment.index(classment.select { |e| e[:id] == @student.id }.first) + 1
        @tot_f = tot_f
        @classment = classment
        tot_c = 0
        classment = []

        @cltt = []
        @batchs1.each do |b|
          sts = b.students
          redouble = @student.redouble(b.id)
          sts += b.old_students

          sts += b.all_students

          if !redouble.nil?
            sts << @student
          end

          sts = sts.uniq

          tot_c += sts.count

          sts.each do |s|
            note = SchoolModule.average_of_year([b], s.id, @school_year, session[:param_notes])
            #note = s.check_student_result([b],@school_year,4,session[:param_notes])["average_of_year"]
            classment << { :id => s.id, :note => note }
            @cltt << { :id => s.id, :note => note }
          end

        end

        classment = classment.sort_by { |c| c[:note] }.reverse
        @cltt = @cltt.sort_by { |c| c[:note] }.reverse

        @cla_cla = classment.index(classment.select { |e| e[:id] == @student.id }.first) + 1
        @tot_c = tot_c
        @classment2 = classment

      end
      @yd = YearlyDecision.find(:first, :conditions => " student_id = #{@student.id} and school_year =#{@school_year} and batch_ids like '%#{@batch_ids}%'")
      @exams1 = []
      @exams2 = []
    else
      @students = Student.find_all_by_batch_id(@batchs1[0].id)
      @students += @batchs1[0].old_students

      tot_c = 0
      @classment = []
      @batchs1.each do |b|
        sts = b.students
        sts += b.old_students
        sts += b.all_students
        sts = sts.uniq

        tot_c += sts.count

        sts.each do |s|
          note = SchoolModule.average_of_year([b], s.id, @school_year, session[:param_notes])
          #note = s.check_student_result([b],@school_year,4,session[:param_notes])["average_of_year"]
          @classment << { :id => s.id, :note => note }
        end

      end

      @classment = @classment.sort_by { |c| c[:note] }.reverse
      @tot_c = tot_c

=begin
        bs = BatchStudent.find_all_by_batch_id(@batchs1[0].id)
                unless bs.empty?
                               bs.each do |bst|
                                     student = Student.find(bst.student_id)
                                     @students << student unless student.nil?
                                end
                end
=end

      @students = @students.uniq { |x| x.id } #[199..300]

    end

    render :pdf => 'show_student_releve'

  end

  def racheter
    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @school_module_id = params[:school_module_id]
    @student_id = params[:student_id]
    @course1 = params[:course1]
    @course2 = params[:course2]
    @content = params[:content]
    @act = 1
    @courses = []
    @courses << params[:course1]
    @courses << params[:course2]

    @batches = []
    @courses.each do |course|

      bt = Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s}").reject { |x| x.get_batch_year != @school_year.to_i } #Batch.find(:all, :conditions => "course_id = #{course.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i+1).to_s} and month(start_date) < 8))")
      bt.each do |btch|
        @batches << btch unless btch.get_batch_year != @school_year.to_i

      end
    end

    @exam_groups = []
    @batches.each do |batch|
      @exam_groups += ExamGroup.find(:all, :conditions => { :batch_id => batch.id, :module_id => @school_module_id })
    end
    #@rachetage=[]
    test = 0

    @exam_groups.each do |exp|
      @rtc = Rachetage.find_by_exam_group_id_and_student_id(exp.id, @student_id)
      if (!@rtc and params[:content])
        @content = params[:content]
        @rachetage = Rachetage.new(:exam_group_id => exp.id, :student_id => @student_id, :observation => @content)
        if @rachetage.save then
          test = 1
        end
      else
        @rtc.destroy
      end
    end

    render :update do |page|
      page.hide "show_elements_result_#{@school_module_id}"
      page.replace_html "action_#{@school_module_id}", :partial => 'element_result_show_hide'
      if (test == 1)
        page.replace_html "state_#{@school_module_id}", :text => 'R'
      else
        page.replace_html "state_#{@school_module_id}", :text => ''
      end
    end
  end

  def statistique
    @yearlys = []

  end

  def statistiques
    @year1 = params[:school_year_d]
    @year2 = params[:school_year_f]

    @year1_i = @year1.to_i
    @year2_i = @year2.to_i
    i = @year1_i
    @res = []
    @yearlys = []
    while (i <= @year2_i)
      @res[i] = {}
      compteAdmis = 0
      compteAnneeReserve = 0
      compteReoriente = 0
      compteExclu = 0
      compteAnneeBlanch = 0
      yearly_decisions = YearlyDecision.find(:all, :conditions => "school_year = #{i.to_s}")
      compte = 0
      yearly_decisions.each do |yd|
        if (yd.decision != 'Redouble' and yd.decision != 'AnneeReserve' and yd.decision != 'Exclu' and yd.decision != 'AnneeBlanche' and yd.decision != 'Ajourne' and yd.decision != 'Reoriente')
          compteAdmis = compteAdmis + 1
        elsif (yd.decision == 'AnneeReserve')
          compteAnneeReserve = compteAnneeReserve + 1
        elsif (yd.decision == 'Reoriente')
          compteReoriente = compteReoriente + 1
        elsif (yd.decision == 'Exclu')
          compteExclu = compteExclu + 1
        elsif (yd.decision == 'AnneeBlanche')
          compteAnneeBlanch = compteAnneeBlanch + 1
        end
        if (compte == 0)
          @yearlys << yd
        end
        compte = compte + 1
      end

      @res[i]['Admis'] = compteAdmis.to_s
      @res[i]['AnneeReserve'] = compteAnneeReserve.to_s
      @res[i]['Reoriente'] = compteReoriente.to_s
      @res[i]['Exclu'] = compteExclu.to_s
      @res[i]['AnneeBlanch'] = compteAnneeBlanch.to_s
      logger.debug "******************Statistique********************"
      logger.debug @res[i]['Admis']
      i = i + 1

    end

    @school_fields = SchoolField.find(:all, :conditions => "field_root = id")
    @resultat = []
    @cle = @school_fields.first.id
    @school_fields.each do |sf|

      @school_field_ch = SchoolField.find(:all, :conditions => "field_root = #{sf.id}")
      @resultat[sf.id] = {}
      @resultat[sf.id]['name'] = sf.name
      @resultat[@cle]['total_nb1'] = 0
      @resultat[@cle]['total_nb2'] = 0
      @resultat[@cle]['total_nb3'] = 0
      @batch1 = Batch.find(:all, :conditions => ["(course_id= 1 or course_id = 2) and school_field_id=#{sf.id}"]).reject { |b| b.get_batch_year != @year2_i }.first
      @batch2 = Batch.find(:all, :conditions => ["(course_id= 3 or course_id = 4) and school_field_id=#{sf.id}"]).reject { |b| b.get_batch_year != @year2_i }.first
      @batch3 = Batch.find(:all, :conditions => ["(course_id= 5 or course_id = 6) and school_field_id=#{sf.id}"]).reject { |b| b.get_batch_year != @year2_i }.first
      if (!@batch1.nil?)
        @resultat[sf.id]['nb_1'] = @batch1.students.count
      else
        @resultat[sf.id]['nb_1'] = 0
      end
      if (!@batch2.nil?)
        @resultat[sf.id]['nb_2'] = @batch2.students.count
      else
        @resultat[sf.id]['nb_2'] = 0
      end
      if (!@batch3.nil?)
        @resultat[sf.id]['nb_3'] = @batch3.students.count
      else
        @resultat[sf.id]['nb_3'] = 0
      end

      @resultat[@cle]['total_nb1'] = @resultat[@cle]['total_nb1'] + @resultat[sf.id]['nb_1']
      @resultat[@cle]['total_nb2'] = @resultat[@cle]['total_nb2'] + @resultat[sf.id]['nb_2']
      @resultat[@cle]['total_nb3'] = @resultat[@cle]['total_nb3'] + @resultat[sf.id]['nb_3']

      @school_field_ch.each do |sf_c|
        @batch1 = Batch.find(:all, :conditions => ["(course_id= 1 or course_id = 2) and school_field_id=#{sf_c.id}"]).reject { |b| b.get_batch_year != @year2_i }.first
        @batch2 = Batch.find(:all, :conditions => ["(course_id= 3 or course_id = 4) and school_field_id=#{sf_c.id}"]).reject { |b| b.get_batch_year != @year2_i }.first
        @batch3 = Batch.find(:all, :conditions => ["(course_id= 5 or course_id = 6) and school_field_id=#{sf_c.id}"]).reject { |b| b.get_batch_year != @year2_i }.first
        if (!@batch1.nil?)
          @resultat[sf.id]['nb_1'] = @resultat[sf.id]['nb_1'] + @batch1.students.count

        end
        if (!@batch2.nil?)
          @resultat[sf.id]['nb_2'] = @resultat[sf.id]['nb_2'] + @batch2.students.count

        end
        if (!@batch3.nil?)
          @resultat[sf.id]['nb_3'] = @resultat[sf.id]['nb_3'] + @batch3.students.count

        end
      end
    end

    render(:update) do |page|
      page.replace_html 'statistiques', :partial => 'statistiques'
      #page.replace_html 'effectifs', :partial => 'effectifs'
    end
  end

  def show_student_bulletin
    @todo = params[:todo]
    @which_one = params[:which_one]
    @school_field_id = params[:school_field_id]
    @old_year = params[:old_year]
    @school_year = params[:school_year]
    @course1 = params[:course1]
    @course2 = params[:course2]
    @student = Student.find_by_id(params[:student_id])
    @changed = params[:changed]
    @classement = params[:classement]
    @nbr_students = params[:nbr_students]

    if @changed

      if @old_year > @school_year
        @course1 = params[:course1].to_i - (@old_year.to_i - @school_year.to_i)
        @course2 = params[:course2].to_i - (@old_year.to_i - @school_year.to_i)
        if @course1 < 1
          @course1 = 1
        elsif @course2 < 7
          @course2 = 7
        end

      else
        @course1 = params[:course1].to_i + (@school_year.to_i - @old_year.to_i)
        @course2 = params[:course2].to_i + (@school_year.to_i - @old_year.to_i)
        if @course1 > 6
          @course1 = 6
        elsif @course2 > 12
          @course2 = 12
        end
      end
      @changed = false
      #to fixxx
      BatchStudent.find_all_by_student_id(@student.id).each do |bs|
        f = Batch.find_by_id(bs.batch_id)
        if f.start_date.year.to_i == @school_year.to_i
          @school_field_id = f.school_field_id
          break
        end
      end
    end
    @batchs1 = Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @batchs2 = Batch.find(:all, :conditions => "course_id = #{@course2.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @sf_sm1 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course1, :school_year => @school_year, :school_field_id => @school_field_id })
    @sf_sm2 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course2, :school_year => @school_year, :school_field_id => @school_field_id })
    @batch_ids = ""

    @batches = []
    if @batchs1
      @batches += @batchs1
    end
    if @batchs2
      @batches += @batchs2
    end

    if @student
      infos_modules = []
      number_modules = 0
      @batches.each do |batch|
        @batch_ids += batch.id.to_s + ","
        modules = []
        sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => batch.school_field_id, :course_id => batch.course_id, :school_year => batch.get_batch_year })
        sf_sm.each do |sfssm|
          modules << SchoolModule.find(sfssm.school_module_id)
        end
        modules = modules.uniq
        infos_modules[batch.id] = {}
        infos_modules[batch.id]['modules'] = modules

        modules.each do |md|
          sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
          exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(batch.id, md.id)
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
                sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{@school_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
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
          infos_modules[batch.id][md.id] = {}
          infos_modules[batch.id][md.id]['non_spec_pond'] = non_spec_pond
          infos_modules[batch.id][md.id]['spec_pond'] = spec_pond
          infos_modules[batch.id][md.id]['pond'] = pond
          infos_modules[batch.id][md.id]['sfsm'] = sfsm
          number_modules += 1
        end
      end
      infos_modules[0] = {}
      infos_modules[0]['number_modules'] = number_modules
      @yearly_infos = @student.check_student_result_h(@batches, @school_year, infos_modules)

    end
    @batchs1.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end
    @btss = @batchs1 + @batchs2
    @batchs2.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end

    @annee_reserve_detail = []
    @annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id =#{@student.id} and school_year = #{@school_year} ")
    if (@annee_reserve != nil)
      @annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve.id}")
    end
    if (@sf_sm1)
      @infos = []
      @sf_sm1.each do |sf_sm|
        @infos[sf_sm.id] = {}
        found = 0
        md = SchoolModule.find(sf_sm.school_module_id)
        @infos[sf_sm.id]["md_name"] = md.name
        @annee_reserve_detail.each do |ar|
          if (ar.school_module_id == md.id)
            found = 1
          end
        end
        if (md)
          if @school_field_id.to_i == 10 and @school_year.to_i == 2020
            @batchs1 = @batchs1.select { |b| b.is_active == true }
          end
          @batchs1.each do |bat|
            bat_anc = Batch.find(:first, :conditions => "course_id = #{bat.course.id.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{(@school_year.to_i - 1).to_s} or (year(start_date)=#{(@school_year).to_s} and month(start_date) < 8))")
            if ((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?))
              rq = md.marks_infos_2(bat.id, @student.id, @school_year)
              @infos[sf_sm.id]["held_avg"] = rq["held_average"]
              @infos[sf_sm.id]["decision"] = rq["decision"]
              @infos[sf_sm.id]["is_pond_zero"] = rq["is_pond_zero"]
            else
              rq = md.marks_infos_2(bat.id, @student.id, @school_year.to_i - 1)
              @infos[sf_sm.id]["held_avg"] = rq["held_average"]
              @infos[sf_sm.id]["decision"] = rq["decision"]
              @infos[sf_sm.id]["is_pond_zero"] = rq["is_pond_zero"]
            end
          end
        end
      end
    end
    if (@sf_sm2)
      @infos2 = []
      @sf_sm2.each do |sf_sm|
        @infos2[sf_sm.id] = {}
        found = 0
        md = SchoolModule.find(sf_sm.school_module_id)
        @infos2[sf_sm.id]["md_name"] = md.name
        @annee_reserve_detail.each do |ar|
          if (ar.school_module_id == md.id)
            found = 1
          end
        end
        if (md)
          if @school_field_id.to_i == 10 and @school_year.to_i == 2020
            @batchs2 = @batchs2.select { |b| b.is_active == true }
          else
            @batchs2 = @batchs2
          end
          @batchs2.each do |bat|
            bat_anc = Batch.find(:first, :conditions => "course_id = #{bat.course.id.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{(@school_year.to_i - 1).to_s} or (year(start_date)=#{(@school_year).to_s} and month(start_date) < 8))")
            if ((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?))
              rq = md.marks_infos_2(bat.id, @student.id, @school_year)
              @infos2[sf_sm.id]["held_avg"] = rq["held_average"]
              @infos2[sf_sm.id]["decision"] = rq["decision"]
              @infos2[sf_sm.id]["is_pond_zero"] = rq["is_pond_zero"]
            else
              rq = md.marks_infos_2(bat_anc.id, @student.id, @school_year.to_i - 1)
              @infos2[sf_sm.id]["held_avg"] = rq["held_average"]
              @infos2[sf_sm.id]["decision"] = rq["decision"]
              @infos2[sf_sm.id]["is_pond_zero"] = rq["is_pond_zero"]
            end
          end
        end
      end
    end

    if (@todo == 'show_bulletin')
      render(:update) do |page|
        page.replace_html 'modal-box', :partial => 'show_student_marks_bulletin'
        page << "Modalbox.show($('modal-box'), {title: '#{t('marks_bulletin')}', width: 1000, height:700});"
      end
    elsif (@todo == 'show_bulletin_report')
      #get the @available_years
      @available_years = []
      BatchStudent.find_all_by_student_id(@student.id).reject { |b| Batch.find_by_id(b.batch_id).nil? }.each do |bs|
        @available_years.push Batch.find_by_id(bs.batch_id).start_date.year unless Batch.find_by_id(bs.batch_id).start_date.nil?
      end
      @available_years = @available_years.uniq.sort
      render(:update) do |page|
        page.replace_html 'modal-box', :partial => 'show_student_report_mark'
        page << "Modalbox.show($('modal-box'), {title: '#{t('marks_report')}', width: 1000, height:700});"
      end
    elsif (@todo == 'show_without_semester')
      render :pdf => 'bulletin_without_semester'
    elsif (@todo == 'show_in_pdf')
      @students = []
      render :pdf => 'show_student_bulletin'
    elsif (@todo == 'show_releve_in_pdf')
      @students = Student.find_all_by_batch_id(@batchs1[0].id)
      @students += @batchs1[0].old_students
      @students = @students.uniq { |x| x.id }.sort! { |a, b| a.last_name <=> b.last_name }
      render :pdf => 'Relevé' + @student.full_name + '_' + @student.batch.name
    end
  end

  def show_student_bulletin_global
    @school_field_id = params[:school_field_id]
    @old_year = params[:old_year]
    @school_year = params[:school_year]
    @course1 = params[:course1]
    @course2 = params[:course2]

    @batchs1 = Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @batchs2 = Batch.find(:all, :conditions => "course_id = #{@course2.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @sf_sm1 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course1, :school_year => @school_year, :school_field_id => @school_field_id })
    @sf_sm2 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course2, :school_year => @school_year, :school_field_id => @school_field_id })
    @batch_ids = ""
    @batches = []
    if @batchs1
      @batches += @batchs1
    end
    if @batchs2
      @batches += @batchs2
    end
    @students = []
    if @students
      infos_modules = []
      number_modules = 0
      @batches.each do |batch|
        @batch_ids += batch.id.to_s + ","
        @students += Student.find_by_sql("select id,matricule,last_name,first_name from students where batch_id = #{batch.id}") unless !Student.find_by_sql("select id,matricule,last_name,first_name from students where batch_id = #{batch.id}")
        @students += batch.old_students
        @students = @students.uniq { |x| x.id }
        modules = []
        sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => batch.school_field_id, :course_id => batch.course_id, :school_year => batch.get_batch_year })
        sf_sm.each do |sfssm|
          modules << SchoolModule.find(sfssm.school_module_id)
        end
        modules = modules.uniq
        infos_modules[batch.id] = {}
        infos_modules[batch.id]['modules'] = modules

        modules.each do |md|
          sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
          exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(batch.id, md.id)
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
                sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{@school_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
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
          infos_modules[batch.id][md.id] = {}
          infos_modules[batch.id][md.id]['non_spec_pond'] = non_spec_pond
          infos_modules[batch.id][md.id]['spec_pond'] = spec_pond
          infos_modules[batch.id][md.id]['pond'] = pond
          infos_modules[batch.id][md.id]['sfsm'] = sfsm
          number_modules += 1
        end
      end
      infos_modules[0] = {}
      infos_modules[0]['number_modules'] = number_modules
    end
    @infos = []
    @yearly_infos = []
    @students.each do |st|
      @infos[st.id] = {}
      @yearly_infos[st.id] = st.check_student_result_h(@batches, @school_year, infos_modules)
      @annee_reserve_detail = []
      @annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id =#{st.id} and school_year = #{@school_year} ")
      if (@annee_reserve != nil)
        @annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve.id}")
      end
      if (@sf_sm1)
        @sf_sm1.each do |sf_sm|
          @infos[st.id][sf_sm.id] = {}
          found = 0
          md = SchoolModule.find(sf_sm.school_module_id)
          @infos[st.id][sf_sm.id]["md_name"] = md.name
          @annee_reserve_detail.each do |ar|
            if (ar.school_module_id == md.id)
              found = 1
            end
          end
          if (md)
            if @school_field_id.to_i == 10 and @school_year.to_i == 2020
              @batchs1 = @batchs1.select { |b| b.is_active == true }
            end
            @batchs1.each do |bat|
              bat_anc = Batch.find(:first, :conditions => "course_id = #{bat.course.id.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{(@school_year.to_i - 1).to_s} or (year(start_date)=#{(@school_year).to_s} and month(start_date) < 8))")
              if ((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?))
                rq = md.marks_infos_2(bat.id, st.id, @school_year)
                @infos[st.id][sf_sm.id]["held_avg"] = rq["held_average"]
                @infos[st.id][sf_sm.id]["decision"] = rq["decision"]
                @infos[st.id][sf_sm.id]["is_pond_zero"] = rq["is_pond_zero"]
              else
                rq = md.marks_infos_2(bat.id, st.id, @school_year.to_i - 1)
                @infos[st.id][sf_sm.id]["held_avg"] = rq["held_average"]
                @infos[st.id][sf_sm.id]["decision"] = rq["decision"]
                @infos[st.id][sf_sm.id]["is_pond_zero"] = rq["is_pond_zero"]
              end
            end
          end
        end
      end
      if (@sf_sm2)
        @sf_sm2.each do |sf_sm|
          @infos[st.id][sf_sm.id] = {}
          found = 0
          md = SchoolModule.find(sf_sm.school_module_id)
          @infos[st.id][sf_sm.id]["md_name"] = md.name
          @annee_reserve_detail.each do |ar|
            if (ar.school_module_id == md.id)
              found = 1
            end
          end
          if (md)
            if @school_field_id.to_i == 10 and @school_year.to_i == 2020
              @batchs2 = @batchs2.select { |b| b.is_active == true }
            else
              @batchs2 = @batchs2
            end
            @batchs2.each do |bat|
              bat_anc = Batch.find(:first, :conditions => "course_id = #{bat.course.id.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{(@school_year.to_i - 1).to_s} or (year(start_date)=#{(@school_year).to_s} and month(start_date) < 8))")
              if ((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?))
                rq = md.marks_infos_2(bat.id, st.id, @school_year)
                @infos[st.id][sf_sm.id]["held_avg"] = rq["held_average"]
                @infos[st.id][sf_sm.id]["decision"] = rq["decision"]
                @infos[st.id][sf_sm.id]["is_pond_zero"] = rq["is_pond_zero"]
              else
                rq = md.marks_infos_2(bat_anc.id, st.id, @school_year.to_i - 1)
                @infos[st.id][sf_sm.id]["held_avg"] = rq["held_average"]
                @infos[st.id][sf_sm.id]["decision"] = rq["decision"]
                @infos[st.id][sf_sm.id]["is_pond_zero"] = rq["is_pond_zero"]
              end
            end
          end
        end
      end
    end

    @students.sort! { |a, b| @yearly_infos[b.id]['average_of_year_session_normale'] <=> @yearly_infos[a.id]['average_of_year_session_normale'] }
    i = 1
    @students.each do |st|
      @yearly_infos[st.id]['range'] = i
      i = i + 1
    end
    render :pdf => 'Relevé global_'
  end

  def show_student_bulletin_without_semester
    @todo = params[:todo]
    @which_one = params[:which_one]
    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @course1 = params[:course1]
    @course2 = params[:course2]
    @student = Student.find_by_id(params[:student_id])
    @students = []
    @batchs1 = Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @batchs2 = Batch.find(:all, :conditions => "course_id = #{@course2.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @sf_sm1 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course1, :school_year => @school_year, :school_field_id => @school_field_id })
    @sf_sm2 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course2, :school_year => @school_year, :school_field_id => @school_field_id })
    @batch_ids = ""
    @nbre_modules = SchoolModule.nbre_modules(@batchs1, @school_year) + SchoolModule.nbre_modules(@batchs2, @school_year)
    @batchs1.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end
    @batchs1.each do |bt|
      @students += Student.find(:all, :conditions => { :batch_id => bt.id })
      @students += bt.old_students #batch_string+=batch.id.to_s+','
    end
    @batchs2.each do |bt|
      @students += Student.find(:all, :conditions => { :batch_id => bt.id })
      @students += bt.old_students #batch_string+=batch.id.to_s+','
    end
    @students = @students.uniq { |x| x.id }
    @btss = @batchs1 + @batchs2

    ranges = []

    @student_orders = []
    @students.each do |sto|
      # @student_orders[sto.id] = sto.check_student_result(@batchs1,@school_year,4)['average_of_year_session_normale']
      # @student_orders[sto.id] = sto.check_student_result(@btss,@school_year,4)['average_of_year_session_normale']
      # @student_orders[sto.id] = sto.check_student_result(@btss,@school_year,4)['average_of_year']
      @student_orders[sto.id] = sto.check_student_result(@btss, @school_year, 4)['average_of_year_session_normale']
      if @student_orders[sto.id].nil?
        @student_orders[sto.id] = 0
      end
      ranges << { :st_id => sto.id, :note => @student_orders[sto.id] }
    end
    # @student_orders = @student_orders.sort_by{|ssso| ssso}
    ranges = ranges.sort_by { |sso| sso[:note] }.reverse
    @range = ranges.index(ranges.select { |po| po[:st_id].to_i == params[:student_id].to_i }.first).to_i + 1

    @batchs2.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end

    @yearly_infos = Student.find_by_id(params[:student_id]).check_student_result(@batchs1, @school_year, 4) unless params[:student_id].nil?
    @student_orders = YearlyDecision.find(:all, :conditions => " batch_ids like '%#{@batch_ids}%'", :order => "avg_year DESC")
    @annee_reserve_detail = []
    @annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id =#{@student.id} and school_year = #{@school_year} ")
    if (@annee_reserve != nil)
      @annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve.id}")

    end
    if (@todo == 'show_bulletin')
      @student = Student.find(params[:student_id])
      @yd = YearlyDecision.find(:first, :conditions => " student_id = #{@student.id} and school_year =#{@school_year} and batch_ids like '%#{@batch_ids}%'")
      @exams1 = []
      @exams2 = []
      render(:update) do |page|
        page.replace_html 'modal-box', :partial => 'show_student_marks_bulletin'
        page << "Modalbox.show($('modal-box'), {title: '#{t('marks_bulletin')}', width: 1000, height:700});"
      end
    elsif (@todo == 'show_bulletin_report')
      @student = Student.find(params[:student_id])
      @yd = YearlyDecision.find(:first, :conditions => " student_id = #{@student.id} and school_year =#{@school_year} and batch_ids like '%#{@batch_ids}%'")
      @exams1 = []
      @exams2 = []
      render(:update) do |page|
        page.replace_html 'modal-box', :partial => 'show_student_report_mark'
        page << "Modalbox.show($('modal-box'), {title: '#{t('marks_report')}', width: 1000, height:700});"
      end
    elsif (@todo == 'show_bulletin_report')
      @student = Student.find(params[:student_id])
      @yd = YearlyDecision.find(:first, :conditions => " student_id = #{@student.id} and school_year =#{@school_year} and batch_ids like '%#{@batch_ids}%'")
      @exams1 = []
      @exams2 = []
      render :pdf => 'show_student_bulletin_without_semester'
    elsif (@todo == 'show_in_pdf')
      @students = Student.find_all_by_batch_id(@batchs1[0].id)
      @students += @batchs1[0].old_students
=begin
        bs = BatchStudent.find_all_by_batch_id(@batchs1[0].id)
                unless bs.empty?
                               bs.each do |bst|
                                     student = Student.find(bst.student_id)
                                     @students << student unless student.nil?
                                end
                end
=end

      @students = @students.uniq { |x| x.id }
      render :pdf => 'bulletin_annuel_' + @student.full_name + '_' + @student.batch.name
    elsif (@todo == 'show_releve_in_pdf')
      @students = Student.find_all_by_batch_id(@batchs1[0].id)
      @students += @batchs1[0].old_students

      @students = @students.uniq { |x| x.id }.sort! { |a, b| a.last_name <=> b.last_name }
      render :pdf => 'bulletin_annuel_' + @student.full_name + '_' + @student.batch.name
    end

  end

  def show_student_releve
    logger.debug "awdyyyyyyyyyyyy"
    logger.debug "awdyyyyyyyyyyyy"
    logger.debug "awdyyyyyyyyyyyy"
    @todo = params[:todo]
    @which_one = params[:which_one]
    @school_field_id = params[:school_field_id]
    @old_year = params[:old_year]
    @school_year = params[:school_year]
    @course1 = params[:course1]
    @course2 = params[:course2]
    @student = Student.find_by_id(params[:student_id])
    @available_years = []
    @classement = params[:classement]
    @nbr_students = params[:nbr_students]

    BatchStudent.find_all_by_student_id(@student.id).reject { |b| Batch.find_by_id(b.batch_id).nil? }.each do |bs|
      @available_years.push Batch.find_by_id(bs.batch_id).start_date.year
    end
    @available_years = @available_years.uniq.sort
    @changed = params[:changed]
    if @changed
      if @old_year > @school_year
        @course1 = params[:course1].to_i - (@old_year.to_i - @school_year.to_i)
        @course2 = params[:course2].to_i - (@old_year.to_i - @school_year.to_i)
        if @course1 < 1
          @course1 = 1
        elsif @course2 < 7
          @course2 = 7
        end
      else
        @course1 = params[:course1].to_i + (@school_year.to_i - @old_year.to_i)
        @course2 = params[:course2].to_i + (@school_year.to_i - @old_year.to_i)
        if @course1 > 6
          @course1 = 6
        elsif @course2 > 12
          @course2 = 12
        end
      end

      @changed = false
      BatchStudent.find_all_by_student_id(@student.id).each do |bs|
        f = Batch.find_by_id(bs.batch_id)
        if f.start_date.year.to_i == @school_year.to_i
          @school_field_id = f.school_field_id
          break
        end
      end
    end
    @batchs1 = Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @batchs2 = Batch.find(:all, :conditions => "course_id = #{@course2.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @sf_sm1 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course1, :school_year => @school_year, :school_field_id => @school_field_id })
    @sf_sm2 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course2, :school_year => @school_year, :school_field_id => @school_field_id })
    @batch_ids = ""

    @btss = @batchs1 + @batchs2

    @batches = []
    if @batchs1
      @batches += @batchs1
    end
    if @batchs2
      @batches += @batchs2
    end

    if @student
      infos_modules = []
      number_modules = 0
      @batches.each do |batch|
        @batch_ids += batch.id.to_s + ","
        modules = []
        sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => batch.school_field_id, :course_id => batch.course_id, :school_year => batch.get_batch_year })
        sf_sm.each do |sfssm|
          modules << SchoolModule.find(sfssm.school_module_id)
        end
        modules = modules.uniq
        infos_modules[batch.id] = {}
        infos_modules[batch.id]['modules'] = modules

        modules.each do |md|
          sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
          exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(batch.id, md.id)
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
                sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{@school_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
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
          infos_modules[batch.id][md.id] = {}
          infos_modules[batch.id][md.id]['non_spec_pond'] = non_spec_pond
          infos_modules[batch.id][md.id]['spec_pond'] = spec_pond
          infos_modules[batch.id][md.id]['pond'] = pond
          infos_modules[batch.id][md.id]['sfsm'] = sfsm
          number_modules += 1
        end
      end
      infos_modules[0] = {}
      infos_modules[0]['number_modules'] = number_modules
      @yearly_infos = @student.check_student_result_h(@batches, @school_year, infos_modules)
    end

    @nbre_modules = SchoolModule.nbre_modules(@batchs1, @school_year) + SchoolModule.nbre_modules(@batchs2, @school_year)
    @batchs1.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end

    @batchs2.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end
    @attendance = []
    @batchs1.each do |b|
      @attendance += Attendance.find(:all, :conditions => { :student_id => @student.id, :batch_id => b.id })
    end
    @annee_reserve_detail = []
    @annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id =#{@student.id} and school_year = #{@school_year} ")
    if (@annee_reserve != nil)
      @annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve.id}")
    end
    render :pdf => 'Relevé_normal_' + @student.full_name + '_' + @student.batch.name
  end

  def show_student_releve_without_semester
    @todo = params[:todo]
    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @course1 = params[:course1]
    @course2 = params[:course2]
    @batchs1 = Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @batchs2 = Batch.find(:all, :conditions => "course_id = #{@course2.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @sf_sm1 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course1, :school_year => @school_year, :school_field_id => @school_field_id })
    @sf_sm2 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course2, :school_year => @school_year, :school_field_id => @school_field_id })
    @batch_ids = ""
    @nbre_modules = SchoolModule.nbre_modules(@batchs1, @school_year) + SchoolModule.nbre_modules(@batchs2, @school_year)
    @classement = params[:classement]
    @nbr_students = params[:nbr_students]
    @batches = @batchs1 + @batchs2

    infos_modules = []
    number_modules = 0
    @batches.each do |batch|
      @batch_ids += batch.id.to_s + ","
      modules = []
      sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => batch.school_field_id, :course_id => batch.course_id, :school_year => batch.get_batch_year })
      sf_sm.each do |sfssm|
        modules << SchoolModule.find(sfssm.school_module_id)
      end
      modules = modules.uniq
      infos_modules[batch.id] = {}
      infos_modules[batch.id]['modules'] = modules

      modules.each do |md|
        sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
        exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(batch.id, md.id)
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
              sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{@school_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
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
        infos_modules[batch.id][md.id] = {}
        infos_modules[batch.id][md.id]['non_spec_pond'] = non_spec_pond
        infos_modules[batch.id][md.id]['spec_pond'] = spec_pond
        infos_modules[batch.id][md.id]['pond'] = pond
        infos_modules[batch.id][md.id]['sfsm'] = sfsm
        number_modules += 1
      end
    end
    infos_modules[0] = {}
    infos_modules[0]['number_modules'] = number_modules

    if (params[:student_id])
      @student = Student.find(params[:student_id])
      @yearly_infos = @student.check_student_result_h(@batches, @school_year, infos_modules)
      @yd = YearlyDecision.find(:first, :conditions => " student_id = #{@student.id} and school_year =#{@school_year} and batch_ids like '%#{@batch_ids}%'")
    else
      @yearly_infos = []
      @students = []
      @batches.each do |batch|
        @students += Student.find_by_sql("select id,matricule,last_name,first_name from students where batch_id = #{batch.id}") unless !Student.find_by_sql("select id,matricule,last_name,first_name from students where batch_id = #{batch.id}")
        @students += batch.old_students
        @students = @students.uniq { |x| x.id }
      end
      @students.each do |st|
        @yearly_infos[st.id] = {}
        # annee_reserves = ReserveYearStudent.find_by_sql("select * from reserve_year_students where student_id = #{st.id}")
        # annee_reserve = annee_reserves.select { |ar| ar.school_year == @school_year }.first
        # annee_reserve_old = annee_reserves.select { |ar| ar.school_year == (@school_year.to_i - 1) }.first
        # ydecision = YearlyDecision.find(:first, :conditions => "student_id = #{st.id} and school_year = #{@school_year} and batch_ids like '%#{@batch_ids}%'")
        # if (1 == 0 and ydecision and !params[:typd] and annee_reserve.nil? and annee_reserve_old.nil? and ydecision.avg_year.to_i != -1)
        #   @yearly_infos[st.id]['decision'] = ydecision.decision
        #   @yearly_infos[st.id]['avg_year'] = ydecision.avg_year
        # else
        @yearly_infos[st.id] = st.check_student_result_h(@batches, @school_year, infos_modules)
        # end
      end
      @students.sort! { |a, b| @yearly_infos[b.id]['average_of_year_session_normale'] <=> @yearly_infos[a.id]['average_of_year_session_normale'] }
      i = 1
      @students.each do |st|
        @yearly_infos[st.id]['range'] = i
        i = i + 1
      end
      # @students.sort! { |a, b| b.last_name <=> a.last_name }
    end
    render :pdf => 'Relevé_annuel_'
  end

  def show_student_releve_first_semester

    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @course1 = params[:course1]
    @batchs1 = Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @sf_sm1 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course1, :school_year => @school_year, :school_field_id => @school_field_id })
    @batch_ids = ""
    @classement = params[:classement]
    @nbr_students = params[:nbr_students]
    @nbre_modules = SchoolModule.nbre_modules(@batchs1, @school_year)
    @batchs1.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end

    @batches = @batchs1

    if (params[:student_id])
      @student = Student.find(params[:student_id])
      infos_modules = []
      number_modules = 0
      @batches.each do |batch|
        @batch_ids += batch.id.to_s + ","
        modules = []
        sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => batch.school_field_id, :course_id => batch.course_id, :school_year => batch.get_batch_year })
        sf_sm.each do |sfssm|
          modules << SchoolModule.find(sfssm.school_module_id)
        end
        modules = modules.uniq
        infos_modules[batch.id] = {}
        infos_modules[batch.id]['modules'] = modules

        modules.each do |md|
          sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
          exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(batch.id, md.id)
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
                sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{@school_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
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
          infos_modules[batch.id][md.id] = {}
          infos_modules[batch.id][md.id]['non_spec_pond'] = non_spec_pond
          infos_modules[batch.id][md.id]['spec_pond'] = spec_pond
          infos_modules[batch.id][md.id]['pond'] = pond
          infos_modules[batch.id][md.id]['sfsm'] = sfsm
          number_modules += 1
        end
      end
      infos_modules[0] = {}
      infos_modules[0]['number_modules'] = number_modules
      @yearly_infos = @student.check_student_result_h(@batches, @school_year, infos_modules)
      @yd = YearlyDecision.find(:first, :conditions => " student_id = #{@student.id} and school_year =#{@school_year} and batch_ids like '%#{@batch_ids}%'")

    end
    @students = []
    render :pdf => 'Relevé_premier_semestre_' + @student.full_name + '_' + @student.batch.name

  end

  def show_student_releve_second_semester

    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @course1 = params[:course2]
    @batchs1 = Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @sf_sm1 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course1, :school_year => @school_year, :school_field_id => @school_field_id })
    @batch_ids = ""
    @classement = params[:classement]
    @nbr_students = params[:nbr_students]
    @nbre_modules = SchoolModule.nbre_modules(@batchs1, @school_year)
    @batchs1.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end
    @batches = @batchs1
    if (params[:student_id])
      @student = Student.find(params[:student_id])
      infos_modules = []
      number_modules = 0
      @batches.each do |batch|
        @batch_ids += batch.id.to_s + ","
        modules = []
        sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => batch.school_field_id, :course_id => batch.course_id, :school_year => batch.get_batch_year })
        sf_sm.each do |sfssm|
          modules << SchoolModule.find(sfssm.school_module_id)
        end
        modules = modules.uniq
        infos_modules[batch.id] = {}
        infos_modules[batch.id]['modules'] = modules

        modules.each do |md|
          sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
          exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(batch.id, md.id)
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
                sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{@school_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
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
          infos_modules[batch.id][md.id] = {}
          infos_modules[batch.id][md.id]['non_spec_pond'] = non_spec_pond
          infos_modules[batch.id][md.id]['spec_pond'] = spec_pond
          infos_modules[batch.id][md.id]['pond'] = pond
          infos_modules[batch.id][md.id]['sfsm'] = sfsm
          number_modules += 1
        end
      end
      infos_modules[0] = {}
      infos_modules[0]['number_modules'] = number_modules
      @yearly_infos = @student.check_student_result_h(@batches, @school_year, infos_modules)
      @yd = YearlyDecision.find(:first, :conditions => " student_id = #{@student.id} and school_year =#{@school_year} and batch_ids like '%#{@batch_ids}%'")

    end
    @students = []
    render :pdf => 'Relevé_deuxieme_semestre_' + @student.full_name + '_' + @student.batch.name

  end
  

  def show_student_releve_sans_rattrapage
    @todo = params[:todo]
    @school_field_id = params[:school_field_id]
    @school_year = params[:school_year]
    @course1 = params[:course1]
    @course2 = params[:course2]
    @classement = params[:classement]
    @nbr_students = params[:nbr_students]
    @batchs1 = Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @batchs2 = Batch.find(:all, :conditions => "course_id = #{@course2.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
    @sf_sm1 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course1, :school_year => @school_year, :school_field_id => @school_field_id })
    @sf_sm2 = SchoolFieldSchoolModule.find(:all, :conditions => { :course_id => @course2, :school_year => @school_year, :school_field_id => @school_field_id })
    @batch_ids = ""
    @nbre_modules = SchoolModule.nbre_modules(@batchs1, @school_year) + SchoolModule.nbre_modules(@batchs2, @school_year)
    @batchs1.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end
    @batchs2.each do |bat|
      sbat = bat.id.to_s
      @batch_ids += sbat + ","
    end
    @batches = @batchs2 + @batchs1
    if (params[:student_id])
      @student = Student.find(params[:student_id])
      infos_modules = []
      number_modules = 0
      @batches.each do |batch|
        @batch_ids += batch.id.to_s + ","
        modules = []
        sf_sm = SchoolFieldSchoolModule.find(:all, :conditions => { :school_field_id => batch.school_field_id, :course_id => batch.course_id, :school_year => batch.get_batch_year })
        sf_sm.each do |sfssm|
          modules << SchoolModule.find(sfssm.school_module_id)
        end
        modules = modules.uniq
        infos_modules[batch.id] = {}
        infos_modules[batch.id]['modules'] = modules

        modules.each do |md|
          sfsm = sf_sm.select { |smmm| smmm.school_module_id = md.id }.first
          exams_groups = ExamGroup.find_all_by_batch_id_and_module_id(batch.id, md.id)
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
                sme = SchoolModuleSubject.find_by_sql("select * from school_module_subjects where school_year = #{@school_year} and school_module_id = #{md.id} and subject_group_id = #{ex.subject.subject_group_id}").first
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
          infos_modules[batch.id][md.id] = {}
          infos_modules[batch.id][md.id]['non_spec_pond'] = non_spec_pond
          infos_modules[batch.id][md.id]['spec_pond'] = spec_pond
          infos_modules[batch.id][md.id]['pond'] = pond
          infos_modules[batch.id][md.id]['sfsm'] = sfsm
          number_modules += 1
        end
      end
      infos_modules[0] = {}
      infos_modules[0]['number_modules'] = number_modules
      @yearly_infos = @student.check_student_result_h(@batches, @school_year, infos_modules)
      @yd = YearlyDecision.find(:first, :conditions => " student_id = #{@student.id} and school_year =#{@school_year} and batch_ids like '%#{@batch_ids}%'")
    end
    @exams1 = []
    @exams2 = []
    @students = []
    @moy_cla = 10
    render :pdf => 'Relevé_annuel_sansrattrapage' + @student.full_name + '_' + @student.batch.name
  end

  def show_ratrappage
    @courses = (params[:course_ids].gsub('%2C', ',')).split(",")
    @batches = Batch.find(:all, :conditions => ["school_field_id=? and (course_id = ? or course_id = ?)", params[:school_field_id], @courses[0], @courses[1]]).reject { |b| b.get_batch_year.to_i != params[:school_year].to_i }
    @filiere = SchoolField.find(params[:school_field_id])
    @courses = @courses.reject { |c| c.to_i == 0 }
    @nivau = Course.find(@courses[0]).course_name
    @liste = []
    @batches.each do |bt|
      @liste[bt.id] = []
      subjects = bt.subjects
      subjects.each do |sb|
        found = 0
        exams = Exam.find_all_by_subject_id(sb.id)
        exams.each do |ex|
          exam_scores = ex.exam_scores
          if (exam_scores)
            exam_scores.each do |es|
              @annee_reserve = ReserveYearStudent.find(:first, :conditions => "student_id =#{es.student_id} and school_year = #{bt.get_batch_year} ")
              @annee_reserve_detail = []
              if (@annee_reserve != nil)
                @annee_reserve_detail = ReserveYearStudentDetail.find(:all, :conditions => "reserve_year_student_id =#{@annee_reserve.id}")
              end
              school_module = SchoolModule.find(ExamGroup.find(ex.exam_group_id).module_id)
              @annee_reserve_detail.each do |ar|
                if (ar.school_module_id == school_module.id)
                  found = 1
                end
              end
              if (!((found == 1 and !@annee_reserve_detail.empty?) or (found == 0 and @annee_reserve_detail.empty?)))
                bat_anc = Batch.find(:first, :conditions => "course_id = #{bt.course.id.to_s} and school_field_id = #{@filiere.id.to_s} and (year(start_date)= #{(bt.get_batch_year.to_i - 1).to_s} or (year(start_date)=#{(bt.get_batch_year).to_s} and month(start_date) < 8))")
                subjectss = bat_anc.subjects
                subjectss.each do |sbb|
                  examss = Exam.find_all_by_subject_id(sbb.id)
                  examss.each do |exx|
                    school_modulee = SchoolModule.find(ExamGroup.find(exx.exam_group_id).module_id)
                    exam_scoress = exx.exam_scores
                    if (exam_scoress and school_modulee.id == school_module.id)
                      exam_scoress.each do |ess|
                        if (ess.student_id == es.student_id and ess.marks.to_f < 10 and (Student.find(ess.student_id).batch_id == bt.id or BatchStudent.find_all_by_student_id_and_batch_id(ess.student_id, bt.id).length > 0))
                          school_module = SchoolModule.find(ExamGroup.find(exx.exam_group_id).module_id)
                          module_infos = school_module.marks_infos_2(bat_anc.id, ess.student_id, bat_anc.start_date.year)
                          moyenne_module_ar = module_infos["average"]
                          if (((ess.marks.to_f < 10 and moyenne_module_ar.to_f < 10)) and ess.remarks != 'DISP')
                            @liste[bt.id] << { :student_id => ess.student_id, :subject_name => sbb.name, :school_module_name => school_module.name, :mark_element => ess.marks, :mark_element_ar => ess.marks_ar, :mark_module => moyenne_module_ar, :mark_module_retenue => module_infos["held_average"], :observation => ess.remarks }
                          end
                        end
                      end
                    end
                  end
                end
              else
                (es.marks.to_f < 10 and (Student.find(es.student_id).batch_id == bt.id or BatchStudent.find_all_by_student_id_and_batch_id(es.student_id, bt.id).length > 0))
                school_module = SchoolModule.find(ExamGroup.find(ex.exam_group_id).module_id)
                module_infos = school_module.marks_infos_2(bt.id, es.student_id, bt.start_date.year)
                moyenne_module_ar = module_infos["average"]
                if (((es.marks.to_f < 10 and moyenne_module_ar.to_f < 10)) and es.remarks != 'DISP')
                  @liste[bt.id] << { :student_id => es.student_id, :subject_name => sb.name, :school_module_name => school_module.name, :mark_element => es.marks, :mark_element_ar => es.marks_ar, :mark_module => moyenne_module_ar, :mark_module_retenue => module_infos["held_average"], :observation => es.remarks }
                end
              end
            end
          end
        end

      end
    end
    render :pdf => 'show_ratrappage', :orientation => 'Landscape'
  end

end
