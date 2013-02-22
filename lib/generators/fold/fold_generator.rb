# -*- encoding : utf-8 -*-
require 'generators/fold/atributo'
require 'generators/fold/paths'
require 'generators/fold/templates'
require 'generators/fold/routes'

class FoldGenerator < Rails::Generators::NamedBase
  include Paths
  include Templates
  include Routes

  source_root File.expand_path('../templates', __FILE__)

  argument :args, :type => :array, :default => [], :banner => "nombre descripcion contenido:text es_destacado:boolean:true"

  class_option :ordenable, :desc => 'el modelo se puede reordenar', :type => :boolean, :aliases => "-O", :default => false
  class_option :archivable, :desc => 'el modelo tiene archivos', :type => :boolean, :aliases => "-A", :default => false
  class_option :sluggable, :desc => 'el modelo tiene una url amigable', :type => :boolean, :aliases => "-S", :default => false

  def initialize(*arguments, &block)
    super

    @admin_paths = generar_restful_paths(@name)

    @atributos = []
    arguments.first.drop(1).each do |arg|
      @atributos << Atributo.new(arg)
    end
    @identificador = @atributos.first.nombre

  end

  def ejecutar
    aplicar_templates
    aplicar_rutas
  end

  private

  def atributos_con_referencia
    @atributos.select {|a| a.clase == :references}
  end

end
