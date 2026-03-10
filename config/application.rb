require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module ContractsApp
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w(assets tasks))
    
    # Timezone
    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :utc
    
    # Locale
    config.i18n.default_locale = :'pt-BR'
    config.i18n.available_locales = [:'pt-BR', :en]
    
    # Active Job
    config.active_job.queue_adapter = :sidekiq
  end
end
