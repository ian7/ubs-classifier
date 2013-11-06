f = File.open 'export.csv'

lines = f.readlines


def value( line )
	if( line[18] )
		return line[18].gsub("'","").to_f
	else
		return -(line[17].gsub("'","").to_f)
	end
end


allSplit = []

lines.each do |l|
	allSplit << l.to_s.split(';')
end

puts "found #{lines.size.to_s}, after split #{allSplit.size.to_s}"

categories = ["Denner",
			  "Manor",
			  "Coop-",
			  "Aldi",
			  "CITTA",
			  "AIL",
			  "ATUPRI",
			  "HANNOVER",
			  "CREDIT CARD",
			  "IKEA",
			  "Piccadilly",
			  "1701 FRIBOURG",
			  "USI",
			  "SWISSCOM",
			  "Cash withdrawal",
			  "INTRAS",
			  "SBB",
			  "UBS BANCOMAT"
			]

subTotals = {}
subTotals['unclassified'] = 0.0
counts = {}
counts['unclassified'] = 0

categories.each {|x| 
	subTotals[x] = 0.0
	counts[x] = 0
	}

split = allSplit.select{ |x| x[11] && x[11].include?("2013")}

#debugger

unclassified = []


split.each do |line| 
	# just prevent short lines from getting in.
	if line.size < 10
		next
	end

	if line[12].include?("MULTI E-BANKING") || line[12].include?("ot debited") || line[12].include?("harges waive")
		next
	end

	categoryMatch = categories.find { |category| 
		line[14].include?(category) || 
		line[13].include?(category) ||
		line[12].include?(category) 
	}

	if line[18]
		value = line[18].gsub("'","").to_f
	else
		value = -(line[17].gsub("'","").to_f)
	end

	if categoryMatch
		subTotals[categoryMatch] += value
		counts[categoryMatch] += 1
	else
		subTotals['unclassified'] += value
		counts['unclassified'] += 1

		unclassified << line
	end
end
uf = File.open 'unclassified.csv','w'

unclassified.sort {|x,y| value(x) <=> value(y) }.each{ |line| 
	uf.puts line.join "\t"
}
uf.close


earnings = 0.0

split.each do |line| 
	if line.size < 10
		next
	end

	if line[19]
		earnings += line[19].gsub("'","").to_f
	end
end


total = 0.0

subTotals.each {|category,v|
	puts "  #{category.ljust(30)}  => (#{counts[category].to_s.rjust(3)}) #{("%5.2f" % v).rjust(10)}"
	#puts "  #{category.ljust(30)}  => #{("%5.2f" % v).rjust(10)}"
	total += v
}
	puts "total: #{"%5.2f" % total}, earnings: #{"%5.2f" % earnings}"




