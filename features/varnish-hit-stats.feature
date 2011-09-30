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
	Cache-Brochure, 0, 2, 2, 4, 0.500000
	Cache-Default, 0, 17, 20, 37, 0.459459
	Cache-Search, 0, 1, 2, 3, 0.333333
	URL-List, 14, 0, 0, 14, 0.000000

	"""

