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
				cast_class = @options[:cast]
				if cast_class == Integer
					value.to_i
				elsif cast_class == Float
					value.to_f
				else
					cast_class.new(value)
				end
			rescue => e
				raise ParsingError, "failed to cast argument: #{@name} to type: #{@options[:cast].name}: #{e}"
			end
		end

		def optional?
			@options.member? :default
		end

		def default
			@options[:default]
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

		while argument = @arguments.shift
			value = if @argv.length < @arguments.length + 1 and argument.optional?
				argument.default # not enough arguments, try to skip optional if possible
			else
				@argv.shift or raise ParsingError, "missing argument: #{argument.name}"
			end

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

