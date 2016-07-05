require 'rubygems'
require 'json'
require 'pp'
require 'csv'

# It fetches the Element from Element reader under object repository
module Vanilla
  #class FileReader
  module ObjectRepoReader
    # get_all_locator : reads the locator from csv and json file
    # Output :: Hash
    def get_all_locator
      $LOG.info "Inside file Exist method"
      dir_path = File.expand_path('../../object_repository', File.dirname(__FILE__))
      config_set = Dir.entries(dir_path)
      $LOG.info "inside method get locators"
      begin
        if config_set.any? { |s| s.include?('element_reader') }
          if (config_set.index('element_reader.json') != nil)
            file_path = dir_path+"/element_reader.json"
            begin
              $LOG.debug "Initiated parsing of json file"
              json = File.read(file_path)
              $locator = JSON.parse(json)
              $LOG.debug "JSON Parsing successful"
              $locator
            rescue Exception=>e
              $LOG.error "Invalid JSON file " + e.message
              raise "Invalid JSON file " + e.message
            end
            # TODO :: TBD :: YML support for object repository reader
            #elsif(config_set.index('element_reader.yml') != nil)
            #file_path = dir_path+"/element_reader.yml"
          elsif(config_set.index('element_reader.csv') != nil)
            file_path = dir_path+"/element_reader.csv"
            $locators = Hash.new {|h,k| h[k] = Hash.new(&h.default_proc) }
            begin
              CSV.foreach(file_path) do |row|
                for iterator in 1..(row.length-1)
                  if row[iterator].to_s.split("=")[2]==nil
                    $locators[row[0]][row[iterator].split("=")[0]] = row[iterator].split("=")[1]
                  else
                    #TODO Make this part generic to handle multiple occurence of '=' in xpath if required. As of now we dont see need for this scenerio.
                    $locators[row[0]][row[iterator].split("=")[0]] = "#{row[iterator].split("=")[1]}=#{row[iterator].split("=")[2]}"
                  end
                end
              end
            rescue Exception => e
              raise "Invalid CSV file " + e.message
            end
            $locators
          end
        end
      rescue Exception=>e
        $LOG.error "Unknown Error "+e.message
        raise "Unknown Error "+e.message
      end
    end

    # get_locator(ele) 
    # Input :: parameter ele ::  Read element name
    # Output :: Locator value
    def get_locator(ele)
      elem = get_all_locator
      elem[ele]
    end
  end
end


