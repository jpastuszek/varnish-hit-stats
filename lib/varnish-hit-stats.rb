require 'universal-access-log-parser'

class VarnishHitStats
	class Stat
		def initialize
			@pass = 0
			@hit = 0
			@miss = 0
		end

		def pass
			@pass += 1
		end

		def hit
			@hit += 1
		end

		def miss
			@miss += 1
		end

		def get
			total = @pass + @hit + @miss
			hit_total_rate = @hit.to_f / total
			Struct.new(
				:pass, :hit, :miss, :total, :hit_total_rate
			).new(
				@pass, @hit, @miss, total, hit_total_rate
			)
		end
	end

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
				@stats[entry.initial_status] ||= Stat.new
				@stats[entry.initial_status].send(entry.handling)
			end
		end
	end

	def each
		@stats.keys.sort.each do |page_class|
			yield page_class, @stats[page_class].get
		end
	end
end

