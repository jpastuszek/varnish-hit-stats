require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'shell_script'

def stdin_write(data)
		r, w = IO.pipe
		old_stdin = STDIN.reopen r
		Thread.new do
		 	w.write data
			w.close
		end
		begin
			yield
		ensure
			STDIN.reopen old_stdin
		end
end

describe ShellScript do
	before :all do
		@yaml = <<EOF
--- 
:parser: 
  :successes: 41
  :failures: 0
EOF
	end

	it "should return IO stdin by default" do
		ps = ShellScript.new.parse
		ps.stdin.should be_a IO
	end

	it "should return YAML document for stdin if stdin type is :yaml" do
		ps = nil
		ss = ShellScript.new do
			stdin :yaml
		end

		stdin_write(@yaml) do
			ps = ss.parse
		end

		ps.stdin.should == {:parser=>{:successes=>41, :failures=>0}}
	end

	describe 'argument handling' do
		it "should handle single argument" do
			ps = ShellScript.new(['/tmp']) do
				argument :log
			end.parse
			ps.log.should be_a String
			ps.log.should == '/tmp'
		end

		it "non empty, non optional with class casting" do
			ps = ShellScript.new(['/tmp']) do
				argument :log, :cast => Pathname
			end.parse
			ps.log.should be_a Pathname
			ps.log.to_s.should == '/tmp'
		end

		it "non empty, non optional with builtin class casting" do
			ps = ShellScript.new(['123']) do
				argument :number, :cast => Integer
			end.parse
			ps.number.should be_a Integer
			ps.number.should == 123

			ps = ShellScript.new(['123']) do
				argument :number, :cast => Float
			end.parse
			ps.number.should be_a Float
			ps.number.should == 123.0
		end

		it "should handle multiple arguments" do
			ps = ShellScript.new(['/tmp', 'hello']) do
				argument :log, :cast => Pathname
				argument :test
			end.parse
			ps.log.should be_a Pathname
			ps.log.to_s.should == '/tmp'
			ps.test.should be_a String
			ps.test.should == 'hello'
		end

		it "should raise error if not given" do
			lambda {
				ps = ShellScript.new([]) do
					argument :log
				end.parse
			}.should raise_error ShellScript::ParsingError
		end

		it "should raise error if casting fail" do
			require 'ip'
			lambda {
				ps = ShellScript.new(['abc']) do
					argument :log, :cast => IP
				end.parse
			}.should raise_error ShellScript::ParsingError
		end

		describe "with defaults" do
			it "should use default first argument" do
				ps = ShellScript.new(['hello']) do
					argument :log, :cast => Pathname, :default => '/tmp'
					argument :test
				end.parse
				ps.log.should be_a Pathname
				ps.log.to_s.should == '/tmp'
				ps.test.should be_a String
				ps.test.should == 'hello'
			end

			it "should use default second argument" do
				ps = ShellScript.new(['/tmp']) do
					argument :log, :cast => Pathname
					argument :test, :default => 'hello'
				end.parse
				ps.log.should be_a Pathname
				ps.log.to_s.should == '/tmp'
				ps.test.should be_a String
				ps.test.should == 'hello'
			end

			it "should use default second argument" do
				ps = ShellScript.new(['/tmp', 'hello']) do
					argument :log, :cast => Pathname
					argument :magick, :default => 'word'
					argument :test
					argument :code, :cast => Integer, :default => '123'
				end.parse
				ps.log.to_s.should == '/tmp'
				ps.magick.should == 'word'
				ps.test.should == 'hello'
				ps.code.should == 123
			end
		end
	end

	describe 'option handling' do
		it "should handle long option names" do
			ps = ShellScript.new(['--location', 'singapore']) do
				option :location
			end.parse
			ps.location.should be_a String
			ps.location.should == 'singapore'
		end

		it "should handle short option names" do
			ps = ShellScript.new(['-l', 'singapore']) do
				option :location, :short => :l
			end.parse
			ps.location.should be_a String
			ps.location.should == 'singapore'
		end

		it "should handle default values" do
			ps = ShellScript.new([]) do
				option :location, :default => 'singapore'
				option :size, :cast => Integer, :default => 23
			end.parse
			ps.location.should be_a String
			ps.location.should == 'singapore'
			ps.size.should be_a Integer
			ps.size.should == 23
		end

		it "should support casting" do
			ps = ShellScript.new(['--size', '24']) do
				option :size, :cast => Integer
			end.parse
			ps.size.should be_a Integer
			ps.size.should == 24
		end

		it "not given and not defined options should be nil" do
			ps = ShellScript.new([]) do
				option :size, :cast => Integer
			end.parse
			ps.size.should be_nil
			ps.gold.should be_nil
		end

		it "should handle multiple long and short intermixed options" do
			ps = ShellScript.new(['-l', 'singapore', '--power-up', 'yes', '-s', '24', '--size', 'XXXL']) do
				option :location, :short => :l
				option :group, :default => 'red'
				option :power_up, :short => :p
				option :speed, :short => :s, :cast => Integer
				option :not_given
				option :size
			end.parse
			ps.group.should == 'red'
			ps.power_up.should == 'yes'
			ps.speed.should == 24
			ps.not_given.should be_nil
			ps.size.should == 'XXXL'
			ps.gold.should be_nil
		end

		it "should raise error on unrecognized switch" do
			ps = ShellScript.new(['--xxx', 'singapore']) do
				option :location
			end
			
			lambda {
				ps.parse
			}.should raise_error ShellScript::ParsingError
		end

		it "should raise error on missing option argument" do
			ps = ShellScript.new(['--location']) do
				option :location
			end
			
			lambda {
				ps.parse
			}.should raise_error ShellScript::ParsingError
		end

		it "should raise error on missing required option" do
			ps = ShellScript.new(['--location', 'singapore']) do
				option :location
				option :size, :required => true
				option :group, :default => 'red'
				option :speed, :short => :s, :cast => Integer
			end
			
			lambda {
				ps.parse
			}.should raise_error ShellScript::ParsingError, "following options are required but were not specified: --size"
		end
	end

	it "should handle options and then arguments" do
			ps = ShellScript.new(['-l', 'singapore', '--power-up', 'yes', '-s', '24', '--size', 'XXXL', '/tmp', 'hello']) do
				option :location, :short => :l
				option :group, :default => 'red'
				option :power_up, :short => :p
				option :speed, :short => :s, :cast => Integer
				option :size

				argument :log, :cast => Pathname
				argument :magick, :default => 'word'
				argument :test
				argument :code, :cast => Integer, :default => '123'
			end.parse

			ps.group.should == 'red'
			ps.power_up.should == 'yes'
			ps.speed.should == 24
			ps.size.should == 'XXXL'

			ps.log.to_s.should == '/tmp'
			ps.magick.should == 'word'
			ps.test.should == 'hello'
			ps.code.should == 123
	end

	it "parse should set help variable if -h specified in the argument list" do
			ps = ShellScript.new(['-h', '-l', 'singapore', '--power-up', 'yes', '-s', '24', '--size', 'XXXL', '/tmp', 'hello']) do
				option :location, :short => :l
				option :group, :default => 'red'
				option :power_up, :short => :p
				option :speed, :short => :s, :cast => Integer
				option :size

				argument :log, :cast => Pathname
				argument :magick, :default => 'word'
				argument :test
				argument :code, :cast => Integer, :default => '123'
			end.parse
			ps.help.should be_a String
			puts ps.help
	end
end

