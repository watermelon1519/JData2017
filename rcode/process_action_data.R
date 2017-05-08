library(data.table)
library(dplyr)

# 赛事网址：http://xianzhi.jd.com/#
# 提交：该用户2016-04-16到2016-04-20是否下单P中的商品
# 训练：该用户2016-04-09到2016-04-13是否下单P中的商品

# clear memory
clear_memory <- function(x=c()) {
    if (length(x) == 0) {
    gc()
  } else if (length(x) == 1 & x[1] == 1) {
    rm(list = ls())
    gc()
  } else {
    rm(list = x, inherits=TRUE)
    gc()
  }
}

clear_memory(1)

# product <- fread('./JData_Product.csv')
# user <- fread('./JData_User.csv', na.strings='NULL')
# comment <- fread('./JData_Comment.csv')

fpath1 <- './JData_Action_0301_0315.csv'
fpath2 <- './JData_Action_0316_0331.csv'
fpath3 <- './JData_Action_0401_0415.csv'

# fpath_list <- c('./JData_Action_0301_0315.csv', './JData_Action_0316_0331.csv', './JData_Action_0401_0415.csv')

# 处理行为数据
action_processor <- function(fpath) {

    # read data
    action <- fread(fpath)
    cat("There are ", nrow(action), " rows in the original df.\n")
  
    # remove duplicated rows
    # 暂时忽略model_id
    cat("Remove duplicated rows.\n")
    action <- action[!duplicated(action, by=c('user_id', 'sku_id', 'time', 'type')), ]
    cat("There are ", nrow(action), " rows left.\n")
  
    # print(table(action$cate))
  
    return(action)
  
}

action1 <- action_processor(fpath1)
clear_memory()

action2 <- action_processor(fpath2)
clear_memory()

action_all <- rbind(action1, action2)
clear_memory(x=c('action1', 'action2'))

action3 <- action_processor(fpath3)
clear_memory()

action_all <- rbind(action_all, action3)
clear_memory(c('action3'))

# 总体去重
action_all <- action_all[!duplicated(action_all), ]

# 保存数据
save(action_all, file='action_all.RData')