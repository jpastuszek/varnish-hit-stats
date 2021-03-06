$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

def gem_dir
	Pathname.new(__FILE__).dirname + '..'
end

def features_dir
	gem_dir + 'features'
end

def test_file(file)
	features_dir + 'test_files' + file
end

def compare_trees(a, b)
	a.should be_a(b.class)

	if b.is_a? Hash
		b.each_pair do |k, v|
			a.should include(k)
			compare_trees(a[k], v)
		end
	end
end

