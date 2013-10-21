class Spree::CmsImage < ActiveRecord::Base

  # dragonfly
  image_accessor :file

  belongs_to :imageable, polymorphic: true

  attr_accessible :retained_file, :file_url, :remove_file, :alt, :name, :file

  validates :name, :file, presence: true
  validates :name, uniqueness: true
  validates_size_of :file, maximum: 3.megabytes
  validates_property :format, of: :file, in: [:jpeg, :jpg, :png, :gif]

  class << self
    def replace_tokens(str)
      str ||= ''
      # 1. check body text for any image tags containing 'data-cms-image=""'
      # 2. process the files
      # 2. cache the results
      matches = str.scan(/(<img(.*?)data-cms-image="(\d+)\|([\d+x\d+].*?+)?"(.*?)>)/)

      cached = str
      if matches.any?
        matches.each do |token|
          tok = token[0] # the original <img...> tag

          pre_data = token[1]
          img_id = token[2].to_i
          resize_str = (token[3] || '').gsub('&gt;', '>')
          post_data = token[4]

          # strip out the original src="..." width="..." and height="...",
          # leaving all other attributes in there
          reg = / src=".*?"| width=".*?"| height=".*?"/
          pre_data.gsub!(reg, '')
          post_data.gsub!(reg, '')

          # and recreate the tag
          if thumb = Spree::CmsImage.find_by_id(img_id)
            if resize_str.present?
              # thumbnail
              processed = thumb.file.thumb(resize_str)
            else
              # original
              processed = thumb.file
            end
            cached.gsub!(tok, %(<img#{pre_data} src="#{processed.url}" width="#{processed.width}" height="#{processed.height}"#{post_data}>))
          else
            # TODO: display a 'missing' image or something?
            # log an error?
            cached.gsub!(tok, '')
          end
        end
      end
      cached
    end
  end

end
