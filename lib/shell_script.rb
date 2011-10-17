require 'ostruct'

class ShellScript
	class ParsingError < ArgumentError
	end

	class Parsed < OpenStruct
	end

	class Argument
		def initialize(name, options = {})
			@name = name
			@options = {
				:cast => String
			}.merge(options)
		end

		attr_reader :name

		def cast(value)
			begin
				@options[:cast].new(value)
			rescue => e
				raise ParsingError, "failed to cast argument: #{@name} to type: #{@options[:cast].name}: #{e}"
			end
		end
	end

	def initialize(argv = ARGV, &block)
		@argv = argv
		@arguments = []
		instance_eval(&block) if block_given?
	end

	def stdin(stdin_type)
		@stdin_type = stdin_type
	end

	def argument(name, options = {})
		raise ArgumentError, "expected argument options of type Hash, got: #{options.class.name}" unless options.is_a? Hash
		@arguments << Argument.new(name, options)
	end

	def parse!
		parsed = Parsed.new

		@arguments.each do |argument|
			value = @argv.shift
			raise ParsingError, "missing argument: #{argument.name}" unless value
			parsed.send((argument.name.to_s + '=').to_sym, argument.cast(value)) 
		end

		case @stdin_type
			when :yaml
				require 'yaml'
				parsed.stdin = YAML.load(STDIN)
			else
				parsed.stdin = STDIN
		end

		parsed
	end
end

