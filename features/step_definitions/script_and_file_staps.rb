Given /content of ([^ ]*) file/ do |test_file|
	@test_file = test_files(test_file)
end

When /run ([^ ]*) script with that file content piped in STDIN/ do |script_file|
	@out = script_output_from_input(@test_file, script_file)
end

When /run ([^ ]*) script with file path given as first argument/ do |script_file|
	@out = script_output(script_file, @test_file)
end

Then /will print the following output/ do |output|
	@out.should == output
end

