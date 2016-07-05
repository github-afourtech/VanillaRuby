module CreateDriver

  #initializes the web browser
  def page_driver
    # it reads the browser details from configuration file
    get_browser = Vanilla::ConfigReader.configuration_reader
    #It launches the driver
    @driver = Selenium::WebDriver.for get_browser['browser'].to_sym
    $LOG.info "Browser window maximized"
    @driver.manage.window.maximize
  end

  def driver
    @driver
  end

  def launch_selenium_driver
    page_driver
  end
end
