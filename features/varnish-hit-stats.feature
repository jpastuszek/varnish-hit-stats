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
	Cache-Brochure, 0, 2, 5, 7, 0.285714
	Cache-Default, 0, 8, 45, 53, 0.150943
	Cache-Search, 0, 0, 4, 4, 0.000000
	Request-List, 1, 0, 0, 1, 0.000000
	URL-List, 20, 0, 0, 20, 0.000000

	"""

