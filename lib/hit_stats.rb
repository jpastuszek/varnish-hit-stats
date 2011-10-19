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

		total = Hash.new(0)
		h.each_pair do |page_class, s|
			s.each_pair do |k, v|
				total[k] += v
			end
		end

		h['total'] = total
		total[:hit_to_total_ratio] = total[:hit].to_f / total[:total]
		h
	end
end

