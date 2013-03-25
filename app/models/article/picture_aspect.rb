# -*- encoding : utf-8 -*-
require 'paperclip_processors/watermark'
module Article::PictureAspect
	module ClassMethods
		
	end
	
	module InstanceMethods
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
