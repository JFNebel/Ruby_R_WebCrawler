require 'open-uri'
require 'nokogiri'
require_relative "ScraperWorkana"

puts "Ingrese el tema que desea recolectar de Coursera: "
tema = gets()

puts "Los resultados para #{tema} son: "
puts ""

scraper = Scraper.new  
scraper.extraer(tema)


