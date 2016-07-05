Given(/^I open the browser$/) do
  # Launching the webdriver defined in configuration
  launch_selenium_driver
  # creating the global object of page action, it can be utilised in all steps accordingly
  $browser = Vanilla::PageAction.new(driver)
end



When(/^I navigate to url "([^"]*)"$/) do |url|
  $browser.get_url(url)
end



Then(/^I verify title is "([^"]*)"$/) do |title|
  $browser.title(title)
end



Then(/^I close the browser$/) do
  $browser.close_browser
end