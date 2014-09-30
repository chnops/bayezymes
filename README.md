bayezymes
=========

These are scripts related to Bayesian hierarchical models used in a network context for mining soil metagenomes

|_frac_model.R_|
----------------

This script outlines the model that will be used with aggregate fraction (frac) as a random effect.

|_frac_model_imp.R_|
--------------------

This script is the actual implementation of the model in a pairwise framework where each variable is run in a pairwise manner.
The model necessitates installing [JAGS-Just Another Gibbs Sampler](http://http://mcmc-jags.sourceforge.net/)

|_community_simulation.R_|
--------------------------

This script simulates communities using edge betweenness and the posterior distributions of beta1 from each model between pairs of variables.

