require 'paperclip_processors/watermark'
module Article::PictureAspect
	module ClassMethods
		
	end
	
	module InstanceMethods
    def is_original?
     picture_id.nil? || original_picture.original_id == id
    end

    def ensure_picture
      return original_picture if picture_id
      p = Picture.new :original_id => id,:user_id => user_id,:group_id => group_id
      p.attachment = self.picture
      p.save
      self.original_picture = p
      self.save
      original_picture
    end		
	end
	
	def self.included(receiver)
    receiver.class_eval do
      has_attached_file :picture, :styles => {
        :thumb => '64x64#',
        :small => '256x256>',
        :medium => '320x320>',
        :large => '1024x1024>'
      } ,
        :processors => [:thumbnail, :watermark], 
        :watermark_path => lambda {|record| record.group && record.group.options &&record.group.options[:watermark_path] }
      

      validates_attachment_content_type :picture,
        :content_type =>
          ['image/jpeg',
           'image/gif',
           'image/png',
           'image/pjpeg',
           'image/bmp',
           'image/x-portable-bitmap'
           ], :unless => Proc.new {|model| model.picture}

      validates_attachment_size :picture, :less_than => 2.megabytes, :unless => Proc.new {|model| model.picture}      
      extend ClassMethods
      include InstanceMethods
    end
	end
end