class Oferta
  attr_accessor :o_titulo, :o_fecha_publicacion, :o_descripcion, :o_salario, :o_postulantes, :o_habilidades

  def initialize(titulo, fecha_publicacion, descripcion, salario, postulantes, habilidades)
    @o_titulo = titulo
    @o_fecha_publicacion = fecha_publicacion
    @o_descripcion = descripcion
    @o_salario = salario
    @o_postulantes = postulantes
    @o_habilidades = habilidades
  end

#   def registrar()
#     File.open("valores.csv", "a") do |file| 
#       linea = "#{@nombre},#{@link},#{@nivel},#{@tipo},#{@institucion},#{@calificacion}\n"
#       file.write(linea)
#       file.close
#     end
#   end


end