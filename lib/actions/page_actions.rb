module Vanilla
  class PageAction
    # Initializes the Web driver
    def initialize(page_driver)
      @driver = page_driver
      $driver = @driver
    end

    attr_reader :driver

    # get_url :: It opens the browser defined in config file and performs sending the URL and executing it on open web browser
    # Input : URL String eg. www.google.com
    # It can be either passed using configuration file or using the default parameter
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.get_url("http://www.google.com")
    def get_url(url=nil)
      # launch_selenium_driver
      begin
        if url.to_s.length == 0
          url = Vanilla::ConfigReader.configuration_reader
          $LOG.info "Inside method get_url to navigate to URL in browser #{url['url'].to_s}"
          $driver.navigate.to url['url'].to_s
        else
          $LOG.info "Inside method get_url to navigate to URL in browser #{url.to_s}"
          $driver.navigate.to url
        end
      rescue Exception => e
        $LOG.error "Error in getting URL, Error Message :: "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Error in getting URL \n Error Message ::"+e.message
      end
    end

    # forward performs sending forward action to opened browser button
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.forward
    def forward
      $LOG.info "Browser navigating forward method"
      begin
        $driver.navigate.forward
      rescue Exception => e
        $LOG.error "Browser navigating forward error "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Browser navigating forward error \n Error Message :: "+e.message
      end
    end

    # back performs sending backward action to opened browser button
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.back
    def back
      $LOG.info "Browser navigating backward"
      begin
        $driver.navigate.back
      rescue Exception => e
        $LOG.error "Browser navigating backward error "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Browser navigating backward error \n Error Message :: "+e.message
      end
    end

    # close_browser :: closes all browser windows, and quit the selenium session
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.close_browser
    def close_browser
      $LOG.info "Inside close browser method"
      begin
        $driver.quit
      rescue Exception => e
        $LOG.error "Error in quiting browser and ending session" + e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Error in quiting browser and ending session \n Error Message ::" + e.message
      end
    end

    # close_window :: closes the current browser windows, selenium session is still active
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.close_window
    def close_window
      $LOG.info "Inside close window method"
      begin
        $driver.close
      rescue Exception => e
        $LOG.error "Error Close the current window, \n Error Message :: "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Error Close the current window \n Error Message :: "+e.message
      end
    end


    # el(element_name) will grab the element from the defined CSV and JSON file
    # custom method too find element
    # O/P :: return the element
    # usage :: Other methods default uses to grab element from the defined object repository
    def el(element_name)
      $LOG.info "fetching the element #{element_name}"
      element_reader = get_locator(element_name)
      begin
        if element_reader.length > 0
          element_reader.each do |k,v|
            if(k=='class' || k=='css' || k=='id' || k=='xpath' || k=='partial_link_text' || k=='tag_name')
              begin
                $elem = $driver.find_element(k.to_sym,v.to_s)
                $LOG.info "Element found \n #{element_name} : #{k} => #{v}"
              rescue Exception => e
                $LOG.error "Element not found "
                $LOG.error "#{element_name} : #{k} => #{v}"
                $LOG.error "Error message ::  " + e.message
                $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
                $webscreenshot = $webscreenshot+1
                e.attach_file("test_file", "log/webscreenshot/webScreenshot.png", true )
                raise "Element not found \n #{element_name} : #{k} => #{v} \n Error Message :: " + e.message
              end
              $elem
            end
          end
        else
          $LOG.error "Element not present in object repository"
          raise "Element not present in object repository"
        end
        $elem
      rescue Exception => e
        $LOG.error "Error in finding the element :: "  + e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Error in finding the element :: "  + e.message
      end
    end

    # els(element_name) will grab the element from the defined CSV and JSON file
    # O/P :: return the array of element
    # usage :: Other methods default uses to grab element from the defined object repository
    def els(element_name)
      element_reader = get_locator(element_name)
      begin
        if element_reader.length > 0
          element_reader.each do |k,v|
            if(k=='class' || k=='css' || k=='id' || k=='xpath' || k=='partial_link_text' || k=='tag_name')
              begin
                $elems = $driver.find_elements(k.to_sym,v.to_s)
                $LOG.info "Elements found \n #{element_name} : #{k} => #{v}"
              rescue Exception => e
                $LOG.error "Element not found "
                $LOG.error "#{element_name} : #{k} => #{v}"
                $LOG.error "Error message ::  " + e.message
                raise "Element not found \n #{element_name} : #{k} => #{v} \n Error Message :: " + e.message
              end
              $elems
            end
          end
        else
          $LOG.error "Element not present in object repository"
          raise "Element not present in object repository"
        end
        $elems
      rescue Exception => e
        $LOG.error "Error in finding the element :: "  + e.message
        raise "Error in finding the element :: "  + e.message
      end
    end



    # wait_and_find_element: will wait for element
    # I/P :: Parameter is defined "element name" in csv or json file
    # O/P :: return true if element is appears in webpage else it will throw error
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.wait_and_find_element(element_name)
    def wait_and_find_element(element_name)
      $LOG.info "Waiting for element #{element_name}"
      begin
        # timeout = INITIALIZATION_COMPONENTS['wait'].to_i
        timeout = Vanilla::ConfigReader.configuration_reader
        timeout = timeout['wait']
        if timeout == 0
          timeout = 10
        end
        wait_ele = el(element_name)
        wait = Selenium::WebDriver::Wait.new(timeout: timeout ) # seconds
        wait.until { wait_ele }
      rescue Exception => e
        $LOG.error "Element is not displayed in specific time "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Element is not displayed in specific time "+e.message
      end
    end

    # element_enabled : It verifies the element is enabled on webpage
    # I/P :: Parameter is defined "element name" in csv or json file
    # O/P :: return true if element is enabled to perform action in webpage else it will throw error
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.element_enabled(element_name)
    def element_enabled(element_name)
      $LOG.info "verifing enabled Element #{element_name}"
      begin
        raise "Element not found" unless wait_and_find_element(element_name)
        raise "Element not enabled" unless (expect(el(element_name).enabled?).to eql true)
      rescue Exception => e
        $LOG.error "Element not Enabled "+ e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Element not Enabled "+ e.message
      end
    end

    # click_on_element :: It click on defined element
    # I/P :: Parameter is defined "element name" in csv or json file
    # O/P :: It clicks on element
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.click_on_element(element_name)
    def click_on_element(element_name)
      $LOG.info "clicking on element #{element_name} "
      begin
        wait_and_find_element element_name
        click_ele = el(element_name)
        click_ele.click
      rescue Exception => e
        $LOG.error "Can't click on element "+ e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Can't click on element "+ e.message
      end
    end


    # delete_all_cookies :: It delete all cookies from browser
    # O/P :: delete all cookies
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.delete_all_cookies
    def delete_all_cookies
      $LOG.info "deleting all cookies"
      begin
        $driver.manage.delete_all_cookies
      rescue Exception => e
        $LOG.error "error in deleting cookies :: " +e.message
        raise "error in deleting cookies :: " +e.message
      end
    end

    # delete_cookie :: Delete particular cookie in Selenium session browser
    # I/P :: parameter should be the name of cookie to be deleted
    # O/P :: It deletes particular from browser
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.delete_cookie(cookie_name)
    def delete_cookie(name)
      $LOG.info "deleting cookie #{name}"
      begin
        $driver.manage.delete_cookie name
      rescue Exception => e
        $LOG.error "error in deleting cookie #{name} "+e.message
        raise "Error in deleting cookie #{name} "+e.message
      end
    end

    # add_cookie :: add cookie in browser session
    # I/P :: (key,value) cookie key and value is added to brower session
    # O/P :: adds the cookie to browser session
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.add_cookie(key,value)
    def add_cookie(key,value)
      $LOG.info "adding cookie with key => #{key} and value => #{value}"
      begin
        $driver.manage.add_cookie(:name => "#{key}", :value => "#{value}")
      rescue Exception => e
        $LOG.error "Add Cookie can't be completed "+e.message
        raise "Add Cookie can't be completed "+e.message
      end
    end

    # all_cookies :: get all cookies in current session
    # O/P :: Returns the array of cookies
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.all_cookies
    def all_cookies
      $LOG.info "Return all cookies"
      begin
        $driver.manage.all_cookies
      rescue Exception => e
        $LOG.error "get all cookies can't be completed\nerror :: "+e.message
        raise "get all cookies can't be completed \nerror ::  "+e.message
      end
    end

    # browser action

    # drag_and_drop :: It drags the element from current location to target location
    # I/P :: parameter(source_element) :: element name, Defined in object repository (csv or json),
    #        parameter(target_element) :: element name, Defined in object repository (csv or json)
    # O/P :: drags the element name
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.drag_and_drop(source_element, target_element)
    def drag_and_drop(source_element_, target_element)
      $LOG.info "draging and droping the element Source : #{source_element_} and Target : #{target_element}"
      begin
        wait_and_find_element(source_element_)
        wait_and_find_element(target_element)
        element = el(source_element_)
        target = el(target_element)
        $driver.action.drag_and_drop(element, target).perform
      rescue Exception => e
        $LOG.error "Error in drag and drop \n source element :: #{source_element_} \n target element #{target_element}"
        $LOG.error "Error Message :: " +e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Error in drag and drop \n source element :: #{source_element_} \n target element #{target_element} \n " + e.message
      end
    end


    # Text

    # get_text :: ets the text value of the current element
    # I/P :: Parameter is defined "element name" in csv or json file
    # O/P :: gets the text from the element
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.get_text(element_name)
    def get_text(element_name)
      $LOG.info "getting text of an element #{element_name}"
      begin
        wait_and_find_element(element_name)
        ele_get_text = el(element_name)
        ele_get_text.text
      rescue Exception => e
        $LOG.error "Error getting text value of element name : #{element_name} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Error getting text value of element name : #{element_name}  "+e.message
      end
    end

    # clear_text :: clear value of text field or text area element name and text value
    # I/P :: Parameter is defined "element name" in csv or json file
    # Output :: clear value of text field or text area
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.clear_text(element_name)
    def clear_text(element_name)
      $LOG.info "clear value of text field or text area  : #{element_name}"
      wait_and_find_element(element_name)
      begin
        wait_and_find_element element_name
        clear_value = el element_name
        clear_value.clear
      rescue Exception => e
        $LOG.error "Unable to clear value of text field or text area  : #{element_name}  "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Unable to clear value of text field or text area : #{element_name}  "+e.message
      end
    end

    # send_keys_text :: sends the text value of text field or text area element name
    # Input :: parameter(element name) defined in JSON / CSV file
    #          parameter(text) send the text value in text field and text area
    # Output :: type the text value in text field and text area
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.send_keys_text(element_type, text)
    def send_keys_text(element_name, text)
      $LOG.info "sending values of element name : #{element_name} and text_value : #{text} "
      wait_and_find_element(element_name)
      begin
        wait_and_find_element element_name
        send_value = el element_name
        send_value.send_keys text
      rescue Exception => e
        $LOG.error "error in sending values of element name : #{element_name} and text_value : #{text} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "error in sending values element name : #{element_name} and text_value : #{text} "+e.message
      end
    end

    # element_location(element_type) :: gets the element location
    # I/P :: Parameter is defined "element name" in csv or json file
    # Output :: Gets the element location
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.element_location(element_name)
    def element_location(element_name)
      $LOG.info "getting element location #{element_name}"
      begin
        wait_and_find_element(element_name)
        el_loc = el element_name
        el_loc.location
      rescue Exception => e
        $LOG.error "Error getting element location of element name : #{element_name} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Error getting element location of element name : #{element_name} "+e.message
      end
    end


    # location_scroll(element_type) :: scroll to element location
    # I/P :: Parameter is defined "element name" in csv or json file
    # Output :: scroll to location
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.location_scroll(element_name)
    def location_scroll(element_name)
      $LOG.info "getting location scroll for element : #{element_name}"
      begin
        wait_and_find_element element_name
        loc_scr = el element_name
        loc_scr.location_once_scrolled_into_view
      rescue Exception => e
        $LOG.error "Error in scrolling to location of element name : #{element_name} " +e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Error in scrolling to location of element name : #{element_name} " +e.message
      end
    end

    # element_size :: get the size of element
    # I/P :: Parameter is defined "element name" in csv or json file
    # Output :: Gets the size of element
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.element_size(element_name)
    def element_size(element_name)
      $LOG.info "getting element size of #{element_name}"
      begin
        wait_and_find_element element_name
        el_size = el element_name
        el_size.size
      rescue Exception => e
        $LOG.error "Error in size of element of element name : #{element_name} \n Error Message :: "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Error in size of element of element name : #{element_name}\n Error Message ::"+e.message
      end
    end

    # element_displayed :: The element is displayed on web page
    # I/P :: Parameter is defined "element name" in csv or json file
    # Output :: return element is displayed on web page
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.element_displayed(element_name)
    def element_displayed(element_name)
      $LOG.info "verify element displayed in current page #{element_name}"
      begin
        wait_and_find_element element_name
        el_disp = el element_name
        el_disp.display?
      rescue Exception => e
        $LOG.error "error in displaying Element of element name : #{element_name} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "error in displaying Element of element name : #{element_name}"+e.message
      end
    end



    # element_attribute :: Get the attribute of element
    # I/P :: Parameter is defined "element name" in csv or json file
    # Output :: return the attribute of element
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.element_attribute(element_name, attribute_type)
    def element_attribute(element_name, attribute_type)
      $LOG.info "fetching attribute of Element \n element name : #{element_name} & Attribute type : #{attribute_type} "
      begin
        wait_and_find_element element_name
        el_attribute = el element_name
        el_attribute.attribute(attribute_type)
      rescue Exception => e
        $LOG.error "error in fetching attribute of Element \n element name : #{element_name} & Attribute type : #{attribute_type} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "error in fetching Element"+e.message
      end
    end

    # value :: Get the value of element
    # I/P :: Parameter is defined "element name" in csv or json file
    # O/P :: Get the element value
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.value(element_name)
    def value element_name
      begin
        el_attribute = el element_name
        el_attribute.attribute('value')
      rescue Exception => e
        $LOG.error "error in getting element value \n element name : #{element_name} "+e.message
        raise "error in getting element value \n element name : #{element_name} "+e.message
      end
    end

    # move_to element_name, right_by = nil, down_by = nil :: move the element from one location to other
    # Input :: Element_name => element name defined in JSON / CSV file, right_by => value to shift right, down_by => value to move
    # Output :: Move the element
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.move_to(element_name, right_by = nil, down_by = nil)
    def move_to element_name, right_by = nil, down_by = nil
      begin
        $driver.action.move_to(el(element_name), right_by, down_by).perform
      rescue Exception => e
        $LOG.error "error in moving element \n element name : #{element_name}, right: #{right_by} and down: #{down_by} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "error in moving element \n element name : #{element_name}, right: #{right_by} and down: #{down_by} "+e.message
      end
    end

    # double_click :: double clicks on element
    # I/P :: Parameter is defined "element name" in csv or json file
    # Output :: double clicks on element
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.double_click(element_name)
    def double_click(element_name)
      begin
        $driver.action.double_click(el(element_name)).perform
      rescue Exception => e
        $LOG.error "error in perform double click on  element \n element name : #{element_name} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "error in perform double click on  element \n element name : #{element_name} "+e.message
      end
    end

    # select:: Select the element, can be used with checkbox or radio
    # Input :: Element_name => element name defined in JSON / CSV file
    # Output :: select the element
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.select(element_name)
    def select(element_name)
      begin
        el(element_name).click
      rescue Exception => e
        $LOG.error "error in selecting  element \n element name : #{element_name} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "error in selecting  element \n element name : #{element_name} "+e.message
      end
    end

    # selected?(element_name) :: verify elememnt is selected or not
    # Input :: Element_name => element name defined in JSON / CSV file
    # Output :: true or false
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.selected?(element_name)
    def selected?(element_name)
      el(element_name).selected?
    end

    # checkbox_checked(element_name, be_selected=true) :: selecting and verifying check box is selected
    # Input :: Element_name => element name defined in JSON / CSV file
    # Output :: true or false
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.checkbox_checked(element_name, be_selected=true)
    def checkbox_checked(element_name, be_selected=true)
      begin
        select_check = select(element_name)
        select_check unless be_selected == selected?(element_name)
      rescue Exception => e
        $LOG.error "error in selecting check box on  element \n element name : #{element_name} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "error in selecting check box on  element \n element name : #{element_name} "+e.message
      end
    end

    # Select options by visible text, index or value.
    #
    # When selecting by :text, selects options that display text matching the argument. That is, when given "Bar" this
    # would select an option like:
    #
    #     <option value="foo">Bar</option>
    #
    # When selecting by :value, selects all options that have a value matching the argument. That is, when given "foo" this
    # would select an option like:
    #
    #     <option value="foo">Bar</option>
    #
    # When selecting by :index, selects the option at the given index. This is done by examining the "index" attribute of an
    # element, and not merely by counting.
    #
    # @param [:text, :index, :value] how How to find the option
    # @param [String] what What value to find the option by.
    #

    # how can be :text, :index, :value


    # Usage ::
    # element_name = company_dropdown
    # dropdown should be selected by "value"
    # value is "afour"
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.select_option('company_dropdown', :value, 'afour')
    def select_option(element_name, how=nil, what=nil)
      begin
        wait_and_find_element(element_name)
        el(element_name).click if how.nil?
        Selenium::WebDriver::Support::Select.new(el(element_name)).select_by(how, what)
      rescue Exception => e
        $LOG.error "error in perform double click on  element \n element name : #{element_name} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "error in perform double click on  element \n element name : #{element_name} "+e.message
      end
    end


    # refresh :: it refresh current web page
    # O/P :: refresh current web page, with current URL
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.get_text(element_name)
    def refresh
      $driver.refresh
    end

    # switch_frame :: it switch the frame to given frame id or index
    # I/P :: parameter(frame_name) : it requires the frame name or frame id
    # O/P :: Switch to the given frame else return the error message
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.switch_frame(frame_name)
    def switch_frame(frame_name)
      begin
        $driver.switch_to.frame frame_name
      rescue Exception => e
        $LOG.error " frame_name : #{frame_name} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "\n frame_name : #{frame_name} "+e.message
      end
    end

    # switch_default :: switches back to default frame
    # O/P :: Switch to the default frame
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.switch_default
    def switch_default
      begin
        $driver.switch_to.default_content
      rescue Exception => e
        $LOG.error " frame_name : #{frame_name} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "\n frame_name : #{frame_name} "+e.message
      end
    end


    # title :: It verify the title
    # I/P :: it takes input as expected title
    # O/P :: return true if page title matches with expected title else return false
    # Information :: This method uses a custom made rspec matchers
    # usage :: create the object of PageAction class
    # $browser = Vanilla::PageAction.new(driver)
    # $browser.title(expected_title)
    def title(expected_title)
      $LOG.info "Verifying the expected title #{expected_title}"
      #$driver.title
      begin
        expect($driver.title.to_s).to eq(expected_title)
      rescue Exception => e
        $LOG.error "Error in getting the expected title #{expected_title} "+e.message
        $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
        $webscreenshot = $webscreenshot+1
        raise "Error in getting the expected title #{expected_title} "+e.message
      end
    end
  end
end
