# congress_sponsorship
Cosponsorship networks in the US Congress

#### Intro  
Bills and resolutions introduced in the United States Congress must always have a so-called “sponsor” (main author, backer) and may also have additional co-sponsors (co-authors, co-backers). Presumably, co-sponsors become such because they agree with the text of the bill or resolution; if so, co-sponsorship may be treated as circumstantial evidence for a collaborative relationship between the two persons involved.
  
This project illustrates the co-sponsorship networks of several US Congresses (109th-113th), House and Senate chambers separately. The 109th Congress was the first Congress under GW Bush.


#### Data  
Data comes from [govtrack.us](https://www.govtrack.us/developers/data); data documentation may be found on [github](https://github.com/unitedstates/congress/wiki/bills). I used R with *jsonlite* to parse the JSON files for the *sponsor* and *cosponsors* fields.


#### Transformed Data
Transformed data are found in /data, in folders named after Congresses.  

For a given Congress and chamber:
* congress*congress*-*chamber*.csv contains the raw data parsed from the original data - all the co-sponsorship links found in the original data, combining data from all the bill types for the given Congress and chamber, i.e. /s , /sconres, /sjres and /sres for the Senate and /hr, /hconres, /hjres and /hres for the House. Sponsors and co-sponsors are identified by their unique Library of Congress THOMAS ID. For each bill, there is also a pro-forma line with the sponsor included as the co-sponsor, in order to record how many bills there were;  
* congress*congress*-*chamber*-sum.csv is the above, but summarised;
* congress*congress*-*chamber*-noloop.csv is the above, but with loops removed (i.e. only true edges between different legislators are included). So, this is a list of edges for the graph;
* congress*congress*-*chamber*-leg.csv is a list of nodes for the graph - a list of legislators. /data-legislators contains a list of ALL the legislators, and this file is a subset of that list combined with the number of bills the legislator sponsored in the given Congress/chamber;
* congress*congress*-*chamber*-zzzedgelist.csv, finally, is something readable by humans! It's a summarised list of all the edges in the Congress/chamber graph with edge weights >5, but including some information about the nodes - specifically, the names of the legislators and their parties in addition to their THOMAS IDs.

#### Graphs
Graphs are found in /graphs. They were made in R with *igraph*.   
Vertices represent Senators/Representatives. They are weighted by number of sponsored bills and coloured by party (blue=Democrat, red=Republican, orange=other).  
Edges represent co-sponsorship relationships. The graphs are directed, the direction of the arrow is from the sponsor to the co-sponsor. Edge widths are weighted by the number of co-sponsored bills and coloured by the party of the sponsor.  
Graph files have the naming convention of *congress*-*chamber*-*cutoff*, where *cutoff* is the noninclusive threshold of edge weight required for edge visualisation. So, for example, cutoff=5 means that only edges with weights 6 or larger are displayed.


#### Scripts and how to use them
Scripts are found in /scripts. To use them, download the original data to /data_bills/*congress*, and then set the working directory and the Congress in the scripts. The working directory is the one which contains /data, /scripts, /data_bills, /data_legislators etc..  

* script1.R parses the original data files to obtain congress*congress*-*chamber*.csv and congress*congress*-*chamber*-sum.csv;
* script2.R uses the result of script1.R and the legislator files from /data-legislators to obtain congress*congress*-*chamber*-leg.csv and congress*congress*-*chamber*-noloop.csv, i.e. the list of graph nodes and edges;
* script3.R constructs graphs;
* script4.R combines the raw edge lists from several Congresses, specified inside. So, it is supposed to be used between script1 and script2. There are some folders in /data and graphs in /graph which combine the networks from several Congresses - 107_108_109_110 and 110_111_112_113.
