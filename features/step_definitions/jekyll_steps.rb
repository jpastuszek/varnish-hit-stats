Given /^jekyll directory$/ do
	@jekyll_dir = gem_dir + 'site'
end

Given /^source directory$/ do
	@source_dir = tmp_test_dir + 'source'
end

Given /^source _posts directory$/ do
	@source__posts_dir = tmp_test_dir + 'source' + '_posts'
end

Given /^source csv directory$/ do
	@source_csv_dir = tmp_test_dir + 'source' + 'csv'
end

Given /^site directory$/ do
	@site_dir = tmp_test_dir + 'site'
end

Then /the ([^ ]*) directory will contain ([^ ]*) post titled (.*) that will include/ do |dir_name, time_spec, post_name, output|
	time = Time.now.send(time_spec.singularize)
	file_name = post_name.downcase.tr(' :', '-')
	uri = time.strftime('%Y/%m/%d') + '/' + file_name + '.html'

	File.open(dir_by_name(dir_name) + uri) do |file|
		file.read.should include(output)
	end
end

Then /the (.*) directory will contain ([^ ]*) post template titled (.*) that will include/ do |dir_name, time_spec, post_name, output|
	time = Time.parse(time_spec)
	file_name = post_name.downcase.tr(' :', '-')
	uri = time.strftime('%Y-%m-%d') + '-' + file_name + '.textile'

	puts @out

	File.open(dir_by_name(dir_name) + uri) do |file|
		file.read.should include(output)
	end
end

Then /the (.*) directory will contain ([^ ]*) CSV titled (.*) that will include/ do |dir_name, time_spec, post_name, output|
	time = Time.parse(time_spec)
	file_name = post_name.downcase.tr(' :', '-')
	uri = time.strftime('%Y-%m-%d') + '-' + file_name + '.csv'

	puts @out

	File.open(dir_by_name(dir_name) + uri) do |file|
		file.read.should include(output)
	end
end

Then /the (.*) directory will not contain ([^ ]*) post template titled (.*)/ do |dir_name, time_spec, post_name|
	time = Time.parse(time_spec)
	file_name = post_name.downcase.tr(' ', '-')
	uri = time.strftime('%Y-%m-%d') + '-' + file_name + '.textile'

	puts @out

	File.exist?(dir_by_name(dir_name) + uri).should == false
end

