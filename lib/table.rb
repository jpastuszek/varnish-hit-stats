require 'stringio'

class Table
	def initialize(&block)
		@columns = []
		@rows = []

		@column_index = {}
		@row_index = {}

		instance_eval &block

		@table = []
		@rows.each do |row|
			r = Array.new(@columns.length)
			r[0] = row
			@table << r
		end

		@columns.each_with_index{|n, i| @column_index[n] = i}
		@rows.each_with_index{|n, i| @row_index[n] = i}
	end

	def column(name)
		@columns << name
	end

	def row(name)
		@rows << name
	end

	def []=(row, column, value)
		raise ArgumentError, "no row of name: #{row}" unless @row_index.member? row
		raise ArgumentError, "no column of name: #{column}" unless @column_index.member? column

		@table[@row_index[row]][@column_index[column]] = value
	end

	def [](row, column)
		raise ArgumentError, "no row of name: #{row}" unless @row_index.member? row
		raise ArgumentError, "no column of name: #{column}" unless @column_index.member? column

		@table[@row_index[row]][@column_index[column]]
	end

	def to_textile(options = {})
		options = {
			:null => '-',
			:float => '0.6'
		}.merge(options)

		o = StringIO.new		

		o.print '|_. '
		o.print @columns.join(' |_. ')
		o.puts ' |'

		@table.each do |row|
			row.map! do |value|
				next options[:null] if value == nil
				next "%#{options[:float]}f" % value if value.is_a? Float
				value
			end

			o.print '| '
			o.print row.join(' | ')
			o.puts ' |'
		end

		o.rewind
		o.read
	end

	def to_csv
		o = StringIO.new		

		([@columns] | @table).each do |row|
			o.puts row.map{|v|
				next '"' + v.delete('"') + '"' if v.class == String
				v
			}.join(',')
		end

		o.rewind
		o.read
	end
end

