version <- "v1"

n.chains <- 3
n.iter <- 1000
n.neighb <- 4;
n.age <- 3;

basedir <- "~/stat/sanipath/exposure/dw/"
mcmcpost <- paste(basedir,version,"/output/",version,".post.rda",sep="");
mcmcpars <- paste(basedir,version,"/output/",version,".mcmc.rda",sep="");
load(mcmcpost);

extr.mc <- function(varstring) {
  tmp <- array(NA,dim=c(n.chains,n.iter));
  for(k in 1:n.chains) {
    tmp[k,] <- as.vector(mcmc.post[[k]][,varstring]);
  }
  return(c(tmp));
}

extr.mcvec <- function(varstring,len) {
  tmp <- array(NA,dim=c(n.chains,n.iter));
  tmpvec <- numeric(0);
  for(k.len in 1:len){
    for(k.chain in 1:n.chains) {
      tmp[k.chain,] <-
        as.vector(mcmc.post[[k.chain]][,paste(varstring,"[",k.len,"]",sep="")]);
    }
    tmpvec <- cbind(tmpvec,c(tmp));
  }
  return(tmpvec);
}

mu.tap  <- extr.mcvec("mu.tap",n.age)
tau.tap <- extr.mcvec("tau.tap",n.age)
mu.sac  <- extr.mcvec("mu.sac",n.age)
tau.sac <- extr.mcvec("tau.sac",n.age)

dwpars <- list("freqs"=c(freq.tap,freq.sac),
               "mu.tap"=mu.tap,"tau.tap"=tau.tap,
               "mu.sac"=mu.sac,"tau.sac"=tau.sac);
save(dwpars,freqs.neigh,file=mcmcpars,ascii=TRUE);
