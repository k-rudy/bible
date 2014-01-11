module Bible
  module Config
    # Reads the `config/bible.yml` configuration
    # Creates books collection based on the configuration content
    #
    class Reader
      class << self

        def import
          config[:bible].each do |key, book|
            Bible::Book.create!( {
              name: key,
              chapters_count: book[:chapters],
              order: book[:order],
              title_translations: translate_title(book, :short),
              title_full_translations: translate_title(book, :full)
            })
          end
        end

        private

        # @return [ Hash ] - config hash
        def config
          configuration = YAML.load(File.read(config_path))
          configuration.with_indifferent_access
        end

        def config_path
          File.read(File.expand_path('../../../config/books.yml', __FILE__))
        end

        # Gets the title translations hash from the configuration file
        #
        def translate_title(book, title_type)
          book[:title].inject({}) do |result, title_hash|
            result[title_hash.first] = title_hash.last[title_type]
            result
          end
        end
      end
    end
  end
end
