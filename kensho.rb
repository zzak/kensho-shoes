require 'rubygems'
require 'bundler'
Bundler.setup
require 'green_shoes'
require 'w3c_validators'
require 'nokogiri'

Shoes.app do
  stack do 
    flow do 
      para "kensho" 
    end

    flow do
      lb = list_box items: ["HTML", "CSS", "XML"], choose: "HTML" do |item|
        @type = item 
      end
    end

    flow do
      eb = edit_box do
        
      end
    end
  end
end
