require 'universal-access-log-parser'

UniversalAccessLogParser.parser(:varnish) do
	apache_combined
	string :handling, :process => lambda{|s| s.to_sym}
	string :current_status, :nil_on => '-'
	string :initial_status, :nil_on => '-'
	integer :cache_hits
	float :cache_ttl, :nil_on => '-'
	integer :cache_age
	float :response_time
end


