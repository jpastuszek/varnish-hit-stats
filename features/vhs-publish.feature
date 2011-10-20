Feature: Publishing Varnish hit statistics as Jekyll website
		In order to present Varnish hit statistics on Jekyll website
		As a Varnish admin
		I want to render Jekyll website from Jekyll source directory

		Background:
				Given USE_BUNDLER_EXEC env var set to true
				And gem bin directory in PATH
				Given jekyll directory
				Given site directory

				Scenario: Publishing Jekyll website from Jekyll source directory to site directory	
						Given site directory is empty
						Given jekyll directory as script argument
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
						
