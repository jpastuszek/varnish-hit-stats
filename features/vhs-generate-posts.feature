Feature: Generating Jkyll posts from YAML data
	In order to present statistical data as Jekyll posts
	As an admin
	I want to be able to process already collected YAML data into posts

	Background:
		Given USE_BUNDLER_EXEC env var set to true
		And gem bin directory in PATH
		Given jekyll directory
		And source directory
		Given source directory contain what jekyll directory contains
		Given source _posts directory
		And source csv directory

	Scenario: Generating Hit statistics post with vhs-generate-posts
		Given source _posts directory is empty
		Given source directory as script argument
		And content of test1.yml file piped in STDIN
		When I run vhs-generate-posts script
		Then the source _posts directory will contain 2011-10-12 post template titled Varnish Request Statistics that will include
		"""
		0.251896
		"""

	Scenario: Generating Hit statistics post with vhs-generate-posts and location
		Given source _posts directory is empty
		Given '-l Singapore' as script argument
		And source directory as script argument
		And content of test1.yml file piped in STDIN
		When I run vhs-generate-posts script
		Then the source _posts directory will contain 2011-10-12 post template titled Varnish Request Statistics - Singapore that will include
		"""
		0.251896
		"""

	Scenario: Generating Hit statistics CSV with vhs-generate-posts and location
		Given source _posts directory is empty
		And source csv directory is empty
		Given '-l Singapore' as script argument
		And source directory as script argument
		And content of test1.yml file piped in STDIN
		When I run vhs-generate-posts script
		Then the source csv directory will contain 2011-10-12 CSV titled Varnish Request Statistics - Singapore that will include
		"""
		0.251896
		"""
		
	Scenario: vhs-generate-post when no data is available (empty data set)
		Given source _posts directory is empty
		Given source directory as script argument
		And content of test_empty.yml file piped in STDIN
		When I run vhs-generate-posts script
		Then the source _posts directory will not contain 2011-10-12 post template titled Varnish Request Statistics
		
