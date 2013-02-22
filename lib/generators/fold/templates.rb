module Templates

  def aplicar_templates
    models
    migrations
    controllers
    views
  end

  private

  def models
    template 'model.erb', model_path(@name)
  end

  def migrations
    template 'migration.erb', migration_path(@name)
  end

  def controllers
    template 'controller.erb', controller_path(@name)
    template 'admin_controller.erb', controller_path(@name, :admin)
  end

  def views
    %w[_form edit index new].each do |action|
      action += ".html"
      template File.join('views', "#{action}.erb"), view_path(@name, action, :admin)
    end
    template "views/nombre.html.erb", view_path(@name, "_#{@name.underscore}.html", :admin)
  end

end