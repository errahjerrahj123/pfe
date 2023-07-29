#Fedena
#Copyright 2011 Foradian Technologies Private Limited
#
#This product includes software developed at
#Project Fedena - http://www.projectfedena.org/
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

class TimetableEntriesController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  @@salle_id_tmp = nil

  def update_batch
    month = Time.now.month
    year = Time.now.year
    if month < 8
      year = year - 1
    end
    @course_id = params[:course_id]
#    @batches = Batch.find_all_by_course_id(@course_id).select{|b| b.get_batch_year.to_i == year.to_i  || b.id == 3721 || b.id == 3662  || b.id == 3740}
    @batches = Batch.find_all_by_course_id(@course_id).select{|b| b.get_batch_year.to_i >= year.to_i-2}#  || b.id == 3721 || b.id == 3662  || b.id == 3740}
    @timetable_id = params[:timetable_id]

    render(:update) do |page|
   page.replace_html 'select_batch2', :partial => 'select_batch2'
    end

  end

def update_data
 @timetable = Timetable.find(97)
 Batch.all.each do |b|
     first = (@timetable.start_date.to_date..@timetable.end_date.to_date).first
      (@timetable.start_date.to_date..@timetable.end_date.to_date).each do |e,i|
              @timetable_entries = TimetableEntry.find_all_by_timetable_id_and_batch_id_and_day(97,b.id,e.strftime("%Y-%m-%d")).group_by(&:subject_id)
               @seance_nb = 0 ;
               @timetable_entries.each do |subject_id, entries|
                logger.debug entries.count
                               @seance_nb = 0 ;

                entries.each do |en|
                  @seance_nb = @seance_nb + 1
TimetableEntry.find(en.id).update_attributes(:seance_nb => @seance_nb)
                end
               end

      end

   end


    end







  def new

    @timetable = Timetable.find(params[:timetable_id])



    @current_user = current_user
    if current_user.admin?  #or 1 == 1
      #@batches = Batch.all
      @batches = Batch.all.select{|b| b.start_date.year == @timetable.start_date.year || (b.end_date.year == @timetable.end_date.year && b.end_date.month <= @timetable.end_date.month)}
    elsif current_user.employee and current_user.privileges.map{|p| p.name}.include?("Coordonateurfiliere")
        @batches = current_user.employee_record.subjects.all(:group => 'batch_id').map{|x|x.batch}.reject {|n| n.nil? }
        @batches += Batch.find_by_sql("select b.* from batches b, school_fields sf where sf.id=b.school_field_id and ( sf.employee_id="+current_user.employee_record.id.to_s+" or b.employee_id="+current_user.employee_record.id.to_s+")")
        sf_opts = SchoolField.find_all_by_parent_sf_id(current_user.employee_record.school_field.id)+[current_user.employee_record.school_field]

            sf_opts.each do |sf|
               @batches += Batch.find(:all,:conditions => {:school_field_id => sf.id})
            end
        @batches=@batches.uniq{|x| x.id}
        @batches=@batches.reject { |b| b.is_active == false }
              @batches = @batches.all.select{|b| b.start_date.year == @timetable.start_date.year || (b.end_date.year == @timetable.end_date.year && b.end_date.month <= @timetable.end_date.month)}

        # @batches = @batches.reject { |b| b.get_batch_year < Time.now.year - 1 }

    end

  end

  def select_batch
    @timetable=Timetable.find(params[:timetable_id])
    @batches = Batch.active
    if request.post?
      unless params[:timetable_entry][:batch_id].empty?

      else
        flash[:notice]="#{t('select_a_batch_to_continue')}"
        redirect_to :action => "select_batch"
      end
    end
  end
def set_tte
require 'nokogiri'

@jqs = params[:salle_id]
@period = params[:tte_ids]
@batch_id = params[:batch_id]
@ttidd = params[:tt_id]
@period_time= params[:period_id]
@day_id= params[:day_id]


@dd =  @period_time.split("-")[0].to_date.strftime('%Y/%m/%d').to_s
@df =  @period_time.split("-")[1].to_date.strftime('%Y/%m/%d').to_s

logger.debug @dd
=begin
  records_hash = params[:day]
logger.debug records_hash.class
  records_hash.each do |a1|

  a1.map { |k,v|
    logger.debug "#{k} is2 #{v}"

  if k.to_s== "periods"
  records_hash.each do |a2|
      a2.map { |k2,v2|

  logger.debug "#{k2} is2 #{v2}"}
  end

  end
  }

  end
=end
@days = params[:day].split(',')
@end = params[:end].split(',')
@id_period = params[:id_period].split(',')

@weekday = 0 ;
 @days.each_with_index do |page, index|

if !TimetableEntry.find_by_timetable_id_and_end_time_and_weekday_id(@ttidd,@end[index],@days[index]
)
if @end[index] != '00:00'
  @weekday = @days[index]
end

end
 end



 @weekday = @day_id
@per = Nokogiri::HTML.parse(@period)
#@per1 = Nokogiri::HTML.parse(@day)



@rper = @per.xpath("//div").first.children.to_s
@dates = @rper.to_s
logger.debug "142"
logger.debug @rper.split('-')[2]
logger.debug @rper.split('-')[3]
@debut =(@rper.split('-')[2]).split('>')[1]
@fin = (@rper.split('-')[3]).split('<')[0]
logger.debug "tesssssssst"+@debut
logger.debug "tesssssssst"+@fin
#@rper=12
logger.debug "tesssssssst"
logger.debug "tesssssssst"
logger.debug "tesssssssst"
logger.debug "tesssssssst"
logger.debug "tesssssssst"
logger.debug "tesssssssst"
logger.debug "tesssssssst"
logger.debug @rper.to_s+"\n"
logger.debug "tesssssssst"
logger.debug "tesssssssst"
logger.debug "tesssssssst"
                render(:update) do |page|
                  if @jsq == 1
       redirect_to :back

else

     page.replace_html 'modal-box', :partial => 'set_tte'
page << "Modalbox.show($('modal-box'), {title: 'Ajouter entrée', width: 700, height:600});"
  end
                        end
end

def dupplicate
require 'nokogiri'

@timetable_id = params[:id]
@dd = params[:dd]
@df = params[:df]
@batch_id = params[:batch_id]

@timetable = Timetable.find(@timetable_id)

   @periods = []

   count = 0
      # a = []
#(@timetable.start_date.to_date..@timetable.end_date.to_date).select{|r| r.wday == 1}.map(&:to_s).each{|r| @periods << (r.to_date+1).to_s+" - "+(r.to_date+7).to_s+"\n" }
      first = ((@df.to_date + 1 )..@timetable.end_date.to_date).first

      ((@df.to_date + 1 )..@timetable.end_date.to_date).each do |e,i|
            if e.wday == 0 or i == (((@df.to_date + 1 )..@timetable.end_date.to_date).count - 1)

              @periods << first.to_s+" - "+e.to_s
              first = e+1

            end
      end

      @periods << first.to_s+" - "+((@df.to_date + 1 )..@timetable.end_date.to_date).last.to_s
      # @timetable = TimetableEntry.find_all_by_batch_id_and_timetable_id(@batch.id,@tt.id)
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # @timetable.each do |tt|
      #   @periods << "#{tt.start_date} - #{tt.end_date}"
      # end
      @periods = @periods.uniq
      logger.debug @periods
@periods2 = []
@periods3 = []

t = 0
@periods.each do |p|
  if p != "#{@dd} - #{@df}"
    @periods2 << p
  end
end
@periods2.each do |p2|
  if p2.split("-")[0] > @dd
    @periods3 << p2
  end
end


logger.debug @periods2.inspect
logger.debug @periods3.inspect

logger.debug @dd
logger.debug @df

@batch = Batch.find(@batch_id)
@all_entries = TimetableEntry.find_all_by_timetable_id_and_batch_id(@timetable_id,@batch_id).select{|tte| tte.day >= @dd.to_date and tte.day <= @df.to_date }
logger.debug @all_entries.inspect

@lgs = LanguageGroup.find_all_by_school_year(@batch.get_batch_year).select{|lg| lg.batch_ids != nil}.select{|l| l.batch_ids.split(",").include? @batch_id.to_s}
logger.debug @lgs.inspect
@lgs.each do |lg|
@all_entries = @all_entries + TimetableEntry.find_all_by_timetable_id_and_language_group_id(@timetable_id,lg.id).select{|tte| tte.day >= @dd.to_date and tte.day <= @df.to_date }
end
@all_entries  = @all_entries.uniq

