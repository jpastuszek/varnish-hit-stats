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

	def initialize
		@stats = {}
		@parser = UniversalAccessLogParser.new do
			apache_combined
			string :handling
			string :current_status, :nil_on => '-'
			string :initial_status, :nil_on => '-'
			integer :cache_hits
			float :cache_ttl, :nil_on => '-'
			integer :cache_age
		end
	end

	def process(line)
		line.strip!
		data = @parser.parse(line)

		handling = data.handling.to_sym
		#puts handling, current_status, initial_status
		@stats[data.initial_status] ||= Stat.new
		@stats[data.initial_status].send(data.handling)
	end

	def each
		@stats.keys.sort.each do |page_class|
			yield page_class, @stats[page_class].get
		end
	end
end

