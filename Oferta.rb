require 'csv'

class Oferta
  attr_accessor :o_titulo, :o_fecha_publicacion, :o_descripcion, :o_salario, :o_postulantes, :o_habilidades


  

  def initialize(titulo, fecha_publicacion, descripcion, salario, habilidades)
    @o_titulo = titulo
    @o_fecha_publicacion = fecha_publicacion
    @o_descripcion = descripcion
    @o_salario = salario
    @o_habilidades = habilidades
  end
  

  def registrarWorkana()
      # File.open("workana.csv", "a") do |file| 
      # linea = "#{@o_titulo},#{@o_fecha_publicacion},#{@o_descripcion},#{@o_salario},#{@o_habilidades}\n"
      # file.write(linea)
      # file.close
      csv = CSV.open("workana.csv", "a" )
      csv << [@o_titulo, @o_fecha_publicacion, @o_descripcion, @o_salario, @o_habilidades]
      csv.close
  end

  
  def registrarFreelancer()
    csv = CSV.open('freelancer.csv', 'a')
    csv << [@o_titulo, @o_fecha_publicacion, @o_descripcion , @o_salario, @o_habilidades]
    
  end


end