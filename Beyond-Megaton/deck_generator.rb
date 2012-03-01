#!/usr/bin/env ruby
require 'optparse'
require 'yaml'

def HandleCatastrophe
	puts "\t<div class='Card " + type + " " + title + " " + type + "'>"
    puts "\t\t<h2 class='type'>" + type + " </h2>" unless type == ""
    puts "\t\t<h3 class='title'>" + title + " </h3>"
    puts "\t\t<p class='special'>" + special + "</p>" unless special == "" 
    sorted_remaining_values.each { |other_value_name, other_value| puts "\t\t<p class='"+other_value_name.to_s.downcase + "'><strong>"+ other_value_name.to_s + "</strong>: " + other_value.to_s + " </p>" }
    puts "\t\t<p class='flavor'><em>" + flavor + "</em></p>" unless flavor == "" 
    puts "\t\t<div class='type'>" + type + "</div>" unless type == "" 
    puts "\t</div>"
    pagecounter += 1
    puts "<div style='clear:both'> </div> </div><div class='Page'>" if pagecounter % CARDS_PER_PAGE == 0
end

CARDS_PER_PAGE = 8
 
options = {} 

optparse = OptionParser.new {|opts|
    opts.banner = "Usage: deck_generator.rb --file FILENAME"

    options[:filename] = ""
    opts.on( '-f', '--file FILENAME', 'File' ) {|file| options[:filename] = file } 

    options[:name] = ""
    opts.on( '-d', '--deck NAME', 'The name of the deck.') { |name| options[:name] = name } 

    options[:stylesheet] = "style.css" 
    opts.on( '-s', '--stylesheet FILENAME', 'The name of the stylesheet.') { |filename| options[:stylesheet] = filename } 

    opts.on("-h", "--help", "Show this message"){
        puts opts
        exit
    }
}
optparse.parse!

if (options[:filename] == "") then
    puts optparse
    exit
end

cards = YAML.load_file( options[:filename] )

pagecounter = 0

puts "<!DOCTYPE html>"
puts "<html>"
puts "\t<link href='http://fonts.googleapis.com/css?family=Gudea:400,700,400italic|Waiting+for+the+Sunrise|Stint+Ultra+Expanded|Share:400,400italic,700,700italic' rel='stylesheet' type='text/css'>"
puts "\t<meta charset='utf-8'>"
puts "\t<link rel='stylesheet' href='"+options[:stylesheet]+"' />" 
puts "<body>"
puts "<div class='Page'>" 

cards.each do |key, value|
    # Quantity 
    quantity = value["Quantity"] ||= 1
    title = value["Title"] ||= key
	requirement = value["Requirement"] ||= ""
	pass = value["Pass"] ||= ""
	fail = value["Fail"] ||= ""
	
    special = value["Special"] ||= ""
    type = value["Type"] ||= ""
	resolve = value["Resolve"] ||= ""
	effect = value["Effect"] ||= ""
	flavor = value["Flavour"] ||= ""
	
	remaining_values = value.reject{ |key, value| ["Quantity", "Title", "Image", "Special", "Flavor", "Type"].include?(key) }
    sorted_remaining_values = remaining_values.sort{ |a, b| a[0].split(" ")[-1] <=> b[0].split(" ")[-1] } 

    quantity.times do 
		if type == "Catastrophe"
			HandleCatastrophe
		end
    end
end

puts "</body>"
puts "</html>"