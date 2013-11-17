class Transfer
	def initialize( line )
		@line = line
	end
	def date
		return @line[11]
	end
	def value
		if @line[18]
			value = @line[18].gsub("'","").to_f
		else
			value = -(@line[17].gsub("'","").to_f)
		end
	end
	def to_s
		s = []

		s << date
		s << value
		s << line[12]
		s << line[13]
		s << line[14]

		return s.join "\t"
	end
	def line
		return @line
	end
end