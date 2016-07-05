@all
Feature: Verify google title
  Go to www.google.com
  validate the title

  @one
  Scenario: User should go to
    Given I open the browser
    When I navigate to url "http://www.google.com"
    Then I verify title is "Google"
    Then I close the browser

