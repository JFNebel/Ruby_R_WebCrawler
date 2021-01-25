require 'open-uri'
require 'nokogiri'
require_relative 'ScraperFreelancer' 
require_relative "ScraperWorkana"

puts "Ingrese el tema que desea recolectar: "
tema = gets()

puts "Los resultados para #{tema} han sido guardados en su csv! "
puts ""

scraperW = ScraperWorkana.new  
scraperF = Scraper.new
scraperW.extraer(tema)
scraperF.extraer(tema)

