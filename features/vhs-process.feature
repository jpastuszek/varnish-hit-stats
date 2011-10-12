Feature: Processing Varnish access log file
	In order to gather knowledge on Varnish hit rates
	As an admin
	I want to extract hit rates from Varnish access log file

	Scenario: Processing varinsh access log file with vhs-process
		Given content of test1.log file piped in STDIN
		When I run vhs-process script
		Then it will output yaml that has the same hash structure and types as
		"""
		--- 
		:info:
		  :first_entry_time: 2011-10-03 16:26:04 Z
		  :last_entry_time: 2011-10-03 16:30:17 Z
		:parser: 
		  :failures: 0
		  :successes: 71
		:hit: 
		  Response-Status: 
		    :pass: 1
		    :miss: 0
		    :total: 1
		    :hit_to_total_ratio: 0.0
		    :hit: 0
		  Cache-Default: 
		    :pass: 0
		    :miss: 19
		    :total: 37
		    :hit_to_total_ratio: 0.486486486486487
		    :hit: 18
		  Cache-Brochure: 
		    :pass: 0
		    :miss: 3
		    :total: 6
		    :hit_to_total_ratio: 0.5
		    :hit: 3
		  URL-List: 
		    :pass: 19
		    :miss: 0
		    :total: 19
		    :hit_to_total_ratio: 0.0
		    :hit: 0
		  Cache-Search: 
		    :pass: 0
		    :miss: 4
		    :total: 7
		    :hit_to_total_ratio: 0.428571428571429
		    :hit: 3
		  total:
		    :hit: 42
		    :pass: 23
		    :miss: 45
		    :hit_to_total_ratio: 0.381818181818182
		    :total: 110
		"""

