Feature: Generating Jkyll posts from YAML data
	In order to present statistical data as Jekyll posts
	As an admin
	I want to be able to process already collected YAML data into posts

	Background:
		Given USE_BUNDLER_EXEC env var set to true
		And gem bin directory in PATH
		Given source directory
		Given source directory is empty
		Given jekyll directory
		Given source directory contain what jekyll directory contains
		Given source _posts directory

	Scenario: Generating Hit statistics post with vhs-generate-posts
		And _posts directory is empty
		Given source directory as script argument
		And content of test1.yml file piped in STDIN
		When I run vhs-generate-posts script
		Then the _posts directory will contain 2011-10-12 post template titled Varnish hit stats that will include
		"""
		0.366667
		"""
		And the _posts directory will contain 2011-10-12 post template titled Varnish response time stats that will include
		"""
		0.760594
		"""
		
	Scenario: vhs-generate-post when no data is available (empty data set)
		And _posts directory is empty
		Given source directory as script argument
		And content of test_empty.yml file piped in STDIN
		When I run vhs-generate-posts script
		Then the _posts directory will not contain 2011-10-12 post template titled Varnish hit stats
		And the _posts directory will not contain 2011-10-12 post template titled Varnish response time stats
		
