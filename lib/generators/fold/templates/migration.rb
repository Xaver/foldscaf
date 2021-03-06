class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    create_table :<%= table_name %> do |t|
<% estandar_attributes.each do |attribute| -%>
      t.<%= attribute.type %> :<%= attribute.name %><%= attribute.inject_options %>
<% end -%>
<% imagen_attributes.each do |attribute| -%>
      t.string :<%= attribute.name %>_uid, :<%= attribute.name %>_name
<% end -%>
<% reference_attributes.each do |attribute| -%>
      t.references :<%= attribute.name %><%= attribute.inject_options %>
<% end -%>

<% if options.ordenable? %>
      t.integer :orden
<% end -%>
<%- if options.sluggable? -%>
      t.string :slug
<% end -%>
      t.timestamps
    end
<% attributes_with_index.each do |attribute| -%>
    add_index :<%= table_name %>, :<%= attribute.index_name %><%= attribute.inject_index_options %>
<% end -%>
<%- if options.sluggable? -%>
    add_index :<%= table_name %>, :slug, :unique => true
<% end -%>
  end
end