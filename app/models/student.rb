# #IAV
# #Copyright 2011 Cactus IT Technologies Private Limited
# #
# #This product includes software developed at
# #Project IAV - http://www.projectIAV.org/
# #
# #Licensed under the Apache License, Version 2.0 (the "License");
# #you may not use this file except in compliance with the License.
# #You may obtain a copy of the License at
# #
# #  http://www.apache.org/licenses/LICENSE-2.0
# #
# #Unless required by applicable law or agreed to in writing, software
# #distributed under the License is distributed on an "AS IS" BASIS,
# #WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# #See the License for the specific language governing permissions and
# #limitations under the License.

 class Student < ActiveRecord::Base

 has_many :guardians
#   #after_create :create_user_and_validate
#   belongs_to :country
   belongs_to :batch
  belongs_to :student_category
   belongs_to :nationality, class_name:  'Country'
#   belongs_to :user, :dependent => :destroy

#   has_one :immediate_contact
#   has_one :student_previous_data
#   has_many :student_previous_subject_mark
#   has_many :guardians, :foreign_key => 'ward_id', :dependent => :destroy
#   has_many :finance_transactions, :as => :payee
#   has_many :attendances
#   has_many :finance_fees
#   has_many :fee_category, :class_name => "FinanceFeeCategory"
#   has_many :students_subjects
#   has_many :subjects, :through => :students_subjects
#   has_many :student_additional_details
#   has_many :batch_students
#   has_many :subject_leaves
#   has_many :grouped_exam_reports
#   has_many :cce_reports
#   has_many :assessment_scores
#   has_many :exam_scores
#   has_many :previous_exam_scores
#   has_many :rachetages

#  scope :active, -> { where(is_active: true) }
# scope :with_full_name_only, -> { select("id, CONCAT(first_name, ' ', last_name) AS name, first_name, last_name").order(:first_name) }
# scope :with_name_admission_no_only, -> { select("id, CONCAT(first_name, ' ', last_name, ' - ', admission_no) AS name, first_name, last_name, admission_no").order(:first_name) }
# scope :by_first_name, -> { order(:first_name).where(is_active: true) }
# scope :by_last_name, -> { order(:last_name).where(is_active: true) }

# validates :admission_no, :admission_date, :first_name, :last_name, :batch_id, :date_of_birth, presence: true
# validates :admission_no, uniqueness: true
# validates :matricule, uniqueness: true

#   #validates_presence_of :gender
#   #validates_format_of     :email, :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,   :allow_blank=>true:message => "#{t('must_be_a_valid_email_address')}"
# #  validates_format_of :admission_no, :with => /^[A-Z0-9_-]*$/i,
#                     #  :message => "#{t('must_contain_only_letters')}"

#   #validates_associated :user
#  # before_validation :create_user_and_validate


#has_one_attached :photo

#VALID_IMAGE_TYPES = ['image/gif', 'image/png', 'image/jpeg', 'image/jpg']

#validates :photo, presence: true#, content_type: VALID_IMAGE_TYPES,
                   #message: 'Image can only be GIF, PNG, JPG', if: ->(p) { !p.photo_file_name.blank? }

#validates :photo, presence: true#, size: { less_than: 512.kilobytes }
                   #message: 'must be less than 500 KB.', if: ->(p) { p.photo_file_name_changed? }

#   # after_create :create_moodle_user

#   # def create_moodle_user
#   #   self.user.create_moodle_user
#   # end

#   def niveau
#     self.batch.course.course_name
#   end

#   def get_class
#     self.batch.name
#   end

#   def previous_batch
#     bats = []
#     BatchStudent.find_all_by_student_id(self.id).each do |bs|
#       bats << Batch.find(bs.batch_id)
#     end
#     bats = bats.uniq.sort_by { |b| b.get_batch_year }
#     return bats.last
#   end

#   def has_studied_in_batch(batch_id)

#     result = true
#     batchstudents = BatchStudent.find_by_batch_id_and_student_id(batch_id, self.id)
#     if (!batchstudents and self.batch_id != batch_id)
#       result = false
#     end
#     return result
#   end

