s#etwd("/Users/ryanjwtx/Desktop/ANL_meeting_2014")

#dataset<-read.csv("data_noncore_cazyfam.csv")

summary(dataset)

# Using rjags library that communicates to JAGS (Just Another Gibbs Sampler)
library("rjags")


# Set up variables for the model, SoilFrac is aggregate fractions that will be random terms
Ndata<-nrow(dataset)
Nfrac<-length(unique(dataset$SoilFrac))
frac<-as.numeric(dataset$SoilFrac)

# Using the following function to implement the Bayesian hierarchical model
bayezymes<-function(var1, var2){
	x<-var1
	y<-var2
Ndata<-nrow(dataset)
Nfrac<-length(unique(dataset$SoilFrac))
frac<-as.numeric(dataset$SoilFrac)

# centering variables
	zx<-x-mean(x)
	zy<-y-mean(y)

# calling model that is called frac_model, this object is initialized in the script frac_model.R
# Using 10 Chains
	model_imp<-jags.model(textConnection(frac_model), data=list(
		"Ndata"=Ndata,
		"x"=zx,
		"y"=zy,
		"Nfrac"=Nfrac,
		"frac"=frac
		),n.chains=10,quiet=TRUE)

#Chains are 100000 values long and thinned every 100
	chains<-coda.samples(model=model_imp, c("beta1"),n.iter=100000,thin=100)
	#plot(chains)

	results<-matrix(nrow=0,ncol=1)
# the initial 500 values are thrown away as burn in
	for(i in 1:10){
			burned<-as.matrix(chains[[i]][501:1000,],ncol=1)
			results<-rbind(results, burned)	
	}

# calculating mean, median, and 95% credible interval for each variable
# also maintaining the actual values of the distribution here, standard deviation was calculated later but can be included here
	means<-mean(results)
	medians<-median(results)
	high95<-quantile(results,0.975)
	low95<-quantile(results, 0.025)
	result_stats<-c(means,medians,high95[[1]],low95[[1]],results)
	return(result_stats)

}


# results are put into the following matrix
head(dataset[,1:10])
bayezymes_results<-matrix(nrow=0,ncol=5006)
for(a in 3:(dim(dataset)[2]-1)){
	
	for(b in 4:dim(dataset)[2]){
		#b<-6
		
		fam1<-names(dataset)[a]
		fam2<-names(dataset)[b]
		output<-c(fam1,fam2,bayezymes(dataset[,a],dataset[,b]))
		output
		bayezymes_results<-rbind(bayezymes_results, output)
		print(a/205)
		
	}
}

