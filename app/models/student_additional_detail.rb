#EMI
#Copyright 2011 Cactus IT Technologies Private Limited
#
#This product includes software developed at
#Project EMI - http://www.projectEMI.org/
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

class StudentAdditionalDetail < ActiveRecord::Base
  belongs_to :student
  belongs_to :student_additional_field, :foreign_key=>'additional_field_id'
end
