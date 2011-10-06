Given /([^ ]*) env var set to (.*)/ do |name, val|
	ENV[name] = val
end

Given /gem bin directory in PATH/ do
	ENV['PATH'] = ENV['PATH'] + ':' + (Pathname.new(__FILE__).dirname + '../../bin').to_s
end

