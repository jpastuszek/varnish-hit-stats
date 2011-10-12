require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'hit_stats'
require 'parser'

describe HitStats do
	before :all do
		@hit_stats = HitStats.new
		UniversalAccessLogParser.varnish.parse_file(test_file('test1.log')).each do |entry|
			@hit_stats.process(entry)
		end
	end

  it "#to_hash should return hash map of hit stats containing: pass, hit, miss, total and hit/total per class" do
		h = {
			"Response-Status"=> {:pass=>1, :hit=>0, :hit_to_total_ratio=>0.0, :total=>1, :miss=>0},
			"Cache-Default"=> {:pass=>0, :hit=>18, :hit_to_total_ratio=>0.486486486486487, :total=>37, :miss=>19},
			"Cache-Brochure"=> {:pass=>0, :hit=>3, :hit_to_total_ratio=>0.5, :total=>6, :miss=>3},
			"Host-Redirect"=> {:pass=>0, :hit=>3, :hit_to_total_ratio=>0.5, :total=>6, :miss=>3},
			"URL-List"=> {:pass=>19, :hit=>0, :hit_to_total_ratio=>0.0, :total=>19, :miss=>0},
			"Cache-Search"=> {:pass=>0, :hit=>3, :hit_to_total_ratio=>0.428571428571429, :total=>7, :miss=>4},
			"total"=>{:pass=>23, :hit=>42, :hit_to_total_ratio=>0.381818181818182, :total=>110, :miss=>45}
		}

		hs = @hit_stats.to_hash
		
		compare_trees(hs, h)
	end
end

