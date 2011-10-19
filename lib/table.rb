class Table
	def initialize(&block)
		@columns = []
		@rows = []

		@column_index = {}
		@row_index = {}

		instance_eval &block

		@table = [@columns]
		@rows.each do |row|
			r = Array.new(@columns.length)
			r[0] = row
			@table << r
		end

		@columns.each_with_index{|n, i| @column_index[n] = i}
		@rows.each_with_index{|n, i| @row_index[n] = i + 1}

	end

	def column(name)
		@columns << name
	end

	def row(name)
		@rows << name
	end

	def []=(column, row, value)
		@table[@row_index[row]][@column_index[column]] = value
	end

	def [](column, row)
		@table[@row_index[row]][@column_index[column]]
	end
end

