class BatchGrpsController < ApplicationController

    def new
    @batch = Batch.find(params[:id])
    @batch_group = BatchGrp.new
    @batch_groups = BatchGrp.find_all_by_batch_id(@batch.id)
    logger.debug @batch_groups.count
    # @nb_group = params[:nb_group]

    if BatchGrp.find_by_batch_id( @batch.id)
      c = 1
      @group = []
      @nb_group = BatchGrp.find_by_batch_id( @batch.id).nb_group.to_i
      while c <= @nb_group 
      @group[c] = BatchGrp.find_by_sql("select * from batch_grps where batch_id = #{@batch.id} and status = true and group_id = #{c} ORDER BY name")
      c += 1
      end
    # end


      k = 1
      @select = {} 
      while k <= @nb_group.to_i
      @select[k] = "group#{k}"
      k += 1
      end
 
 
#****************************************************************************************
@all_students = Batch.find(@batch.id).students.sort_by {|w| w.last_name}
  @students =[]
  @full_name = Hash.new 
  @all_students.each do |st|
    @students << st.id
     @full_name[st.full_name]  = st.id

  end
  
  @sliced_array = Hash.new 
  count = @students.count
  @range = sprintf("%.2f",count.fdiv(@nb_group.to_i))
  @array = @students.each_slice(@range.to_i + 1).to_a


   x =Student.find(@array[0][-1]).full_name.to_s
  
    b = x.chars.first

    @s = Hash.new 
   @full_name.each {|key, val| 
    c = key.chars.first
    if @s.include?("#{c}") == false 
    @s[c] = []
      @s[c] << val
    else

      @s[c] << val
      
     end}
     @k = []
@s.each_key {|key| 
@k << key
}

sort = @k.sort {|a, b| a <=> b }
x = 0
@select_groups = Hash.new
@k.sort {|a, b| a <=> b }.each do |s|
@select_groups[x] = s
x += 1
end

  @slice = sort.each_slice((@k.count / (@nb_group.to_i + 1) ).to_i).to_a  
 


   y = 0
   while y.to_i < @nb_group.to_i

     @array[y].each do|h|
   if !BatchGrp.find_by_student_id(h)
     
             BatchGrp.create(:name=>Student.find(h).full_name,:student_id => h, :batch_id => @batch.id, :nb_group =>  @nb_group, :status=>false, :group_id=>y+1)
         
       end
   end
     y += 1
  end


      @student_deleted = []

      @student_deleted = BatchGrp.find_by_sql("select student_id from batch_grps where batch_id = #{@batch.id} and status = false ")

#****************************************************************************************
  end
  end

def create

   


if params[:commit] == "valider"
 
  @debut = params[:debut].compact
  @fin = params[:fin].compact
  @nb_group = params[:nb_group]
  @batch_id = params[:batch_id]
 
  


  @all_students = BatchGrp.find_all_by_batch_id(@batch_id)
  @students =[]
  @full_name = Hash.new 
  @all_students.each do |st|
    @students << st.student_id
     @full_name[Student.find(st.student_id).full_name]  = st.student_id

  end
  
  @sliced_array = Hash.new 
  count = @students.count
  @range = sprintf("%.2f",count.fdiv(@nb_group.to_i))
  @array = @students.each_slice(@range.to_i + 1).to_a



    @s = Hash.new 
   @full_name.each {|key, val| 
    c = key.chars.first
    if @s.include?("#{c}") == false 
    @s[c] = []
      @s[c] << val
    else

      @s[c] << val
      
     end}



   
   @new_table = Hash.new
i = 0 
while i < @nb_group.to_i
  @new_table[i] = []
  d = @debut[i]
  f = @fin[i]
 
  index_d = @s.sort {|a, b| a <=> b }.find_index { |k,_| k== "#{d}" }
index_f = @s.sort {|a, b| a <=> b }.find_index { |k,_| k== "#{f}" }

  @s.sort {|a, b| a <=> b }.each  {|key, value| 
index_key = @s.sort {|a, b| a <=> b }.find_index { |k,_| k== "#{key}" }
if !d.empty? or !f.empty?
  if index_key >= index_d   and index_key  <= index_f
    @new_table[i] += value
 
end
end


}
  
  i += 1
end


# @students.each do |st|
  y = 0
  while y.to_i < @nb_group.to_i
    @new_table[y].each do|h|
      
        logger.debug "student_id #{h}   group_id #{y+1}"
        st = BatchGrp.find_by_student_id(h) 
        
          st.update_attributes( :group_id=>y+1, :status=>true)
         

      
     end
    y += 1
   end
