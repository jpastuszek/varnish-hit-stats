require 'bundler'
require 'pathname'
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

def gem_dir
	Pathname.new(__FILE__).dirname + '..' + '..'
end

def features_dir
	gem_dir + 'features'
end

def tmp_test_dir
	features_dir + 'tmp'
end

def test_files(file)
	features_dir + 'test_files' + file
end

def script(file)
	gem_dir + 'bin' + file
end

def script_output(file, *args)
	cmd = "#{script(file)} #{args.join(' ')}"
	out = `#{cmd} 2>&1`
	raise "failed to execute script: #{cmd} out: #{out}" unless $?.success?
	out
end

def script_output_from_input(in_file, file, *args)
	cmd = "cat #{in_file} | #{script(file)} #{args.join(' ')}"
	out = `#{cmd} 2>&1`
	raise "failed to execute script: #{cmd} out: #{out}" unless $?.success?
	out
end

