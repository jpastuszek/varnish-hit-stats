Feature: Processing Varnish access log file
	In order to gather knowledge on Varnish hit rates
	As an admin
	I want to extract hit rates from Varnish access log file

	Scenario: Processing varinsh access log file with vhs-process
		Given content of test1.log file piped in STDIN
		When I run vhs-process script
		Then it will output yaml that is the same as
		"""
		--- 
		:parser: 
		  :failures: 0
		  :successes: 71
		:hit: 
		  unset: 
		    :pass: 1
		    :miss: 0
		    :total: 1
		    :hit_to_total: 0
		    :hit: 0
		  Response-Status: 
		    :pass: 1
		    :miss: 0
		    :total: 1
		    :hit_to_total: 0
		    :hit: 0
		  Cache-Default: 
		    :pass: 0
		    :miss: 19
		    :total: 37
		    :hit_to_total: 0
		    :hit: 18
		  Cache-Brochure: 
		    :pass: 0
		    :miss: 3
		    :total: 6
		    :hit_to_total: 0
		    :hit: 3
		  URL-List: 
		    :pass: 19
		    :miss: 0
		    :total: 19
		    :hit_to_total: 0
		    :hit: 0
		  Cache-Search: 
		    :pass: 0
		    :miss: 4
		    :total: 7
		    :hit_to_total: 0
		    :hit: 3
		"""

