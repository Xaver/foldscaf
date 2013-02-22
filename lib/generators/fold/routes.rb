module Routes

  def aplicar_rutas
    ruta_publica
    ruta_admin
  end

  private

  def ruta_admin
    ruta = "\nresources :#{@name.tableize}"
    ruta += concerns
    ruta += "\n"
    inject_into_file 'config/routes.rb', ruta, :after => /namespace :admin do/
  end

  def ruta_publica
    ruta = "\nresources :#{@name.tableize}\n"
    inject_into_file 'config/routes.rb', ruta, :before => /namespace :admin do/
  end

  def concerns
    modulos = []
    modulos.push ":ordenable" if options.ordenable?
    modulos.push ":archivable" if options.archivable?
    return ", :concerns => [#{modulos.compact.join(", ")}]" if modulos.present?
  end

end