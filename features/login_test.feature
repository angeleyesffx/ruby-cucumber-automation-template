# language: en

Feature: Login in Youse System

	Scenario Outline: Login/Logout Functionality
		Given an user navigates to Youse website
		When user logs in using an email as <email>
        And password as <password>
        And the login is successful
        And the Account page was displayed
        Then user could be logout from My Account page
        And the Home page should be displayed

		Examples:
			| email                   | password |
			| pri_test@gmail.com      | 12345678 |

