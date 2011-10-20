Feature: Initialization and update of Jekyll source directory
	In order to generate blog with statistics
	As an admin
	I want to initialize Jekyll directory where posts will be storred and whole blog will be generated from

	Background:
		Given USE_BUNDLER_EXEC env var set to true
		And gem bin directory in PATH
		Given jekyll directory
		And source directory
		And source _posts directory
		And source csv directory

	Scenario: Initialization of Jekyll source directory
		And source directory is empty
		Given source directory as script argument
		When I run vhs-init script
		Then source directory will contain entries
		| _config.yml |
		| _layouts |
		| _posts |
		| _site |
		| atom.xml |
		| index.html |

	Scenario: Updating files in already existing Jekyll source directory
		Given source directory contain what jekyll directory contains
		And file index.html in source directory contain
		"""
		modified
		"""
		Given source directory as script argument
		When I run vhs-init script
		Then file index.html in source directory will be identical to index.html file in jekyll directory

	Scenario: Updating files in already existing Jekyll source director should not remove posts
		And source directory is empty
		And source _posts directory is empty
		And there are files a,b,c in source _posts directory
		Given source directory as script argument
		When I run vhs-init script
		Then those files will exist
		And source directory will contain entries
		| _config.yml |
		| _layouts |
		| _posts |
		| _site |
		| atom.xml |
		| index.html |

	Scenario: Updating files in already existing Jekyll source director should not remove csv
		And source directory is empty
		And source csv directory is empty
		And there are files a,b,c in source csv directory
		Given source directory as script argument
		When I run vhs-init script
		Then those files will exist
		And source directory will contain entries
		| _config.yml |
		| _layouts |
		| _posts |
		| csv |
		| _site |
		| atom.xml |
		| index.html |



	Scenario: Updating files in already existing Jekyll source director should remove other files
		And source directory is empty
		Given there are files a,b,c in source directory
		Given source directory as script argument
		When I run vhs-init script
		Then those files will not exist
		And source directory will contain entries
		| _config.yml |
		| _layouts |
		| _posts |
		| _site |
		| atom.xml |
		| index.html |

