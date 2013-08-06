# Adjusting default rails generators
Bible::Application.config.generators do |g|
  g.test_framework  :rspec
  g.integration_tool :rspec
end
