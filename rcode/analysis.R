library(dplyr)
library(data.table)
library(reshape2)

# 提交阶段：该用户2016-04-16到2016-04-20是否下单P中的商品

# 训练标记：该用户2016-04-09到2016-04-13是否下单P中的商品
# 训练标记：该用户2016-04-02到2016-04-16是否下单P中的商品

# load('~/JData2017/action_all.RData')
# product <- fread('~/JData2017/JData_Product.csv')
# user <- fread('~/JData2017/JData_User.csv', na.strings=c('NULL'), encoding='UTF-8')

load('E:/JData2017/action_all.RData')
product <- fread('E:/JData2017/JData_Product.csv')
user <- fread('E:/JData2017/JData_User.csv', na.strings=c('NULL'))

# action表中的用户数，232741
user_action <- unique(action_all$user_id)

# action表中的商品数（cate6），3112
product_action <- unique(action_all$sku_id[action_all$cate == 6])

# action表中cate6的下单记录数，33324
cate6type4_cnt_action <- sum(action_all$cate == 6 & action_all$type == 4)

# 不同品类每日下单数
type4_by_day <- action_all %>% filter(type == 4) %>% group_by(dt, cate) %>% summarise(cnt=n()) %>% arrange(dt)
type4_by_day <- dcast(type4_by_day, dt ~ cate, value.var = c('cnt'))

# 不同品类每日浏览数
type1_by_day <- action_all %>% filter(type == 1) %>% group_by(dt, cate) %>% summarise(cnt=n()) %>% arrange(dt)
type1_by_day <- dcast(type1_by_day, dt ~ cate, value.var = c('cnt'))

# 用户购买cate6的次数分布
# 99.7%的用户只购买了一次
cate6_buy_cnt_per_user <- action_all %>% filter(type == 4 & cate == 6) %>% group_by(user_id) %>% summarise(cnt = n())

#######################################################################################################################################

# 案例分析

# 提取用户购买cate6的记录
cate6_buy_record <- action_all %>% filter(cate == 6 & type == 4) %>% arrange(user_id, time)

# 随机抽取一条购买记录，查看之前的日志记录
case_study <- function() {
    index <- sample(1:nrow(cate6_buy_record), 1)
    print(index)
    a <- cate6_buy_record$user_id[index]
    b <- cate6_buy_record$dt[index]
    tmp <- action_all %>% filter(user_id == a & dt <= b) %>% arrange(time) 
    return(tmp)
}






