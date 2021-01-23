require 'net/http'
require 'open-uri'
require 'nokogiri'
require_relative 'Oferta' 

class Scraper
  
  def initialize
  end

  def extraer(tema)
    num_pagina = 1
    fp = File.open("workana.csv", "w") # --> Solo para reiniciar el archivo 
    while num_pagina < 8
        puts "El número de página es: #{num_pagina}" 
        url = "https://www.workana.com/jobs?language=en&skills=android&page=#{num_pagina}"
        parsed_content= Nokogiri::HTML(Net::HTTP.get(URI(url)))
        elements = parsed_content.css('.project-item.js-project')
        numero_elementos= elements.length() 
    
        # ITERACIÓN DE ELEMENTOS DEL CONTENEDOR DE TODOS LOS RESULTADOS 
        elements.each do |i|
            
            # RECOLECTO ATRIBUTOS 
            titulo = i.css('span').first.inner_text
            fecha_publicacion = i.css('span')[1].inner_text[24..].strip
            descripcion = i.css('.html-desc.project-details').inner_text.strip
            salario = i.css('.values').inner_text
            habilidades = []

            #REGISTRO EN OBJETO EN EL CSV
            registrar(titulo, fecha_publicacion, descripcion, salario, habilidades)

            # habilidades = []
            # puts titulo
            # puts 'Iteración del skills'
            # puts i.css('.skills label-expander')
            # i.css('.skills > div').each do |s|
            #     puts 'itera'
            #     puts s
            #     puts ''
            #     puts ''
            # end
        end
        num_pagina = num_pagina + 1
    end
    fp.close()
   end
end



def registrar(titulo, fecha_publicacion, descripcion, salario, habilidades)
    File.open("workana.csv", "a") do |file| 
    linea = "#{titulo}||#{fecha_publicacion}||#{descripcion}||#{salario}||#{habilidades}\n"
    file.write(linea)
    file.close
    end
end