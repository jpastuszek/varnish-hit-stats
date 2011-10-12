require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'response_time_stats'
require 'parser'

describe ResponseTimeStats do
	before :all do
		@stats = ResponseTimeStats.new
		UniversalAccessLogParser.varnish.parse_file(test_file('test1.log')).each do |entry|
			@stats.process(entry)
		end
	end

  it "#to_hash should return hash map of hit stats containing: pass, hit, miss, total and hit/total per class" do
		hsub = {:total_time => 0.0, :total_requests => 0, :average_time => 0.0, :max_time => 0.0, :min_time => 0.0}
		h = {
			"Response-Status"=> hsub,
			"Cache-Default"=> hsub,
			"Cache-Brochure"=> hsub,
			"Host-Redirect"=> hsub,
			"URL-List"=> hsub,
			"Cache-Search"=> hsub,
			"total"=>hsub,
		}

		s = @stats.to_hash
		
		compare_trees(s, h)

		s.each_value do |h|
			h[:max_time].should > 0
			h[:min_time].should > 0
			h[:min_time].should <= h[:max_time]
			h[:average_time].should > 0
			h[:total_time].should > 0
			h[:total_requests].should > 0
		end
	end
end

