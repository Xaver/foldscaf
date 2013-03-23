module Fold
  module Paths

    def paths
      {
        :index => [:admin, table_name.to_sym],
        :new => [:new, :admin, file_name.to_sym],
        :reordenar => [:reordenar, :admin, table_name.to_sym]
      }
    end

    def model_path
      File.join 'app/models', class_path, "#{file_name}.rb"
    end

    def controller_path(namespace = nil)
      File.join 'app/controllers', namespace.to_s, class_path, "#{controller_file_name}_controller.rb"
    end

    def migration_path
      File.join 'db/migrate', "create_#{table_name}.rb"
    end

    def view_path(action, namespace = nil)
      File.join 'app/views', namespace.to_s, class_path, table_name, "#{action}.erb"
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
end