#  end



  render :js=>"window.location='#{new_batch_grp_path(:id=>@batch_id , :nb_group=>@nb_group)}'"
else

    @batch_group = BatchGrp.new(params[:batch_grp])
    @batch_id = params[:batch_grp][:batch_id]
    @nb_group = params[:batch_grp][:nb_group]

#cree les etudiante premier fois if BatchGrp ==empty and nb_group not null
if (BatchGrp.find_all_by_batch_id(@batch_id).empty?  and !@nb_group.nil?) 

  @all_students = Batch.find(params[:batch_grp][:batch_id]).students.sort_by {|w| w.last_name}
  

  @students =[]
  @all_students.each do |st|
    @students << st.id
  end
  
  @sliced_array = Hash.new 
  count = @students.count
 @range = sprintf("%.2f",count.fdiv(@nb_group.to_i))
 
 @array = @students.each_slice(@range.to_i + 1).to_a

 x = 0
 while x.to_i < @nb_group.to_i
 
   @sliced_array["#{x+1}"] = @array[x]
   x += 1
 end


  @all_students.each do |st|
   y = 0
   while y.to_i < @nb_group.to_i
     
     @sliced_array["#{y+1}"].each do|h|
     
       if st.id == h.to_i
          logger.debug "#{st.id} HHHHHHHHHHHHHHHHHHHHH#{h}"
         
          BatchGrp.create(:name=>"group#{y+1}" ,:student_id => st.id, :batch_id => @batch_id, :nb_group =>  @nb_group, :status=>true, :group_id=>y+1)
          

       end
      end
     y += 1
   end
  end


else
 # update status et group_id et nb_group des etudiante pour BatchGrp == not empty and nb_group not null   

  @all_students = BatchGrp.find_all_by_batch_id(@batch_id)

  @students =[]
  @all_students.each do |st|
    @students << st.id
  end
  
  @sliced_array = Hash.new 
  count = @students.count
  @range = sprintf("%.2f",count.fdiv(@nb_group.to_i))
  @array = @students.each_slice(@range.to_i + 1).to_a
 
   x = 0
   while x.to_i < @nb_group.to_i
     @sliced_array["#{x+1}"] = @array[x]
     x += 1
   end
 
  @all_students.each do |st|
   y = 0
   while y.to_i < @nb_group.to_i
     @sliced_array["#{y+1}"].each do|h|
       if st.id == h.to_i
        
          st.update_attributes(:nb_group =>@nb_group,  :status=>true)
         

        end
      end
     y += 1
    end
  end

  
end
render :js=>"window.location='#{new_batch_grp_path(:id=>@batch_group.batch_id , :nb_group=>@nb_group)}'"
end

        

  end


def retirer
  @student_id = params[:transfer]
  @group_id = params[:group_id]


  if params[:transfer_auto]
      @batch_id = params[:batch_id]
      # logger.debug "TTTTTTTTTTTTTTTTTTTTTTT #{params[:transfer_auto]}"
       @student = BatchGrp.find_by_sql("select * from batch_grps where batch_id = #{@batch_id} and student_id = #{params[:transfer_auto]} ")
       @student.each do |s|
       s.update_attributes(:status=> true)
     end
    end

    if params[:transfer_auto_tout]
      @batch_id = params[:batch_id]
       params[:transfer_auto_tout].each do |student_id|
         @student = BatchGrp.find_by_sql("select * from batch_grps where batch_id = #{@batch_id} and student_id = #{student_id} ")
         @student.each do |s|
         s.update_attributes(:status=> true)
         end
       end
    end


   if params[:commit] == "Transfer"
     @batch_id = params[:batch_id]
    
      @student = BatchGrp.find_by_sql("select student_id from batch_grps where batch_id = #{@batch_id} and status = false ")
      @group_id = params[:group_id]

      c = 0
      while c < @student.count
        if @group_id[c].to_i != 0
        
          changed = BatchGrp.find_by_sql("select * from batch_grps where batch_id = #{@batch_id} and student_id = #{@student[c].student_id}")
          changed.each do |changed|
            changed.update_attributes(:status=> true, :group_id=>@group_id[c])
          end
           
        end
       c +=1 
      end

    end

 
    if params[:commit] == "Retirer"
  @batch_id = params[:batch_grp][:batch_id]
      # if @student_id.count > 1
        student_deleted = []
        @student_id.each do |st|
          logger.debug st
          student_deleted += BatchGrp.find_by_sql("select * from batch_grps where batch_id = #{@batch_id} and group_id = #{@group_id} and student_id = #{st.to_i}")
        end


        student_deleted.each do |sd|
          sd.update_attributes(:status=> false)
          logger.debug sd.inspect
        end
      # else
      #   st = @student_id
      # deleted = BatchGrp.find_by_sql("select * from batch_grps where batch_id = #{@batch_id} and group_id = #{@group_id} and student_id = #{ st[0].to_i}")
      # logger.debug "EEEEEEEEEEEEEEEEEEEEEEE #{deleted.inspect}"
      # deleted.each do |st|
      # st.update_attributes(:status=> false)
      # end
      # logger.debug "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSS #{deleted.inspect}"
    # end

    # if BatchGrp.find_by_batch_id( @batch_id)
  
    #   @student_deleted = []
    #    @nb_group = BatchGrp.find_by_batch_id( @batch_id).nb_group.to_i
    #   @student_deleted = BatchGrp.find_by_sql("select student_id from batch_grps where batch_id = #{@batch_id} and status = false ")


    
  end

 # render(:update) do |page|
 #                                          page.replace_html 'generate_group', :partial => 'generate_group' ,:batch_id=>@batch_id
 #                             end

     render :js=>"window.location='#{new_batch_grp_path(:id=>@batch_id )}'"
    #  redirect_to :action => "generate_group" , :id=> @batch_id
