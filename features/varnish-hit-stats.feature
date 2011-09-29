Feature: Hit rate stat generation
  In order to gather knowledge on Varnish hit rates
  As a Varnish admin
  I want to know hit rates for each page class

  Scenario: Getting hit rates from Varnish ncsa log file
    Given Varnish ncsa log file test1.log
    When I run varnish-hit-stats script on that log file
	Then it will print the following output
	"""
	dfasf
	"""

