Feature: Generating Jkyll posts from YAML data
	In order to present statistical data as Jekyll posts
	As an admin
	I want to be able to process already collected YAML data into posts

	Background:
		Given USE_BUNDLER_EXEC env var set to true
		And gem bin directory in PATH
		Given source directory
		Given source _posts directory
		And _posts directory is empty

	Scenario: Generating Hit statistics post with vhs-generate-posts
		Given source directory as script argument
		And content of test1.yml file piped in STDIN
		When I run vhs-generate-posts script
		Then the _posts directory will contain 2011-10-03 post template titled Varnish Hit Stats that will include
		"""
		0.381818
		"""
		
