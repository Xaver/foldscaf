<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>

  ##############################################################################
  #### CONFIGURACIONES Y RELACIONES
  ##############################################################################
<% if options.sluggable? %>
  extend FriendlyId
  friendly_id <%= ":#{attributes.first.name}" if attributes.first.name != "nombre" %>
<%- end -%>
<% if accessible_attributes.present? %>
  attr_accessible <%= accessible_attributes %>
<%- end -%>
<% if imagen_attributes.any? %>
  after_create :guardar_archivos!
<% end -%>
<% reference_attributes.each do |attribute| %>
  belongs_to :<%= attribute.name %>
<%- end -%>
<% if options.archivable? %>
  has_many :archivos, :as => :propietario, :dependent => :destroy
  has_many :fotos, :as => :propietario
  has_many :adjuntos, :as => :propietario
  has_many :videos, :as => :propietario
  accepts_nested_attributes_for :fotos, :adjuntos, :videos
<% end %>
<%- imagen_attributes.each do |attribute| -%>
  image_accessor :<%= attribute.name %> do
    storage_path { |f| File.join carpeta, "<%= attribute.name %>-#{rand(10000)}.#{f.format}" }
  end
<% end %>
  ##############################################################################
  #### SCOPES Y VALIDACIONES
  ##############################################################################
<% if options.ordenable? %>
  default_scope -> { order{orden} }
<% else %>
  default_scope -> { order{<%= attributes.first.name %>} }
<% end %>
  ##############################################################################
  #### MÉTODOS PÚBLICOS
  ##############################################################################
<% if options.archivable? || imagen_attributes.any? %>
  def carpeta
    File.join Rails.env, self.class.name.tableize, id.to_s
  end
<% end %>
  def se_puede_eliminar?
    true
  end

  def destroy
    super if se_puede_eliminar?
  end

  ##############################################################################
  #### ALIAS E IMPRESIONES
  ##############################################################################

  alias_attribute :to_label, :<%= attributes.first.name %>
  alias_attribute :to_s, :<%= attributes.first.name %>

  ##############################################################################
  #### MÉTODOS PRIVADOS
  ##############################################################################

  private
<% if imagen_attributes.any? %>
  def guardar_archivos!
    update_attributes! <%= imagen_attributes.map { |a| ":#{a.name} => #{a.name}" }.join(", ") %>
  end
<% end -%>
end
<% end -%>
