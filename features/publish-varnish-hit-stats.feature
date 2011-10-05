Feature: Publishing varnish hit stats to jekyll website
  In order to present varnish hit stats on jekyll website
  As a Varnish admin
  I want to process varnish log into published jekyll post

  Scenario: Processing yesterdays varnish log file into published jekyll post
    Given content of test1.log file
    When I run publish-varnish-hit-stats script with that file content piped in STDIN
		Then jekyll post Varnish Hit Stats in yesterdays directory will contain
		"""
		<!DOCTYPE html>
		<html>
			<head>
				<title>Varnish Hit Stats - My Blog Title</title>
				
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<link rel="stylesheet" media="screen" href="/stylesheets/screen.css" type="text/css" />
				
				
			</head>
			<body>
				<div id="page">
					<div id="header">
						<a href="/"><h1>My Blog Title</h1></a>
					</div>
					<div id="body">
						<h1>Hit Stats</h1>
						<div class="postdate">Posted on 20 Nov 2010</div>

		<div class="post">
		<table>
						<tr>
										<th>class </th>
										<th>pass </th>
										<th>hit </th>
										<th>miss </th>
										<th>total </th>
										<th>hit/total </th>
						</tr>
						<tr>
										<td> Cache-Brochure </td>
										<td> 0 </td>
										<td> 3 </td>
										<td> 3 </td>
										<td> 6 </td>
										<td> 0.500000 </td>
						</tr>
						<tr>
										<td> Cache-Default </td>
										<td> 0 </td>
										<td> 18 </td>
										<td> 19 </td>
										<td> 37 </td>
										<td> 0.486486 </td>
						</tr>
						<tr>
										<td> Cache-Search </td>
										<td> 0 </td>
										<td> 3 </td>
										<td> 4 </td>
										<td> 7 </td>
										<td> 0.428571 </td>
						</tr>
						<tr>
										<td> Response-Status </td>
										<td> 1 </td>
										<td> 0 </td>
										<td> 0 </td>
										<td> 1 </td>
										<td> 0.000000 </td>
						</tr>
						<tr>
										<td> <span class="caps">URL</span>-List </td>
										<td> 19 </td>
										<td> 0 </td>
										<td> 0 </td>
										<td> 19 </td>
										<td> 0.000000 </td>
						</tr>
		</table>
		</div>
		 
		<div id="related">
			<h2>Related Posts</h2>
			<ul class="posts">
				
			</ul>
		</div>


		</div>
					</div>
				</div>

			
			</body>
		</html>

		"""

