require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'table'

describe Table do
	it "should be buildable" do
		t = Table.new do
			column "Words"
			column "Letters"
			column "Plural"
			row "stanford"
			row "zabbix"
			row "galileo"
			row "welcome"
		end

		t["Letters", "zabbix"] = "zabbix".length
		t["Plural", "welcome"] = false

		t["Letters", "zabbix"].should == "zabbix".length
		t["Plural", "welcome"].should == false
		t["Words", "welcome"].should == "welcome"
		t["Letters", "welcome"].should be_nil
	end
end

