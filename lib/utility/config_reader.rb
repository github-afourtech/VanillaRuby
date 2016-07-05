require 'rubygems'
require 'json'
require 'pp'
require 'csv'


# Reads the config file under the configuration folder
module Vanilla
  module ConfigReader
    def configuration_reader
      begin
        dir_path = File.expand_path('../../configuration', File.dirname(__FILE__))
        config_set = Dir.entries(dir_path)
        if config_set.any? { |s| s.include?('config') }
          if (config_set.index('config.json') != nil)
            file_path = dir_path+"/config.json"
            begin
              json = File.read(file_path)
              $config = JSON.parse(json)
              $config
            rescue Exception => e
              raise "Json file is not in defined format #{file_path} \n error : #{e.message}"
            end
            $config
          elsif(config_set.index('config.yml') != nil)
            file_path = dir_path+"/config.yml"
            begin
              $config = YAML::load(File.open file_path)
              $config
            rescue Exception => e
              raise "yml file is not in defined format #{file_path} \n error : #{e.message}"
            end
            $config
          elsif(config_set.index('config.csv') != nil)
            file_path = dir_path+"/config.csv"
            begin
              $config =  {}
              CSV.foreach(file_path) do |row|
                row = row[0].split('=')
                $config[row[0]] = row[1]
              end
              $config
            rescue Exception => e
              raise "csv file is not in defined format #{file_path} \n error : #{e.message}"
            end
            $config
          end
        end
      rescue Exception=>e
        dir_path = Dir.pwd + "/configuration"
        raise "path :: #{dir_path} \n Configuration Directory Not Exist Error #{e.message}"
      end
      $config
    end
  end
end
