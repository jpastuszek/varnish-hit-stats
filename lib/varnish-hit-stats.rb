require 'universal-access-log-parser'
require 'stat_counter'

class VarnishHitStats
	def initialize(file)
		@stats = {}
		@parser = UniversalAccessLogParser.new do
			apache_combined
			string :handling, :process => lambda{|s| s.to_sym}
			string :current_status, :nil_on => '-'
			string :initial_status, :nil_on => '-'
			integer :cache_hits
			float :cache_ttl, :nil_on => '-'
			integer :cache_age
		end

		@parser.parse_file(file) do |iter|
			iter.each do |entry|
				@stats[entry.initial_status] ||= StatCounter.new
				@stats[entry.initial_status].up(entry.handling)
			end
		end
	end

	def each
		@stats.keys.sort.each do |page_class|
			yield page_class, @stats[page_class]
		end
	end
end

