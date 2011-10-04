require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'stat_counter'

describe "StatCounter" do
	before :all do
		@sc = StatCounter.new
		3.times{ @sc.up(:hit) }
		2.times{ @sc.up(:miss) }
		5.times{ @sc.up(:pass_for_hit) }
	end

  it "should sum up given stats and provide getters to the sum" do
		@sc.hit.should == 3
		@sc.miss.should == 2
  end

	it "should return return total of all stats" do
		@sc.total.should == 10
	end

	it "should return ratio of two stats including total" do
		@sc.hit_to_miss_ratio.should == 3.0/2
		@sc.hit_to_total_ratio.should == 3.0/10
		@sc.pass_for_hit_to_total_ratio.should == 5.0/10
	end
end
