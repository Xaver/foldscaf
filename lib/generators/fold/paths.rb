module Paths

  def generar_restful_paths(nombre_recurso)
    {
      :index => [:admin, nombre_recurso.tableize.to_sym],
      :new => [:new, :admin, nombre_recurso.underscore.to_sym],
      :reordenar => [:reordenar, :admin, nombre_recurso.tableize.to_sym]
    }
  end

  def model_path(nombre_recurso)
    File.join 'app', 'models', "#{nombre_recurso.underscore}.rb"
  end

  def controller_path(nombre_recurso, namespace = nil)
    File.join 'app', 'controllers', namespace.to_s, "#{nombre_recurso.tableize}_controller.rb"
  end

  def migration_path(nombre_recurso)
    File.join 'db', 'migrate', "#{fecha}_create_#{nombre_recurso.tableize}.rb"
  end

  def view_path(nombre_recurso, vista, namespace = nil)
    File.join 'app', 'views', namespace.to_s, nombre_recurso.tableize, "#{vista}.erb"
  end

  private

  def fecha
    Time.zone.now.strftime("%Y%m%d%H%M%S")
  end

  def self.next_migration_number(dirname) #:nodoc:
    if ActiveRecord::Base.timestamped_migrations
      Time.zone.now.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

end