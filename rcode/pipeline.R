library(data.table)
library(dplyr)
library(xgboost)

offline_train <- fread('../data/offline_train_20170509175021.txt')
offline_prediction_x <- fread('../data/offline_prediction_x_20170509175101.txt')
offline_verify <- fread('../data/offline_verify_20170509175141.txt')

label <- offline_train$label
user_id <- offline_train$user_id

offline_train$user_id <- NULL
offline_train$sku_id <- NULL
offline_train$label <- NULL

# 构建均衡训练集
train_sample_true <- which(label == 1)
train_sample_false <- which(label == 0)
balanced_sample_size <- ceiling(length(train_sample_true) * 1.3)
true_index <- train_sample_true
false_index <- train_sample_false[sample(1:length(train_sample_false), balanced_sample_size)]
balanced_index <- c(true_index, false_index)

dtrain_balanced <- xgb.DMatrix(data = as.matrix(1.0*offline_train[balanced_index, ]), 
                              label=label[balanced_index])

# 设置参数
params <- list(objective="binary:logistic", nthread=5, max_depth=10, eta=0.01, subsample=0.9)

# 交叉验证
train.xgboost.cv <- xgb.cv(data = dtrain_balanced, params=params, nrounds=200, nfold=5)

# 训练模型（均衡样本）
train.xgboost.balanced <- xgb.train(data=dtrain_balanced, params=params, nrounds=1000)

# # 训练误差分析
# dtrain <- xgb.DMatrix(data = as.matrix(1.0*offline_train), label=label)
# model <- train.xgboost.balanced
# pred <- predict(model, dtrain)
# tmp <- data.frame(label, pred)
# tmp <- tmp %>% arrange(desc(pred))
# 
# precision <- sum(tmp$label[1:12000]) / 12000
# recall <- sum(tmp$label[1:12000]) / sum(tmp$label)
# f11 <- 6*recall*precision / (5*recall + precision)

# 离线验证
verify_user_id <- offline_prediction_x$user_id
offline_prediction_x$user_id <- NULL
dtest <- xgb.DMatrix(data=as.matrix(1.0*offline_prediction_x))
pred <- predict(model, dtest)

result <- data.frame(user_id=verify_user_id, prob=pred)
result <- left_join(result, offline_verify, by=c('user_id')) %>% arrange(desc(prob))
result$label <- as.numeric(!is.na(result$sku_id))

precision <- sum(result$label[1:12000]) / 12000
recall <- sum(result$label[1:12000]) / sum(result$label)
f11 <- 6*recall*precision / (5*recall + precision)

# importance
imp <- xgb.importance(model=model)
feature_rank <- as.numeric(imp$Feature) + 1
print(colnames(offline_prediction_x)[feature_rank])

