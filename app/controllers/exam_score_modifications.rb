class ExamScoreModificationsController < ApplicationController
  # GET /exam_score_modifications
  # GET /exam_score_modifications.xml
  def index
    @exam_score_modifications = ExamScoreModification.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @exam_score_modifications }
    end
  end

  # GET /exam_score_modifications/1
  # GET /exam_score_modifications/1.xml
  def show
    @exam_score_modification = ExamScoreModification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @exam_score_modification }
    end
  end

  # GET /exam_score_modifications/new
  # GET /exam_score_modifications/new.xml
  def new
    @exam_score_modification = ExamScoreModification.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @exam_score_modification }
    end
  end

  # GET /exam_score_modifications/1/edit
  def edit
    @exam_score_modification = ExamScoreModification.find(params[:id])
  end

  # POST /exam_score_modifications
  # POST /exam_score_modifications.xml
  def create
    @exam_score_modification = ExamScoreModification.new(params[:exam_score_modification])

    respond_to do |format|
      if @exam_score_modification.save
        flash[:notice] = 'ExamScoreModification was successfully created.'
        format.html { redirect_to(@exam_score_modification) }
        format.xml  { render :xml => @exam_score_modification, :status => :created, :location => @exam_score_modification }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @exam_score_modification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /exam_score_modifications/1
  # PUT /exam_score_modifications/1.xml
  def update
    @exam_score_modification = ExamScoreModification.find(params[:id])

    respond_to do |format|
      if @exam_score_modification.update_attributes(params[:exam_score_modification])
        flash[:notice] = 'ExamScoreModification was successfully updated.'
        format.html { redirect_to(@exam_score_modification) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @exam_score_modification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /exam_score_modifications/1
  # DELETE /exam_score_modifications/1.xml
  def destroy
    @exam_score_modification = ExamScoreModification.find(params[:id])
    @exam_score_modification.destroy

    respond_to do |format|
      format.html { redirect_to(exam_score_modifications_url) }
      format.xml  { head :ok }
    end
  end


  # GET /exam_score_modifications/1
  # GET /exam_score_modifications/1.xml
  def show_by_exam_score

    @exam_score_modifications = ExamScoreModification.find(:all, :conditions => {:exam_scores_id => params[:id]} )

  end
end
