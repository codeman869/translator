require 'httparty'
require 'nokogiri'
require 'csv'


APP_NAME = "Translator v1.0"

class DictCC

	include HTTParty
	base_uri "http://dict.cc"
	headers "User-agent" => APP_NAME


end

def lookup(word)
	response = DictCC.get("/", :query => {:s => "#{word}"})
	if response.code == 200
		begin
			doc = Nokogiri::HTML(response.body)
		
			doc.css("#tr1").css("td")[1].css("a").map{|k| k.text}.join(" ") 
		rescue => e
			puts "Error #{e}"
			e
		end
	end
end


rows = CSV.read("words.csv")

rows.each do |k|
	puts "Looking up #{k[0]}"
	CSV.open("final.csv","a") do |csv|

		csv << [k[0], lookup(k[0])]
	end

	


end

puts "finished"

