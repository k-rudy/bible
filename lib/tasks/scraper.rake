namespace :scraper do
  
  desc 'Get the list of books that require mappings'
  task :missing_mappings, [:translation] => [:environment] do |t, args|
    if args[:translation].present?
      puts 'Checking mappings. This can take a while...'
      result = Bible::Scrapers.const_get(args[:translation].camelize).missing_mappings.to_sentence
      puts "\nRequire mapping: #{result}"
    else
      puts 'Please set the translation like: rake scraper:missing_mappings[ru]'
    end
  end
end
