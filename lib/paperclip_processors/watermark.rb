# -*- encoding : utf-8 -*-
# Based on
# https://github.com/ng/paperclip-watermarking-app/blob/master/lib/paperclip_processors/watermark.rb
# Modified by Laurynas Butkus

module Paperclip
  class Watermark < Processor
    # Handles watermarking of images that are uploaded.
    attr_accessor :format, :whiny, :watermark_path, :position, :current_format, :attachment

    def initialize file, options = {}, attachment = nil
      super(file, options, attachment)
      @whiny            = options[:whiny].nil? ? true : options[:whiny]
      @watermark_path   = options[:watermark_path] || attachment.options[:watermark_path]
      @position         = options[:position] || attachment.options[:position] || "SouthEast"
      @current_format   = File.extname(@file.path)
      @attachment = attachment
     end

    # Performs the conversion of the +file+ into a watermark. Returns the Tempfile
    # that contains the new image.
    def make
      l = Rails.logger
      l.info("watermark------#{watermark_path.inspect}")
      
      return file unless watermark_path
      wpath = case watermark_path
      when Symbol
        @attachment.instance.send(watermark_path)
      when Proc
        watermark_path.call @attachment.instance
      else
        watermark_path
      end
      l.info("Watermark Path: #{wpath}")
      return file unless wpath and File.exists?(wpath)
      
      basename         = File.basename(file.path, current_format)
      format           = options[:format] || current_format

      dst = Tempfile.new([basename, format].compact)
      dst.binmode

      command = "convert"
      #fromfile = "\"#{ File.expand_path(file.path) }\"[0]"
      fromfile = File.expand_path file.path
      #tofile = "\"#{ File.expand_path(dst.path) }\"[0]"
      tofile = File.expand_path(dst.path)
      #params = "#{fromfile} -coalesce null: #{watermark_path} -gravity #{@position} -layers Composite -layers optimize #{tofile}"      
      params = "#{fromfile} -coalesce null: #{wpath} -gravity #{@position} -layers Composite #{tofile}"

      begin
        success = Paperclip.run(command, params)
      rescue PaperclipCommandLineError
        raise PaperclipError, "There was an error processing the watermark for #{basename}" #if @whiny
      end
      dst
    end
  end
end

