# 赛事网址：http://xianzhi.jd.com/#

# 提交：该用户2016-04-16到2016-04-20是否下单P中的商品
# 离线训练：该用户2016-04-09到2016-04-13是否下单P中的商品

library(data.table)
library(dplyr)
library(xgboost)

load('./action_all.RData')
load('./model.RData')

# 构建特征
# action_all$dt <- substring(action_all$time, 1, 10)

X <- action_all %>% group_by(user_id) %>% summarise(record_cnt=n(),
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
                                                    cate6_type1_last1day=sum(substring(action_all$time, 1, 10) == '2016-04-15' & cate == 6 & type == 1),
                                                    cate6_type2_last1day=sum(substring(action_all$time, 1, 10) == '2016-04-15' & cate == 6 & type == 2),
                                                    cate6_type3_last1day=sum(substring(action_all$time, 1, 10) == '2016-04-15' & cate == 6 & type == 3),
                                                    cate6_type4_last1day=sum(substring(action_all$time, 1, 10) == '2016-04-15' & cate == 6 & type == 4),
                                                    cate6_type5_last1day=sum(substring(action_all$time, 1, 10) == '2016-04-15' & cate == 6 & type == 5),
                                                    cate6_type6_last1day=sum(substring(action_all$time, 1, 10) == '2016-04-15' & cate == 6 & type == 6))

user_id <- X$user_id
X$user_id <- NULL
X <- X * 1.0
dtrain <- xgb.DMatrix(data = as.matrix(X))

# 预测
pred <- predict(model, dtrain)
