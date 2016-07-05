require File.dirname(__FILE__) + '/../../lib/pages'
require 'log4r'
require 'rspec'
include Log4r
include RSpec::Matchers


time = Time.new
time = time.getlocal.to_s
time= time.gsub(/([-: +])/, '')

$LOG=Logger.new("log/application_log/application#{time}.log", 'daily', 10)
$LOG.level = Logger::INFO


require 'allure-cucumber'

include AllureCucumber::DSL

AllureCucumber.configure do |c|
  c.output_dir = "allure"
  c.clean_dir  = false
end


$webscreenshot = 1