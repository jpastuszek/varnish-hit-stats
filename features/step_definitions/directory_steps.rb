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

Given /file (.*) in ([^ ]*) directory contain/ do |file, dir_name, content|
	(dir_by_name(dir_name) + file).open('w') do |io|
		io.write(content)
	end
end

Given /there is no (.*) file in ([^ ]*) directory/ do |file, dir_name|
	f = (dir_by_name(dir_name) + file)
	f.rm if f.exist?
end

Then /file (.*) in ([^ ]*) directory will contain/ do |file, dir_name, content|
	(dir_by_name(dir_name) + file).open do |io|
		io.read.should == content
	end
end

Then /file (.*) in ([^ ]*) directory will be identical to (.*) file in ([^ ]*) directory/ do |file1, dir_name1, file2, dir_name2|
	content1 = (dir_by_name(dir_name1) + file1).read
	content2 = (dir_by_name(dir_name2) + file2).read
	content1.should == content2
end

