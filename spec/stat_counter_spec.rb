require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'stat_counter'

describe "StatCounter" do
	before :all do
		@sc = StatCounter.new
		3.times{ @sc.up(:hit) }
		2.times{ @sc.up(:miss) }
	end

  it "should sum up given stats and provide getters to the sum" do
		@sc.hit.should == 3
		@sc.miss.should == 2
  end

	it "should return return total of all stats" do
		@sc.total.should == 5
	end

	it "should return ratio of two stats including total" do
		@sc.hit_miss_ratio.should == 3.0/2
		@sc.hit_total_ratio.should == 3.0/5
	end
end
