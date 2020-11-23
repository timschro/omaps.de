#encoding: utf-8
class Map < ActiveRecord::Base

  belongs_to :club
  belongs_to :map_type
  belongs_to :discipline



  has_many_attached :images
  attr_accessor :remove_images




  has_paper_trail

  default_scope { where("lat > 0") }

  scope :published, -> { where(published: true) }

  scope :visible, -> { where("lat > 0") }




  # Validations
  validates :title, :scale, :contours, :year, :mapper, :map_type, :club, :lat, :lng, :presence => true

  # Format

  validates :scale, :year, numericality: { only_integer: true }
  validates :lat, :lng, :contours, numericality: true

  before_save :add_editor


  after_initialize do |obj|
   # obj.last_editor_id = nil
  end



  def to_param
    url
  end


  #getter/setter

  def price=(val)
    write_attribute(:price, val.to_s.gsub(I18n.t('number.format.separator'), '.'))
  end

  def scale=(val)
    write_attribute(:scale, val.to_s.gsub('1:', ''))
  end

  def contours=(val)
    write_attribute(:contours, val.to_s.gsub(I18n.t('number.format.separator'), '.'))
  end

  def lat=(val)
    write_attribute(:lat, val.to_s.gsub(I18n.t('number.format.separator'), '.'))
  end

  def lng=(val)
    write_attribute(:lng, val.to_s.gsub(I18n.t('number.format.separator'), '.'))
  end



  def belongs_to_user user
    !self.versions.where(whodunnit: user.id.to_s).empty?
  end

  def add_editor
    logger.debug("add_editor?")
    if last_editor_id_changed?
      logger.debug("last_editor_id_changed?")
      PaperTrail.request(whodunnit: last_editor_id.to_s) do
        restore_last_editor_id!
        paper_trail.save_with_version
      end

    end
  end

  after_save do
    Array(remove_images).each do |id|
      images.find_by_id(id).try(:purge)
    end
  end

  rails_admin do
    group :info do
      label "Karteninformationen"
    end
    group :geo do
      label "Geografie"
    end
    group :files do
      label "Bilder und Downloads"
    end
    group :contact do
      label "Kontakt"
    end
    group :meta do
      label "Administratives"
    end
    field :title do
      group :info
    end
    field :club do
      group :info
    end
    field :discipline do
      group :info
    end
    field :map_type do
      group :info
    end
    field :year do
      group :info
    end
    field :mapper do
      group :info
    end
    field :scale do
      group :info
      # formatted_value do
      #   "1:#{value}"
      # end
      # pretty_value do
      #   "1:#{value}"
      # end
      help 'Erforderlich. Angabe von 1:xxxxxx. Bitte nur die Maßstabszahl eintragen, also z.B. 15000 oder 4000.'
    end
    field :contours do
      group :info

      formatted_value do
        value.to_s.gsub('.', I18n.t('number.format.separator'))
      end
      pretty_value do
        value.to_s.gsub('.', I18n.t('number.format.separator'))
      end
      help 'Erforderlich. Angabe in Metern. Komma erlaubt. Bitte den reinen Zahlenwert, ohne Meter-Angabe, eintrage. Z.B.: 5 oder 2,5.'
    end
    field :description do
      group :info
    end
    field :lat, :map do
      longitude_field :lng
      mapbox_api_key 'pk.eyJ1Ijoib3JpZW50ZXJhcmUiLCJhIjoiTDg0RE5WZyJ9.OyBqycEeIbDxvsFSP0Pzbw'
      mapbox_style 'mapbox://styles/orienterare/cj731u0fm264z2sqh47snx9ep'
      group :geo
    end
    field :images, :multiple_active_storage do
      group :files
    end
    field :contact_email do
      group :contact
    end
    field :website do
      group :contact
    end
    field :published do
      group :meta
      help 'Wenn aktiviert erscheint die Karte in der Übersicht und in der Suche.'
    end
    field :identifier do
      group :meta
      help 'Bitte Karten ID in der Form "GER-HH201901" eintragen falls verfügbar.'
      visible do
        bindings[:view]._current_user.admin?
      end
    end

    field :created_at do
      group :meta
      read_only true
      help ''
    end

    field :updated_at do
      group :meta
      read_only true
      help ''
    end


    list do
      exclude_fields :created_at,
                     :updated_at,
                     :mapper,
                     :contours,
                     :lat,
                     :lng,
                     :website,
                     :description,
                     :contact_email,
                     :google_map,
                     :images,
                     :size,
                     :approved

      field :identifier do
        column_width 130
      end
      field :club do
        column_width 150
      end
      field :year do
        column_width 50
      end
      field :scale do
        column_width 70
      end
      field :published do
        column_width 20
      end
    end
  end
end
