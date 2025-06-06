#Gold Standard GRN
rm(list = ls())
##1. Package loading
##--------------------------------------------------------------------------------------------
library(readr)
library(Seurat)
library(SeuratData)
##--------------------------------------------------------------------------------------------
data_source<-"Zheng"
dim_data<-300
p_TF<-8
#2. Set up the overall file path
##--------------------------------------------------------------------------------------------
File_path<-paste("./Benchmarking on scRNA-seq data/",data_source,"'s file",sep = "")
##--------------------------------------------------------------------------------------------

##3. load the GRN geneset and specifc the TFs
##--------------------------------------------------------------------------------------------
load(paste(File_path,"/Data/gene_GRN_intop",dim_data,"HVG_4group.Rdata",sep = ""))
TF_choose<-gene_GRN[1:p_TF]
##--------------------------------------------------------------------------------------------

##4. Construction of golden standard GRN from collected database
##--------------------------------------------------------------------------------------------
##4.0 Preparion
# setwd(paste("./reference database",sep = ""))
##
gold_standard_network<-diag(length(gene_GRN))
rownames(gold_standard_network)<-gene_GRN
colnames(gold_standard_network)<-gene_GRN
pat_mat<-matrix(0,nrow = length(gene_GRN),ncol = length(gene_GRN))
pat_mat[1:length(TF_choose),]<-1
sel_index<-which(pat_mat[upper.tri(pat_mat)] == 1)

##4.1 Database: ChEA
data_ChEA<-read.table("./reference database/ChEA/gene_attribute_edges.txt",header = TRUE)
data_ChEA<-data_ChEA[-1,]
data_ChEA_choose<-data_ChEA[which(data_ChEA$source %in% TF_choose),c(1,4)]
rm(data_ChEA)
for(tf_index in 1:length(TF_choose)){
  target_ori<-data_ChEA_choose[data_ChEA_choose$source == TF_choose[tf_index],2]
  index_in<-which(gene_GRN %in% target_ori)
  gold_standard_network[tf_index,index_in]<-1
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))

##4.2 Database: ChiP-Atlas
file_names<-dir(paste("./reference database/Chip-Atlas/",data_source,"/",sep = ""))
TF_use_chipatlas<-as.vector(Reduce("rbind",strsplit(file_names,".t"))[,1])
for(tf_index in 1:length(TF_use_chipatlas)){
  data_chipatlas<-read_tsv(paste("./reference database/Chip-Atlas/",data_source,"/",file_names[tf_index],sep = "")) 
  target_ori<-as.vector(as.matrix(data_chipatlas[,1]))
  index_in<-which(gene_GRN %in% target_ori)
  gold_standard_network[which(TF_choose == TF_use_chipatlas[tf_index]),index_in]<-1
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))

##4.3 Database: chip-base
data_chipbase<-read.csv(paste("./reference database/chip-base/",data_source,"/GRN_chipbase.csv",sep = ""),header = TRUE)
data_chipbase_choose<-data_chipbase[which(data_chipbase$TF %in% TF_choose),c(2,3)]
rm(data_chipbase)
for(tf_index in 1:length(TF_choose)){
  target_ori<-data_chipbase_choose[data_chipbase_choose$TF == TF_choose[tf_index],1]
  index_in<-which(gene_GRN %in% target_ori)
  gold_standard_network[tf_index,index_in]<-1
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))

##4.4 Database: ESCAPE
data_ESCAPE<-read.table("./reference database/ESCAPE/chip_x.txt",header = TRUE)
data_ESCAPE_choose<-data_ESCAPE[which(data_ESCAPE$sourceName %in% TF_choose),c(1,3)]
rm(data_ESCAPE)
for(tf_index in 1:length(TF_choose)){
  target_ori<-data_ESCAPE_choose[data_ESCAPE_choose$sourceName == TF_choose[tf_index],2]
  index_in<-which(gene_GRN %in% target_ori)
  gold_standard_network[tf_index,index_in]<-1
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))

