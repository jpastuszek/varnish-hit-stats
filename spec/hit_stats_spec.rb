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
		@hit_stats.to_hash.should == {
			"unset"=>{:pass=>1, :hit=>0, :total=>1, :hit_to_total=>0, :miss=>0},
			"Response-Status"=>{:pass=>1, :hit=>0, :total=>1, :hit_to_total=>0, :miss=>0},
			"Cache-Default"=> {:pass=>0, :hit=>18, :total=>37, :hit_to_total=>0, :miss=>19},
			"Cache-Brochure"=>{:pass=>0, :hit=>3, :total=>6, :hit_to_total=>0, :miss=>3},
			"URL-List"=>{:pass=>19, :hit=>0, :total=>19, :hit_to_total=>0, :miss=>0},
			"Cache-Search"=>{:pass=>0, :hit=>3, :total=>7, :hit_to_total=>0, :miss=>4}
		}
  end
end

