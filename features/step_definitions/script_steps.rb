Given /content of ([^ ]*) file piped in STDIN/ do |test_file|
	@script_stdin_input_file = test_file(test_file)
end

Given /'(.*)' as script argument/ do |argument|
	@script_args ||= []
	@script_args << argument
end

When /run ([^ ]*) script/ do |script_file|
	if @script_stdin_input_file
		@out = script_output_from_input(@script_stdin_input_file, script_file, @script_args)
	else
		@out = script_output(script_file, @script_args)
	end
end

Then /will output the following output/ do |output|
	@out.should == output
end

Then /will output yaml that is the same as/ do |yaml|
	out = YAML.load(@out)
	out.should == YAML.load(yaml)
end

Then /will output yaml that has the same hash structure and types as/ do |yaml|
	out = YAML.load(@out)
	test = YAML.load(yaml)

	compare_trees(out, test)
end

