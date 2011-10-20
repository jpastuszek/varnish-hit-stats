require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'table'

describe Table do
	before :each do
		@t = Table.new do
			column "Words"
			column "Letters"
			column "Plural"
			row "stanford"
			row "zabbix"
			row "galileo"
			row "welcome"
		end

		@t["zabbix", "Letters"] = "zabbix".length
		@t["welcome", "Plural"] = false
	end

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

	describe "textile output" do
		it "should render basic textile" do
			@t.to_textile.should == <<EOS
|_. Words |_. Letters |_. Plural |
| stanford | - | - |
| zabbix | 6 | - |
| galileo | - | - |
| welcome | - | false |
EOS
		end

		it "should handle nil rendering options" do
			@t.to_textile(:null => 'NULL').should == <<EOS
|_. Words |_. Letters |_. Plural |
| stanford | NULL | NULL |
| zabbix | 6 | NULL |
| galileo | NULL | NULL |
| welcome | NULL | false |
EOS
		end

		it "should handle float rendering options" do
			@t["galileo", "Letters"] = 1.333333333
			@t.to_textile(:float => '0.2').should == <<EOS
|_. Words |_. Letters |_. Plural |
| stanford | - | - |
| zabbix | 6 | - |
| galileo | 1.33 | - |
| welcome | - | false |
EOS
		end
	end

	describe "CSV output" do
		it "should render basic format" do
			@t.to_csv.should == <<EOS
"Words","Letters","Plural"
"stanford",,
"zabbix",6,
"galileo",,
"welcome",,false
EOS
		end

		it "should remove \" from data" do
			@t["galileo", "Letters"] = 'this is " a test'
			@t.to_csv.should == <<EOS
"Words","Letters","Plural"
"stanford",,
"zabbix",6,
"galileo","this is  a test",
"welcome",,false
EOS
		end
	end
end

