class StatCounter
	def initialize
		@stats = {}
	end

	def up(stat)
		value = @stats[stat]
		value ||= 0
		value += 1
		@stats[stat] = value
	end

	def method_missing(name, *args)
		super(name, *args) unless args.empty?
		case name.to_s
		when /^([^_]*)_([^_]*)_ratio$/
			send($1.to_sym).to_f / send($2.to_sym)
		when 'total'
			@stats.values.inject(0){|sum, value| sum + value}
		else
			@stats[name] or 0
		end
	end
end
