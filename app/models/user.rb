 class User < ApplicationRecord
  has_secure_password
#  validates :email, presence: true, uniqueness: true
#  validates :role, presence: true, on: :create
 enum role: { admin: 0, student: 1, employee: 2 }
# #attr_accessor :role, :admin , :student , :employee


# def before_save
#   logger.debug"SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
#     self.salt = random_string(8) if self.salt == nil
#     self.hashed_password = Digest::SHA1.hexdigest(self.salt + self.password) unless self.password.nil?
#     if self.new_record?
#       self.admin, self.student, self.employee = false, false, false
#       self.admin    = true if self.role == 'Admin'
#       self.student  = true if self.role == 'student'
#       self.employee = true if self.role == 'Employee'
#       self.parent = true if self.role == 'Parent'
#     end
#   end

#   def full_name
#     "#{last_name} #{first_name}"
#   end
#   def role_name
#     return "#{t('admin')}" if self.admin?
#     return "#{t('student_text')}" if self.student?
#     return "#{t('employee_text')}" if self.employee?
#     return "#{t('parent')}" if self.parent?
#     return nil
#   end

#   def role_symbols
#     prv = []
#     @privilge_symbols ||= privileges.map { |privilege| prv << privilege.name.underscore.to_sym }

#     if admin?
#       return [:admin] + prv
#     elsif student?
#       return [:student] + prv
#     elsif employee?
#       employee = employee_record
#       unless employee.nil?
#         if employee.subjects.present?
#           prv << :subject_attendance if Configuration.get_config_value('StudentAttendanceType') == 'SubjectWise'
#           prv << :subject_exam
#         end
#         if Batch.active.collect(&:employee_id).include?(employee.id.to_s)
#           prv << :view_results
#         end
#       end
#       return [:employee] + prv
#     elsif parent?
#       return [:parent] + prv
#     else
#       return prv
#     end
#   end


#  private

#   def user_params
#    params.require(:user).permit(:username, :last_name, :first_name,  :email, :password, :password_confirmation, :role, :admin , :student , :employee)
#   end
 end

