# -*- encoding : utf-8 -*-
require 'rails/generators/active_record'
require 'rails/generators/resource_helpers'
require 'generators/fold/helpers/fold'

class FoldGenerator < ActiveRecord::Generators::Base
  include Rails::Generators::ResourceHelpers
  include Fold

  source_root File.expand_path('../templates', __FILE__)

  check_class_collision

  argument :attributes, :type => :array, :required => true, :banner => "nombre descripcion contenido:text es_destacado:boolean:index precio:decimal{15.2}"

  class_option :ordenable, :desc => 'el modelo se puede reordenar', :type => :boolean, :aliases => "-O", :default => false
  class_option :archivable, :desc => 'el modelo tiene archivos', :type => :boolean, :aliases => "-A", :default => false
  class_option :sluggable, :desc => 'el modelo tiene una url amigable', :type => :boolean, :aliases => "-S", :default => false
  class_option :rake, :desc => "crear archivo rake", :type => :boolean, :aliases => "-R", :default => false
  class_option :padre, :desc => "el padre del modelo", :type => :string, :aliases => "-P"

  class_option :orm, :type => :string, :required => true

  def initialize(*arguments, &block)
    super
    @paths = paths
  end

  def ejecutar
    aplicar_templates
    aplicar_rutas
  end

  def navegacion
    insert_into_file "app/views/admin/admin/_nav_lateral.html.erb", "\n    <li><%= link_to '#{plural_name.humanize}', #{@paths[:index]} if can? :index, #{class_name} %></li>", :after => '<li class="nav-header">General</li>'
  end

  def rake_cargar_todo
    insert_into_file "lib/tasks/cargar_todo.rake", "\n    cargar :#{table_name}", :before => "\n    puts 'Listo!'" if options.rake?
  end

  private

  def attributes_with_index
    attributes.select { |a| a.has_index? || a.reference? }
  end

  def reference_attributes
    attributes.select &:reference?
  end

  def imagen_attributes
    attributes.select { |a| a.type == :imagen }
  end

  def estandar_attributes
    attributes - reference_attributes - imagen_attributes
  end

  def listable_attributes
    estandar_attributes + reference_attributes
  end

  def accessible_attributes
    array = estandar_attributes.map { |a| ":#{a.name}" }
    array.push imagen_attributes.map { |a| [":#{a.name}", ":remove_#{a.name}"] }
    array.push reference_attributes.map { |a| ":#{a.name}_id" }
    array.push [":adjuntos_attributes", ":fotos_attributes", ":videos_attributes"] if options.archivable?
    array.flatten.join(', ')
  end

  def parent_class_name
    options[:padre] || "ActiveRecord::Base"
  end

  def parent_controller_name(namespace = nil)
    if options.padre?
      [namespace.to_s.camelize, options[:padre].pluralize.camelize + "Controller"].compact.join("::")
    elsif namespace.present?
      [namespace.to_s.camelize, namespace.to_s.camelize + "Controller"].join("::")
    else
      "ApplicationController"
    end
  end

end
