Feature: Publishing varnish hit stats to jekyll website
  In order to present varnish hit stats on jekyll website
  As a Varnish admin
  I want to process varnish log into published jekyll post

  Scenario: Processing yesterdays varnish log file into published jekyll post
		Given USE_BUNDLER_EXEC env var set to true
		Given gem bin directory in PATH
		Given jekyll test directory
		Given jekyll directory as script argument
    Given content of test1.log file piped in STDIN
    When I run publish-varnish-hit-stats script
		Then jekyll post Varnish Hit Stats in yesterdays directory will include 
		"""
		0.486486
		"""

