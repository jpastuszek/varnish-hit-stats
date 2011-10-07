Given /^jekyll directory$/ do
	@jekyll_dir = gem_dir + 'site'
end

Given /^source directory$/ do
	@source_dir = tmp_test_dir + 'source'
end

Given /^site directory$/ do
	@site_dir = tmp_test_dir + 'site'
end

Given /^source _posts directory$/ do
	@_posts_dir = tmp_test_dir + 'source' + '_posts'
end

Given /^test_source test directory$/ do
	@test_source_dir = test_files_dir + 'test_source'
end

Then /the ([^ ]*) directory will contain ([^ ]*) post titled (.*) that will include/ do |dir_name, time_spec, post_name, output|
	time = Time.now.send(time_spec.singularize)
	file_name = post_name.downcase.tr(' ', '-')
	uri = time.strftime('%Y/%m/%d') + '/' + file_name + '.html'

	File.open(dir_by_name(dir_name) + uri) do |file|
		file.read.should include(output)
	end
end

Then /the ([^ ]*) directory will contain ([^ ]*) post template titled (.*) that will include/ do |dir_name, time_spec, post_name, output|
	#time = Time.now.send(time_spec.singularize)
	time = Time.parse(time_spec)
	file_name = post_name.downcase.tr(' ', '-')
	uri = time.strftime('%Y-%m-%d') + '-' + file_name + '.textile'

	puts @out

	File.open(dir_by_name(dir_name) + uri) do |file|
		file.read.should include(output)
	end
end