#   def get_column_name(choice)
#     return self.choice

#   end

#   def validate
#     errors.add(:date_of_birth, "#{t('cant_be_a_future_date')}.") if self.date_of_birth >= Date.today \
#       unless self.date_of_birth.nil?
#     errors.add(:gender, "#{t('model_errors.student.error2')}.") unless ['m', 'f'].include? self.gender.downcase \
#       unless self.gender.nil?
#     errors.add(:admission_no, "#{t('model_errors.student.error3')}.") if self.admission_no == '0'
#     errors.add(:admission_no, "#{t('should_not_be_admin')}") if self.admission_no.to_s.downcase == 'admin'

#   end

#   def get_decision_name(decision)
#     if (decision == 'AdmisAF')
#       return 'Admis(e) avec félicitations'
#     elsif (decision == 'Admis')
#       return 'Admis(e)'
#     elsif (decision == 'AdmisAIM')
#       return 'Admis(e) avec Indulgence Militaire'
#     elsif (decision == 'DiplomeAD')
#       return 'Admis(e) avec dérogation'
#     elsif (decision == 'AdmisAA')
#       return 'Admis(e) avec Avertissement'
#     elsif (decision == 'AnneeReserve')
#       return 'Année de reserve'
#     elsif (decision == 'Ajourne')
#       return 'Ajourné(e)'
#     elsif (decision == 'Exclu')
#       return 'Exclu(e)'
#     elsif (decision == 'Diplome')
#       return 'Diplomé(e)'
#     elsif (decision == 'Ajourne')
#       return 'Ajourné'
#     elsif (decision == 'Reoriente')
#       return 'Réoriente(e)'
#     elsif (decision == 'Redouble')
#       return 'Redouble'

#     elsif (decision == 'AdmisAI')
#       return 'Admis(e) avec Indulgence'
#     elsif (decision == 'AnneeBlanche')
#       return 'Année blanche'
#     elsif (decision == 'AnneeBlanche')
#       return 'Année blanche'
#     elsif (decision == 'coursValid')
#       return 'Cours théoriques validés '
#     elsif (decision == 'Admis sous réserve')
#       return 'Admis sous réserve '
#     elsif (decision == 'Tout')
#       return 'Tout'
#     else
#       return ''

#     end
#   end

#  # def create_user_and_validate
#  #    logger.debug "qqqlool"
#  #    if self.new_record? or 1==1
#  #      user_record = self.build_user
#  #      user_record.first_name = first_name
#  #      user_record.last_name = last_name
#  #      user_record.username = self.matricule.to_s
#  #      user_record.password = self.matricule.to_s + "123"
#  #      user_record.role = 'student'
#  #      user_record.email = self.email.blank? ? "" : self.email.to_s
#  #      logger.debug  user_record.inspect
#  #      #check_user_errors(user_record)
#  #  errors.each{ |e| logger.debug e.to_s+"\n"}
#  #      return false unless errors.blank?
#  #      logger.debug "lool"
#  #    else
#  #      logger.debug "lool11"
#  #      self.user.role = "Student"
#  #      changes_to_be_checked = ['matricule', 'first_name', 'last_name', 'email', 'immediate_contact_id']
#  #      check_changes = self.changed & changes_to_be_checked
#  #      unless check_changes.blank?
#  #        self.user.username = self.matricule if check_changes.include?('matricule')
#  #        self.user.first_name = self.first_name if check_changes.include?('first_name')
#  #        self.user.last_name = self.last_name if check_changes.include?('last_name')
#  #        self.user.email = self.email if check_changes.include?('email')
#  #        check_user_errors(self.user)
#  #      end

#  #      if check_changes.include?('immediate_contact_id') or check_changes.include?('matricule')
#  #        Guardian.shift_user(self)
#  #      end

#  #    end
#  #    self.email = "" if self.email.blank?
#  #    return false unless errors.blank?
#  #  end

#   def check_classement(course1, course2, school_field_id, school_year)
#     @course1 = course1
#     @course2 = course2
#     @school_field_id = school_field_id
#     @school_year = school_year

