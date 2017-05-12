library(data.table)
library(dplyr)
library(xgboost)

online_train <- fread('../data/online_train_20170512085041.txt', na.strings = c('NULL'))
online_prediction_x <- fread('../data/online_prediction_20170512085121.txt')

# 补充特征
supp <- fread('../data/dev_ftp_user_feacture_zhjs_01_20170511134601.csv', na.strings = c('NULL'))
supp$flag <- NULL

online_train <- left_join(online_train, supp, by='user_id')
online_prediction_x <- left_join(online_prediction_x, supp, by='user_id')

label <- online_train$label
user_id <- online_train$user_id

online_train$user_id <- NULL
online_train$sku_id <- NULL
online_train$label <- NULL
online_train$stat_day_cnt <- NULL

# 构建均衡训练集
train_sample_true <- which(label == 1)
train_sample_false <- which(label == 0)
balanced_sample_size <- ceiling(length(train_sample_true) * 2)
true_index <- train_sample_true
false_index <- train_sample_false[sample(1:length(train_sample_false), balanced_sample_size)]
balanced_index <- c(true_index, false_index)

dtrain_balanced <- xgb.DMatrix(data = as.matrix(1.0*online_train[balanced_index, ]), 
                               label=label[balanced_index])

# 评价函数
recall <- function(preds, dtrain) {
    labels <- getinfo(dtrain, "label")
    labels_pred <- preds > 0.5
    recall <- sum(labels_pred * labels)/sum(labels)
    return(list(metric = "recall", value = recall))
}

# 设置参数
params <- list(objective="binary:logistic", nthread=5, max_depth=8, eta=0.02, subsample=0.8)
# params <- list(objective="binary:logistic", nthread=5, max_depth=8, eta=0.02, subsample=0.667)
# params <- list(objective="binary:logistic", nthread=5, max_depth=8, eta=0.02, subsample=0.8)

# # 交叉验证
# train.xgboost.cv <- xgb.cv(data = dtrain_balanced, params=params, nrounds=400, nfold=5, feval=recall)
train.xgboost.cv <- xgb.cv(data = dtrain_balanced, params=params, nrounds=400, nfold=5)

# 训练模型（均衡样本）
train.xgboost.balanced <- xgb.train(data=dtrain_balanced, params=params, nrounds=1000)

# 最终模型
model <- train.xgboost.balanced

# 训练误差分析
dtrain <- xgb.DMatrix(data = as.matrix(1.0*online_train), label=label)
pred <- predict(model, dtrain)
tmp <- data.frame(label, pred)
tmp <- tmp %>% arrange(desc(pred))

precision <- sum(tmp$label[1:12000]) / 12000
recall <- sum(tmp$label[1:12000]) / sum(tmp$label)
f11 <- 6*recall*precision / (5*recall + precision)

# 提交预测
user_id <- online_prediction_x$user_id
online_prediction_x$user_id <- NULL
online_prediction_x$stat_day_cnt <- NULL

dtrain_online <- xgb.DMatrix(data = as.matrix(1.0*online_prediction_x))
pred <- predict(model, dtrain_online)

# 根据概率排序
result <- data.frame(user_id, pred)
result <- result %>% arrange(desc(pred))

# 取前12000个作为提交结果
result <- result[1:12000, ]

# 匹配SKU
load('E:/JData2017/action_all.RData')
product <- fread('E:/JData2017/JData_Product.csv')

sku_prediction <- action_all %>% filter(user_id %in% result$user_id & sku_id %in% product$sku_id)

rm(list = c('action_all')); gc()

sku_prediction <- sku_prediction %>% dplyr::arrange(user_id, desc(time)) %>% group_by(user_id) %>% dplyr::mutate(id=row_number()) %>% filter(id == 1)

result <- left_join(result, sku_prediction, by='user_id')
idx <- which(is.na(result$sku_id))
result$sku_id[idx] <- 162344

output <- result %>% select(user_id, sku_id)
write.csv(output, file='output.csv', row.names=FALSE, quote=FALSE)

# # 特征分析
# imp <- xgb.importance(model=model)
# feature_rank <- as.numeric(imp$Feature) + 1
# print(colnames(online_prediction_x)[feature_rank])
# 
# # 特征选择
# num_of_features <- 30
# imp <- xgb.importance(model=train.xgboost.balanced)
# feature_rank <- as.numeric(imp$Feature) + 1
# feature_select_index <- feature_rank[1:num_of_features]
# 
# # re-train
# dtrain_balanced_fs <- xgb.DMatrix(data = as.matrix(1.0*online_train[balanced_index, ..feature_select_index]),
#                                   label = label[balanced_index])
# params <- list(objective="binary:logistic", nthread=5, max_depth=8, eta=0.02, subsample=0.8)
# train.xgboost.cv <- xgb.cv(data = dtrain_balanced_fs, params=params, nrounds=200, nfold=5)
# train.xgboost.balanced.fs <- xgb.train(data=dtrain_balanced_fs, params=params, nrounds=300)