@all_entries.each do |at|
@period = @periods.first
day = 0
(@period.split("-")[0].to_date .. @period.split("-")[1].to_date).each do |y|
  if y.wday == at.day.to_date.wday
    logger.debug "heeeeeeeeeeeeeeere"
    day = y
  end
  end
  logger.debug day
  if day != 0
    if TimetableEntry.find_by_start_time_and_end_time_and_weekday_id_and_start_date_and_end_date_and_subject_id_and_salle_id_and_employee_id_and_timetable_id_and_day_and_language_group_id(at.start_time,at.end_time,at.weekday_id,@period.split("-")[0],@period.split("-")[1],at.subject_id,at.salle_id,at.employee_id,at.timetable_id,day,at.language_group_id)
else
   TimetableEntry.new(:start_time => at.start_time, :end_time => at.end_time, :is_done => 0,:weekday_id=>at.weekday_id,:start_date => @period.split("-")[0] ,:end_date => @period.split("-")[1],:subject_id => at.subject_id,:salle_id => at.salle_id, :employee_id=>at.employee_id,:batch_id=>at.batch_id,:timetable_id=>at.timetable_id,:day => day,:tte_type_id=>at.tte_type_id,:is_done => 0,:seance_nb => 1,:language_group_id => at.language_group_id).save
end
end
end


                render(:update) do |page|

   page.replace_html 'flu', :text => 'Dupplication fait avec succes'


end

end
def dupplicate_save2
require 'nokogiri'

@timetable_id = params[:id]
@dd = params[:dd]
@df = params[:df]
@batch_id = params[:batch_id]

@timetable = Timetable.find(@timetable_id)

   @periods = []

   count = 0
      # a = []
#(@timetable.start_date.to_date..@timetable.end_date.to_date).select{|r| r.wday == 1}.map(&:to_s).each{|r| @periods << (r.to_date+1).to_s+" - "+(r.to_date+7).to_s+"\n" }
      first = ((@df.to_date + 1 )..@timetable.end_date.to_date).first

      ((@df.to_date + 1 )..@timetable.end_date.to_date).each do |e,i|
            if e.wday == 0 or i == (((@df.to_date + 1 )..@timetable.end_date.to_date).count - 1)

              @periods << first.to_s+" - "+e.to_s
              first = e+1

            end
      end

      @periods << first.to_s+" - "+((@df.to_date + 1 )..@timetable.end_date.to_date).last.to_s
      # @timetable = TimetableEntry.find_all_by_batch_id_and_timetable_id(@batch.id,@tt.id)
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # @timetable.each do |tt|
      #   @periods << "#{tt.start_date} - #{tt.end_date}"
      # end
      @periods = @periods.uniq
      logger.debug @periods
@periods2 = []
@periods3 = []

t = 0
@periods.each do |p|
  if p != "#{@dd} - #{@df}"
    @periods2 << p
  end
end
@periods2.each do |p2|
  if p2.split("-")[0] > @dd
    @periods3 << p2
  end
end


logger.debug @periods2.inspect
logger.debug @periods3.inspect

logger.debug @dd
logger.debug @df

@batch = Batch.find(@batch_id)
@all_entries = TimetableEntry.find_all_by_timetable_id_and_batch_id(@timetable_id,@batch_id).select{|tte| tte.day >= @dd.to_date and tte.day <= @df.to_date }

@lgs = LanguageGroup.find_all_by_school_year(@batch.get_batch_year).select{|lg| lg.batch_ids != nil}.select{|l| l.batch_ids.split(",").include? @batch_id}
logger.debug @lgs.inspect
@lgs.each do |lg|
@all_entries = @all_entries + TimetableEntry.find_all_by_timetable_id_and_language_group_id(@timetable_id,lg.id).select{|tte| tte.day >= @dd.to_date and tte.day <= @df.to_date }
end
@all_entries  = @all_entries.uniq

logger.debug @all_entries.inspect
@periodss = []
# a = []
#(@timetable.start_date.to_date..@timetable.end_date.to_date).select{|r| r.wday == 1}.map(&:to_s).each{|r| @periods << (r.to_date+1).to_s+" - "+(r.to_date+7).to_s+"\n" }
firs = (@timetable.start_date.to_date..@timetable.end_date.to_date).first
(@timetable.start_date.to_date..@timetable.end_date.to_date).each do |e,i|
      if e.wday == 0 or i == ((@timetable.start_date.to_date..@timetable.end_date.to_date).count - 1)
        @periodss << firs.to_s+" - "+e.to_s
        firs = e+1
      end
end
@periodss << firs.to_s+" - "+(@timetable.start_date.to_date..@timetable.end_date.to_date).last.to_s
@periodss = @periodss.uniq
 logger.debug @periodss.inspect

@periodss.each do |p|

@all_entries.each do |at|
#@period =p
day = 0
(p.split("-")[0].to_date .. p.split("-")[1].to_date).each do |y|
  if y.wday == at.day.to_date.wday
    logger.debug "heeeeeeeeeeeeeeere"
    day = y
  end
  end
  logger.debug day
  logger.debug p
  logger.debug p.split("-")[0]
  logger.debug p.split("-")[1]

  if day != 0
    ty =TimetableEntry.find_by_batch_id_and_subject_id_and_day_and_employee_id_and_end_time_and_start_time(at.batch_id,at.subject_id,day,at.employee_id,at.end_time,at.start_time)
    if TimetableEntry.find_by_batch_id_and_subject_id_and_day_and_employee_id_and_end_time_and_start_time(at.batch_id,at.subject_id,day,at.employee_id,at.end_time,at.start_time)
if ty.start_date != p.split("-")[0] && ty.end_date != p.split("-")[1]
  ty.update_attributes(:start_date => p.split("-")[0],:end_date => p.split("-")[1])
end
    else
   TimetableEntry.new(:start_time => at.start_time, :end_time => at.end_time, :is_done => 0,:weekday_id=>at.weekday,:start_date => p.split("-")[0] ,:end_date => p.split("-")[1],:subject_id => at.subject_id,:salle_id => at.salle_id, :employee_id=>at.employee_id,:batch_id=>at.batch_id,:timetable_id=>at.timetable_id,:day => day,:tte_type_id=>at.tte_type_id,:is_done => 0,:seance_nb => 1,:language_group_id =>at.language_group_id).save
end
end
end
end


                render(:update) do |page|

   page.replace_html 'flu', :text => 'Dupplication fait avec succes'


end

end


def add_inside
require 'nokogiri'

@jqs = params[:salle_id]
@period = params[:tte_ids]
@batch_id = params[:batch_id]
@ttidd = params[:tt_id]
@period_time= params[:period_id]
@day = params[:day]


@timetable_entry = TimetableEntry.find(@ttidd)
@per = Nokogiri::HTML.parse(@period)



@rper = @per.xpath("//div").first.children.to_s
@dates = @rper.to_s
logger.debug "142"
logger.debug @rper.split('-')[2]
logger.debug @rper.split('-')[3]
@debut =(@rper.split('-')[2]).split('>')[1]
@fin = (@rper.split('-')[3]).split('<')[0]
@subject = Subject.find(@timetable_entry.subject_id)
@lgs = LanguageGroup.find_all_by_subject_group_id_and_school_year(@subject.subject_group.id,@subject.batch.get_batch_year)
if @lgs.count > 0
else
  @lgs = LanguageGroup.find_all_by_school_year(@subject.batch.get_batch_year).select{|lg| lg.subject_group_ids != nil}.select{|l| l.subject_group_ids.split(",").include? "#{@subject.subject_group.id}"}
end
@employees_subject = @subject.employees

                render(:update) do |page|
                  if @jsq == 1
       redirect_to :back

else

     page.replace_html 'modal-box', :partial => 'add_inside'
page << "Modalbox.show($('modal-box'), {title: 'Ajouter entrée', width: 700, height:600});"
  end
                        end
end
def add_inside_saved
require 'nokogiri'

@jqs = params[:salle_id]
@period = params[:tte_ids]
@batch_id = params[:batch_id]
@ttidd = params[:tt_id]
@period_time= params[:period_id]
@day = params[:day]



@per = Nokogiri::HTML.parse(@period)



@rper = @per.xpath("//div").first.children.to_s
@dates = @rper.to_s
logger.debug "142"
logger.debug @rper.split('-')[2]
logger.debug @rper.split('-')[3]
@debut =(@rper.split('-')[2]).split('>')[1]
@fin = (@rper.split('-')[3]).split('<')[0]

                render(:update) do |page|
                  if @jsq == 1
       redirect_to :back

else

     page.replace_html 'modal-box', :partial => 'add_inside'