end



def export_cvs

  @batch_id = params[:batch_id]

  c = 1
  @group = []
  @nb_group = BatchGrp.find_by_batch_id( @batch_id).nb_group.to_i

  while c <= @nb_group 
    @group[c] = BatchGrp.find_by_sql("select * from batch_grps where batch_id = #{@batch_id} and status = true and group_id = #{c}")
    c += 1
  end

  csv_string = FasterCSV.generate(:col_sep=>';') do | csv |

  a = 1
  while a <= @nb_group.to_i
    csv << ["","GROUPE  #{a }"]
    c =1
    @group[a].each do |gb|
      csv << [c, Student.find(gb.student_id).full_name]

      c += 1
    end
      csv << ["_________________ ", " ________________________"]

    a += 1
  end


  end

  filename="all_students"
  send_data Iconv.conv("iso-8859-1//IGNORE", "iso-8859-1", csv_string),
  :type => 'text/csv; charset=iso-8859-1; header=present',
  :disposition => "attachment; filename=#{filename}.csv"
  
end

def export_pdf
   @batch_id = params[:batch_id]

   c = 1
  @group = []
  @nb_group = BatchGrp.find_by_batch_id( @batch_id).nb_group.to_i

  while c <= @nb_group 
    @group[c] = BatchGrp.find_by_sql("select * from batch_grps where batch_id = #{@batch_id} and status = true and group_id = #{c}")
    c += 1
  end

  render :pdf=>"Les_groupes_de_classe"
  
end

  def show_students
  #@batch = Batch.find(params[:id])

  @batch_group = BatchGrp.find(params[:id])
  @batch_grp_students = BatchGrpStudent.find_all_by_batch_grp_id(@batch_group.id)

  @batch_grp_student = BatchGrpStudent.find_by_batch_grp_id(@batch_group.id)
  @stds = []
  @batch_grp_students.each do |b|
    @stds << Student.find(b.student_id)
  end
  @students = Batch.find(@batch_group.batch_id).all_students
  @students = @students - @stds

end

def add_all
  @batch_grp_id=params[:batch_grp_id].to_i
  @students=params[:add_res][:students]
  @students.each do |st|
       @batch_grp_student = BatchGrpStudent.new(:student_id => st.to_i,:batch_grp_id => @batch_grp_id)
       # @language_group_student = LanguageGroupStudent.new(:student_id => st.to_i, :batch_id => params[:show_det][:batch_id].to_i, :language_group_id => @language_group_id)
       @batch_grp_student.save
  end

  redirect_to :controller=>"batch_grps", :action=>"show_students", :id=>@batch_grp_id

end

def destroy_all
  @students=params[:destroy_res][:students]
  @batch_grp_id = params[:batch_grp_id]
  @students.each do |st|
       @batch_grp_student = BatchGrpStudent.find_by_student_id_and_batch_grp_id(st.to_i,@batch_grp_id)
       # @language_group_student = LanguageGroupStudent.new(:student_id => st.to_i, :batch_id => params[:show_det][:batch_id].to_i, :language_group_id => @language_group_id)
       @batch_grp_student.destroy
  end

  redirect_to :controller=>"batch_grps", :action=>"show_students", :id=>@batch_grp_id

end

end