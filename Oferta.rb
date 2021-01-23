require 'csv'

class Oferta
  attr_accessor :o_titulo, :o_fecha_publicacion, :o_descripcion, :o_salario, :o_postulantes, :o_habilidades

  # def initialize(titulo, fecha_publicacion, descripcion, salario, postulantes, habilidades)
  #   @o_titulo = titulo
  #   @o_fecha_publicacion = fecha_publicacion
  #   @o_descripcion = descripcion
  #   @o_salario = salario
  #   @o_habilidades = habilidades
  # end
  def initialize
    @o_titulo = nil
    @o_fecha_publicacion = nil
    @o_descripcion = nil
    @o_salario = nil
    @o_habilidades = nil
  end
#   def registrar()
#     File.open("valores.csv", "a") do |file| 
#       linea = "#{@nombre},#{@link},#{@nivel},#{@tipo},#{@institucion},#{@calificacion}\n"
#       file.write(linea)
#       file.close
#     end
#   end
def registrarCSV(titulo, fecha_publicacion, descripcion,salario,habilidades)
  @o_titulo = titulo
  @o_fecha_publicacion = fecha_publicacion
  @o_descripcion = descripcion
  @o_salario = salario
  @o_habilidades = habilidades
  csv = CSV.open('plazas.csv', 'a')
  csv << [@o_titulo , @o_fecha_publicacion , @o_descripcion , @o_salario , @o_habilidades]
end

end
