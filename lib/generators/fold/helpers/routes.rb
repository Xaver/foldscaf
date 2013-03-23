module Fold
  module Routes

    def aplicar_rutas
      ruta_admin
      ruta_publica
    end

    private

    def ruta_admin
      ruta = "\n    resources :#{table_name}"
      ruta += concerns.to_s
      inject_into_file 'config/routes.rb', ruta, :after => /namespace :admin do/
    end

    def ruta_publica
      ruta = "resources :#{table_name}\n\n  "
      inject_into_file 'config/routes.rb', ruta, :before => /namespace :admin do/
    end

    def concerns
      modulos = []
      modulos.push ":ordenable" if options.ordenable?
      modulos.push ":archivable" if options.archivable?
      return ", :concerns => [#{modulos.compact.join(", ")}]" if modulos.present?
    end

  end
end