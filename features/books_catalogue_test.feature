# language: en
@books @browser
Feature: Books to Scrape - Catalogue browsing
  As a user
  I want to browse the book catalogue
  So that I can find books by category

  Background:
    Given I am on the Books to Scrape homepage

  Scenario: Homepage displays a list of books
    Then the homepage shows a list of books
    And the book count on the homepage is greater than 0

  Scenario Outline: Browse books by category
    When I navigate to the "<category>" category
    Then the catalogue page is displayed
    And the category heading matches the expected name for "<category>"

    Examples:
      | category |
      | mystery  |
      | travel   |
      | science  |

  Scenario: Mystery category has books with pagination
    When I navigate to the "mystery" category
    Then the catalogue shows at least 1 book
    And some books have a next page available
