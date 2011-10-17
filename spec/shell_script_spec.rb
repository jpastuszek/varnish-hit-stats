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
		ps = ShellScript.new.parse!
		ps.stdin.should be_a IO
	end

	it "should return YAML document for stdin if stdin type is :yaml" do
		ps = nil
		ss = ShellScript.new do
			stdin :yaml
		end

		stdin_write(@yaml) do
			ps = ss.parse!
		end

		ps.stdin.should == {:parser=>{:successes=>41, :failures=>0}}
	end

	describe 'argument handling' do
		it "should handle single argument with default casting" do
			ps = ShellScript.new(['/tmp']) do
				argument :log
			end.parse!
			ps.log.should be_a String
			ps.log.should == '/tmp'
		end

		it "non empty, non optional with class casting" do
			ps = ShellScript.new(['/tmp']) do
				argument :log, :cast => Pathname
			end.parse!
			ps.log.should be_a Pathname
			ps.log.to_s.should == '/tmp'
		end

		it "should handle multiple arguments" do
			ps = ShellScript.new(['/tmp', 'hello']) do
				argument :log, :cast => Pathname
				argument :test
			end.parse!
			ps.log.should be_a Pathname
			ps.log.to_s.should == '/tmp'
			ps.test.should be_a String
			ps.test.should == 'hello'
		end

		it "should raise error if not given" do
			lambda {
				ps = ShellScript.new([]) do
					argument :log
				end.parse!
			}.should raise_error ShellScript::ParsingError
		end

		it "should raise error if casting fail" do
			require 'ip'
			lambda {
				ps = ShellScript.new(['abc']) do
					argument :log, :cast => IP
				end.parse!
			}.should raise_error ShellScript::ParsingError
		end
	end
end
