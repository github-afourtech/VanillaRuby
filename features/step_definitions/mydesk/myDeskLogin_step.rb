Then(/^I verify "([^"]*)" is "([^"]*)"$/) do |arg1, arg2|
  profile_name = $test1.text(arg1)
  puts "testjhgjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj :::: " +profile_name.to_s
  puts profile_name.class
  expect(profile_name.to_s).to include(arg2)
end


Then(/^I select "([^"]*)"$/) do |arg1|
  mySelect=$driver.find_element(:id,"AssociateList")
  options=mySelect.find_elements(:tag_name=>"option")
  options.each do |g|
  if g.text == arg1
    sleep 2
    g.click
    sleep 2
  break
  end
end
end



Then(/^I close browser$/) do
  $driver.quit
end
