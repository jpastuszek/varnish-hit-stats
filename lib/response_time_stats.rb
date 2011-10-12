class ResponseTimeStats
	def initialize
		@stats = {}
	end

	def process(entry)
		page_class = (entry.initial_status or entry.current_status or 'unset')
		s = @stats[page_class] ||= {:total_time => 0.0, :total_requests => 0, :max_time => 0.0, :min_time => Float::MAX}

		s[:total_time] += entry.response_time
		s[:total_requests] += 1
		s[:min_time] = entry.response_time if s[:min_time] > entry.response_time
		s[:max_time] = entry.response_time if s[:max_time] < entry.response_time
	end

	def to_hash
		@stats.each_pair do |pc, h|
			h[:average_time] = h[:total_time] / h[:total_requests]
		end

		t = @stats['total'] = {:total_time => 0.0, :total_requests => 0, :max_time => 0.0, :min_time => Float::MAX}

		@stats.each_pair do |pc, h|
			t[:total_time] += h[:total_time]
			t[:total_requests] += h[:total_requests]
			t[:average_time] = h[:total_time] / h[:total_requests]
			t[:min_time] = h[:min_time] if t[:min_time] > h[:min_time]
			t[:max_time] = h[:max_time] if t[:max_time] < h[:max_time]
		end

		@stats
	end
end