page << "Modalbox.show($('modal-box'), {title: 'Ajouter entrée', width: 700, height:600});"
  end
                        end
end

def new_entry_save
  logger.debug "tesssssssst"+params[:debut]
logger.debug "tesssssssst"+params[:fin]
    end_date = params[:fin]
    weekday = params[:weekday]
    subjects = params[:attendances]
    salle_id = subjects["salle_id"]
    subject_id = subjects["subject_id"]

@batch_id = params[:batch_id]
@ttidd = params[:ttidd]
@period_time= params[:period_time].split('-')
  start_date = @period_time[0]+" "+ params[:debut]
  end_date = @period_time[1]+" "+ params[:fin]
day = ""
weekd = 0
db = @period_time[0].to_date()
  fn = @period_time[1].to_date()
(db..fn).each do |date|
  logger.debug   "*********************"
    logger.debug "*********************"
  logger.debug "*********************"

  logger.debug weekday.to_i
  logger.debug date.wday.to_i
   day2 = weekday.to_i + 1
  if day2 == 7
    day2 = 0
  end
  if(date.wday.to_i == day2)
day = date
  end



end
@alltte = TimetableEntry.find_all_by_batch_id_and_subject_id_and_day(@batch_id,subject_id,day).sort_by{|ll| ll.seance_nb}
if  @alltte.last != nil
nb_seance = @alltte.last.seance_nb + 1
else
  nb_seance = 1
end
if subjects["language_group_id"] && subjects["language_group_id"] != ""
  subjects["employee_id"] = LanguageGroup.find(subjects["language_group_id"]).employee_id
else
end
  TimetableEntry.new(:start_time => start_date, :end_time => end_date, :is_done => 0,:weekday_id=>weekday,:start_date => @period_time[0] ,:end_date => @period_time[1],
   :subject_id => subject_id,:salle_id => salle_id,:language_group_id=>subjects["language_group_id"] ,:employee_id=>subjects["employee_id"],:batch_id=>@batch_id,:timetable_id=>@ttidd,:day => day,:tte_type_id=>subjects["tte_typs_id"],:is_done => 0,:seance_nb => nb_seance).save


       logger.debug TimetableEntry.last
       render :update do |page|
page << "Modalbox.hide();"
         page.replace_html "period-"+params[:debut]+"-"+params[:fin], :text => TimetableEntry.last.id
       end


    # end
  end
  def new_entry_save2
  test= Timetable.last
  respond_to do |format|
       format.js { render :action => 'update' }

    end

    # end
  end

def new_entry_sav
start_hour = params[:start_hour]
end_hour = params[:end_hour]
weekday =params[:day]
    subjects = params[:attendances]
    salle_id = subjects["salle_id"]
    subject_id = subjects["subject_id"]

@batch_id = params[:batch_id]
@ttidd = params[:ttidd]
start_date = "2000/01/01 "+ start_hour
  end_date = "2000/01/01 "+ end_hour

@period_time= params[:period_time].split('-')

day = ""
weekd = 0
db = @period_time[0].to_date()
  fn = @period_time[1].to_date()
(db..fn).each do |date|
  logger.debug "*********************"
    logger.debug "*********************"
  logger.debug "*********************"

  logger.debug weekday.to_i
  logger.debug date.wday.to_i
  day2 = weekday.to_i + 1
  if day2 == 7
    day2 = 0
  end
  if(date.wday.to_i == day2)
day = date
  end

end

  logger.debug day

 TimetableEntry.new(:start_time => start_date, :end_time => end_date, :is_done => 0,:weekday_id=>weekday,
   :subject_id => subject_id,:salle_id => salle_id, :employee_id=>subjects["employee_id"],:batch_id=>@batch_id,:timetable_id=>@ttidd,:day => day,:tte_type_id=>subjects["tte_typs_id"],:is_done => 0,:seance_nb => 1).save

   @batch = Batch.find(params[:batch_id])
   tta = []

   TimetableEntry.find_all_by_batch_id(@batch.id).each{|zz| tta << zz.timetable_id}

   # @tt = Timetable.find_by_batch_id(@batch.id)


   # @tt = Timetable.find(params[:timetable_id])

   @start_date = start_date = Date.parse(params[:period_time].to_s.split(" - ")[0])
   logger.debug "teeeeeeeeeeeeeeeeeeeeeeest"
   logger.debug Date.parse(params[:period_time].to_s.split(" - ")[0])
   @end_date = end_date = Date.parse(params[:period_time].to_s.split(" - ")[1])

   #tte_from_batch_and_tt(@ttidd)
   timetable_entries=TimetableEntry.find(:all,:conditions=>{:batch_id=>@batch.id,:timetable_id=>@ttidd}).reject{|tte| tte.day < start_date or tte.day > end_date }



 respond_to do |format|
       format.js { render :action => 'update' }
    end
  end
def edit_period
  require 'nokogiri'

@jqs = params[:salle_id]
@period = params[:period]
@batch_id = params[:batch_id]
@ttidd = params[:tt_id]
@tteidd = params[:tte_id]

@period_time= params[:period_id]
@day = params[:day]



@per = @period




#@dates = @rper.to_s
logger.debug "142"
logger.debug @per.split('-')[0]
logger.debug @per.split('-')[1]
@debut =(@per.split('-')[0])
@fin = (@per.split('-')[1])
        TimetableEntry.find_by_id(@tteidd).update_attributes(:start_time=> @debut , :end_time => @fin)
       redirect_to :back

#return true;
end
def remove_tte
  require 'nokogiri'

  @period = params[:tte_ids]

  @per = Nokogiri::HTML.parse(@period)
#@per1 = Nokogiri::HTML.parse(@day)

logger.debug @per.to_s+"\n"
logger.debug "********************"
logger.debug "********************"
logger.debug "********************"
logger.debug "********************"

@rper = @per.xpath("//div").first.children.to_s
logger.debug @rper
logger.debug @rper.split('-')[2]
logger.debug @rper.split('-')[3]
@debut =(@rper.split('-')[2]).split('>')[1].gsub(/\s/, "")
@fin = (@rper.split('-')[3]).split('<')[0].gsub(/\s/, "")
logger.debug "tesssssssst"+@debut
logger.debug "tesssssssst"+@fin
@name = params[:name].split('/')[0]
logger.debug "tesssssssst"+@name
@period_id = params[:period_id].split("-")
db = @period_id[0].to_date()
  fn = @period_id[1].to_date()
  day = ""
(db..fn).each do |date|
  day2 = params[:day].to_i + 1
  if day2 == 7
    day2 = 0
  end
      logger.debug date.wday.to_i
logger.debug day2
  if(date.wday.to_i == day2)
day = date
  end
end
@subject_id = TimetableEntry.find(params[:tte_id]).subject_id
TimetableEntry.find_all_by_timetable_id_and_batch_id_and_start_date_and_end_date(params[:tt_id],[:batch_id],'%#{fin}','%#{fin}')
    TimetableEntry.find(:first,:conditions=>["id = ? and timetable_id = ? and day = ? and start_time like ? and end_time like ? ",params[:tte_id],params[:tt_id],day,
            "%#{@debut}%","%#{@fin}%" ]).destroy

@alltte = TimetableEntry.find_all_by_batch_id_and_subject_id_and_day(params[:batch_id],@subject_id,day).sort_by{|ll| ll.start_time}

@seance_nb = 0
@alltte.each do |tt|
  @seance_nb = @seance_nb + 1
  tt.update_attributes(:seance_nb => @seance_nb)
end
  respond_to do |format|
       format.js { render :action => 'update' }
    end

    # end
  end
  def new_entry_save2
  test= Timetable.last
  respond_to do |format|
       format.js { render :action => 'update' }

    end

    # end
  end

  def new_entry
    @pis = params[:period]
    @timetable=Timetable.find(params[:timetable_id])
    @ttidd = params[:timetable_id]
    @batch_id=params[:batch_id]
    @salles = Classroom.all
    #ttes = TimetableEntry.find_all_by_timetable_id_and_batch_id(@ttidd,@batch_id).select{|tte| tte.day >= Date.parse(@pis.split('-')[0]) and tte.day <= Date.parse(@pis.split('-')[1]) }
logger.debug "********************"
logger.debug "********************"
#logger.debug ttes.count
# @salles  = Salle.all
    if params[:batch_id] == ""
      render :update do |page|
        page.replace_html "render_area", :text => ""
      end
      return
    elsif params[:period].nil?
      @batch = Batch.find(params[:batch_id])
      ttza = []
      TimetableEntry.find_all_by_batch_id(@batch.id).each{|zz| ttza << zz.timetable_id}
      logger.debug ttza.uniq.first
      logger.debug ttza.uniq.first
      logger.debug ttza.uniq.first
      logger.debug "tta.uniq.first"
      #@tt = Timetable.find(ttza.uniq.first)
      @periods = []
      # a = []
