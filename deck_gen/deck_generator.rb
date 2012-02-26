require 'optparse' 
require 'yaml'

# 1. Get Options. 
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

# 2. Parse Deck
thing = YAML.load_file( options[:filename] )

# 3. Display Deck
puts "<!DOCTYPE html>"
puts "<html>"
puts "\t<meta charset='utf-8'>"
puts "\t<link rel='stylesheet' href='"+options[:stylesheet]+"' />" 
puts "<body>"

thing.each do |key, value|
    # Quantity 
    quantity = value["Quantity"] ||= 1
    category = options[:name]
    title = value["Title"] ||= key
    image = value["Image"] ||= ""
    special = value["Special"] ||= ""
    flavor = value["Flavor"] ||= ""
    type = value["Type"] ||= ""
    remaining_values = value.reject{ |key, value| ["Quantity", "Title", "Image", "Special", "Flavor", "Type"].include?(key) }
    sorted_remaining_values = remaining_values.sort{ |a, b| a[0].split(" ")[-1] <=> b[0].split(" ")[-1] } 
    
    quantity.times do 
        puts "\t<div class='" + category + " " + title + " " + type + "'>"
        puts "\t\t<h2 class='category'>" + category + " </h2>" unless category == ""
        puts "\t\t<h3 class='title'>" + title + " </h3>"
        puts "\t\t<img src='"+image+"' /> " unless image == "" 
        puts "\t\t<p class='special'>" + special + "</p>" unless special == "" 
        sorted_remaining_values.each { |other_value_name, other_value| puts "\t\t<p class='"+other_value_name.to_s.downcase + "'><strong>"+ other_value_name.to_s + "</strong>: " + other_value.to_s + " </p>" }
        puts "\t\t<p class='flavor'><em>" + flavor + "</em></p>" unless flavor == "" 
        puts "\t\t<div class='type'>" + type + "</div>" unless type == "" 
        puts "\t</div>"
    end
end

puts "</body>"
puts "</html>"