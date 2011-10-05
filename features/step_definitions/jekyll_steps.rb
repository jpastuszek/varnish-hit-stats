Given /jekyll test directory/ do
	@jekyll_dir = Pathname.new(__FILE__).dirname + '../../site'
end

Given /jekyll directory as script argument/ do
	@script_args ||= []
	@script_args << @jekyll_dir
end

Then /jekyll post (.*) in ([^ ]*) directory will include/ do |post_name, time_spec, output|
	time = Time.now.send(time_spec.singularize)
	file_name = post_name.downcase.tr(' ', '-')
	uri = time.strftime('%Y/%m/%d') + '/' + file_name + '.html'

	puts @out
	File.open(@jekyll_dir + '_site' + uri) do |file|
		file.read.should include(output)
	end
end

