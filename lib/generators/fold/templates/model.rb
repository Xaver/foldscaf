<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>

  ##############################################################################
  #### CONFIGURACIONES Y RELACIONES
  ##############################################################################
<% if options.sluggable? %>
  extend FriendlyId
  friendly_id <%= ":#{attributes.first.name}" if attributes.first.name != "nombre" %>
<%- end -%>
<% if attributes.any? %>
  attr_accessible <%= attributes.map { |a| ":#{a.name}#{"_id" if a.reference?}" }.join(', ') %>
<%- end -%>
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
<% if options.archivable? %>
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

end
<% end -%>
