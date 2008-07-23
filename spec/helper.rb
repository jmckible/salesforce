require 'rubygems'
require 'spec'
require 'active_record'

require File.dirname(__FILE__) + '/../lib/salesforce.rb'

require File.expand_path(File.join(File.dirname(__FILE__), '/fixtures/user'))
require File.expand_path(File.join(File.dirname(__FILE__), '/fixtures/person'))

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.configurations = {'test' => config[ENV['DB'] || 'sqlite3']}
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])

load(File.dirname(__FILE__) + "/schema.rb")