#     @studentss = []
#     @school_field_id = self.batch.school_field_id
#     @school_year = self.batch.get_batch_year

#     @batchs1 = Batch.find(:all, :conditions => "course_id = #{@course1.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }
#     @batchs2 = Batch.find(:all, :conditions => "course_id = #{@course2.to_s} and school_field_id = #{@school_field_id.to_s} and (year(start_date)= #{@school_year.to_s} or (year(start_date)=#{(@school_year.to_i + 1).to_s} and month(start_date) < 8))").reject { |x| x.get_batch_year != @school_year.to_i }

#     @batchs1.each do |bt|
#       @studentss += Student.find(:all, :conditions => { :batch_id => bt.id })
#       @studentss += bt.old_students #batch_string+=batch.id.to_s+','
#     end

#     @batchs2.each do |bt|
#       @studentss += Student.find(:all, :conditions => { :batch_id => bt.id })
#       @studentss += bt.old_students #batch_string+=batch.id.to_s+','
#     end
#     @studentss = @studentss.uniq { |x| x.id }
#     @btss = @batchs1 + @batchs2

#     ranges = []
#     @student_orders = []
#     @studentss.each do |sto|
#       #          @student_orders[sto.id] = sto.check_student_result3(@btss,@school_year,4)['average_of_year_session_normale']
#       @student_orders[sto.id] = SchoolModule.modules_max_data(@btss, sto.id, @school_year)['average_of_year_session_normale']

#       if @student_orders[sto.id].nil?
#         @student_orders[sto.id] = 0
#       end
#       ranges << { :st_id => sto.id, :note => @student_orders[sto.id] }
#     end
#     ranges = ranges.sort_by { |sso| sso[:note] }.reverse
#     @range = ranges.index(ranges.select { |po| po[:st_id].to_i == self.id.to_i }.first).to_i + 1
#     return @range

#   end

#   def check_user_errors(user)
#   unless user.validate
#     user.errors.each { |attr, msg| errors.add(attr, msg) }
#   end
#   return false unless user.errors.empty?
# end


#   def first_and_last_name
#     "#{first_name} #{last_name}"
#   end

   def full_name
     "#{last_name} #{middle_name} #{first_name}"
   end

   def gender_as_text
     return 'Male' if gender.downcase == 'm'
     return 'Female' if gender.downcase == 'f'
     nil
   end

#   def graduated_batches
#     self.batch_students.map { |bt| bt.batch }
#   end

#   def all_batches
#     self.graduated_batches + self.batch.to_a
#   end

#   def last_batch
#     self.graduated_batches - self.batch.to_a
#   end

#   def immediate_contact
#     Guardian.find(self.immediate_contact_id) unless self.immediate_contact_id.nil?
#   end

def image_file=(input_data)
    return if input_data.blank?
       self.photo_filename = input_data.original_filename
     self.photo_content_type = input_data.content_type.chomp
     self.photo_data = input_data.read
   end

#   def next_student
#     next_st = self.batch.students.first(:conditions => "id > #{self.id}", :order => "id ASC")
#     next_st ||= batch.students.first(:order => "id ASC")
#   end

#   def previous_student
#     prev_st = self.batch.students.first(:conditions => "id < #{self.id}", :order => "admission_no DESC")
#     prev_st ||= batch.students.first(:order => "id DESC")
#     prev_st ||= self.batch.students.first(:order => "id DESC")
#   end

#   def previous_fee_student(date)
#     fee = FinanceFee.first(:conditions => "student_id < #{self.id} and fee_collection_id = #{date}", :joins => 'INNER JOIN students ON finance_fees.student_id = students.id', :order => "student_id DESC")
#     prev_st = fee.student unless fee.blank?
#     fee ||= FinanceFee.first(:conditions => "fee_collection_id = #{date}", :joins => 'INNER JOIN students ON finance_fees.student_id = students.id', :order => "student_id DESC")
#     prev_st ||= fee.student unless fee.blank?
#     #    prev_st ||= self.batch.students.first(:order => "id DESC")
#   end

