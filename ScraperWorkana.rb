require 'net/http'
require 'open-uri'
require 'json'
require 'nokogiri'
require_relative 'Oferta' 

# Referencia util para el futuro: https://www.rubyguides.com/2018/01/ruby-string-methods/


class ScraperWorkana
  
  def initialize
  end

  def extraer(tema)
    num_pagina = 1
    fp = File.open("workana.csv", "w") # --> Solo para reiniciar el archivo 
    while num_pagina < 8
        # puts "El número de página es: #{num_pagina}" 
        url = "https://www.workana.com/jobs?language=en&skills=#{tema}&page=#{num_pagina}"
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

            #RECOLECTANDO EL ATRIBUTO HABILIDADES
            habilidades = []
            arreglo_skills = i.css('.skills').at_css('label-expander')[':to-expand']
            data = JSON.parse(arreglo_skills)
            data.each do |j|
                habilidad = j['anchorText']
                habilidades.append(habilidad)
            end

            #REGISTRO EN EL CSV
            oferta = Oferta.new(titulo, fecha_publicacion, descripcion, salario, habilidades) 
            oferta.registrarWorkana()

            #PRUEBAS POR CONSOLA
            #puts "Título: #{oferta.o_titulo}"

        end
        num_pagina = num_pagina + 1
    
    end
    fp.close()

   end

end
