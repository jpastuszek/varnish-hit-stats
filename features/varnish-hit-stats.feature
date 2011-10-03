Feature: Hit rate stat generation
  In order to gather knowledge on Varnish hit rates
  As a Varnish admin
  I want to know hit rates for each page class

  Scenario: Getting hit rates from Varnish ncsa log file
    Given Varnish ncsa log file test1.log
    When I run varnish-hit-stats script on that log file
	Then it will print the following output
	"""
	class, pass, hit, miss, total, hit/total
	Cache-Brochure, 0, 3, 3, 6, 0.500000
	Cache-Default, 0, 18, 19, 37, 0.486486
	Cache-Search, 0, 3, 4, 7, 0.428571
	Response-Status, 1, 0, 0, 1, 0.000000
	URL-List, 19, 0, 0, 19, 0.000000

	"""

