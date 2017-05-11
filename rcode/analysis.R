library(dplyr)
library(data.table)

# 提交阶段：该用户2016-04-16到2016-04-20是否下单P中的商品

load('~/JData2017/action_all.RData')
product <- fread('~/JData2017/JData_Product.csv')
user <- fread('~/JData2017/JData_User.csv', na.string=c('NULL'), encoding='UTF-8')

# action表中的用户数，232741
user_action <- unique(action_all$user_id)

# action表中的商品数（cate6），3112
product_action <- unique(action_all$sku_id[action_all$cate == 6])

# action表中cate6的下单记录数，33324
cate6type4_cnt_action <- sum(action_all$cate == 6 & action_all$type == 4)
