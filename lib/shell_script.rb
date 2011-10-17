require 'ostruct'

class ShellScript
	class ParsingError < ArgumentError
	end

	class Parsed < OpenStruct
		def set(argument, value)
			send((argument.name.to_s + '=').to_sym, argument.cast(value)) 
		end
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

	class Option < Argument
		def switch
			'--' + name.to_s.tr('_', '-')
		end

		def has_short?
			@options.member? :short
		end

		def short
			@options[:short]
		end
	end

	def initialize(argv = ARGV, &block)
		@argv = argv
		@optoins_long = {}
		@optoins_short = {}
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

	def option(name, options = {})
		o = Option.new(name, options)
		@optoins_long[name] = o
		@optoins_short[o.short] = o if o.has_short?
	end

	def parse!
		parsed = Parsed.new

		while @argv.first =~ /^-/
			switch = @argv.shift
			option = if switch =~ /^--/
				@optoins_long[switch.sub(/^--/, '').tr('-', '_').to_sym]
			else
				@optoins_short[switch.sub(/^-/, '').tr('-', '_').to_sym]
			end

			if option
				value = @argv.shift or raise ParsingError, "missing option argument: #{option.switch}"
				parsed.set(option, value)
			else
				raise ParsingError, "unknonw switch: #{switch}"
			end
		end

		while argument = @arguments.shift
			value = if @argv.length < @arguments.length + 1 and argument.optional?
				argument.default # not enough arguments, try to skip optional if possible
			else
				@argv.shift or raise ParsingError, "missing argument: #{argument.name}"
			end

			parsed.set(argument, value)
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

