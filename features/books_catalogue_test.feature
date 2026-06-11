# language: en
@books @browser
Feature: Books to Scrape - Catalogue browsing
  As a user
  I want to browse the book catalogue
  So that I can find books by category

  Background:
    Given I am on the Books to Scrape homepage

  # ─── Homepage ──────────────────────────────────────────────────────────────

  Scenario: Homepage displays a list of books
    When I view the homepage catalogue
    Then the homepage shows a list of books
    And the book count on the homepage is greater than 0

  # ─── Category navigation ───────────────────────────────────────────────────

  Scenario Outline: Browse books by category
    When I navigate to the "<category>" category
    Then the catalogue page is displayed
    And the category heading matches the expected name for "<category>"

    Examples:
      | category |
      | mystery  |
      | travel   |
      | science  |

  # ─── Pagination — equivalence partition: categories WITH next page ──────────

  Scenario: Mystery category has books spread across multiple pages
    When I navigate to the "mystery" category
    Then the "mystery" catalogue shows at least 1 book
    And the "mystery" category has a next page

  # ─── Pagination — equivalence partition: categories WITHOUT next page ───────

  Scenario Outline: Single-page categories have no pagination
    When I navigate to the "<category>" category
    Then the catalogue page is displayed
    And the "<category>" category has no next page

    Examples:
      | category |
      | travel   |
      | science  |
