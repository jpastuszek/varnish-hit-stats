Feature: Publishing varnish hit stats to jekyll website
  In order to present varnish hit stats on jekyll website
  As a Varnish admin
  I want to process varnish log into published jekyll post

	Background:
		Given USE_BUNDLER_EXEC env var set to true
		And gem bin directory in PATH
		Given source directory
		And source directory is empty
		Given site directory
		And site directory is empty

  Scenario: Processing yesterdays varnish log file into published jekyll post
		Given source directory as script argument
		And site directory as script argument
		And content of test1.log file piped in STDIN
		When I run publish-varnish-hit-stats script
		Then the site directory will contain yesterdays post titled Varnish Hit Stats that will include
		"""
		0.486486
		"""

