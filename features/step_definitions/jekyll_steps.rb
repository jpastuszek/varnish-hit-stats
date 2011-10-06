Given /^source directory$/ do
	@source_dir = tmp_test_dir + 'source'
end

Given /^site directory$/ do
	@site_dir = tmp_test_dir + 'site'
end

def dir_by_name(dir_name)
	eval("@#{dir_name}_dir") or fail "undefined dir: #{dir_name}"
end

Given /([^ ]*) directory is empty/ do |dir_name|
	dir = dir_by_name(dir_name)
	dir.mkpath unless dir.exist?
	Pathname.glob(dir + '*').each do |entry|
		puts "removing: #{entry}"
		entry.rmtree
	end
end

Given /([^ ]*) directory as script argument/ do |dir_name|
	@script_args ||= []
	@script_args << dir_by_name(dir_name).to_s
end

Then /the ([^ ]*) directory will contain ([^ ]*) post titled (.*) that will include/ do |dir_name, time_spec, post_name, output|
	time = Time.now.send(time_spec.singularize)
	file_name = post_name.downcase.tr(' ', '-')
	uri = time.strftime('%Y/%m/%d') + '/' + file_name + '.html'

	puts @out
	File.open(dir_by_name(dir_name) + uri) do |file|
		file.read.should include(output)
	end
end

