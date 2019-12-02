######################################################################
# reify_link_communities 
# Adds vertices representing link communities to a graph, with the
# intention that they be used for visualization in Gephi. 
# Dan Suthers, Nov 16, 2016
# April 7, 2018 Comment added concerning computation of node.ids
# Nov 14 2019 DS: Minor reordering for clarity; no functional change 
######################################################################
library(igraph)
library(linkcomm)

# Community labels will be constructed from IDs to indicate 
# that they are communities. 
#
comm_label <- function (id) {return(paste0("COMM_", id))}

# Given a graph g and a legal link community object lc for
# that graph, returns a copy of the graph with communites
# added as vertices. We don't compute the link community
# within this function as we want the user to retain full
# control of that computation through its various parameters. 
# 
reify_link_communities <- function(g, lc) {
	
  #  Mark existing vertices as not being community nodes. 
  V(g)$comm_p <- FALSE 

  # Create a "community" vertex for each cluster. The cluster
  # column of attribute $nodeclusters has cluster ids. It's a
  # factor, so we can get the possible values with 'levels'. 
  for(id in levels(lc$nodeclusters$cluster)) {
  	g <- add_vertices(g, 1, label = comm_label(id), comm_p = TRUE)
  }

  # Make corresponding list of communities identified by label. 
  comm.labels <- vapply(lc$nodeclusters$cluster, comm_label, character(1))

  # Get list of regular vertices. 
  # Note that node.ids <- lc$nodeclusters$node did not work. 
  node.ids <- as.numeric(as.vector(lc$nodeclusters$node))
  
  # Make the regular vertices point to their community vertices,
  # using 'which' to map from string labels to actual node IDs. 
  for (i in 1:length(node.ids)) {
	  g <- g + edge(node.ids[i], which(V(g)$label == comm.labels[i]))
  }
  return(g)
}

######################################################################
# Pau 