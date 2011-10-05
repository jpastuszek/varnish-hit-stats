require 'bundler'
require 'pathname'
require 'i18n'
require 'active_support/core_ext'

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

def test_files(file)
	Pathname.new(__FILE__).dirname + '../test_files' + file
end

def script(file)
	Pathname.new(__FILE__).dirname + '../../bin' + file
end

def script_output(file, *args)
	out = `#{script(file)} #{args.join(' ')}`
	raise 'failed to execute script' unless $?.success?
	out
end

def script_output_from_input(in_file, file, *args)
	out = `cat #{in_file} | #{script(file)} #{args.join(' ')}`
	raise 'failed to execute script' unless $?.success?
	out
end

