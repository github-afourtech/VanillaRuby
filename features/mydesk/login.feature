@all
Feature: Login to my desk application
  Go to mydesk.afourtech.com
  validate the title
  Login to "Controller@afourtech.com""

#  @one
#  Scenario: User should go to www.google.com and verify title
#    Given I open the browser
#    When I navigate to url "mydesk.afourtech.com"
#    Then I verify title is "My Desk @ AFour"

  @one
  Scenario: User should go to
    Given I open the browser
    When I navigate to url "stagingmydesk.azurewebsites.net/"
    Then I verify title is "My Desk @ AFour"
    Then I enter "Controller@afourtech.com" to "username"
    Then I enter "@four123" to "password"
    Then I click on "login"
    Then I click on "message"
    Then I select "hruser" from list
#    Then I send message "Hi There"
    
    
