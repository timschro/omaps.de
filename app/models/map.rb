#encoding: utf-8
class Map < ActiveRecord::Base

  belongs_to :club
  belongs_to :map_type

  has_many_attached :images
  attr_accessor :remove_images




  has_many :comments

  has_paper_trail

  default_scope {where("lat > 0")}

  scope :published, -> {where(published: true)}
  scope :published_and_approved, -> {published.where(approved: true)}


  belongs_to :submitter, :class_name => 'User'
  belongs_to :last_editor, :class_name => 'User'


  acts_as_url :title, :url_attribute => :url, :only_when_blank => true, :sync_url => false, :allow_duplicates => false


  # Validations

  # Presence for steps
  validates :title, :scale, :contours, :year, :mapper, :map_type_id, :map_type, :presence => true
  validate :validate_club_name_or_relation
  validates :lat, :lng, :presence => true

  # Format
  validates :scale, :year, :numericality => {:only_integer => true}
  validates :contours, :numericality => true
  validates :lat, :lng, :numericality => true


  serialize :google_map, JSON


  def validate_club_name_or_relation
    if club_id.nil? && club_name.blank?
      errors.add(:club_name, "can't be blank")
    end
  end


  def to_param
    url
  end


  def icon_path
    mt = self.map_type
    return mt.icon unless mt.nil? || mt.icon.nil? || mt.icon.empty?
    "forest.png"
  end


  #getter/setter


  def address
    [city, region, "Germany"].compact.join(', ')
  end

  def address=(value)
    city = value.city if city.nil? || city.empty?
    zip = value.postal_code
    region = value.state
  end

  def city
    val = read_attribute(:city)
    return "" if val.nil?
    val
  end

  def region
    val = read_attribute(:region)
    return "" if val.nil?
    val
  end


  def price=(val)
    write_attribute(:price, val.to_s.gsub(I18n.t('number.format.separator'), '.'))
  end

  def contours=(val)
    write_attribute(:contours, val.to_s.gsub(I18n.t('number.format.separator'), '.'))
  end




  after_save do
     Array(remove_images).each do |id|
      images.find_by_id(id).try(:purge)
    end
  end

  rails_admin do
    exclude_fields :id, :worldofo, :google_map, :submitter_email, :price, :size, :count, :access_permission_needed, :imported, :url, :city, :zip, :region, :comment, :worldofo_id, :download_file_name, :download_content_type, :download_file_size, :download_updated_at, :comments, :status
    field :submitter do
      read_only true
    end
    field :last_editor do
      read_only true
    end
    field :created_at do
      read_only true
    end

    field :updated_at do
      read_only true
    end
    field :lat do
      help 'Erforderlich. Bitte vorerst die Koordinate der Karte im Dezimalformat manuell eintragen. Ein Auswahlmechanismus wird später bereitgestellt.'
    end

    field :lng do
      help 'Erforderlich. Bitte vorerst die Koordinate der Karte im Dezimalformat manuell eintragen. Ein Auswahlmechanismus wird später bereitgestellt.'
    end

    field :images, :multiple_active_storage

    list do
      exclude_fields :created_at, :updated_at, :mapper, :contours, :lat, :lng, :website, :description, :contact_email, :google_map, :images, :size, :approved, :submitter, :last_editor
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

    # edit do
    #   field :google_map, :google_map do
    #     google_api_key 'AIzaSyApg5YWYo8a9avXl-ICqdgaEoTqt9mz53w'
    #     default_latitude -34.0
    #     default_longitude 151.0
    #     locale 'de'
    #   end
    # end
  end


end
