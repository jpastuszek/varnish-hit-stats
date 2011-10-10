require 'universal-access-log-parser'
require 'stat_counter'

class HitStats
	def initialize
		@stats = {}
	end

	def process(entry)
		page_class = (entry.initial_status or entry.current_status or 'unset')
		@stats[page_class] ||= StatCounter.new
		@stats[page_class].up(entry.handling)
	end

	def each_page_class_stat
		@stats.keys.sort.each do |page_class|
			yield page_class, @stats[page_class]
		end
	end

	def to_hash
		h = {}

		@stats.each_pair do |page_class, s|
			pc = h[page_class] ||= {:pass => 0, :hit => 0, :miss => 0}
			pc.merge! s
			pc[:total] = s.total
			pc[:hit_to_total_ratio] = s.hit_to_total_ratio
		end

		total = h['total'] = Hash.new(0)
		h.each_pair do |page_class, s|
			s.each_pair do |k, v|
				total[k] += v
			end
		end

		total[:hit_to_total_ratio] = total[:hit].to_f / total[:total]
		h
	end

	def to_csv
		out = ""
		out += "class, pass, hit, miss, total, hit/total\n"
		each_page_class_stat do |page_class, s|
			out += "%s, %i, %i, %i, %i, %f\n" % [page_class, s.pass, s.hit, s.miss, s.total, s.hit_to_total_ratio]
		end
		out
	end
end

