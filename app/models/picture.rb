class Picture < ActiveRecord::Base
  has_attached_file :attachment,
    :styles => {
      :thumb => '256x256#',
      :medium => '400x400>'
    }
  validates_attachment_content_type :attachment,
    :content_type =>
      ['image/jpeg',
       'image/gif',
       'image/png',
       'image/pjpeg',
       'image/bmp',
       'image/x-portable-bitmap'
       ], :unless => Proc.new {|model| model.attachment}
  validates_attachment_size :attachment, :less_than => 2.megabytes, :unless => Proc.new {|model| model.attachment}
  has_many :articles
  belongs_to :original_article, :foreign_key => 'original_id'

  def draw(text, position='Center', color='black')
    image = MiniMagick::Image.open(attachment.path(:original))
    text.gsub!(/["']/i, '')
    color = "\##{color}" if color =~ /^[0-9a-fA-F]{6}$/
    image.combine_options do |c|
      c.gravity position
      c.font RUBY_PLATFORM =~ /mingw/ ? 'C:/Windows/fonts/simsun.ttc' : '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc'
      c.pointsize 32
      c.fill 'black'
      c << "-draw \'text 0,-1 \"#{text}\"\'"
      c << "-draw \'text -1,0 \"#{text}\"\'"
      c << "-draw \'text 0,1 \"#{text}\"\'"
      c << "-draw \'text 1,0 \"#{text}\"\'"
      c.pointsize 32
      c.fill color
      #c << "-draw text 0,0 \"#{text}\""
      c << "-draw \'text 0,0 \"#{text}\"\'"
    end
    tmp = Tempfile.new(['qqq', File.extname(image.path)])
    tmp.binmode
    image.write(tmp)
    #image.destroy!
    r = yield tmp
    tmp.close
    #File.unlink!(tmp)
    r
  end
end