#   def next_fee_student(date)

#     fee = FinanceFee.first(:conditions => "student_id > #{self.id} and fee_collection_id = #{date}", :joins => 'INNER JOIN students ON finance_fees.student_id = students.id', :order => "student_id ASC")
#     next_st = fee.student unless fee.nil?
#     fee ||= FinanceFee.first(:conditions => "fee_collection_id = #{date}", :joins => 'INNER JOIN students ON finance_fees.student_id = students.id', :order => "student_id ASC")
#     next_st ||= fee.student unless fee.nil?
#     #    prev_st ||= self.batch.students.first(:order => "id DESC")
#   end

#   def finance_fee_by_date(date)
#     FinanceFee.find_by_fee_collection_id_and_student_id(date.id, self.id)
#   end

#   def check_fees_paid(date)
#     particulars = date.fees_particulars(self)
#     total_fees = 0
#     financefee = date.fee_transactions(self.id)
#     batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(date.id)
#     student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(date.id, self.id)
#     category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(date.id, self.student_category_id)
#     total_discount = 0
#     total_discount += batch_discounts.map { |s| s.discount }.sum unless batch_discounts.nil?
#     total_discount += student_discounts.map { |s| s.discount }.sum unless student_discounts.nil?
#     total_discount += category_discounts.map { |s| s.discount }.sum unless category_discounts.nil?
#     if total_discount > 100
#       total_discount = 100
#     end
#     particulars.map { |s| total_fees += s.amount.to_f }
#     total_fees -= total_fees * (total_discount / 100)
#     paid_fees_transactions = FinanceTransaction.find(:all, :select => 'amount,fine_amount', :conditions => "FIND_IN_SET(id,\"#{financefee.transaction_id}\")") unless financefee.nil?
#     paid_fees = 0
#     paid_fees_transactions.map { |m| paid_fees += (m.amount.to_f - m.fine_amount.to_f) } unless paid_fees_transactions.nil?
#     amount_pending = total_fees.to_f - paid_fees.to_f
#     if amount_pending == 0
#       return true
#     else
#       return false
#     end

#     #    unless particulars.nil?
#     #      return financefee.check_transaction_done unless financefee.nil?
#     #
#     #    else
#     #      return false
#     #    end
#   end

#   def has_retaken_exam(subject_id)
#     retaken_exams = PreviousExamScore.find_all_by_student_id(self.id)
#     if retaken_exams.empty?
#       return false
#     else
#       exams = Exam.find_all_by_id(retaken_exams.collect(&:exam_id))
#       if exams.collect(&:subject_id).include?(subject_id)
#         return true
#       end
#       return false
#     end

#   end

#   def check_fee_pay(date)
#     date.finance_fees.first(:conditions => "student_id = #{self.id}").is_paid
#   end

#   def self.next_admission_no
#     '' #stub for logic to be added later.
#   end

#   def get_fee_strucure_elements(date)
#     elements = FinanceFeeStructureElement.get_student_fee_components(self, date)
#     elements[:all] + elements[:by_batch] + elements[:by_category] + elements[:by_batch_and_category]
#   end

#   def total_fees(particulars)
#     total = 0
#     particulars.each do |fee|
#       total += fee.amount
#     end
#     total
#   end

#   def has_associated_fee_particular?(fee_category)
#     status = false
#     status = true if fee_category.fee_particulars.find_all_by_admission_no(admission_no).count > 0
#     status = true if student_category_id.present? and fee_category.fee_particulars.find_all_by_student_category_id(student_category_id).count > 0
#     return status
#   end

#   def archive_student(status)
#     self.update_attributes(:is_active => false, :status_description => status)
#     student_attributes = self.attributes
#     student_attributes["former_id"] = self.id
#     # student_attributes.delete "id"
#     # student_attributes.delete "has_paid_fees"
#     # student_attributes.delete "user_id"
#     # student_attributes.delete "created_at"
#     # student_attributes.delete "type_ens"
#     # student_attributes.delete "group_td"
#     logger.debug "stooooop here"
#     logger.debug "stooooop here"
#     logger.debug "stooooop here"
#     archived_student = ArchivedStudent.create(student_attributes)
 #    archived_student.photo = self.photo
