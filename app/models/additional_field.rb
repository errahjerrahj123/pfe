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

class AdditionalField < ApplicationRecord
  validates :name, presence: true
  validates :name, format: { with: /\A[a-zA-Z0-9 ]+\z/, message: "#{t('must_contain_only_letters_numbers_space')}" }
end

