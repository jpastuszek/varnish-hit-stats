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

		t["zabbix", "Letters"] = "zabbix".length
		t["welcome", "Plural"] = false

		t["zabbix", "Letters"].should == "zabbix".length
		t["welcome", "Plural"].should == false
		t["welcome", "Words"].should == "welcome"
		t["welcome", "Letters"].should be_nil
	end

	it "should render to textile format" do
		t = Table.new do
			column "Words"
			column "Letters"
			column "Plural"
			row "stanford"
			row "zabbix"
			row "galileo"
			row "welcome"
		end

		t["zabbix", "Letters"] = "zabbix".length
		t["welcome", "Plural"] = false

		puts t.to_textile
	end
end

