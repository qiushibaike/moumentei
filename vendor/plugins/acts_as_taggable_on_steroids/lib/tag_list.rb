# coding:utf-8
class TagList < Array
  #cattr_accessor :delimiter, :delimiter_before, :delimiter_after, :delimiter_reg
#  if RUBY_VERSION >= '1.9'
#    self.delimiter = " |,|;|\uff0c|\u3000|\uff1b|\u3001|\u3002|\u2026"
#  else
  Delimiter = " |,|;|\\?|\\.|　|，|。|；|、|。|…|！|：|｜|＃|？".freeze
  DelimiterReg = Regexp.new(Delimiter).freeze
  DelimiterBefore = /\s*(#{Delimiter})\s*(['"])(.*?)\2\s*/.freeze
  DelimiterAfter = /^\s*(['"])(.*?)\1\s*(#{Delimiter})?/.freeze

#
#    self.delimiter = ' |,|;|，|　|；|、|。|…'
#
#  end
  def initialize(*args)
    add(*args)
  end
  
  # Add tags to the tag_list. Duplicate or blank tags will be ignored.
  #
  #   tag_list.add("Fun", "Happy")
  # 
  # Use the <tt>:parse</tt> option to add an unparsed tag string.
  #
  #   tag_list.add("Fun, Happy", :parse => true)
  def add(*names)
    names = names[0,(3 - size)]
    if names and names.size > 0
      extract_and_apply_options!(names)
      concat(names.reject{|n|n.unpack("U*").collect{|i| i >= 0x2e80 ? 2: 1}.sum>10})
      clean!
    end
    self
  end
  
  # Remove specific tags from the tag_list.
  # 
  #   tag_list.remove("Sad", "Lonely")
  #
  # Like #add, the <tt>:parse</tt> option can be used to remove multiple tags in a string.
  # 
  #   tag_list.remove("Sad, Lonely", :parse => true)
  def remove(*names)
    extract_and_apply_options!(names)
    delete_if { |name| names.include?(name) }
    self
  end
  
  # Toggle the presence of the given tags.
  # If a tag is already in the list it is removed, otherwise it is added.
  def toggle(*names)
    extract_and_apply_options!(names)
    
    names.each do |name|
      include?(name) ? delete(name) : push(name)
    end
    
    clean! 
    self
  end
  
  # Transform the tag_list into a tag string suitable for edting in a form.
  # The tags are joined with <tt>TagList.delimiter</tt> and quoted if necessary.
  #
  #   tag_list = TagList.new("Round", "Square,Cube")
  #   tag_list.to_s # 'Round, "Square,Cube"'
  def to_s
    clean!
#    map do |name| name end.join(' ')
    join(' ')
#    map do |name|
#      name.include?(delimiter) ? "\"#{name}\"" : name
#    end.join(delimiter.ends_with?(" ") ? delimiter : "#{delimiter} ")
  end
  
 private
  # Remove whitespace, duplicates, and blanks.
  def clean!
    reject!(&:blank?)
    map!(&:strip)
    uniq!
  end
  
  def extract_and_apply_options!(args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    options.assert_valid_keys :parse
    
    if options[:parse]
      args.map! { |a| self.class.from(a) }
    end
    
    args.flatten!
  end
  
  class << self
    # Returns a new TagList using the given tag string.
    # 
    #   tag_list = TagList.from("One , Two,  Three")
    #   tag_list # ["One", "Two", "Three"]
    def from(source)
      new.tap do |tag_list|
        case source
	      when nil
        when Array
          tag_list.add(source)
        else
          #string = source.to_s.gsub(DelimiterBefore) { tag_list << $3; ""}
          #string.gsub!(DelimiterAfter) { tag_list << $2; "" }
          #tag_list.add(string.split(DelimiterReg))
          tag_list.add(source.split(DelimiterReg))
        end
      end
    end
  end
end
#delete low_priority quick from taggings using taggings,tags where taggings.tag_id =  tags.id and char_length(tags.name) > 20
#delete low_priority quick from tags where char_length(tags.name) > 20
