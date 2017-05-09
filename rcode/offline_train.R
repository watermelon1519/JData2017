# 赛事网址：http://xianzhi.jd.com/#
# 提交：该用户2016-04-16到2016-04-20是否下单P中的商品

# 离线训练：该用户2016-04-09到2016-04-13是否下单P中的商品

library(data.table)
library(dplyr)
library(xgboost)

load('./action_all.RData')

# 处理Label
label_data = action_all %>% filter(time >= '2016-04-09' & time < '2016-04-14' & cate == 6)
tmp <- label_data %>% group_by(type) %>% summarise(user_id_cnt=length(unique(user_id)), sku_id_cnt=length(unique(sku_id)))
label_true_user <- label_data %>% filter(type == 4) %>% group_by(user_id) %>% summarise(cnt=n())

# 构建特征
feature_data <- action_all %>% filter(time < '2016-04-09')
feature_data$dt <- as.Date(feature_data$time)

rm(list = c('action_all'))
gc()

user_id_cnt <- length(unique(feature_data$user_id))

X <- feature_data %>% group_by(user_id) %>% summarise(record_cnt=n(),
                                                      type1_cnt=sum(type == 1),
                                                      type2_cnt=sum(type == 2),
                                                      type3_cnt=sum(type == 3),
                                                      type4_cnt=sum(type == 4),
                                                      type5_cnt=sum(type == 5),
                                                      type6_cnt=sum(type == 6),
                                                      cate4_cnt=sum(cate == 4),
                                                      cate5_cnt=sum(cate == 5),
                                                      cate6_cnt=sum(cate == 6),
                                                      cate7_cnt=sum(cate == 7),
                                                      cate8_cnt=sum(cate == 8),
                                                      cate9_cnt=sum(cate == 9),
                                                      cate10_cnt=sum(cate == 10),
                                                      cate11_cnt=sum(cate == 11),
                                                      cate6_type1_last1day=sum(dt == '2016-04-08' & cate == 6 & type == 1),
                                                      cate6_type2_last1day=sum(dt == '2016-04-08' & cate == 6 & type == 2),
                                                      cate6_type3_last1day=sum(dt == '2016-04-08' & cate == 6 & type == 3),
                                                      cate6_type4_last1day=sum(dt == '2016-04-08' & cate == 6 & type == 4),
                                                      cate6_type5_last1day=sum(dt == '2016-04-08' & cate == 6 & type == 5),
                                                      cate6_type6_last1day=sum(dt == '2016-04-08' & cate == 6 & type == 6))


# 打标签
label <- rep(0, nrow(X))
label[X$user_id %in% label_true_user$user_id] <- 1
X$user_id <- NULL

X <- X * 1.0
dtrain <- xgb.DMatrix(data = as.matrix(X), label = label)

# 设置参数
params <- list(eval_metric="auc", objective="binary:logistic", nthread=5, max_depth=5, eta=0.05, subsample=0.5)

# 交叉验证
train.xgboost <- xgb.cv(data=dtrain, params=params, nrounds=100, nfold=5)

# 训练模型
train.xgboost <- xgb.train(data=dtrain, params=params, nrounds=100)

# 训练误差分析
pred <- predict(train.xgboost, dtrain)
tmp <- data.frame(label, pred)
tmp <- tmp %>% arrange(desc(pred))

precision <- sum(tmp$label[1:12000]) / 12000
recall <- sum(tmp$label[1:12000]) / sum(tmp$label)
f11 <- 6*recall*precision / (5*recall + precision)

# TODO: 解决样本不均衡的问题，再训练看看
