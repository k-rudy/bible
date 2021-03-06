require 'open-uri'

module Bible
  module Scrapers 
    # Contains base scraping logic that is common for all translations
    #
    class Base
      class <<self
        # Scrapes all Bible translation to the db
        #
        # @param [ String ] book title to start scraping from
        def scrape(book_to_start_from = nil)
          books_to_scrape(book_to_start_from).map { |book| scrape_book(book) }
        end
        
        # Returns the list of books titles that require mapping
        #
        # @return [ Array ] array of book titles needed to map
        def missing_mappings
          books_with_missing_mapping.map(&:title)
        end
        
        private
        
        def books_to_scrape(book_to_start_from)
          if book_to_start_from
            book = Bible::Book.by_title(book_to_start_from).first
            Bible::Book.starting_from(book.order)
          else
            Bible::Book.all
          end
        end
        
        # Srapes single book translation
        #
        # @param [ Bible::Book ] book
        def scrape_book(book)
          print "\nScraping #{book.title}:" unless Rails.env.test?
          book.chapters_count.times do |i|
            print "\n#{i + 1}: " unless Rails.env.test?
            scrape_chapter(book, i + 1) 
          end
        end
        
        # Scrapes chapter
        #
        # @param [ Bible::Book ] book
        # @param [ Integer ] chapter being imported
        def scrape_chapter(book, chapter)
          scrape_verses(book, chapter, book.latest_verse_order(chapter) + 1)
        end
        
        # Scrapes the verse text and creates the Bible::Verse.
        # If the verse wasn't blank - recoursively calls the function for scraping next verse
        #
        # @param [ Bible::Book ] book
        # @param [ Integer ] chapter number being imported
        # @param [ Integer ] verse_number number being imported
        def scrape_verses(book, chapter, verse_number = 1)       
          process_verse(book, chapter, verse_number) && scrape_verses(book, chapter, verse_number + 1)
        rescue OpenURI::HTTPError
          out false
          sleep(30)
          scrape_verses(book, chapter, verse_number)
        end      
        
        # Scrapes verse text and if it exists - creates a verse
        #
        # @return [ Verse, nil ] verse if it was creates, otherwise - nil
        def process_verse(book, chapter, verse_number)
          mapping = book_mapping(book)
          verse_text = scrape_verse(mapping, chapter, verse_number)
          out create_verse(book, chapter, verse_number, verse_text) if verse_text
        end
         
        # Gets the book mapping name for the scraping puposes
        # 
        # @return [ String ] mapping value
        def book_mapping(book)
          title = book.title.downcase.gsub(/\s+/, '')
          CONFIG[:sources][translation][:mappings][title] || title
        end
        
        # This method should be implemented in particular Scraper class
        #
        # @raise [ NotImplementedError ] on attempt to call the mathos on Base class
        def scrape_verse(book_mapping, chapter, verse_number)
          raise NotImplementedError.new('Scraper class must implement #scrape_verse method')
        end
        
        # Creates verse in the book
        # 
        # @param [ Bible::Book ] book
        # @param [ Integer ] chapter number being imported
        # @param [ Integer ] verse number being imported
        # @param [ String ] verse_text 
        def create_verse(book, chapter, verse_number, verse_text)
          Bible::Verse.create!({
            book: book,
            chapter: chapter,
            order: verse_number,
            text_translations: {
              translation => verse_text
            } 
          })
        end
        
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
        
        # Returns the list of books titles that require mapping
        #
        # @return [ Array ] array of books needed to map
        def books_with_missing_mapping
          Bible::Book.all.select do |book|
            mapping = book_mapping(book)
            Rails.logger.info("Mapping Check: #{book.title}")
            begin
              out scrape_verse(mapping, 1, 2), true
            rescue OpenURI::HTTPError
              out false, true
            end
          end
        end
        
        # Outputs iteration result in a Rspec like format
        #
        # @param [ true, false ] revert - indicates whether it's needed to revert the result
        #
        # @retun [ true, false] result itself
        def out(result, revert = false)
          (result ? print('.'.green) : print('F'.red)) unless Rails.env.test?
          revert ? !result : result
        end
      end
    end
  end
end
