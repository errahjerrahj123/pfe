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

class ExamScoresController < ApplicationController
  before_filter :login_required
  in_place_edit_for :exam_score, :score
  before_filter :protect_other_student_data
  def update
      @exam_score=ExamScore.find(params[:exam_score_id])
	  test=params[:test]
	  new_mark=params[:new_mark]
	  subject_id=Exam.find(@exam_score.exam_id).subject_id
	  render(:update) do |page|
	  if(test==0)
	  page.replace_html "mark_#{subject_id}", :partial => "mark_change"
	  else 
	  page.replace_html "markar_#{subject_id}", :partial => "markar_change"
	  end
	  end
  end
end