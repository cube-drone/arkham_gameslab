require 'optparse' 
require 'yaml'

CARDS_PER_PAGE = 8

# 1. Get Options. 
options = {} 

optparse = OptionParser.new {|opts|
    opts.banner = "Usage: deck_generator.rb --file FILENAME"

    options[:filenames] = ""
    opts.on( '-f', '--file a,b,c', Array, 'File' ) {|file| options[:filenames] = file } 

    options[:stylesheet] = "style.css" 
    opts.on( '-s', '--stylesheet FILENAME', 'The name of the stylesheet.') { |filename| options[:stylesheet] = filename } 
    
    options[:reprint_list] = []
    opts.on( '-r', '--reprint a,b,c', Array, 'A list of specific cards to reprint.') { |reprint| options[:reprint_list] = reprint } 

    opts.on("-h", "--help", "Show this message"){
        puts opts
        exit
    }
}
optparse.parse!

if (options[:filenames].length == 0) then
    puts optparse
    exit
end

reprint = false
if (options[:reprint_list].length > 0 ) then 
    reprint = true
end

# 3. Display Deck
puts "<!DOCTYPE html>"
puts "<html>"
puts "\t<link href='http://fonts.googleapis.com/css?family=Gudea:400,700,400italic|Waiting+for+the+Sunrise|Stint+Ultra+Expanded|Share:400,400italic,700,700italic' rel='stylesheet' type='text/css'>"
puts "\t<meta charset='utf-8'>"
puts "\t<style>

*{
    /* Leave my colors the way you found them, webkit. */
    -webkit-print-color-adjust:exact;
    text-rendering: optimizeLegibility;
}

body{
    margin: 0;
    padding: 0;
    color: #333;
}

.Page{
    padding: 20px;
    overflow: hidden;
    page-break-before: always;
}

.Card{
    /* You're going to want to overwrite a lot of these. */
    width: 216px;
    height: 302px;
    border: 1px solid gray;
    float: left;
    margin-left: 2mm;
    margin-bottom: 10mm;
    overflow: hidden;
    text-align: center;
    position: relative;
    background-size: 216px 302px;
}

</style>
"
puts "\t<link rel='stylesheet' href='"+options[:stylesheet]+"' />" 
puts "<body>"
puts "<div class='Page'>" 

# 2. Parse Deck

pagecounter = 0
options[:filenames].each do |filename| 

    thing = YAML.load_file( filename )

    category = thing["Title"] ||= "Deck" 

    thing.each do |key, value|
        next if value.class == String
        next if reprint and (not options[:reprint_list].include?(key) and not options[:reprint_list].include?(category) )
        quantity = value["Quantity"] ||= 1
        title = value["Title"] ||= key
        image = value["Image"] ||= ""
        special = value["Special"] ||= ""
        flavor = value["Flavor"] ||= ""
        type = value["Type"] ||= ""
        remaining_values = value.reject{ |key, value| ["Quantity", "Title", "Image", "Special", "Flavor", "Type"].include?(key) }
        sorted_remaining_values = remaining_values.sort{ |a, b| a[0].split(" ")[-1] <=> b[0].split(" ")[-1] } 
        
        quantity.times do 
            puts "\t<div class='Card " + category + " " + title + " " + type + "'>"
            puts "\t\t<h2 class='category'>" + category + " </h2>" unless category == ""
            puts "\t\t<h3 class='title'>" + title + " </h3>"
            puts "\t\t<img src='"+image+"' /> " unless image == "" 
            puts "\t\t<p class='special'>" + special + "</p>" unless special == "" 
            sorted_remaining_values.each { |other_value_name, other_value| puts "\t\t<p class='"+other_value_name.to_s.downcase + "'><strong>"+ other_value_name.to_s + "</strong>: " + other_value.to_s + " </p>" }
            puts "\t\t<p class='flavor'><em>" + flavor + "</em></p>" unless flavor == "" 
            puts "\t\t<div class='type'>" + type + "</div>" unless type == "" 
            puts "\t</div>"
            pagecounter += 1
            puts "<div style='clear:both'> </div> </div><div class='Page'>" if pagecounter % CARDS_PER_PAGE == 0
        end
    end
end

puts "</body>"
puts "</html>"