#     if archived_student.save
#       guardian = self.guardians
#       self.user.destroy unless self.user.blank?
#       self.destroy
#       guardian.each do |g|
#         g.archive_guardian(archived_student.id)
#       end

#       #
#       #      student_exam_scores = ExamScore.find_all_by_student_id(self.id)
#       #      student_exam_scores.each do |s|
#       #        exam_score_attributes = s.attributes
#       #        exam_score_attributes.delete "id"
#       #        exam_score_attributes.delete "student_id"
#       #        exam_score_attributes["student_id"]= archived_student.id
#       #        ArchivedExamScore.create(exam_score_attributes)
#       #        s.destroy
#       #      end
#       #
#     end

#   end

#   def check_dependency
#     return true if self.finance_transactions.present? or self.graduated_batches.present? or self.attendances.present? or self.finance_fees.present?
#     return true if FedenaPlugin.check_dependency(self, "permanant").present?
#     return true if !RestoReservation.find_all_by_student_id(self.id).empty?
#     return true if !RestoTicket.find_all_by_student_id(self.id).empty?
#     return true if !RestoRefill.find_all_by_student_id(self.id).empty?
#     return false
#   end

#   def former_dependency
#     plugin_dependencies = FedenaPlugin.check_dependency(self, "former")
#   end

#   def assessment_score_for(indicator_id, exam_id, batch_id)
#     assessment_score = self.assessment_scores.find(:first, :conditions => { :student_id => self.id, :descriptive_indicator_id => indicator_id, :exam_id => exam_id, :batch_id => batch_id })
#     assessment_score.nil? ? assessment_scores.build(:descriptive_indicator_id => indicator_id, :exam_id => exam_id, :batch_id => batch_id) : assessment_score
#   end

#   def observation_score_for(indicator_id, batch_id)
#     assessment_score = self.assessment_scores.find(:first, :conditions => { :student_id => self.id, :descriptive_indicator_id => indicator_id, :batch_id => batch_id })
#     assessment_score.nil? ? assessment_scores.build(:descriptive_indicator_id => indicator_id, :batch_id => batch_id) : assessment_score
#   end