#(@timetable.start_date.to_date..@timetable.end_date.to_date).select{|r| r.wday == 1}.map(&:to_s).each{|r| @periods << (r.to_date+1).to_s+" - "+(r.to_date+7).to_s+"\n" }
      first = (@timetable.start_date.to_date..@timetable.end_date.to_date).first
      (@timetable.start_date.to_date..@timetable.end_date.to_date).each do |e,i|
            if e.wday == 0 or i == ((@timetable.start_date.to_date..@timetable.end_date.to_date).count - 1)
              @periods << first.to_s+" - "+e.to_s
              first = e+1
            end
      end
      @periods << first.to_s+" - "+(@timetable.start_date.to_date..@timetable.end_date.to_date).last.to_s
      # @timetable = TimetableEntry.find_all_by_batch_id_and_timetable_id(@batch.id,@tt.id)
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # logger.debug @timetable.length
      # @timetable.each do |tt|
      #   @periods << "#{tt.start_date} - #{tt.end_date}"
      # end
      @periods = @periods.uniq
      render :update do |page|
        page.replace_html "timetable_period", :partial => "timetable_period"
      end
      return
      # redirect_to :action =>"update_timetable_view", :course_id => params[:course_id], :timetable_id => params[:timetable_id],:period => params[:period]
    else
      @batch = Batch.find(params[:batch_id])
      tta = []

      TimetableEntry.find_all_by_batch_id(@batch.id).each{|zz| tta << zz.timetable_id}

      # @tt = Timetable.find_by_batch_id(@batch.id)


      # @tt = Timetable.find(params[:timetable_id])
      @period = params[:period]
      @start_date = start_date = Date.parse(params[:period].to_s.split(" - ")[0])
      logger.debug "teeeeeeeeeeeeeeeeeeeeeeest"
      logger.debug Date.parse(params[:period].to_s.split(" - ")[0])
      @end_date = end_date = Date.parse(params[:period].to_s.split(" - ")[1])

      tte_from_batch_and_tt(@timetable.id)


      render :update do |page|
        @pis = params[:period].to_s
            @tt1= ["jj","jjj"]
@all_entries = TimetableEntry.find_all_by_timetable_id_and_batch_id(@ttidd,@batch_id).select{|tte| tte.day >= Date.parse(@pis.split('-')[0]) and tte.day <= Date.parse(@pis.split('-')[1]) }

@lgs = LanguageGroup.find_all_by_school_year(@batch.get_batch_year).select{|lg| lg.batch_ids != nil}.select{|l| l.batch_ids.split(",").collect(&:strip).include? @batch_id.to_s}
logger.debug @lgs.inspect
@lgs.each do |lg|
@all_entries = @all_entries + TimetableEntry.find_all_by_timetable_id_and_language_group_id(@ttidd,lg.id).select{|tte| tte.day >= Date.parse(@pis.split('-')[0]) and tte.day <= Date.parse(@pis.split('-')[1]) }
end
@all_entries  = @all_entries.uniq
logger.debug "*****************hna********"
logger.debug @all_entries.count
        page.replace_html "render_area", :partial => "new_entry"

      end
    end




    # logger.debug "********************batch_id is defined*************************"
    # @batch = Batch.find(params[:batch_id])
    # tte_from_batch_and_tt(@timetable.id)
    # #    @weekday = ["#{t('sun')}", "#{t('mon')}", "#{t('tue')}", "#{t('wed')}", "#{t('thu')}", "#{t('fri')}", "#{t('sat')}"]
    # render :update do |page|
    #   page.replace_html "render_area", :partial => "new_entry"
    # end
  end


    def viewll
     if params[:course_name]
	 @timetable_id=params[:timetable_id]
      render(:update) do |page|
        @batches = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false, :is_active => true }).select{|b| b.get_batch_year == Time.now}
        unless @batches.nil?
          page.replace_html 'batches_courses', :partial=> 'batch_courses'
        end
      end
      elsif params[:clibelle]
	  @timetable_id=params[:timetable_id]
      render(:update) do |page|
        @courses = Course.find_by_sql("select * from courses where is_deleted = 0 ")
        unless @courses.nil?
          page.replace_html 'list_courses', :partial=> 'courses_cycles'
          page.replace_html 'batches_courses', :text => ''
        end
      end
      end

	 end

  def update_employees
    #    @weekday = ["#{t('sun')}", "#{t('mon')}", "#{t('tue')}", "#{t('wed')}", "#{t('thu')}", "#{t('fri')}", "#{t('sat')}"]
    if params[:subject_id] == ""
      render :text => ""
      return
    end
    @ttet = TimetableEntryType.all
    @subject = Subject.find(params[:subject_id])
    @lgs = LanguageGroup.find_all_by_subject_group_id_and_school_year(@subject.subject_group.id,@subject.batch.get_batch_year)
    if @lgs.empty?
	logger.debug "empty"
    @employees_subject = EmployeesSubject.find_all_by_subject_id(params[:subject_id])
    else
	logger.debug "not empty"

@employees_subject = []
    end

    render :partial=>"employee_list"
  end
  def check_salle2
    @timetable_entry = TimetableEntry.find(params[:timetable_entry])



     @dd =@timetable_entry.start_date.to_date()
   @df =@timetable_entry.end_date.to_date()
   @weekday = @timetable_entry.weekday_id
      @jour = 0
  (@dd..@df).each do |date|
  logger.debug   "*********************"
    logger.debug "*********************"
  logger.debug "*********************"

  logger.debug @weekday.to_i
  logger.debug date.wday.to_i

  if(date.wday.to_i - 1 == @weekday.to_i)
logger.debug "hahowa"
logger.debug date
@jour = date
  end
end
#@jour = @jour + 1
@debut = @timetable_entry.start_time
@fin = @timetable_entry.end_time

@ttes  = TimetableEntry.find_by_sql("select * from timetable_entries where salle_id = #{params[:salle_id]} and id != #{params[:timetable_entry]} and  day = '#{@jour.strftime("%Y-%m-%d")}' and ( start_time BETWEEN '#{@debut}' AND '#{@fin}' OR end_time BETWEEN '#{@debut}' AND '#{@fin}') ")
#@ttes = TimetableEntry.find_all_by_employee_id(@employee.id).reject{|t| t.day.to_date.year != @jour.to_date.year}.reject{|t| t.day.to_date.month != @jour.to_date.month}
#TimetableEntry.find(:all, :conditions=> "('"+ @start_date +"' <= day) and ('"+ @end_date +"' >= day)")
@check_salle = ""
if @ttes.count > 0
@check_salle = "Attention :Salle déja occupée"
end
   render(:update) do |page|

        page.replace_html "check_salle", :text => "#{@check_salle}"

      end
end
def new_entry_sav1
  @timetable_entry = TimetableEntry.find(params[:ttidd])
  if params[:attendances][:language_group_id]
    params[:attendances][:language_group_id] = params[:attendances][:language_group_id]
    params[:attendances][:employee_id] = LanguageGroup.find(params[:attendances][:language_group_id] ).employee_id
  end
  if @timetable_entry
    @timetable_entry.update_attributes(params[:attendances])
  end
  respond_to do |format|
        format.js { render :action => 'update' }
     end
end
def check_salle
    @dd =params[:dd].to_date()
   @df =params[:df].to_date()
   @weekday = params[:weekday]
      @jour = 0
  (@dd..@df).each do |date|
  logger.debug   "*********************"
    logger.debug "*********************"
  logger.debug "*********************"

  logger.debug @weekday.to_i
  logger.debug date.wday.to_i

  if(date.wday.to_i - 1 == @weekday.to_i)
logger.debug "hahowa"
logger.debug date
@jour = date
  end
end
#@jour = @jour + 1
@debut = "2000-01-01 #{params[:debut].gsub(" ","")}:00"
@fin = "2000-01-01 #{params[:fin].gsub(" ","")}:00"

@ttes  = TimetableEntry.find_by_sql("select * from timetable_entries where salle_id = #{params[:salle_id]} and day = '#{@jour.strftime("%Y-%m-%d")}' and ( start_time BETWEEN '#{@debut}' AND '#{@fin}' OR end_time BETWEEN '#{@debut}' AND '#{@fin}') ")
#@ttes = TimetableEntry.find_all_by_employee_id(@employee.id).reject{|t| t.day.to_date.year != @jour.to_date.year}.reject{|t| t.day.to_date.month != @jour.to_date.month}
#TimetableEntry.find(:all, :conditions=> "('"+ @start_date +"' <= day) and ('"+ @end_date +"' >= day)")
@check_salle = ""
if @ttes.count > 0
@check_salle = "Attention :Salle déja occupée"
end
   render(:update) do |page|

        page.replace_html "check_salle", :text => "#{@check_salle}"

      end