##4.5 Database: GRNdb (PBMC)
##4.5.1. Adult-Peripheral-Blood-regulons
data_GRNdb<-read.table("./reference database/GRNdb/Adult-Peripheral-Blood-regulons.txt",header = TRUE,quote = "",fill = TRUE)
data_GRNdb_choose<-data_GRNdb[which(data_GRNdb$TF %in% TF_choose),c(1,2)]
rm(data_GRNdb)
for(tf_index in 1:length(TF_choose)){
  target_ori<-data_GRNdb_choose[data_GRNdb_choose$TF == TF_choose[tf_index],2]
  index_in<-which(gene_GRN %in% target_ori)
  gold_standard_network[tf_index,index_in]<-1
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))

##4.5.2. Adult-Peripheral-Blood-regulons
data_GRNdb<-read.table("./reference database/GRNdb/PBMC-regulons.txt",header = TRUE,quote = "",fill = TRUE)
data_GRNdb_choose<-data_GRNdb[which(data_GRNdb$TF %in% TF_choose),c(1,2)]
rm(data_GRNdb)
for(tf_index in 1:length(TF_choose)){
  target_ori<-data_GRNdb_choose[data_GRNdb_choose$TF == TF_choose[tf_index],2]
  index_in<-which(gene_GRN %in% target_ori)
  gold_standard_network[tf_index,index_in]<-1
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))

##4.5.3. Adult-Peripheral-Blood-regulons
data_GRNdb<-read.table("./reference database/GRNdb/whole_PeripheralBlood-regulons.txt",header = TRUE,quote = "",fill = TRUE)
data_GRNdb_choose<-data_GRNdb[which(data_GRNdb$TF %in% TF_choose),c(1,2)]
rm(data_GRNdb)
for(tf_index in 1:length(TF_choose)){
  target_ori<-data_GRNdb_choose[data_GRNdb_choose$TF == TF_choose[tf_index],2]
  index_in<-which(gene_GRN %in% target_ori)
  gold_standard_network[tf_index,index_in]<-1
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))

##4.6 Database: htftarget
file_names<-dir(paste("./reference database/htftarget/",data_source,"/",sep = ""))
TF_use_htftarget<-as.vector(Reduce("rbind",strsplit(file_names,".t"))[,1])
for(tf_index in 1:length(TF_use_htftarget)){
  data_htftarget<-read.table(paste("./reference database/htftarget/",data_source,"/",file_names[tf_index],sep = ""),quote = "",fill = TRUE,header = TRUE,row.names = NULL) 
  target_ori<-as.vector(as.matrix(data_htftarget[,3]))
  index_in<-which(gene_GRN %in% target_ori)
  gold_standard_network[which(TF_choose == TF_use_htftarget[tf_index]),index_in]<-1
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))

##4.7 Database: HumanTFDB
data_TFDB<-read.csv(paste("./reference database/HumanTFDB/",data_source,"/humantfdb_ref.csv",sep = ""),header = FALSE)
colnames(data_TFDB)[1:3]<-c("TF","Type","TARGET")
data_TFDB_choose<-data_TFDB[which(data_TFDB$TF %in% TF_choose),c(1,3)]
rm(data_TFDB)
for(tf_index in 1:length(TF_choose)){
  target_ori<-data_TFDB_choose[data_TFDB_choose$TF == TF_choose[tf_index],2]
  index_in<-which(gene_GRN %in% target_ori)
  gold_standard_network[tf_index,index_in]<-1
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))

##4.8 Database: RegNetwork
data_RegNetwork<-read.csv(paste("./reference database/RegNetwork/",data_source,"/RegNetwork_ref.csv",sep = ""),header = TRUE)
data_RegNetwork_choose<-data_RegNetwork[which(data_RegNetwork$regulator_symbol %in% TF_choose),c(1,3)]
rm(data_RegNetwork)
for(tf_index in 1:length(TF_choose)){
  target_ori<-data_RegNetwork_choose[data_RegNetwork_choose$regulator_symbol == TF_choose[tf_index],2]
  index_in<-which(gene_GRN %in% target_ori)
  gold_standard_network[tf_index,index_in]<-1
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))

