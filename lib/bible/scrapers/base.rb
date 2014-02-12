module Bible
  module Scrapers 
    # Contains base scraping logic that is common for all translations
    #
    class Base
      class <<self
        # Gets the bible source url
        #
        # @return [ String ] source url
        def url 
          CONFIG[:sources][translation][:url]
        end
      
        # Gets the translation code depending on the scraper class
        #
        # @example: Bible::Scraper::Ru -> 'ru'
        #
        # @return [ String ] translation code
        def translation
          @translation ||= name.underscore.split('/').last
        end
      end
    end
  end
end