end
  def check_employee_vh
   # @period_time =
   @employee_check = ""
   count = 0
   @dd =params[:dd].to_date()
   @df =params[:df].to_date()
    @employees_subject = Subject.find_by_id(params[:subject_id]).employees
@employee = Employee.find(params[:employee_id])
@weekday = params[:weekday]
      work_days = Weekday.find_all_by_employee_id_and_is_deleted(@employee.id,false)
      if work_days.count > 0
        work_days.each do |wd|
        if @weekday.to_s == wd.weekday
          logger.debug @weekday
          logger.debug wd.weekday
                    logger.debug "***********"
logger.debug @dd
logger.debug @df
count = 1
        end
        end
      else
                            logger.debug "***********loooooooooooooooool"

        count = 1
      @employee_check = ""
      end
      if count == 0
            @employee_check = "Attention : cet enseignant ne travail pas ce jour"

      end
      @jour = 0
  (@dd..@df).each do |date|
  logger.debug   "*********************"
    logger.debug "*********************"
  logger.debug "*********************"

  logger.debug @weekday.to_i
  logger.debug date.wday.to_i

  if(date.wday.to_i == @weekday.to_i)
logger.debug "hahowa"
logger.debug date
@jour = date
  end
end
@debut = "2000-01-01 #{params[:debut].gsub(" ","")}:00"
@fin = "2000-01-01 #{params[:fin].gsub(" ","")}:00"
@ttes_dupp = TimetableEntry.find_by_sql("select * from timetable_entries where employee_id = #{params[:employee_id]} and day = '#{@jour.strftime("%Y-%m-%d")}' and ( start_time BETWEEN '#{@debut}' AND '#{@fin}') OR (end_time BETWEEN '#{@debut}' AND '#{@fin}') ")
if @ttes_dupp.count > 0
  @check_emp = "Attention : il existe des seances dans cette horaire pour cet enseignant"

end
logger.debug   "*********************"
  logger.debug "*********************"
logger.debug "*********************"

logger.debug @ttes_dupp.inspect
@ttes = TimetableEntry.find_all_by_employee_id(@employee.id).reject{|t| t.day.to_date.year != @jour.to_date.year}
#.reject{|t| t.day.to_date.month != @jour.to_date.month}
nb_hours = 0
 @ttes.each do |al|
         nb_hours = nb_hours + ((al.end_time.to_datetime - al.start_time.to_datetime ) * 24  ).to_f

       end
       @check_vh = ""
       if @employee.vh_month
if @employee.vh_month.to_f > nb_hours
else
  @check_vh = "Attention : Dépassement du volume horaire  défiinie par cet enseignant"
end
       end
       #logger.debug  @ttes.inspect
@employees_subject = @employees

@ttes_ump = []
 @ttes_esto= []
  @ttes_flsh= []
   @ttes_fpn= []
    @ttes_fmp= []
    @ttes_estn= []
     @ttes_ensa = []
if @employee.cin
  @employee_fsjes = Employee.find_by_sql("select * from fsjes.employees where cin = #{@employee.cin}")
  if @employee_fsjes.count > 0
@ttes_fsjes = TimetableEntry.find_by_sql("select * from fsjes.timetable_entries where employee_id = #{@employee_esto.first.id} and day = '#{@jour.strftime("%Y-%m-%d")}' and ( start_time BETWEEN '#{@debut}' AND '#{@fin}') OR (end_time BETWEEN '#{@debut}' AND '#{@fin}') ")
end
@employee_flsh = Employee.find_by_sql("select * from flsh.employees where cin = #{@employee.cin}")
if @employee_flsh.count > 0
@ttes_fsjes = TimetableEntry.find_by_sql("select * from flsh.timetable_entries where employee_id = #{@employee_flsh.first.id} and day = '#{@jour.strftime("%Y-%m-%d")}' and ( start_time BETWEEN '#{@debut}' AND '#{@fin}') OR (end_time BETWEEN '#{@debut}' AND '#{@fin}') ")
end
@employee_fpn = Employee.find_by_sql("select * from fpn.employees where cin = #{@employee.cin}")
if @employee_fpn.count > 0
@ttes_fpn = TimetableEntry.find_by_sql("select * from fpn.timetable_entries where employee_id = #{@employee_fpn.first.id} and day = '#{@jour.strftime("%Y-%m-%d")}' and ( start_time BETWEEN '#{@debut}' AND '#{@fin}') OR (end_time BETWEEN '#{@debut}' AND '#{@fin}') ")
end
@employee_fmp = Employee.find_by_sql("select * from fmp.employees where cin = #{@employee.cin}")
if @employee_fmp.count > 0
@ttes_fmp = TimetableEntry.find_by_sql("select * from fmp.timetable_entries where employee_id = #{@employee_fmp.first.id} and day = '#{@jour.strftime("%Y-%m-%d")}' and ( start_time BETWEEN '#{@debut}' AND '#{@fin}') OR (end_time BETWEEN '#{@debut}' AND '#{@fin}') ")
end
@employee_estn = Employee.find_by_sql("select * from estn.employees where cin = #{@employee.cin}")
if @employee_estn.count > 0
@ttes_estn = TimetableEntry.find_by_sql("select * from estn.timetable_entries where employee_id = #{@employee_estn.first.id} and day = '#{@jour.strftime("%Y-%m-%d")}' and ( start_time BETWEEN '#{@debut}' AND '#{@fin}') OR (end_time BETWEEN '#{@debut}' AND '#{@fin}') ")
end
@employee_ensa = Employee.find_by_sql("select * from ensa.employees where cin = #{@employee.cin}")
if @employee_ensa.count > 0
@ttes_ensa = TimetableEntry.find_by_sql("select * from ensa.timetable_entries where employee_id = #{@employee_ensa.first.id} and day = '#{@jour.strftime("%Y-%m-%d")}' and ( start_time BETWEEN '#{@debut}' AND '#{@fin}') OR (end_time BETWEEN '#{@debut}' AND '#{@fin}') ")
end

@ttes_ump  = @ttes_fsjes + @ttes_flsh  + @ttes_fpn + @ttes_fmp + @ttes_estn + @ttes_ensa
if @ttes_ump.count > 0
  @check_emp = "Attention : il existe des seances dans cette horaire pour cet enseignant dans d'autre ecoles"
end
end

render(:update) do |page|

        page.replace_html "check", :text => "#{@employee_check}"
                page.replace_html "check_vh", :text => "#{@check_vh}"
                page.replace_html "check_emp", :text => "#{@check_emp}"
                page.replace_html "check_ump", :text => "#{@check_ump}"

      end

  end
  def update_employees2
@subject_id = params[:subject_id]
@weekday = params[:weekday].to_i + 1
@dd = params[:dd]
@df = params[:df]
@debut = params[:debut]
@fin = params[:fin]
if @weekday == 7
  @weekday = 0
end
@subject = Subject.find(params[:subject_id])
bid = @subject.batch_id
#    other_bid = Student.find(BatchStudent.find_by_batch_id(bid).student_id).previous_batch.id
@lgs = LanguageGroup.find_all_by_subject_group_id_and_school_year(@subject.subject_group.id,@subject.batch.get_batch_year)
if @lgs.count > 0
  @lgs = @lgs + LanguageGroup.find_all_by_school_year(@subject.batch.get_batch_year).select{|lg| lg.subject_group_ids != nil}.select{|l| l.subject_group_ids.split(",").include? "#{@subject.subject_group.id}"}
else
  @lgs = LanguageGroup.find_all_by_school_year(@subject.batch.get_batch_year).select{|lg| lg.subject_group_ids != nil}.select{|l| l.subject_group_ids.split(",").include? "#{@subject.subject_group.id}"}
end
lgs_todelete = []
@lgs =  @lgs.uniq
@lgs.each do |c|
lgs = LanguageGroupStudent.find_all_by_language_group_id(c.id).collect{|e| e.batch_id }.uniq
#	lgs += LanguageGroupStudent.find_all_by_language_group_id(c.id).collect{|e| Student.find(e.student_id).previous_batch.id }.uniq

