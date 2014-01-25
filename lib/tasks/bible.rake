namespace :bible do
  desc "Initialize bible books collection"
  task :init_books => :environment do
    Bible::Config::Reader.import
  end
end
