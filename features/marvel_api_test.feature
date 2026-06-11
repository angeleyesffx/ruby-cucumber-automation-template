# language: en
@marvel @api
Feature: Marvel App API - GraphQL (marvelapp.com)

  Background:
    Given I have a valid Marvel App API token

  # ─── User profile ────────────────────────────────────────────────────────────

  Scenario: Query current user returns profile data
    When I query the current user
    Then the GraphQL response has no errors
    And the response data contains "user"
    And the user data has an email address

  # ─── Auth context ────────────────────────────────────────────────────────────

  Scenario: Query auth context returns token metadata
    When I query the auth context
    Then the GraphQL response has no errors
    And the response data contains "auth"
    And the auth data has a non-empty scopes string
    And the auth data has an expiry date

  # ─── Auth errors ─────────────────────────────────────────────────────────────

  Scenario: Request with invalid token returns authentication error
    Given I have an invalid Marvel App API token
    When I query the current user
    Then the GraphQL response contains an authentication error