#   def has_higher_priority_ranking_level(ranking_level_id, type, subject_id)
#     ranking_level = RankingLevel.find(ranking_level_id)
#     higher_levels = RankingLevel.find(:all, :conditions => ["course_id = ? AND priority < ?", ranking_level.course_id, ranking_level.priority])
#     if higher_levels.empty?
#       return false
#     else
#       higher_levels.each do |level|
#         if type == "subject"
#           score = GroupedExamReport.find_by_student_id_and_subject_id_and_batch_id_and_score_type(self.id, subject_id, self.batch_id, "s")
#           unless score.nil?
#             if self.batch.gpa_enabled?
#               return true if ((score.marks < level.gpa if level.marks_limit_type == "upper") or (score.marks >= level.gpa if level.marks_limit_type == "lower") or (score.marks == level.gpa if level.marks_limit_type == "exact"))
#             else
#               return true if ((score.marks < level.marks if level.marks_limit_type == "upper") or (score.marks >= level.marks if level.marks_limit_type == "lower") or (score.marks == level.marks if level.marks_limit_type == "exact"))
#             end
#           end
#         elsif type == "overall"
#           unless level.subject_count.nil?
#             unless level.full_course == true
#               subjects = self.batch.subjects
#               scores = GroupedExamReport.find(:all, :conditions => { :student_id => self.id, :batch_id => self.batch.id, :subject_id => subjects.collect(&:id), :score_type => "s" })
#             else
#               scores = GroupedExamReport.find(:all, :conditions => { :student_id => self.id, :score_type => "s" })
#             end
#             unless scores.empty?
#               if self.batch.gpa_enabled?
#                 scores.reject! { |s| !((s.marks < level.gpa if level.marks_limit_type == "upper") or (s.marks >= level.gpa if level.marks_limit_type == "lower") or (s.marks == level.gpa if level.marks_limit_type == "exact")) }
#               else
#                 scores.reject! { |s| !((s.marks < level.marks if level.marks_limit_type == "upper") or (s.marks >= level.marks if level.marks_limit_type == "lower") or (s.marks == level.marks if level.marks_limit_type == "exact")) }
#               end
#               unless scores.empty?
#                 sub_count = level.subject_count
#                 if level.subject_limit_type == "upper"
#                   return true if scores.count < sub_count
#                 elsif level.subject_limit_type == "exact"
#                   return true if scores.count == sub_count
#                 else
#                   return true if scores.count >= sub_count
#                 end
#               end
#             end
#           else
#             unless level.full_course == true
#               score = GroupedExamReport.find_by_student_id(self.id, :conditions => { :batch_id => self.batch.id, :score_type => "c" })
#             else
#               total_student_score = 0
#               avg_student_score = 0
#               marks = GroupedExamReport.find_all_by_student_id_and_score_type(self.id, "c")
#               unless marks.empty?
#                 marks.map { |m| total_student_score += m.marks }
#                 avg_student_score = total_student_score.to_f / marks.count.to_f
#                 marks.first.marks = avg_student_score
#                 score = marks.first
#               end
#             end
#             unless score.nil?
#               if self.batch.gpa_enabled?
#                 return true if ((score.marks < level.gpa if level.marks_limit_type == "upper") or (score.marks >= level.gpa if level.marks_limit_type == "lower") or (score.marks == level.gpa if level.marks_limit_type == "exact"))
#               else
#                 return true if ((score.marks < level.marks if level.marks_limit_type == "upper") or (score.marks >= level.marks if level.marks_limit_type == "lower") or (score.marks == level.marks if level.marks_limit_type == "exact"))
#               end
#             end
#           end
#         elsif type == "course"
#           unless level.subject_count.nil?
#             scores = GroupedExamReport.find(:all, :conditions => { :student_id => self.id, :score_type => "s" })
#             unless scores.empty?
#               if level.marks_limit_type == "upper"
#                 scores.reject! { |s| !(((s.marks < level.gpa unless level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks < level.marks unless level.marks.nil?)) }
#               elsif level.marks_limit_type == "exact"
#                 scores.reject! { |s| !(((s.marks == level.gpa unless level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks == level.marks unless level.marks.nil?)) }
#               else
#                 scores.reject! { |s| !(((s.marks >= level.gpa unless level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks >= level.marks unless level.marks.nil?)) }
#               end
#               unless scores.empty?
#                 sub_count = level.subject_count
#                 unless level.full_course == true
#                   batch_ids = scores.collect(&:batch_id)
#                   batch_ids.each do |batch_id|
#                     unless batch_ids.empty?
#                       count = batch_ids.count(batch_id)
#                       if level.subject_limit_type == "upper"
#                         return true if count < sub_count
#                       elsif level.subject_limit_type == "exact"
#                         return true if count == sub_count
#                       else
#                         return true if count >= sub_count
#                       end
#                       batch_ids.delete(batch_id)
#                     end
#                   end
#                 else
#                   if level.subject_limit_type == "upper"
#                     return true if scores.count < sub_count
#                   elsif level.subject_limit_type == "exact"
#                     return true if scores.count == sub_count
#                   else
#                     return true if scores.count >= sub_count
#                   end
#                 end
#               end
#             end
#           else
#             unless level.full_course == true
#               scores = GroupedExamReport.find(:all, :conditions => { :student_id => self.id, :score_type => "c" })
#               unless scores.empty?
#                 if level.marks_limit_type == "upper"
#                   scores.reject! { |s| !(((s.marks < level.gpa unless level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks < level.marks unless level.marks.nil?)) }
#                 elsif level.marks_limit_type == "exact"
#                   scores.reject! { |s| !(((s.marks == level.gpa unless level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks == level.marks unless level.marks.nil?)) }
#                 else
#                   scores.reject! { |s| !(((s.marks >= level.gpa unless level.gpa.nil?) if s.student.batch.gpa_enabled?) or (s.marks >= level.marks unless level.marks.nil?)) }
#                 end
#                 return true unless scores.empty?
#               end
#             else
#               total_student_score = 0
#               avg_student_score = 0
#               marks = GroupedExamReport.find_all_by_student_id_and_score_type(self.id, "c")
#               unless marks.empty?
#                 marks.map { |m| total_student_score += m.marks }
#                 avg_student_score = total_student_score.to_f / marks.count.to_f
#                 if level.marks_limit_type == "upper"
#                   return true if (((avg_student_score < level.gpa unless level.gpa.nil?) if self.batch.gpa_enabled?) or (avg_student_score < level.marks unless level.marks.nil?))
#                 elsif level.marks_limit_type == "exact"
#                   return true if (((avg_student_score == level.gpa unless level.gpa.nil?) if self.batch.gpa_enabled?) or (avg_student_score == level.marks unless level.marks.nil?))
#                 else
#                   return true if (((avg_student_score >= level.gpa unless level.gpa.nil?) if self.batch.gpa_enabled?) or (avg_student_score >= level.marks unless level.marks.nil?))
#                 end
#               end
#             end
#           end
#         end
#       end
#     end
#     return false
#   end

