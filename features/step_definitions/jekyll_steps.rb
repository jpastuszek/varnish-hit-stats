
Then /jekyll post (.*) in ([^ ]*) directory will contain/ do |post_name, time_spec, output|
	time = Time.now.send(time_spec.singularize)
	file_name = post_name.downcase.tr(' ', '-')
	uri = time.strftime('%Y/%m/%d') + '/' + file_name + '.html'

	File.open(Pathname.new(__FILE__).dirname + '../../site/_site' + uri) do |file|
		output.should == file.read
	end
end

