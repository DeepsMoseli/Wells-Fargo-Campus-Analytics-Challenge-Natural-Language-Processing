######################################################################
# Demonstration of reify_link_communities using Les Miserables
# 
# Demonstration 11-2-Link-Communities-to-Gephi-LesMis.R shows how
# reify_link_communities.R was constructed, step by step. It creates a
# node for every link community and makes every node in the original
# graph point to its respective link community. This short demo shows
# how to use that utility.
#
# Dan Suthers, April 2017
# April 4, 2018 DS: Les Miserables version this year
# Sep 19, 2018 DS: Minor updates for current script style and clarity
# Nov 14, 2019 DS: Checking and cleaning up commments for topic 11 
#
######################################################################
# This section needed only if you have not run the 11-1 or 11-2 demo. 

library(igraph)
library(linkcomm)

setwd("~/Desktop/Network-Science-Demos") # Set to yours 
LM <- read.graph("Networks/Les-Miserables.graphml", format="graphml")

# Compute the link communities.
LM.edges <- as_edgelist(LM)
LM.wedges <- cbind(LM.edges, E(LM)$weight)
LM.wlc <- getLinkCommunities(LM.wedges, hcmethod="average", plot=FALSE)

# Compute any metrics we want on the graph.
# Reason for this: we will be adding nodes to the graph, so should 
# compute metrics that may be affected before the nodes are added. 
V(LM)$degree       <- degree(LM)
V(LM)$wdegree      <- strength(LM, mode="all")
V(LM)$pagerank     <- page_rank(LM)$vector
V(LM)$betweenness  <- betweenness(LM, normalized=TRUE)
V(LM)$comm_louvain <- membership(cluster_louvain(LM))
V(LM)$comm_infomap <- membership(cluster_infomap(LM))
V(LM)$commweight   <- getCommunityCentrality(LM.wlc, type="commweight")
V(LM)$commconn     <- getCommunityCentrality(LM.wlc, type="commconn") 

summary(LM)

######################################################################
# It's a three line demo! 

# Load the utility 
source("Utility/reify_link_communities.R")

# Reify link communities in a copy of the graph. 
LM.comm <- reify_link_communities(LM, LM.wlc)
summary(LM.comm) # optional 

# Write it out for inspection. 
write_graph(LM.comm, "Les-Mis-Weighted-Communities.graphml", format="graphml")

######################################################################
# Activity: 
#
# From 11-2 (if we skipped that, do this first): 
# We can now take a quick look at what we have accomplished in Gephi. 
# * Size nodes by degree and Color nodes by comm_p 
# * Give it a good layout (Force Atlas2, nonoverlap, linlog, gravity 5) 
# * Point at community nodes to see membership.
# * Use ego filter to see only the community 
# * Change the node coloring between Louvain and InfoMap to see how
#   these compare to link communities. 
#
# Then do the same with Tapped In Chats or Network Science (HW)
# 
######################################################################
# Pau. 