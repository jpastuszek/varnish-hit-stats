def dir_by_name(dir_name)
	eval("@#{dir_name}_dir") or fail "undefined dir: #{dir_name}"
end

Given /([^ ]*) directory is empty/ do |dir_name|
	dir = dir_by_name(dir_name)
	dir.mkpath unless dir.exist?
	Pathname.glob(dir + '*').each do |entry|
		#puts "removing: #{entry}"
		entry.rmtree
	end
end

Given /([^ ]*) directory as script argument/ do |dir_name|
	@script_args ||= []
	@script_args << dir_by_name(dir_name).to_s
end

Given /there are files (.*) in ([^ ]*) directory/ do |files, dir_name|
	dir = dir_by_name(dir_name)
	@files = files.split(',').map{|f| dir + f}
	@files.each do |file|
		file.open('w'){|io| io.write 'test' } unless file.exist?
	end
end

Then /those files will exist/ do
	fail 'files not defined' if not @files or @files.empty?
	@files.each do |file|
		file.exist?.should == true
	end
end

Then /those files will not exist/ do
	fail 'files not defined' if not @files or @files.empty?
	@files.each do |file|
		file.exist?.should == false
	end
end

