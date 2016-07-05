require 'rubygems'
require 'bundler'
require 'yaml'
require 'rspec'
require 'cucumber'
require 'rake'
require 'selenium-webdriver'
require 'log4r'

require File.dirname(__FILE__) + '/driver/launch_driver'
include CreateDriver

require File.dirname(__FILE__) + '/actions/page_actions'

require File.dirname(__FILE__) + '/utility/object_repo_reader'
include Vanilla
include Vanilla::ObjectRepoReader
require File.dirname(__FILE__) + '/utility/config_reader'
include Vanilla::ConfigReader

