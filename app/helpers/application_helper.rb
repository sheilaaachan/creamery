module ApplicationHelper
	def get_assignment_options
		Assignment.current.by_employee.all.map{|a| ["#{a.employee.name} @ #{a.store.name}", a.id]}
	end

end