##4.9 Database: TRRUST
data_TRRUST<-read_tsv("./reference database/TRRUST/trrust_rawdata.human.tsv",col_names = FALSE)
colnames(data_TRRUST)<-c("TF","TARGET","Type","score")
data_TRRUST_choose<-data_TRRUST[which(data_TRRUST$TF %in% TF_choose),c(1,2)]
data_TRRUST_choose<-as.data.frame(data_TRRUST_choose)
rm(data_TRRUST)
for(tf_index in 1:length(TF_choose)){
  target_ori<-data_TRRUST_choose[data_TRRUST_choose$TF == TF_choose[tf_index],2]
  index_in<-which(gene_GRN %in% target_ori)
  gold_standard_network[tf_index,index_in]<-1
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))

##4.9 Database: STRING
protein_info<-read.table("./reference database/STRING/9606.protein.info.v11.5.txt",header = TRUE,sep = "\t")
protein_info<-protein_info[,c(1,2)]
protein_link<-read.table("./reference database/STRING/9606.protein.links.v11.5.txt.gz.inproc",header = TRUE,sep = " ")
score_threshold<-850
protein_link_sel<-protein_link[which(protein_link$combined_score>=score_threshold),]
dim(protein_link_sel)
##
for(tf_index in 1:length(TF_choose)){
  
  ENSP_num<-protein_info$string_protein_id[which(protein_info$preferred_name == TF_choose[tf_index])]
  index_1<-which(protein_link_sel$protein1 == ENSP_num)
  index_2<-which(protein_link_sel$protein2 == ENSP_num)
  target_ori<-c()
  if(length(index_1)>0){
    target_ori<-c(target_ori,protein_link_sel$protein2[index_1])
  }
  if(length(index_2)>0){
    target_ori<-c(target_ori,protein_link_sel$protein1[index_2])
  }
  target_ori_ENSP_num<-unique(target_ori)
  #tran
  if(length(target_ori_ENSP_num)>0){
    target_ori<-protein_info$preferred_name[which(protein_info$string_protein_id %in% target_ori_ENSP_num)]
  }else{
    target_ori<-c()
  }
  index_in<-which(gene_GRN %in% target_ori)
  if(length(index_in)>0){
    gold_standard_network[tf_index,index_in]<-1 
  }
}
gold_standard_network<-gold_standard_network + t(gold_standard_network)
gold_standard_network<-ifelse(gold_standard_network>0,1,0)
(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
prop.table(table(gold_standard_network[upper.tri(gold_standard_network)][sel_index]))
##--------------------------------------------------------------------------------------------

##5. Description of data
##--------------------------------------------------------------------------------------------
p_GRN<-300
if(data_source == "Kang"){
  celltypes_num<-10 
}
if(data_source == "Zheng"){
  celltypes_num<-4
}
p_nonTF<-p_GRN - p_TF
description_data<-c(p_TF,p_GRN,p_nonTF,celltypes_num)
names(description_data)<-c("p_TF","p_GRN","p_nonTF","celltypes_num")
save(description_data,file = paste(File_path,"/Evaluation/Obj_use/description_data_4group.Rdata",sep = ""))

##6. Load data
##--------------------------------------------------------------------------------------------
load(paste(File_path,"/Method/EMPLN/Output_Obj/EMPLN_init_4group.Rdata",sep = ""))
load(paste(File_path,"/Data/cluster_true_4group.Rdata",sep = ""))
load(paste(File_path,"/Evaluation/Obj_use/TF_list_all.Rdata",sep = ""))
## Data from other batch
load(paste(File_path,"/Evaluation/Obj_use/expression_profile_otherbatch.Rdata",sep = ""))
load(paste(File_path,"/Evaluation/Obj_use/cluster_true_otherbatch.Rdata",sep = ""))
cluster_true_otherbatch<-ifelse(grepl("Monocyte", cluster_true_otherbatch), "Monocyte", cluster_true_otherbatch)
cell_names<-c("B cell", "CD4 T cell", "CD8 T cell", "Monocyte")
cell_index_otherbatch<-which(cluster_true_otherbatch %in% cell_names)
cluster_true_otherbatch<-cluster_true_otherbatch[cell_index_otherbatch]
expression_profile_otherbatch<-expression_profile_otherbatch[,cell_index_otherbatch]
##--------------------------------------------------------------------------------------------

##7. Construction of silver standard GRN for each cell type
##--------------------------------------------------------------------------------------------
##7.1 Preparion
celltype_order<-colnames(table(EMPLN_init$celltypes_label,cluster_true))[apply(table(EMPLN_init$celltypes_label,cluster_true),MARGIN = 1,which.max)]
##
expressmat_otherbatch<-matrix(NA,nrow = dim(expression_profile_otherbatch)[2],ncol = 300)
for(j in 1:p_GRN){
  gene_use<-gene_GRN[j]
  expressmat_otherbatch[,j]<-as.vector(expression_profile_otherbatch[which(rownames(expression_profile_otherbatch) == gene_use),])
}
ls_vec_otherbatch<-rowSums(expressmat_otherbatch)/10000

expressmat_otherbatch_GRN<-expressmat_otherbatch[,1:p_GRN]

##7.2 Calculate the pvalue of spearman correlation of each cell-type-specifc scRNA profile
pvalue_spearman_otherbatch_GRN<-array(NA,dim = c(celltypes_num,p_GRN,p_GRN))
for(g in 1:length(celltype_order)){
  # print(paste("celltype: ",g,sep = ""))
  ##
  mat_use<-(expressmat_otherbatch_GRN[which(cluster_true_otherbatch == celltype_order[g]),])/ls_vec_otherbatch[which(cluster_true_otherbatch == celltype_order[g])]
  pvalue_mat<-diag(ncol(mat_use))
  for(i in 1:(ncol(mat_use) - 1)){
    # print(i)
    for(j in (i+1):ncol(mat_use)){
      cor_test<-cor.test(mat_use[,i],mat_use[,j],method = "spearman")
      pvalue_mat[i,j]<-cor_test$p.value
    }
  }
  pvalue_spearman_otherbatch_GRN[g,,]<-pvalue_mat
  
}

##7.3 Exact the cell-type-specific silver standard GRN
pvalue_threshold<-0.1
Silver_Standard_GRN<-array(NA,dim = c(celltypes_num,p_GRN,p_GRN))
dimnames(Silver_Standard_GRN)[[1]]<-celltype_order
dimnames(Silver_Standard_GRN)[[2]]<-gene_GRN[1:p_GRN]
dimnames(Silver_Standard_GRN)[[3]]<-gene_GRN[1:p_GRN]
##
for(g in 1:celltypes_num){
  mat_pvalue_cut<-diag(p_GRN)
  mat_pvalue_cut[upper.tri(mat_pvalue_cut)][which((pvalue_spearman_otherbatch_GRN[g,,])[upper.tri(pvalue_spearman_otherbatch_GRN[g,,])]<pvalue_threshold)]<-1
  mat_pvalue_cut<-mat_pvalue_cut + t(mat_pvalue_cut) - diag(p_GRN)
  Silver_Standard_GRN[g,,]<-as.matrix(mat_pvalue_cut * gold_standard_network)
}

##--------------------------------------------------------------------------------------------
## 8. Save The Silver Stand GRN
##--------------------------------------------------------------------------------------------
save(Silver_Standard_GRN,file = paste(File_path,"/Evaluation/Obj_use/Silver_Standard_GRN.Rdata",sep = ""))
##--------------------------------------------------------------------------------------------
