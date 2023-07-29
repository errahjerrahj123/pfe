class GrpBatchesController < ApplicationController
  layout "main"

	def new 
		@course = Course.find(params[:course_id])
		@grp_batch = GrpBatch.new
		@grp_batches = GrpBatch.where(course_id: params[:course_id])


    end 

    def create
    	 @grp_batch = GrpBatch.new(grp_batch_params)
  @grp_batches = GrpBatch.find_by_course_id(grp_batch_params[:course_id])

      if @grp_batch.save
        redirect_to new_grp_batch_path(course_id: params[:grp_batch][:course_id])

        #render :js=>"window.location='#{new_grp_batch_path(:course_id=>params[:grp_batch][:course_id])}'"
       #redirect_to controller: "grp_batches", action: "new", id: grp_batch_params[:course_id]

      end
    end  

    def index
    end	

    def show_batches
    	 @grp_batch = GrpBatch.find(params[:id])
    	  @grp_batch_batches = GrpBatchBatch.find_all_by_grp_batch_id(@grp_batch.id)
           
          @grp_batch_batch = GrpBatchBatch.find_by_grp_batch_id(@grp_batch.id)
           @bts = []
           @grp_batch_batches.each do |b|
           	@bts << Batch.find(b.batch_id)
           end
           @batches = Batch.find_all_by_course_id(@grp_batch.course_id).select{|e| e.get_batch_year == 2021}
           @batches = @batches - @bts
    	    

    end 
   

    def add_all
        @grp_batch_id = params[:grp_batch_id].to_i
    	#@batch_grp_id=params[:batch_grp_id].to_i
       @batches=params[:add_res][:batches]
      @batches.each do |b|
      	logger.debug "******************************************************************************************"
      	logger.debug @grp_batch_id.to_i
      	logger.debug b.to_i
      	logger.debug "******************************************************************************************"
      	@grp_batch_batch = GrpBatchBatch.new(:grp_batch_id => @grp_batch_id.to_i , :batch_id => b.to_i )
        @grp_batch_batch.save
      
    end

     redirect_to :controller=>"grp_batches", :action=>"show_batches", :id=>@grp_batch_id.to_i
    end	

   def destroy_all
  @batches = params[:destroy_res][:batches]
  @grp_batch_id = params[:grp_batch_id]
  @batches.each do |b|
    logger.debug "***************************************555555555555555555***************************************************"
    logger.debug @grp_batch_id.to_i
    logger.debug b.to_i
    logger.debug "************************************5555555555555555555******************************************************"
    @grp_batch_batch = GrpBatchBatch.find_by(grp_batch_id: @grp_batch_id, batch_id: b.to_i)
    @grp_batch_batch.destroy
  end

  redirect_to grp_batches_show_batches_url(id: @grp_batch_id.to_i)
end

def destroy
  if params[:id].present?
    @grp_batch = GrpBatch.find(params[:id])
    @grp_batch.destroy
    #redirect_to grp_batches_path, notice: 'Batch deleted successfully.'
   #redirect_to contoller: "grp_batches" , action: "new" , id: @grp_batch.id
   redirect_to new_grp_batch_path(course_id: @grp_batch.course_id)
  else
    # Handle the case where params[:id] is nil
    redirect_to new , alert: 'Invalid request.'
  end
end




private

def grp_batch_params
  params.require(:grp_batch).permit(:name, :course_id)
end
end

