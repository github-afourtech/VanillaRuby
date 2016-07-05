@allMyDesk
Feature: Login to My Desk Application

@Test1
Scenario: User should go to My Desk and send message
    Given I open the browser
    When I navigate to url "stagingmydesk.azurewebsites.net/#"
    Then I enter "Controller@afourtech.com" to "username"
    Then I enter "@four123" to "password"
    Then I click on "Login"
   # Then I verify "profileName" is "Controller"
    Then I click on "linkAddMessage"
    Then I click on "dropdownAssociateList"
    Then I select "HR user 1"
    Then I enter "Hi How are you ?" to "textbox_SendMessage"
    Then I click on "btn_Send"
    Then I click on "btn_dropdownToggle"
    Then I click on "link_Logout"
    Then I enter "hruser@afourtech.com" to "username"
    Then I enter "@four123" to "password"
    Then I click on "Login"
  #  Then I verify "profileName" is "HR user 1"
    Then I verify "txt_receivedMessage" is "Hi How are you ?"
    Then I click on "link_Logout"
    Then I close browser
