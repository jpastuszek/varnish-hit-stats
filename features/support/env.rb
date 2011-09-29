require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'varnish-hit-stats'

require 'rspec/expectations'

def test_log(file)
	Pathname.new(__FILE__).dirname + '../test_logs' + file
end

def script(file)
	Pathname.new(__FILE__).dirname + '../../bin' + file
end

def script_output(file, *args)
	`#{script(file)} #{args.join(' ')}`
end