#   def check_student_result3(batchs, school_year, rule_number)
#     sf_sm = []
#     all_st = []
#     batchs.each do |bat|
#       #sf_sm += SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => bat.course_id, :school_year => school_year, :school_field_id => bat.school_field_id})
#       sf_sm += SchoolFieldSchoolModule.find_by_sql("select * from school_field_school_modules where course_id = #{bat.course_id} and school_year = #{school_year} and school_field_id = #{bat.school_field_id} ")

#     end

#     result_student = {}
#     result_student["average_of_year_session_normale"] = SchoolModule.average_of_year_session_normale(batchs, self.id, school_year)

#     return result_student
#   end

#   def check_student_result(batchs, school_year, rule_number)
#     result_student = {}
#     result_student["nvalid_number"] = SchoolModule.non_validate_modules(batchs, self.id, school_year)
#     result_student["valid_number"] = SchoolModule.validate_modules(batchs, self.id, school_year)
#     result_student["var_number"] = SchoolModule.validate_modules_after_pass(batchs, self.id, school_year)
#     result_student["elminatory_number"] = SchoolModule.eliminatoire_modules(batchs, self.id, school_year)
#     result_student["elminatory_number_spec"] = SchoolModule.eliminatoire_modules_spec(batchs, self.id, school_year)
#     result_student["average_of_year"] = SchoolModule.average_of_year(batchs, self.id, school_year)
#     result_student["average_of_year_session_normale"] = SchoolModule.average_of_year_session_normale(batchs, self.id, school_year)
#     result_student["average_of_spec_module"] = SchoolModule.average_spec_modules(batchs, self.id, school_year)
#     result_student["average_of_non_spec_module"] = SchoolModule.average_non_spec_modules(batchs, self.id, school_year)
#     result_student["found_spec_module"] = SchoolModule.found_sepc_modules(batchs, self.id, school_year)
#     if result_student["average_of_year"] >= 10
#       result_student["decision"] = 'Admis'
#     else
#       result_student["decision"] = 'En Cours'
#     end
#     return result_student
#   end

#   def check_student_result2(batchs, school_year, rule_number)

#     sf_sm = []
#     all_st = []
#     batchs.each do |bat|
#       #sf_sm += SchoolFieldSchoolModule.find(:all, :conditions => {:course_id => bat.course_id, :school_year => school_year, :school_field_id => bat.school_field_id})
#       sf_sm += SchoolFieldSchoolModule.find_by_sql("select * from school_field_school_modules where course_id = #{bat.course_id} and school_year = #{school_year} and school_field_id = #{bat.school_field_id} ")

