Feature: Generating post form varnish hit stat CSV
  In order to present varnish hit stats as a post entry
  As a Varnish admin
  I want to process hit stat CSV into jekyll post entry

  Scenario: Processing stats from STDIN CSV format into page STDOUT output
    Given content of hit_stats1.csv file
    When I run hit-stats-to-post script with that file content piped in STDIN
		Then it will print the following output
		"""
		"""

