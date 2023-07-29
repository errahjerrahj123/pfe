class SchoolField < ActiveRecord::Base
    belongs_to :employee,
	            :class_name => "Employee",
                :foreign_key => "employee_id"				
	has_many :school_modules, :through => :school_field_school_modules
	has_many :school_field_school_modules
	
	
	
	
       
end
