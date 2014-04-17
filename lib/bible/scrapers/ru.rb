module Bible
  module Scrapers 
    # Russian version scraper
    #
    class Ru < Base
      
      class << self
        # Scrapes verse text. 
        #
        # @param [ String ] book_mapping
        # @param [ Integer ] chapter number being imported
        # @param [ Integer ] verse number being imported
        #
        # @return [ String, nil ] string when the verse with the numer exists, nil - otherwise
        def scrape_verse(book_mapping, chapter, verse_number)
          doc = Nokogiri::HTML(open("#{url}/#{book_mapping}/#{chapter}:#{verse_number}"), nil, 'UTF-8')
          doc.css('#editionDependentData .bibletextblock table .bibletext .bibletext').children.last.try(:text).try(:strip)
        end
      end
    end
  end
end
