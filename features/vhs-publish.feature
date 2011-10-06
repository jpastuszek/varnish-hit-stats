Feature: Publishing Varnish hit statistics as Jekyll website
		In order to present Varnish hit statistics on Jekyll website
		As a Varnish admin
		I want to render Jekyll website from Jekyll source directory

		Background:
				Given USE_BUNDLER_EXEC env var set to true
				And gem bin directory in PATH
				Given source directory
				And source directory is empty
				Given site directory
				And site directory is empty
				Given test_source test directory
				Given source directory contain what test_source directory contains

				Scenario: Publishing Jekyll website from Jekyll source directory to site directory	
						Given source directory as script argument
						And site directory as script argument
						When I run vhs-publish script
						Then site directory will contain entries
						| 2011 |
						| about.html |
						| atom.xml |
						| images |
						| index.html |
						| robots.txt |
						| sitemap.xml |
						| stylesheets |
						
