module Fold
  module Templates

    def aplicar_templates
      models
      !options.padre? ? migrations : puts("Recuerde que debe agregar la columna :type a la tabla :#{options[:padre].tableize}")
      controllers
      views
    end

    private

    def models
      template 'model.rb', model_path
    end

    def migrations
      migration_template 'migration.rb', migration_path
    end

    def controllers
      template 'controller.rb', controller_path
      template 'admin_controller.rb', controller_path(:admin)
    end

    def views
      %w[_form edit index new].each do |action|
        action += ".html"
        template File.join('views', "#{action}.erb"), view_path(action, :admin)
      end
      template "views/_partial.html.erb", view_path("_#{file_name}.html", :admin)
    end

  end
end