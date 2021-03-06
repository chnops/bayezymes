
# Making a matrix to put results into 
results<-matrix(nrow=0,ncol=2)
#this uses igraph as well
library(igraph)
for(i in 1:1000){
	#make a data frame that community results will be put into
	temp<-data.frame(matrix(nrow=dim(data_sub)[1],ncol=3))
	temp[,1]<-data_sub$cazy_1
	temp[,2]<-data_sub$cazy_2
	names(temp)<-c("cazy_1","cazy_2","weight")
	
	# for each j the relationship between two cazy_fams is simulated with mu=weight (B1 from the bayesian model) and SD of the posterior dist.
	for(j in 1:dim(data_sub)[1]){
		#j<-1
		val<-rnorm(1,data_sub$weight[j],data_sub$SD[j])
		# this forces no negative weights as they must be > 0
		if(val < 0){val<-0.0000001}
		temp[j,3]<-val
	}
	#make network of simulated relationships
	temp_g<-simplify(graph.data.frame(temp[,1:3],directed=FALSE))
	# calculate communities based on edge betweenness
	comms<-edge.betweenness.community(temp_g)
	comm_matrix<-data.frame(membership(comms))
	comm_matrix<-cbind(rownames(comm_matrix),comm_matrix)
	names(comm_matrix)<-c("cazy","comm")
	comm_num<-as.vector(unique(comm_matrix$comm))
	# Here we make a list of all grouped pairs within each community
	for(k in 1:length(comm_num)){
		#k<-1
		temp_comm<-subset(comm_matrix, comm==comm_num[k])
		cazies<-as.vector(unique(temp_comm$cazy))
		for(a in 1:length(cazies)){
			#a<-1
			for(b in 1:length(cazies)){
				#b<-2
				new_row<-c(cazies[a],cazies[b])
				results<-rbind(results, new_row)
				#head(results)	
				
			}
		}
	}
	print(i/1000)
	
}
results<-data.frame(results)

# from these results, the number of appearances can be summed and the proportion (p/1000 calculated) to show the probability of cazy_fam's being in the same community