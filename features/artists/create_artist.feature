Feature: Create Artist
  As an admin
  In order to present information about an artist
  I should be able to create an artist

  Scenario: Admin sees new artist page
    Given I am logged in as an admin user
    When I go to the admin artists page
    And I follow "New Artist"
    Then I should be on the new admin artist page

  Scenario Outline: Non admin is redirected from new artist page
    Given I am <log in state>
    When I go to the new admin artist page
    Then I should be on the <redirected to> page

    Scenarios:
      | log in state  | redirected to |
      | logged in     | homepage      |
      | not logged in | login         |

  Scenario: Admin creates new artist
    Given I am logged in as an admin user
    When I go to the new admin artist page
    And I fill in the new artist form with valid attributes
    And I press "Create Artist"
    Then I should see "Artist was successfully created"
    And I should see the "name" of the artist

  Scenario Outline: Admin fails to create artist
    Given I am logged in as an admin user
    When I go to the new admin artist page
    And I fill in the new artist form with valid attributes
    And I select "<state>" from "State"
    But I ommit "<ommitted>"
    And I press "Create Artist"
    Then I should see "<expected error>" within "<container>"

    Scenarios:
      | state       | ommitted | expected error | container          |
      | In Progress | Name     | can't be blank | #artist_name_input |
      | Live        | Name     | can't be blank | #artist_name_input |
      | Live        | Bio      | can't be blank | #artist_bio_input  |

  Scenario: Admin creates artist with website url
    Given I am logged in as an admin user
    When I go to the new admin artist page
    And I fill in the new artist form with valid attributes
    And I fill in "Website" with "http://www.google.com"
    And I press "Create Artist"
    Then I should see "Artist was successfully created"
    And I should see the "website" of the artist

  Scenario: Admin creates artist with new primary instrument
    Given I am logged in as an admin user
    When I go to the new admin artist page
    And I fill in the new artist form with valid attributes
    And I fill in "Name" with "Banjo" within "#artist_instrument_attributes_name_input"
    And I press "Create Artist"
    Then I should see "Artist was successfully created"
    And I should see "banjo"

  Scenario: Admin creates artist with existing primary instrument
    Given I am logged in as an admin user
    And the following instrument exists:
      | name  | 
      | Banjo |
    When I go to the new admin artist page
    And I fill in the new artist form with valid attributes
    And I select "banjo" from "Instrument"
    And I press "Create Artist"
    Then I should see "Artist was successfully created"
    And I should see "banjo"

  Scenario: Admin adds buy link to artist
    Given I am logged in as an admin user
    When I go to the new admin artist page
    And I fill in the new artist form with valid attributes
    And I fill in the new buy link form with valid attributes
    And I press "Create Artist"
    Then I should see "Artist was successfully created"
    And the artist should have 1 buy link

