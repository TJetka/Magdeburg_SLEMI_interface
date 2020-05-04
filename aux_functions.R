library(SLEMI)
library(stringr)
library(data.table)
library(readxl)

calculate_capacity<-function(data_folder,
                             signal_column,
                             response_column,
                             addVar_column,
                             testing=FALSE){
  
  if (!data_folder %in% dir()){
    stop("No specified data folder in the directory. Please check.")
  }
  
  nname=paste0(signal_column,"_to_",response_column)
  if (!is.null(addVar_column)){
    nname=paste0(nname,"_accountingFor_",addVar_column)
  }
  output_folder=paste0("output/",data_folder,"_",nname,"/")
  dir.create(output_folder,recursive = TRUE,showWarnings = FALSE)
  
  ## data loading ##
  temp_df_list=list()
  for (ifile in dir(data_folder)){
    temp_df_list[[ifile]]=read_xlsx(paste0(data_folder,"/",ifile),sheet = 1)
  }
  temp_df=try(do.call(rbind,temp_df_list),silent = TRUE)
  if (class(temp_df)=="try-error"){
    stop("There is something wrong with consistency of data. Please check if
         the columns in all data files are the same.")
  }
  rm(temp_df_list)
  
  
  if (!signal_column %in% colnames(temp_df)){
    stop("No specified signal column in the data. Please check.")
  }
  if (!(response_column %in% colnames(temp_df))){
    stop("No specified response column in the data. Please check.")
  }
  if (!is.null(addVar_column)){
    if (!(addVar_column %in% colnames(temp_df))){
      stop("No specified signal column in the data. Please check.")
    }
  }
  
  if (!(class(temp_df[[signal_column]])%in%c("numeric","integer"))){ 
    temp_df[[signal_column]]=as.numeric(str_trim(str_match(temp_df[[signal_column]],
                                                           "[0-9]+[.]?[0-9]*")))
  }
  if (!(class(temp_df[[response_column]])%in%c("numeric","integer"))){ 
    temp_df[[response_column]]=as.numeric(str_trim(str_match(temp_df[[response_column]],
                                                             "[0-9]+[.]?[0-9]*")))
  }
  
  output_cc=capacity_logreg_main(dataRaw=temp_df,
                                 signal = signal_column,
                                 response = response_column,
                                 side_variables = addVar_column,
                                 output_path=output_folder)
  
  if (testing==TRUE){
    output_cc=capacity_logreg_main(dataRaw=temp_df,
                                   signal = signal_column,
                                   response = response_column,
                                   side_variables = addVar_column,
                                   output_path=output_folder,
                                   testing=TRUE,
                                   boot_num=50,
                                   sidevar_num=50,
                                   traintest_num=50)
  }
  
  1
}