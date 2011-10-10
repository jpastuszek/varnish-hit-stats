class StatCounter < Hash
	def up(stat)
		value = self[stat]
		value ||= 0
		value += 1
		self[stat] = value
	end

	def method_missing(name, *args)
		super(name, *args) unless args.empty?
		case name.to_s
		when /^(.*?)_to_(.*?)_ratio$/
			send($1.to_sym).to_f / send($2.to_sym)
		when 'total'
			values.inject(0){|sum, value| sum + value}
		else
			self[name] or 0
		end
	end
end
