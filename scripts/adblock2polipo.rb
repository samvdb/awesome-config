#!/usr/bin/ruby

# convert adblock ruleset into polipo-forbidden format

if __FILE__ == $0

	if ARGV.length == 0
		exit("Usage: #{File.basename($0)} <adblockrules>")
	end

	if not File.exist?(ARGV[0])
		exit("The rules file (#{ARGV[0]}) doesn't exist")
	end

	dollar_re = Regexp.new(/(.*?)\$.*/)

	File.readlines(ARGV[0]).each {
		| line |
		unless line.empty?
			if (["[", "!", "~", "#", "@"].include?(line[0]) or
			    line[0, 8] == "/adverti" or
			    line.include?("##"))
				next
			end
			line = line.gsub(dollar_re, "\\1")
#			line = line.gsub("|http://", "")
			line = line.gsub("|", "")
			line = line.gsub("||", "")
			line = line.gsub(".", "\\.")
			line = line.gsub("*", ".*")
			line = line.gsub("?", "\\?")
			line = line.gsub("^", "[\\/:\\.=&\\?\\\\+\\-\\ ]+")
#			line = line.gsub("&", "\\&")
			line = line.gsub("+", "\\+")
#			line = line.gsub("-", "\\-")
#			line = line.gsub(";", "\\;")
#			line = line.gsub("=", "\\=")
#			line = line.gsub("/", "\\/")
			puts(line.strip)
		end
	}
	puts("")

end
