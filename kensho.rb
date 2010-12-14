require 'rubygems'
require 'bundler'
Bundler.setup
require 'green_shoes'
require 'w3c_validators'
require 'nokogiri'

class Kensho < Shoes
  url '/', :index
  url '/validate', :validate

  def index
    stack do
      flow do
        para "kensho"
      end

      flow do
        list_box items: ['HTML', 'CSS', 'XML'], choose: 'HTML' do |lb|
          @type = lb
        end
      end

      flow do
        edit_box do |eb| 
          @markup = eb
        end
      end
      
      flow do
        button('Validate') do
          visit '/validate'
        end 
      end
    end
  end

  def validate
    para @type.text
    para @markup.text
  end
end

Shoes.app width: 400, height: 400, title: 'kensho'
