require './Oferta.rb'
require 'nokogiri'
require 'open-uri'
require 'net/http'

class Scraper
  def extraer(tema)
    puts tema
    url = 'https://www.freelancer.es/jobs/?keyword='+tema
    puts url
    contenido_pars = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    # puts contenido_pars
    oferta = Oferta.new
    contenido_pars.css('.JobSearchCard-list').css('.JobSearchCard-item').each do |fila|
      titulo = fila.css('.JobSearchCard-primary-heading-link').inner_text.strip
      #puts titulo
      descripcion = fila.css('.JobSearchCard-primary-description').inner_text.strip.tr("\n"," ")
      # print descripcion
      fechaP = fila.css('.JobSearchCard-primary-heading-days').inner_text
      # puts fechaP
      habilidades = []
      fila.css('.JobSearchCard-primary-tagsLink').each do |skills|
        skills = skills.inner_text.split("/\n/")
        habilidades.append(skills[0])
      end
      # puts lista
      salario = fila.css('.JobSearchCard-primary-price').inner_text.strip
      salarioN = ''
      if salario.end_with?('(Avg Bid)')

        salario = salario.split(' ')
        if salario[1] == '/'
          # puts "por hora"
          salario = salario[0][1..-1].to_f * 1.22
          salarioN=salario.to_s + '/hr'
          #puts salarioN.to_s + '/hr'
        else
          # puts "promedio"
          # salarioN= salario[0].to_f
          salarioN = salario[0][1..-1].to_f * 1.22
          #puts salarioN.to_s
        end
        # print salario[0..-1]
      else
        salario = salario.split(' ')
        # puts salario[0],salario[1],salario[2]
        if (salario[1] == '-') && (salario[3] == '/')
          # puts "rangos del else"
          limitI = salario[0][1..-1].to_f * 1.22
          limitF = salario[2][1..-1].to_f * 1.22
          salarioN = limitI.to_s + '-' + limitF.to_s + "/h"
          #puts salarioN + '/h'
        else
          # puts "rangos"
          limitI = salario[0][1..-1].to_f * 1.22
          limitF = salario[2][1..-1].to_f * 1.22
          salarioN = limitI.to_s + '-' + limitF.to_s
          #puts salarioN
        end
      end
      oferta.registrarCSV(titulo, fechaP, descripcion,salarioN,habilidades)
    end
  end
end
