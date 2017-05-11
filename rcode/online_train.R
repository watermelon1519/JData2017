# 赛事网址：http://xianzhi.jd.com/#

# 提交：该用户2016-04-16到2016-04-20是否下单P中的商品
# 离线训练：该用户2016-04-09到2016-04-13是否下单P中的商品

library(data.table)
library(dplyr)
library(xgboost)

load('./model.RData')

X <- fread('./jdata_x_v0_20170509150221.txt')
user_id <- X$user_id
X$user_id <- NULL
X <- X * 1.0
dtrain <- xgb.DMatrix(data = as.matrix(X))

# 预测
pred <- predict(model, dtrain)

# 根据概率排序
result <- data.frame(user_id, pred)
result <- result %>% arrange(desc(pred))

# 取前12000个作为提交结果
result <- result[1:12000, ]

# 匹配SKU
load('action_all.RData')

sku_prediction <- action_all %>% filter(user_id %in% result$user_id)
product <- fread('./JData_Product.csv')

sku_prediction <- sku_prediction %>% filter(sku_id %in% product$sku_id)

rm(list = c('action_all'))
gc()

sku_prediction <- sku_prediction %>% arrange(user_id, desc(time)) %>% group_by(user_id) %>% mutate(id=row_number()) 

sku_prediction <- sku_prediction %>% filter(id == 1)

result <- left_join(result, sku_prediction, by='user_id')
idx <- which(is.na(result$sku_id))
result$sku_id[idx] <- 162344

output <- result %>% select(user_id, sku_id)
write.csv(output, file='output.csv', row.names=FALSE, quote=FALSE)