if !(lgs.include? @subject.batch_id) # and !(lgs.include? other_bid)
logger.debug c.id.to_s+"\n"
lgs_todelete << c
# @lgs.delete(c)
end
end
logger.debug @lgs.inspect
@employees = []
    @employees_subject = Subject.find_by_id(params[:subject_id]).employees


      render(:update) do |page|

        page.replace_html "employees-select", :partial => "employee_list"
      end
  end
  def delete_employee2
    @salles = Salle.all
    @errors = {"messages" => []}
    tte=TimetableEntry.find(params[:id])
    batch=tte.batch_id
    OnlineMeetingRoom.find_all_by_tte_id(tte.id).each{|omr| omr.destroy}
    #    @timetable = TimetableEntry.find_all_by_batch_id(tte.batch_id)
    @batch=Batch.find batch
    @timetable=Timetable.find(tte.timetable_id)
    if !tte.group_id.nil?
    TimetableEntry.find_all_by_group_id_and_class_timing_id_and_weekday_id(tte.group_id,tte.class_timing_id,tte.weekday_id).reject{|t| t.id == tte.id }.each do |r|
     OnlineMeetingRoom.find_all_by_tte_id(r.id).each{|omr| omr.destroy}
     r.destroy
    end
    end
    tte.destroy
    tte_from_batch_and_tt(@timetable.id)
    render :partial => "new_entry", :batch_id=>batch
  end

  #  for script

  def update_multiple_timetable_entries2
    @period = params[:period]
    @timetable=Timetable.find(params[:timetable_id])
time_interval = (@timetable.start_date.to_date..@timetable.end_date.to_date).reject{|date| date.wday == 7}

    if params[:emp_sub_id]
    employees_subject = EmployeesSubject.find(params[:emp_sub_id])
      logger.debug "params[:emp_sub_id]"
          @batch = employees_subject.subject.batch
    subject = employees_subject.subject
    employee = employees_subject.employee
    elsif params[:lg_id]
    employees_subject = LanguageGroup.find(params[:lg_id])
      logger.debug "params[:lg_id]"
          @batch =  Batch.find(params[:batch_id])#employees_subject.subject_group.subjects.last.batch
    subject = employees_subject.subject_group.subjects.select{|so| so.batch_id == @batch.id}.first
    employee = employees_subject.employee
    end


    tte_ids = params[:tte_ids].split(",").each {|x| x}

    @start_date = start_date = Date.parse(params[:period].to_s.split(" - ")[0])

    @end_date = end_date = Date.parse(params[:period].to_s.split(" - ")[1])


    @salles = Salle.all

    @validation_problems = {}
    puts params[:tte_ids].inspect
    puts tte_ids.inspect
    puts @timetable.inspect
    tte_ids.each do |tte_id|
      co_ordinate=tte_id.split("_")
      weekday=co_ordinate[0].to_i
      class_timing=co_ordinate[1].to_i
      day = nil
        (start_date..end_date).each do |ez|
          logger.debug "CCCurrent day "+ez.to_s+" wday  = "+weekday.to_s
          if ez.wday == Weekday.find(weekday).day_of_week
            day = ez
            logger.debug "this is the day => "+ez.to_s+" wday  = "+ez.wday.to_s
            break
          end
      end
      #      tte = TimetableEntry.find(tte_id)
      tte = TimetableEntry.find_by_weekday_id_and_class_timing_id_and_batch_id_and_timetable_id(weekday,class_timing,@batch.id,@timetable.id)
      errors = { "info" => {"sub_id" => subject.id, "emp_id"=> employee.id,"tte_id" => tte_id}, "messages" => [] }
periods = []
first = time_interval.first
time_interval.each do |e,i|
if e.wday == Weekday.find(weekday).day_of_week
periods << e
end
end
periods = periods.uniq
      # check for weekly subject limit.
      # errors["messages"] << "#{t('weekly_limit_reached')}" \
       # if subject.max_weekly_classes <= TimetableEntry.count(:conditions =>{:subject_id=>subject.id,:timetable_id=>@timetable.id}) unless subject.max_weekly_classes.nil?
       vaca =  Vacancy.all.select{|v| v.start_date <= periods.first and v.end_date >= periods.first}
       if !vaca.empty?
          vaca.each do |v|
            errors["messages"] << "Jours fériés "+ v.name
          end
       end
      #check for overlapping classes
      overlap = TimetableEntry.find(:first,
        :conditions => "timetable_id=#{@timetable.id} AND weekday_id = #{weekday} AND class_timing_id = #{class_timing} AND timetable_entries.employee_id = #{employee.id}", \
          :joins=>"INNER JOIN subjects ON timetable_entries.subject_id = subjects.id INNER JOIN batches ON subjects.batch_id = batches.id AND batches.is_active = 1 AND batches.is_deleted = 0")
      unless overlap.nil?
        errors["messages"] << "#{t('class_overlap')}: #{overlap.batch.full_name}."
      end

      #overlap with an other timetabl
#      overlap_dif_timetable = TimetableEntry.find(:first,:conditions => "weekday_id = #{weekday} AND class_timing_id = #{class_timing} AND timetable_entries.employee_id = #{employee.id}", \
#          :joins=>"INNER JOIN subjects ON timetable_entries.subject_id = subjects.id INNER JOIN batches ON subjects.batch_id = batches.id AND batches.is_active = 1 AND batches.is_deleted = 0")
     # unless overlap_dif_timetable.nil?
if 1 ==2
          tt_over = Timetable.find(overlap_dif_timetable.timetable_id)

        errors["messages"] << "#{t('class_overlap')}: #{overlap_dif_timetable.batch.full_name}"+" sur le calendrier du "+I18n.l(tt_over.start_date,:format=>"%d %b %Y")+ "-"  +I18n.l(tt_over.end_date,:format=>"%d %b %Y")
      end

      # check for max_hour_day exceeded
      employee = subject.lower_day_grade unless subject.elective_group_id.nil?
      errors["messages"] << "#{t('max_hour_exceeded_day')}" \
        if employee.max_hours_per_day <= TimetableEntry.count(:conditions => "timetable_entries.timetable_id=#{@timetable.id} AND timetable_entries.employee_id = #{employee.id} AND weekday_id = #{weekday}",:joins=>"INNER JOIN subjects ON timetable_entries.subject_id = subjects.id INNER JOIN batches ON subjects.batch_id = batches.id AND batches.is_active = 1 AND batches.is_deleted = 0") unless employee.max_hours_per_day.nil?

      # check for max hours per week
      employee = subject.lower_week_grade unless subject.elective_group_id.nil?
      errors["messages"] << "#{t('max_hour_exceeded_week')}" \
        if employee.max_hours_per_week <= TimetableEntry.count(:conditions => "timetable_entries.timetable_id=#{@timetable.id} AND timetable_entries.employee_id = #{employee.id}",:joins=>"INNER JOIN subjects ON timetable_entries.subject_id = subjects.id INNER JOIN batches ON subjects.batch_id = batches.id AND batches.is_active = 1 AND batches.is_deleted = 0") unless employee.max_hours_per_week.nil?

      if errors["messages"].empty?
        unless tte.nil?
          # TimetableEntry.update(tte.id, :subject_id => subject.id, :employee_id=>employee.id,:timetable_id=>@timetable.id)
          TimetableEntry.update(tte.id, :subject_id => subject.id, :employee_id=>employee.id,:timetable_id=>@timetable.id, :day => day,:tte_type_id=>params[:ttet_id.to_s])

        else
          if !weekday.nil? and !class_timing.nil? and !subject.id.nil? and !employee.id.nil? and !@batch.id.nil? and !@timetable.id.nil?

omr_lou =  "http://lgi.iav.ac.ma"
hh = ClassTiming.find(class_timing).start_time.hour
mm = ClassTiming.find(class_timing).start_time.min
time_interval = (@timetable.start_date.to_date..@timetable.end_date.to_date).reject{|date| date.wday == 7}

periods = []
first = time_interval.first
logger.debug Weekday.find(weekday).day_of_week.to_s+"\n"
logger.debug Weekday.find(weekday).day_of_week.to_s+"\n"
logger.debug Weekday.find(weekday).day_of_week.to_s+"\n"
time_interval.each do |e,i|
logger.debug e.wday.to_s+" "+Weekday.find(weekday).day_of_week.to_s+"\n"
if e.wday == Weekday.find(weekday).day_of_week
periods << e
end
end
periods = periods.uniq
@periods = time_interval
if params[:lg_id]

