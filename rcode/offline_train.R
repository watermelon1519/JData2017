# 赛事网址：http://xianzhi.jd.com/#

# 提交：该用户2016-04-16到2016-04-20是否下单P中的商品
# 离线训练：该用户2016-04-09到2016-04-13是否下单P中的商品

library(data.table)
library(dplyr)
library(xgboost)

load('./action_all.RData')

# 处理Label
label_data = action_all %>% filter(time >= '2016-04-09' & time < '2016-04-14' & cate == 6)
label_true_user <- label_data %>% filter(type == 4) %>% group_by(user_id) %>% summarise(cnt=n())

# 构建特征
feature_data <- action_all %>% filter(time < '2016-04-09')
feature_data$dt <- substring(feature_data$time, 1, 10)

rm(list = c('action_all'))
gc()

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

# 保存特征矩阵
save(X, file='X.RData')

# 打标签
label <- rep(0, nrow(X))
label[X$user_id %in% label_true_user$user_id] <- 1
X$user_id <- NULL
X <- X * 1.0

# 构建均衡训练集
label_true_index <- which(label == 1)
label_false_index <- which(label == 0)
train_true_sample_index <- label_true_index
train_false_sample_index <- label_false_index[sample(1:length(label_false_index), 3000)]
train_index <- c(train_true_sample_index, train_false_sample_index)
dtrain_balance <- xgb.DMatrix(data = as.matrix(X[train_index, ]), label=label[train_index])

dtrain <- xgb.DMatrix(data = as.matrix(X), label=label)

# 清理数据
rm(list = c('feature_data'))
gc()

# 设置参数
params <- list(objective="binary:logistic", nthread=5, max_depth=6, eta=0.02, subsample=1)

# 训练模型（均衡样本）
train.xgboost.balance <- xgb.train(data=dtrain_balance, params=params, nrounds=1000)

# 训练误差分析
model <- train.xgboost.balance
pred <- predict(model, dtrain)
tmp <- data.frame(label, pred)
tmp <- tmp %>% arrange(desc(pred))

precision <- sum(tmp$label[1:12000]) / 12000
recall <- sum(tmp$label[1:12000]) / sum(tmp$label)
f11 <- 6*recall*precision / (5*recall + precision)

save(model, file='model.RData')
