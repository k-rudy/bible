require 'active_support'

config = YAML.load(File.read(File.expand_path('../../application.yml', __FILE__)))
config.merge! config.fetch(Rails.env, {})

CONFIG = config.with_indifferent_access