#     end
#     #all_st.sort {|x,y| y}
#     result_student = {}
#     result_student["nvalid_number"] = SchoolModule.non_validate_modules(batchs, self.id, school_year)
#     result_student["valid_number"] = SchoolModule.validate_modules(batchs, self.id, school_year)
#     result_student["var_number"] = SchoolModule.validate_modules_after_pass(batchs, self.id, school_year)
#     result_student["elminatory_number"] = SchoolModule.eliminatoire_modules(batchs, self.id, school_year)
#     result_student["elminatory_number_spec"] = SchoolModule.eliminatoire_modules_spec(batchs, self.id, school_year)
#     result_student["average_of_year"] = SchoolModule.average_of_year(batchs, self.id, school_year)
#     result_student["average_of_year_session_normale"] = SchoolModule.average_of_year_session_normale(batchs, self.id, school_year)
#     result_student["average_of_spec_module"] = SchoolModule.average_spec_modules(batchs, self.id, school_year)
#     result_student["average_of_non_spec_module"] = SchoolModule.average_non_spec_modules(batchs, self.id, school_year)
#     result_student["found_spec_module"] = SchoolModule.found_sepc_modules(batchs, self.id, school_year)

#     # result_student["range"]=all_st[self.id]
#     ranges = []

#     @students = []
#     batchs.each do |bt|
#       @students += Student.find(:all, :conditions => { :batch_id => bt.id })
#       @students += bt.old_students #batch_string+=batch.id.to_s+','
#     end

#     @students = @students.uniq { |x| x.id }
#     @student_orders = []
#     @students.each do |sto|

#       @student_orders[sto.id] = SchoolModule.average_of_year(batchs, sto.id, school_year)
#       if @student_orders[sto.id].nil?
#         @student_orders[sto.id] = 0
#       end
#       ranges << { :st_id => sto.id, :note => @student_orders[sto.id] }
#     end
#     ranges = ranges.sort_by { |sso| sso[:note] }.reverse
#     @range = ranges.index(ranges.select { |po| po[:st_id].to_i == self.id.to_i }.first).to_i + 1
#     result_student["range"] = @range
#     logger.debug "lhoooooooooooola"
#     logger.debug result_student["range"]
#     #exit
#     if result_student["average_of_year"] >= 10
#       result_student["decision"] = 'Admis'
#     else
#       result_student["decision"] = 'En Cours'
#     end
#     return result_student
#   end

#   def check_student_range(batchs, school_year)

#     st_list = BatchStudent.find(:all, :conditions => { :batch_id => batchs.id })

#     logger.debug "start-----------"
#     logger.debug "start-----------"
#     logger.debug "start-----------"
#     stu_list = []
#     # st_list.each do |s|
#     #   stu_list[s.student_id] = Student.find(s.student_id).check_student_result()
#     # end

#   end

#   #  benyissa
#   def check_student_result_h(batchs, school_year, infos_modules)
#     modules_max_data = SchoolModule.modules_max_data_opt3(batchs, self.id, school_year, infos_modules)
#     result_student = {}
#     result_student["nvalid_number"] = modules_max_data['number_non_validate_modules']
#     result_student["valid_number"] = modules_max_data['number_validate_modules']
#     result_student["number_validate_modules_after_pass"] = modules_max_data['number_validate_modules_after_pass']
#     result_student["elminatory_number"] = modules_max_data['eliminatoire_modules']
#     result_student["elminatory_number_spec"] = modules_max_data['eliminatoire_modules_spec']
#     result_student["average_of_year"] = modules_max_data['average_of_year']
#     result_student["average_of_year_session_normale"] = modules_max_data['average_of_year_session_normale']
#     result_student["average_of_spec_module"] = modules_max_data['average_spec_modules']
#     result_student["average_of_non_spec_module"] = modules_max_data['average_non_spec_modules']
#     result_student["found_spec_module"] = 0
#     if result_student["average_of_year"] >= 10
#       result_student["decision"] = 'Admis'
#     else
#       result_student["decision"] = 'En Cours'
#     end
#     return result_student
#   end

 end
