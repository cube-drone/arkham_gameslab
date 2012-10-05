require 'optparse' 
require 'yaml'

options = {} 

optparse = OptionParser.new {|opts|
    opts.banner = "Usage: distanceOdds.rb --file FILENAME"

	options[:filenames] = ""
    opts.on( '-f', '--file a,b,c', Array, 'File' ) {|file| options[:filenames] = file } 
	
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

options[:filenames].each do |filename| 
    thing = YAML.load_file( filename )

	distanceMap = Hash.new(0)
	total = 0
    thing.each do |key, value|
		next if value.class == String
		
		thisDistance = value["Distance"]
		
		quantity = value["Quantity"]
		quantity = 1 if quantity == nil
		
		distanceMap[thisDistance]+=quantity
		total +=quantity
		puts key if thisDistance == nil
	end
	
	distanceMap = Hash[distanceMap.sort]
	distanceMap.each do |distance, distanceCount|
		puts "Count of distance " + distance.to_s + ": " + distanceCount.to_s + ", odds: " + (distanceCount.to_f/total.to_f).to_s
	end
	puts "Total: " + total.to_s
end

