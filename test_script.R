mat1<-matrix(c(0,6,0,2,7,2,5,0,5),3,3)

mat2<-matrix(NA,3,3)

for(j in 1:3){
  
  dataN<-mat1[,j]
  
  for(i in 1:3){
    
    one<-(dataN[[i]])^2
    
    mat2[i,j]<-one
    
  }
  
}

mat1

mat2
mat1*mat2
