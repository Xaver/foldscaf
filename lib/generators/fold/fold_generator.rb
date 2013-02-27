# -*- encoding : utf-8 -*-
require 'rails/generators/active_record'
require 'rails/generators/resource_helpers'
require 'generators/fold/helpers/fold'

class FoldGenerator < ActiveRecord::Generators::Base
  include Rails::Generators::ResourceHelpers
  include Fold

  source_root File.expand_path('../templates', __FILE__)

  check_class_collision

  argument :attributes, :type => :array, :default => [], :banner => "nombre descripcion contenido:text es_destacado:boolean:index precio:decimal{15.2}"

  class_option :ordenable, :desc => 'el modelo se puede reordenar', :type => :boolean, :aliases => "-O", :default => false
  class_option :archivable, :desc => 'el modelo tiene archivos', :type => :boolean, :aliases => "-A", :default => false
  class_option :sluggable, :desc => 'el modelo tiene una url amigable', :type => :boolean, :aliases => "-S", :default => false
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

  private

  def attributes_with_index
    attributes.select { |a| a.has_index? || a.reference? }
  end

  def accessible_attributes
    attributes.reject &:reference?
  end

  def parent_class_name
    options[:padre] || "ActiveRecord::Base"
  end

  def parent_controller_name(namespace = nil)
    if options.padre?
      [namespace.to_s, options[:padre].camelize + "Controller"].compact.join("::")
    elsif namespace.present?
      [namespace.to_s, namespace.to_s.camelize + "Controller"].join("::")
      "Admin::AdminController"
    else
      "ApplicationController"
    end
  end

end