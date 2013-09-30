class Spree::CmsImage < ActiveRecord::Base

  belongs_to :imageable, polymorphic: true

  # dragonfly
  image_accessor :file

  attr_accessible :retained_file, :file_url, :remove_file, :alt, :name

  validates :name, :file, presence: true
  validates_size_of :file, maximum: 3.megabytes
  validates_property :format, of: :file, in: [:jpeg, :jpg, :png, :gif]

  class << self
    def replace_tokens(str)
      str ||= ''
      # 1. check body text for any [image] tokens (which should look like
      # [image:123 300x300]) and flip them to <img> tags
      # 2. cache it
      matches = str.scan(/(\[image:(\d+)\ (\d+x\d+[#]?)\])/)
      cached = str
      if matches.any?
        matches.each do |token|
          tok = token[0]
          img_id = token[1].to_i
          resize_str = token[2]
          if thumb = Spree::CmsImage.find_by_id(img_id)
            processed = thumb.file.thumb(resize_str)
            # TODO: add width / height / alt attributes
            cached.gsub!(tok, %(<img src="#{processed.url}" alt="#{thumb.alt}" width="#{processed.width}" height="#{processed.height}" />))
          else
            # TODO: display a 'missing' image or something?
            # log an error?
          end
        end
      end
      cached
    end
  end

end
