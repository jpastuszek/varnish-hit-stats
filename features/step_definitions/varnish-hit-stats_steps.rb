require 'pathname'

Before do
end

Given /Varnish ncsa log file ([^ ]*)/ do |log_file|
	@log_file = test_log(log_file)
end

When /run ([^ ]*) script on that log file/ do |script_file|
	@out = script_output(script_file, @log_file)
end

Then /will print the following output/ do |output|
	@out.should == output
end