# tt = TimetableEntry.new(:group_id => params[:lg_id].to_i, :weekday_id=>weekday,:class_timing_id=>class_timing, :subject_id => subject.id, :employee_id=>employee.id,:batch_id=>@batch.id,:timetable_id=>@timetable.id).save
tt = TimetableEntry.new(:start_date => start_date, :end_date => end_date, :is_done => 0,:group_id => params[:lg_id].to_i, :weekday_id=>weekday,:class_timing_id=>class_timing, :subject_id => subject.id, :employee_id=>employee.id,:batch_id=>@batch.id,:timetable_id=>@timetable.id,:day => day,:tte_type_id=>params[:ttet_id.to_s]).save
tt = TimetableEntry.last
language_grp = LanguageGroup.find(params[:lg_id])
bats = []
language_grp.language_group_students.each{|lgp| bats << lgp.batch_id}
bats = bats.uniq.reject{|bah| bah.to_s == @batch.id.to_s}
if @batch.school_field.id != 10
bats.each do |bo|
  logger.debug bo.to_s+"\n"
  logger.debug bo.to_s+"\n"
  logger.debug bo.to_s+"\n"
  logger.debug bo.to_s+"\n"
  logger.debug bo.to_s+"\n"
  logger.debug bo.to_s+"\n"
# TimetableEntry.new(:group_id => params[:lg_id].to_i, :weekday_id=>weekday,:class_timing_id=>class_timing, :subject_id => subject.id, :employee_id=>employee.id,:batch_id=>bo,:timetable_id=>@timetable.id).save
TimetableEntry.new(:start_date => start_date, :end_date => end_date, :is_done => 0,:group_id => params[:lg_id].to_i, :weekday_id=>weekday,:class_timing_id=>class_timing, :subject_id => subject.id, :employee_id=>employee.id,:batch_id=>bo,:timetable_id=>@timetable.id,:day => day,:tte_type_id=>params[:ttet_id.to_s]).save

end
end
i = TimetableEntry.find_all_by_subject_id_and_timetable_id(subject.id,@timetable.id).count
require 'i18n'
periods.each do |pdate|
  i = ActiveSupport::SecureRandom.random_number(9999)
  omr_name = "#{I18n.transliterate(subject.name).gsub("\'","")} "+i.to_s+" "+tt.id.to_s#subject.name+" "+subject.batch.full_name
  omr_time =  Time.local(pdate.year,pdate.month,pdate.day,hh,mm,0).strftime("%Y-%m-%d %H:%M:%S")
  logger.debug "OMR INFOS : "+omr_name+ " "+ omr_lou +" "+omr_time.to_s+"\n"
  ooo = OnlineMeetingRoom.new( :server_id => 2,:name => omr_name,:scheduled_on => omr_time)
  ooo.user_id =  employee.user.id
  ooo.member_ids = LanguageGroup.find(params[:lg_id]).language_group_students.collect{ |s| s.student.user.id.to_i }
  ooo.member_ids = ooo.member_ids.uniq
  ooo.member_ids.each{|c| logger.debug c.to_s+"\n"}
  # exit
  # ooo.member_ids = @batch.all_students.collect{ |s| s.user.id.to_i }
  if ooo.save
  #ooo.update_attributes(:tte_id => tt.id)
  logger.debug "OMR Saved Successfully"
  ooo.tte_id = tt.id
  if ooo.save

  logger.debug "99999OMR Saved Successfully"
  end
  else
  logger.debug "ONR Not Savec !!"
  end
end

elsif params[:emp_sub_id]
# tt = TimetableEntry.new( :weekday_id=>weekday,:class_timing_id=>class_timing, :subject_id => subject.id, :employee_id=>employee.id,:batch_id=>@batch.id,:timetable_id=>@timetable.id).save
tt = TimetableEntry.new(:start_date => start_date, :end_date => end_date, :is_done => 0,:weekday_id=>weekday,:class_timing_id=>class_timing, :subject_id => subject.id, :employee_id=>employee.id,:batch_id=>@batch.id,:timetable_id=>@timetable.id,:day => day,:tte_type_id=>params[:ttet_id.to_s]).save


tt = TimetableEntry.last
i = TimetableEntry.find_all_by_subject_id_and_timetable_id(subject.id,@timetable.id).count
require 'i18n'
periods.each do |pdate|
  omr_name = "#{I18n.transliterate(subject.name)} "+i.to_s+" "+tt.id.to_s#subject.name+" "+subject.batch.full_name
  omr_time =  Time.local(pdate.year,pdate.month,pdate.day,hh,mm,0).strftime("%Y-%m-%d %H:%M:%S")
  logger.debug "OMR INFOS : "+omr_name+ " "+ omr_lou +" "+omr_time.to_s+"\n"
  ooo = OnlineMeetingRoom.new( :server_id => 2,:name => omr_name,:scheduled_on => omr_time)
  ooo.user_id =  employee.user.id


  @student_mt = @batch.students
  @student_mt += @batch.old_students       #batch_string+=batch.id.to_s+','
  @student_mt = @student_mt.uniq



  # ooo.member_ids = @batch.all_students.collect{ |s| s.user.id.to_i }
  ooo.member_ids = @student_mt.collect{ |s| s.user.id.to_i }
  if ooo.save
  #ooo.update_attributes(:tte_id => tt.id)
  logger.debug "OMR Saved Successfully"
  ooo.tte_id = tt.id
  if ooo.save
  logger.debug "99999OMR Saved Successfully"
  end
  else
  logger.debug "ONR Not Savec !!"
  end
