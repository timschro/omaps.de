#encoding: utf-8
class Map < ActiveRecord::Base

  belongs_to :club
  belongs_to :map_type

  has_many :images, :dependent => :destroy

  has_many :comments

  default_scope { where("lat > 0") }

  scope :published, -> { where(published: true) }
  scope :published_and_approved, -> { published.where(approved: true) }





  belongs_to :submitter, :class_name => 'User'
  belongs_to :last_editor, :class_name => 'User'


  acts_as_url :title, :url_attribute => :url, :only_when_blank => true, :sync_url => false, :allow_duplicates => false


  # Validations

  # Presence for steps
  validates :title, :scale, :contours, :year, :mapper, :map_type_id, :map_type, :presence => true
  validate :validate_club_name_or_relation
  validates :lat, :lng, :presence => true

  # Format
  validates :scale, :year, :numericality => { :only_integer => true }
  validates :contours, :numericality => true
  validates :lat, :lng, :numericality => true




  def validate_club_name_or_relation
    if club_id.nil? && club_name.blank?
      errors.add(:club_name, "can't be blank")
    end
  end



  def to_param
    url
  end



  def icon_path
    mt=self.map_type
    return mt.icon unless mt.nil? || mt.icon.nil? || mt.icon.empty?
    "forest.png"
  end


  #getter/setter


  def address
    [city, region, "Germany"].compact.join(', ')
  end

  def address=(value)
    city    = value.city if city.nil? || city.empty?
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


  def images_array=(array)
    array.each do |file|
      res=images.build(:attachment => file)
    end
  end

  def images_urls
    # res = []
    # images.each do |i|
    #   res << i.attachment.url(:medium)
    # end
    # res
  end

  rails_admin do

      exclude_fields :worldofo, :imported, :url, :city, :zip, :region, :comment, :worldofo_id, :download_file_name, :download_content_type, :download_file_size, :download_updated_at, :comments, :status
  end


end
