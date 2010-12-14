require 'rubygems'
require 'bundler'
Bundler.setup
require 'green_shoes'
require 'w3c_validators'
require 'nokogiri'


class Validator
  include W3CValidators

  attr_accessor :type, :markup, :errors, :warnings, :parser, :exception_message

  def initialize(type, markup)
    @type = type
    @markup = markup
  end

  def parse_markup
    case @type
      when "HTML"
        @parser = MarkupValidator.new 
        @parser.set_debug!(true) 
      when "CSS"
        @parser = CSSValidator.new
        @parser.set_warn_level!(2)
      when "XML"
        @parser = Nokogiri::XML.parse(@markup) 
      else
        @parser = nil 
    end
  
    if @type == "HTML" || @type == "CSS"
      begin
        @errors = @parser.validate_text(@markup).errors
        @warnings = @parser.validate_text(@markup).warnings
      rescue W3CValidators::ValidatorUnavailable
        @errors = nil
        @warnings = nil
        @exception_message = "Unable to connect to validator, perhaps your request was too large"
      rescue Net::HTTPRetriableError
        @errors = nil
        @warnings = nil
        @exception_message = "Unable to connect to validator, response unavailable"
      rescue
        @errors = nil
        @warnings = nil
        @exception_message = "Unable to validate markup"
      end
    elsif @type == "XML"
      @errors = @parser.errors
      @warnings = nil
    else
      @errors = nil
      @warnings = nil 
    end
  end
end

class Kensho < Shoes
  url '/', :index
  url '/validate', :validate

  def index
    stack do
      flow do
        para "kensho"
      end

      flow do
        @type = list_box items: ['HTML', 'CSS', 'XML'], choose: 'HTML'
      end

      flow do
        @markup = edit_box
      end
      
      flow do
        button('Validate') do
          $validator = Validator.new(@type.text, @markup.text)
          $validator.parse_markup
          visit '/validate'
        end 
      end
    end
  end

  def validate
    para "Type: #{$validator.type}"
    #para "Markup: #{$validator.markup}"
    para "Warnings: #{$validator.warnings}"
    para "Errors: #{$validator.errors}"
  end
end

Shoes.app width: 400, height: 400, title: 'kensho'
