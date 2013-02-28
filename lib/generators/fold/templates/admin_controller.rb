# -*- encoding : utf-8 -*-
<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class Admin::<%= controller_class_name %>Controller < <%= parent_controller_name(:admin) %>
<% if !options.padre? -%>
  load_and_authorize_resource
<% end -%>
<%- if options.ordenable? -%>
  include Ordenable
<%- end -%>

  def index
    # @q = <%= singular_table_name.camelize %>.search params[:q]
    # @<%= plural_table_name %> = @q.relation.page(params[:page]).per(50)
    @<%= plural_table_name%> = <%= singular_table_name.camelize %>.page(params[:page]).per(50)
  end

  def new
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>
    @<%= orm_instance.save %>!
    redirect_to [:admin, :<%= plural_table_name %>], notice: mensaje
  end

  def edit
  end

  def update
    @<%= singular_table_name %>.update_attributes! params[:<%= singular_table_name %>]
    redirect_to [:edit, :admin, @<%= singular_table_name %>], notice: mensaje
  end

  def destroy
    @<%= orm_instance.destroy %>
    mensaje
  end

<%- if options.ordenable? -%>
  private

  def sort_coleccion
    <%= orm_class.all(class_name) %>
  end

<%- end -%>
end<%- end -%>