RailsAdmin.config do |config|
  config.parent_controller = 'ApplicationController'
  config.main_app_name = %w[OMaps Administration]

  require 'i18n'
  I18n.default_locale = :de

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0
  PAPER_TRAIL_AUDIT_MODEL = %w[Map User].freeze

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  config.show_gravatar = true

  config.actions do
    dashboard do
      statistics true
    end
    index                         # mandatory
    new
    # export
    bulk_delete
    show
    edit
    delete
    # show_in_app


    history_show do
      only PAPER_TRAIL_AUDIT_MODEL
    end
  end

  config.model 'Map' do
    label 'Karte'
    label_plural 'Karten'
    weight(-1)
  end

  config.model 'MapType' do
    field :title
    list do
      field :title
      field :count do
        pretty_value do
          bindings[:object].maps.count
        end
      end
    end
  end

  config.excluded_models = %w[State Comment Image Discipline]
end
