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
	end

	def process(line)
		x, handling, current_status, initial_status, hits, ttl, age = *line.match(/([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*)$/)
		handling = handling.to_sym
		#puts handling, current_status, initial_status
		@stats[initial_status] ||= Stat.new
		@stats[initial_status].send(handling)
	end

	def each
		@stats.keys.sort.each do |page_class|
			yield page_class, @stats[page_class].get
		end
	end
end

