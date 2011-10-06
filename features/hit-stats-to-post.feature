Feature: Generating post form varnish hit stat CSV
  In order to present varnish hit stats as a post entry
  As a Varnish admin
  I want to process hit stat CSV into jekyll post entry

  Scenario: Processing stats from STDIN CSV format into page STDOUT output
    Given content of hit_stats1.csv file piped in STDIN
    When I run hit-stats-to-post script
		Then it will output the following output
		"""
		---
		layout: post
		title: Varnish hit stats
		tags: [varnish hit stats]
		---
		|_. class |_. pass |_. hit |_. miss |_. total |_. hit/total |
		| Cache-Brochure | 0 | 3 | 3 | 6 | 0.500000 |
		| Cache-Default | 0 | 18 | 19 | 37 | 0.486486 |
		| Cache-Search | 0 | 3 | 4 | 7 | 0.428571 |
		| Response-Status | 1 | 0 | 0 | 1 | 0.000000 |
		| URL-List | 19 | 0 | 0 | 19 | 0.000000 |

		"""

