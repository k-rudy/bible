RSpec.configure do |config|
  config.include Mongoid::Matchers

  config.before :each do
    Mongoid.purge!
  end
end
