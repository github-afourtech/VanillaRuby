Given(/^I open the browser$/) do
  launch_selenium_driver
end

When(/^I navigate to url "([^"]*)"$/) do |arg1|
  $test1 =  Vanilla::PageAction.new(driver)
  if arg1.to_s.length == 0
    $test1.get_url
  else
    url = "http://"+arg1.to_s
    $test1.get_url url
  end
end


Then(/^I verify title is "([^"]*)"$/) do |arg1|
    $test1.title(arg1)


end
Then(/^I enter "([^"]*)" to "([^"]*)"$/) do |arg1, arg2|
  $test1.send_keys_text(arg2,arg1)
end


Then(/^I click on "([^"]*)"$/) do |arg1|
  $test1.click_on_element(arg1)
end


Then(/^I select "([^"]*)" from list$/) do |arg1|
  $driver.find_element(:id, "AssociateList").find_element(:css,"option[value='3']").click
#  list = $driver.find_elements(:id,"AssociateList")
  
end