end
end
          end
        end
      else
        @validation_problems[tte_id] = errors
      end
    end

    #    @timetable = TimetableEntry.find_all_by_batch_id(@batch.id)
    tte_from_batch_and_tt(@timetable.id)
    render :partial => "new_entry"
  end

  def update_multiple_timetable_entries3
    @timetable=Timetable.find(params[:timetable_id])
    #employees_subject = EmployeesSubject.find(params[:salle_id])
  #salle = Salle.find(params[:salle_id])
	salle = Salle.find(params[:salle_id])
    @@salle_id_tmp = params[:salle_id]
    tte_ids = params[:tte_ids].split(",").each {|x| x}
    logger.debug "***********batch_id****************"
    logger.info params[:batch_id]
    @batch = Batch.find(params[:batch_id])
    logger.debug "**************batch found***************"
    logger.info params[:batch_id]
    #subject = employees_subject.subject
 # @salles = Salle.all
	@salles = Salle.all
    #employee = employees_subject.employee
    @validation_problems = {}
    puts params[:tte_ids].inspect
    puts tte_ids.inspect
    puts @timetable.inspect
    tte_ids.each do |tte_id|
    logger.debug "***********************parcour de tte_ids**********************"
      co_ordinate=tte_id.split("_")
      weekday=co_ordinate[0].to_i
      class_timing=co_ordinate[1].to_i
           # tte = TimetableEntry.find(tte_id)
      tte = TimetableEntry.find_by_weekday_id_and_class_timing_id_and_timetable_id_and_batch_id(weekday,class_timing,@timetable.id,params[:batch_id])
	   errors = { "info" => {"tte_id" => tte_id},
        "messages" => [] }
	logger.debug tte.id
      # check for weekly subject limit.
      #errors["messages"] << "#{t('weekly_limit_reached')}" \
        #if subject.max_weekly_classes <= TimetableEntry.count(:conditions =>{:subject_id=>subject.id,:timetable_id=>@timetable.id}) unless subject.max_weekly_classes.nil?

      #check for overlapping classes
      overlap = TimetableEntry.find(:first,
        :conditions => "timetable_id=#{@timetable.id} AND weekday_id = #{weekday} AND class_timing_id = #{class_timing} AND timetable_entries.salle_id = #{params[:salle_id]}", \
          :joins=>"INNER JOIN subjects ON timetable_entries.subject_id = subjects.id INNER JOIN batches ON subjects.batch_id = batches.id AND batches.is_active = 1 AND batches.is_deleted = 0")
      unless overlap.nil?
        errors["messages"] << "#{t('class_overlap')}: #{overlap.batch.full_name}."
      end
	  logger.debug overlap.nil?
	  logger.debug "**********salle*********///*/"
	  logger.info params[:salle_id]
      # check for max_hour_day exceeded
      #employee = subject.lower_day_grade unless subject.elective_group_id.nil?
      #errors["messages"] << "#{t('max_hour_exceeded_day')}" \
        #if employee.max_hours_per_day <= TimetableEntry.count(:conditions => "timetable_entries.timetable_id=#{@timetable.id} AND timetable_entries.employee_id = #{employee.id} AND weekday_id = #{weekday}",:joins=>"INNER JOIN subjects ON timetable_entries.subject_id = subjects.id INNER JOIN batches ON subjects.batch_id = batches.id AND batches.is_active = 1 AND batches.is_deleted = 0") unless employee.max_hours_per_day.nil?

      # check for max hours per week
      #employee = subject.lower_week_grade unless subject.elective_group_id.nil?
      #errors["messages"] << "#{t('max_hour_exceeded_week')}" \
        #if employee.max_hours_per_week <= TimetableEntry.count(:conditions => "timetable_entries.timetable_id=#{@timetable.id} AND timetable_entries.employee_id = #{employee.id}",:joins=>"INNER JOIN subjects ON timetable_entries.subject_id = subjects.id INNER JOIN batches ON subjects.batch_id = batches.id AND batches.is_active = 1 AND batches.is_deleted = 0") unless employee.max_hours_per_week.nil?

      if errors["messages"].empty?
		logger.debug "***********pas d'erreur*************"
        unless tte.nil?
		  logger.debug "***********avant update*************"
         # TimetableEntry.update(tte.id, :subject_id => tte.subject_id, :employee_id=>tte.employee_id,:timetable_id=>@timetable.id, :salle_id => salle.id)
          tte.update_attributes(:subject_id => tte.subject_id, :employee_id=>tte.employee_id,:timetable_id=>@timetable.id, :salle_id => params[:salle_id])
		      if tte.save
            logger.debug "saaaaaaeved"
          end
      logger.debug "***********apres update*************"
		else
		  logger.debug "***********avant persiste*************"

          TimetableEntry.new(:weekday_id=>weekday,:class_timing_id=>class_timing,:timetable_id=>@timetable.id, :salle_id => params[:salle_id]).save
      logger.debug "***********apres persiste*******************"
		end
      else
        @validation_problems[tte_id] = errors
      end
    end

    #    @timetable = TimetableEntry.find_all_by_batch_id(@batch.id)
    tte_from_batch_and_tt(@timetable.id)
    render :partial => "new_entry"
  end

  def tt_entry_update2
    @errors = {"messages" => []}
    @timetable=Timetable.find(params[:timetable_id])
    @batch=Batch.find(params[:batch_id])
    logger.debug "********salle id 2***********"
    logger.debug @@salle_id_tmp
    co_ordinate=params[:tte_id].split("_")
    weekday=co_ordinate[0].to_i
      @salles = Salle.all

    class_timing=co_ordinate[1].to_i
    #      tte = TimetableEntry.find(tte_id)
    tte = TimetableEntry.find_by_weekday_id_and_class_timing_id_and_batch_id_and_timetable_id(weekday,class_timing,@batch.id,@timetable.id)
    overlapped_tte = TimetableEntry.find_by_weekday_id_and_class_timing_id_and_employee_id_and_timetable_id(weekday,class_timing,params[:emp_id],@timetable.id)
    # if overlapped_tte.nil?
    #   unless tte.nil?
    #     TimetableEntry.update(tte.id, :subject_id => params[:sub_id], :employee_id => params[:emp_id])
    #   else
    #     TimetableEntry.new(:weekday_id=>weekday,:class_timing_id=>class_timing, :subject_id => params[:sub_id], :employee_id => params[:emp_id],:batch_id=>@batch.id,:timetable_id=>@timetable.id).save
    #   end
    # else
    #   overlapped_tte.destroy
    #   unless tte.nil?
    #     TimetableEntry.update(tte.id, :subject_id => params[:sub_id], :employee_id => params[:emp_id])
    #   else
    #     TimetableEntry.new(:weekday_id=>weekday,:class_timing_id=>class_timing, :subject_id => params[:sub_id], :employee_id => params[:emp_id],:batch_id=>@batch.id,:timetable_id=>@timetable.id).save
    #   end
      #      TimetableEntry.update(params[:tte_id], :subject_id => params[:sub_id], :employee_id => params[:emp_id])
    # end


      unless tte.nil?
        logger.debug "11111111111111111"
        if !@@salle_id_tmp.nil?
          logger.debug "222222222222222222222222"
            TimetableEntry.update(tte.id, :salle_id => @@salle_id_tmp)
        elsif !params[:sub_id].nil? and params[:sub_id] != "" and !params[:emp_id].nil? and params[:emp_id] != ""
          logger.debug "33333333333333333333"
            TimetableEntry.update(tte.id, :subject_id => params[:sub_id], :employee_id => params[:emp_id])
        end
      else
        TimetableEntry.new(:weekday_id=>weekday,:class_timing_id=>class_timing, :subject_id => params[:sub_id], :employee_id => params[:emp_id],:batch_id=>@batch.id,:timetable_id=>@timetable.id).save
      end

    tte_from_batch_and_tt(@timetable.id)
    render :update do |page|
      page.replace_html "box", :partial=> "timetable_box"
      page.replace_html "subjects-select", :partial=> "employee_select"
      page.replace_html "error_div_#{params[:tte_id]}", :text => "#{t('done')}"
    end
    # render :partial => "new_entry"

  end

  def tt_entry_noupdate2
    render :update => "error_div_#{params[:tte_id]}", :text => "#{t('cancelled')}"
  end

  def update_salle
    #    @weekday = ["#{t('sun')}", "#{t('mon')}", "#{t('tue')}", "#{t('wed')}", "#{t('thu')}", "#{t('fri')}", "#{t('sat')}"]
    if params[:id] == ""
      render :text => ""
      return
    end
    #@salle = Salle.find(params[:salle_id])
    @salle = Salle.find(params[:salle_id])
    render :partial=>"salle_list"
  end

  def update_salle2
	 if params[:salle_id] == ""
      render :text => ""
      return
    end
	@salle = Salle.find(params[:salle_id])
    render :partial=>"salle_list2"
  end

	def delete_salle
    @errors = {"messages" => []}
    tte=TimetableEntry.find(params[:id])
    batch=tte.batch_id
	@salles = Salle.all
    #    @timetable = TimetableEntry.find_all_by_batch_id(tte.batch_id)
    @batch=Batch.find batch
    @timetable=Timetable.find(tte.timetable_id)
    tte.salle_id = nil
    tte.save
    tte_from_batch_and_tt(@timetable.id)
    render :partial => "new_entry", :batch_id=>batch
  end

  #  for script

  private

  # def tte_from_batch_and_tt(tt)
  #   @tt=Timetable.find(tt)

  #   @class_timing = ClassTiming.default

  #   @class_timing = ClassTiming.for_batch(@batch.id)
  #   if @class_timing.empty?
  #     logger.debug "*************class timing empty*****************"
  #     @class_timing = ClassTiming.default
  #   end
  #   @weekday = Weekday.for_batch(@batch.id)
  #   if @weekday.empty?
  #     @weekday = Weekday.default
  #   end
  #   timetable_entries=TimetableEntry.find(:all,:conditions=>{:batch_id=>@batch.id,:timetable_id=>@tt.id},:include=>[:subject,:employee])
  #   @timetable= Hash.new { |h, k| h[k] = Hash.new(&h.default_proc)}
  #   timetable_entries.each do |tte|
  #     @timetable[tte.weekday_id][tte.class_timing_id]=tte
  #   end
  #   @subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>["elective_group_id IS NULL AND is_deleted = false"])
  #   @ele_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>["elective_group_id IS NOT NULL AND is_deleted = false"], :group => "elective_group_id")
  # end

  def tte_from_batch_and_tt(tt)
    @tt=Timetable.find(tt)
    @class_timing = ClassTiming.for_batch(@batch.id)
    if @class_timing.empty?
      logger.debug "*************class timing empty*****************"
      @class_timing = ClassTiming.default
    end
    @weekday = Weekday.for_batch(@batch.id)
    if @weekday.empty?
      @weekday = Weekday.default
    end
      @start_date =start_date = Date.parse(params[:period].to_s.split(" - ")[0])

      @end_date =end_date = Date.parse(params[:period].to_s.split(" - ")[1])

     timetable_entries=TimetableEntry.find(:all,:conditions=>{:batch_id=>@batch.id,:timetable_id=>@tt.id},:include=>[:subject,:employee]).reject{|tte| tte.day < start_date or tte.day > end_date }
#    timetable_entries=TimetableEntry.find(:all,:conditions=>{:batch_id=>@batch.id},:include=>[:subject,:employee]).reject{|tte| tte.start_date != start_date or tte.day != end_date }
    @timetable= Hash.new { |h, k| h[k] = Hash.new(&h.default_proc)}
    timetable_entries.each do |tte|
      @timetable[tte.weekday_id][tte.class_timing_id]=tte
    end
    @subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>["elective_group_id IS NULL AND is_deleted = false"])
    @ele_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>["elective_group_id IS NOT NULL AND is_deleted = false"], :group => "elective_group_id")
  end


end
