library(igraph)
library(reticulate)
library(igraph)
library(linkcomm)
library('tibble')

source("Utility/new_window.R")
source("Utility/degree_domain.R")
source("Utility/binned_histogram.R")
source("Utility/nonzero_degrees.R")
source("Utility/remove_isolates.R")
source("Utility/reify_link_communities.R")


NS <- read_graph("netscience.graphml", format="graphml")
summary(NS)
##############################Querstion 1#################################
#a)

NS.edges <- as_edgelist(NS)
NS.wlc <- getLinkCommunities(NS.edges, hcmethod="single", plot=FALSE)
print(NS.wlc)

V(NS)$degree       <- degree((NS))
V(NS)$wdegree      <- strength(NS, mode="all")
V(NS)$pagerank     <- page_rank(NS)$vector
V(NS)$betweenness  <- betweenness(NS, normalized=TRUE)
V(NS)$comm_louvain <- membership(cluster_louvain(NS,weights = NA))
V(NS)$comm_infomap <- membership(cluster_infomap(NS,e.weights = NA,v.weights = NA))
V(NS)$commconn     <- getCommunityCentrality(NS.wlc, type="commconn") 

NS.comm <- reify_link_communities(NS, NS.wlc)
summary(NS.comm)
write_graph(NS.comm, "NS_link.graphml", format="graphml")
