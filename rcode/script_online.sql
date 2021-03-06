-- dev.dev_ftp_action
-- dev.dev_ftp_comment
-- dev.dev_ftp_product
-- dev.dev_ftp_user

-- 提交阶段：该用户2016-04-16到2016-04-20是否下单P中的商品
-- 提交模型训练特征数据：2016-03-01到2016-04-08
-- 提交模型训练标记数据：2016-04-09到2016-04-13
-- 提交模型训练预测数据：2016-03-01到2016-04-15

-- 提交训练特征表
-- 提交训练特征数据：2016-03-01到2016-04-08
-- 共计39天
drop table if exists dev.dev_ftp_cc_online_train_x;
create table dev.dev_ftp_cc_online_train_x stored as orc as
select
	user_id,

    39 as stat_day_cnt, -- 特征统计天数
	
	count(*) as record_cnt, -- 记录数
	
	sum(case when type = 1 then 1 else 0 end)/39 as type1_cnt, -- type1记录数，浏览
	sum(case when type = 2 then 1 else 0 end)/39 as type2_cnt, -- type2记录数，加入购物车
	sum(case when type = 3 then 1 else 0 end)/39 as type3_cnt, -- type3记录数，购物车删除
	sum(case when type = 4 then 1 else 0 end)/39 as type4_cnt, -- type4记录数，下单
	sum(case when type = 5 then 1 else 0 end)/39 as type5_cnt, -- type5记录数，关注
	sum(case when type = 6 then 1 else 0 end)/39 as type6_cnt, -- type6记录数，点击
	
	sum(case when cate = 4 then 1 else 0 end)/39 as cate4_cnt, -- cate4记录数
	sum(case when cate = 5 then 1 else 0 end)/39 as cate5_cnt, -- cate5记录数
	sum(case when cate = 6 then 1 else 0 end)/39 as cate6_cnt, -- cate6记录数
	sum(case when cate = 7 then 1 else 0 end)/39 as cate7_cnt, -- cate7记录数
	sum(case when cate = 8 then 1 else 0 end)/39 as cate8_cnt, -- cate8记录数
	sum(case when cate = 9 then 1 else 0 end)/39 as cate9_cnt, -- cate9记录数
	sum(case when cate = 10 then 1 else 0 end)/39 as cate10_cnt, -- cate10记录数
	sum(case when cate = 11 then 1 else 0 end)/39 as cate11_cnt, -- cate11记录数

	count(distinct dt)/39 as active_day_cnt, -- 有记录的天数
	
	count(distinct case when cate = 6 and type = 1 then sku_id else null end)/39 as cate6_type1_sku_cnt, -- cate6，type1商品数
	count(distinct case when cate = 6 and type = 2 then sku_id else null end)/39 as cate6_type2_sku_cnt, -- cate6，type2商品数
	count(distinct case when cate = 6 and type = 3 then sku_id else null end)/39 as cate6_type3_sku_cnt, -- cate6，type3商品数
	count(distinct case when cate = 6 and type = 4 then sku_id else null end)/39 as cate6_type4_sku_cnt, -- cate6，type4商品数
	count(distinct case when cate = 6 and type = 5 then sku_id else null end)/39 as cate6_type5_sku_cnt, -- cate6，type5商品数
	count(distinct case when cate = 6 and type = 6 then sku_id else null end)/39 as cate6_type6_sku_cnt, -- cate6，type6商品数

	count(distinct case when cate = 4 and type = 1 then sku_id else null end)/39 as cate4_type1_sku_cnt, -- cate4，type1商品数
	count(distinct case when cate = 4 and type = 2 then sku_id else null end)/39 as cate4_type2_sku_cnt, -- cate4，type2商品数
	count(distinct case when cate = 4 and type = 3 then sku_id else null end)/39 as cate4_type3_sku_cnt, -- cate4，type3商品数
	count(distinct case when cate = 4 and type = 4 then sku_id else null end)/39 as cate4_type4_sku_cnt, -- cate4，type4商品数
	count(distinct case when cate = 4 and type = 5 then sku_id else null end)/39 as cate4_type5_sku_cnt, -- cate4，type5商品数
	count(distinct case when cate = 4 and type = 6 then sku_id else null end)/39 as cate4_type6_sku_cnt, -- cate4，type6商品数
	
	count(distinct case when cate = 5 and type = 1 then sku_id else null end)/39 as cate5_type1_sku_cnt, -- cate5，type1商品数
	count(distinct case when cate = 5 and type = 2 then sku_id else null end)/39 as cate5_type2_sku_cnt, -- cate5，type2商品数
	count(distinct case when cate = 5 and type = 3 then sku_id else null end)/39 as cate5_type3_sku_cnt, -- cate5，type3商品数
	count(distinct case when cate = 5 and type = 4 then sku_id else null end)/39 as cate5_type4_sku_cnt, -- cate5，type4商品数
	count(distinct case when cate = 5 and type = 5 then sku_id else null end)/39 as cate5_type5_sku_cnt, -- cate5，type5商品数
	count(distinct case when cate = 5 and type = 6 then sku_id else null end)/39 as cate5_type6_sku_cnt, -- cate5，type6商品数
	
	count(distinct case when cate = 8 and type = 1 then sku_id else null end)/39 as cate8_type1_sku_cnt, -- cate8，type1商品数
	count(distinct case when cate = 8 and type = 2 then sku_id else null end)/39 as cate8_type2_sku_cnt, -- cate8，type2商品数
	count(distinct case when cate = 8 and type = 3 then sku_id else null end)/39 as cate8_type3_sku_cnt, -- cate8，type3商品数
	count(distinct case when cate = 8 and type = 4 then sku_id else null end)/39 as cate8_type4_sku_cnt, -- cate8，type4商品数
	count(distinct case when cate = 8 and type = 5 then sku_id else null end)/39 as cate8_type5_sku_cnt, -- cate8，type5商品数
	count(distinct case when cate = 8 and type = 6 then sku_id else null end)/39 as cate8_type6_sku_cnt, -- cate8，type6商品数
	
	sum(case when dt = '2016-04-08' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last1day, -- 最后1天cate6，type1记录数
	sum(case when dt = '2016-04-08' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last1day, -- 最后1天cate6，type2记录数
	sum(case when dt = '2016-04-08' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last1day, -- 最后1天cate6，type3记录数
	sum(case when dt = '2016-04-08' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last1day, -- 最后1天cate6，type4记录数
	sum(case when dt = '2016-04-08' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last1day, -- 最后1天cate6，type5记录数
	sum(case when dt = '2016-04-08' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last1day, -- 最后1天cate6，type6记录数
	
	sum(case when dt = '2016-04-08' and cate = 4 and type = 1 then 1 else 0 end) as cate4_type1_last1day, -- 最后1天cate4，type1记录数
	sum(case when dt = '2016-04-08' and cate = 4 and type = 2 then 1 else 0 end) as cate4_type2_last1day, -- 最后1天cate4，type2记录数
	sum(case when dt = '2016-04-08' and cate = 4 and type = 3 then 1 else 0 end) as cate4_type3_last1day, -- 最后1天cate4，type3记录数
	sum(case when dt = '2016-04-08' and cate = 4 and type = 4 then 1 else 0 end) as cate4_type4_last1day, -- 最后1天cate4，type4记录数
	sum(case when dt = '2016-04-08' and cate = 4 and type = 5 then 1 else 0 end) as cate4_type5_last1day, -- 最后1天cate4，type5记录数
	sum(case when dt = '2016-04-08' and cate = 4 and type = 6 then 1 else 0 end) as cate4_type6_last1day, -- 最后1天cate4，type6记录数
	
	sum(case when dt = '2016-04-08' and cate = 5 and type = 1 then 1 else 0 end) as cate5_type1_last1day, -- 最后1天cate5，type1记录数
	sum(case when dt = '2016-04-08' and cate = 5 and type = 2 then 1 else 0 end) as cate5_type2_last1day, -- 最后1天cate5，type2记录数
	sum(case when dt = '2016-04-08' and cate = 5 and type = 3 then 1 else 0 end) as cate5_type3_last1day, -- 最后1天cate5，type3记录数
	sum(case when dt = '2016-04-08' and cate = 5 and type = 4 then 1 else 0 end) as cate5_type4_last1day, -- 最后1天cate5，type4记录数
	sum(case when dt = '2016-04-08' and cate = 5 and type = 5 then 1 else 0 end) as cate5_type5_last1day, -- 最后1天cate5，type5记录数
	sum(case when dt = '2016-04-08' and cate = 5 and type = 6 then 1 else 0 end) as cate5_type6_last1day, -- 最后1天cate5，type6记录数
	
	sum(case when dt = '2016-04-08' and cate = 8 and type = 1 then 1 else 0 end) as cate8_type1_last1day, -- 最后1天cate8，type1记录数
	sum(case when dt = '2016-04-08' and cate = 8 and type = 2 then 1 else 0 end) as cate8_type2_last1day, -- 最后1天cate8，type2记录数
	sum(case when dt = '2016-04-08' and cate = 8 and type = 3 then 1 else 0 end) as cate8_type3_last1day, -- 最后1天cate8，type3记录数
	sum(case when dt = '2016-04-08' and cate = 8 and type = 4 then 1 else 0 end) as cate8_type4_last1day, -- 最后1天cate8，type4记录数
	sum(case when dt = '2016-04-08' and cate = 8 and type = 5 then 1 else 0 end) as cate8_type5_last1day, -- 最后1天cate8，type5记录数
	sum(case when dt = '2016-04-08' and cate = 8 and type = 6 then 1 else 0 end) as cate8_type6_last1day, -- 最后1天cate8，type6记录数
	
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last3day, -- 最后3天cate6，type1记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last3day, -- 最后3天cate6，type2记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last3day, -- 最后3天cate6，type3记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last3day, -- 最后3天cate6，type4记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last3day, -- 最后3天cate6，type5记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last3day, -- 最后3天cate6，type6记录数
	
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 4 and type = 1 then 1 else 0 end) as cate4_type1_last3day, -- 最后3天cate4，type1记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 4 and type = 2 then 1 else 0 end) as cate4_type2_last3day, -- 最后3天cate4，type2记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 4 and type = 3 then 1 else 0 end) as cate4_type3_last3day, -- 最后3天cate4，type3记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 4 and type = 4 then 1 else 0 end) as cate4_type4_last3day, -- 最后3天cate4，type4记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 4 and type = 5 then 1 else 0 end) as cate4_type5_last3day, -- 最后3天cate4，type5记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 4 and type = 6 then 1 else 0 end) as cate4_type6_last3day, -- 最后3天cate4，type6记录数
	
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 5 and type = 1 then 1 else 0 end) as cate5_type1_last3day, -- 最后3天cate5，type1记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 5 and type = 2 then 1 else 0 end) as cate5_type2_last3day, -- 最后3天cate5，type2记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 5 and type = 3 then 1 else 0 end) as cate5_type3_last3day, -- 最后3天cate5，type3记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 5 and type = 4 then 1 else 0 end) as cate5_type4_last3day, -- 最后3天cate5，type4记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 5 and type = 5 then 1 else 0 end) as cate5_type5_last3day, -- 最后3天cate5，type5记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 5 and type = 6 then 1 else 0 end) as cate5_type6_last3day, -- 最后3天cate5，type6记录数
	
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 8 and type = 1 then 1 else 0 end) as cate8_type1_last3day, -- 最后3天cate8，type1记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 8 and type = 2 then 1 else 0 end) as cate8_type2_last3day, -- 最后3天cate8，type2记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 8 and type = 3 then 1 else 0 end) as cate8_type3_last3day, -- 最后3天cate8，type3记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 8 and type = 4 then 1 else 0 end) as cate8_type4_last3day, -- 最后3天cate8，type4记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 8 and type = 5 then 1 else 0 end) as cate8_type5_last3day, -- 最后3天cate8，type5记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 8 and type = 6 then 1 else 0 end) as cate8_type6_last3day, -- 最后3天cate8，type6记录数

	sum(case when dt between date_sub('2016-04-08', 4) and '2016-04-08' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last5day, -- 最后5天cate6，type1记录数
	sum(case when dt between date_sub('2016-04-08', 4) and '2016-04-08' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last5day, -- 最后5天cate6，type2记录数
	sum(case when dt between date_sub('2016-04-08', 4) and '2016-04-08' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last5day, -- 最后5天cate6，type3记录数
	sum(case when dt between date_sub('2016-04-08', 4) and '2016-04-08' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last5day, -- 最后5天cate6，type4记录数
	sum(case when dt between date_sub('2016-04-08', 4) and '2016-04-08' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last5day, -- 最后5天cate6，type5记录数
	sum(case when dt between date_sub('2016-04-08', 4) and '2016-04-08' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last5day, -- 最后5天cate6，type6记录数

	sum(case when dt between date_sub('2016-04-08', 9) and '2016-04-08' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last10day, -- 最后10天cate6，type1记录数
	sum(case when dt between date_sub('2016-04-08', 9) and '2016-04-08' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last10day, -- 最后10天cate6，type2记录数
	sum(case when dt between date_sub('2016-04-08', 9) and '2016-04-08' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last10day, -- 最后10天cate6，type3记录数
	sum(case when dt between date_sub('2016-04-08', 9) and '2016-04-08' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last10day, -- 最后10天cate6，type4记录数
	sum(case when dt between date_sub('2016-04-08', 9) and '2016-04-08' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last10day, -- 最后10天cate6，type5记录数
	sum(case when dt between date_sub('2016-04-08', 9) and '2016-04-08' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last10day -- 最后10天cate6，type6记录数

from
	dev.dev_ftp_cc_action_unique
where
	dt <= '2016-04-08'
group by
	user_id;
		
-- 提交训练标记表
-- 提交训练标记数据：2016-04-09到2016-04-13
drop table if exists dev.dev_ftp_cc_online_train_y;
create table dev.dev_ftp_cc_online_train_y stored as orc as
select
	user_id,
	max(sku_id) as sku_id
from
	dev.dev_ftp_cc_action_unique
where
	dt between '2016-04-09' and '2016-04-13' and
	cate = 6 and
	type = 4
group by
	user_id;
	
-- 提交预测特征表
-- 提交预测特征数据：2016-03-01到2016-04-15
-- 共计46天
drop table if exists dev.dev_ftp_cc_online_prediction_x;
create table dev.dev_ftp_cc_online_prediction_x stored as orc as
select
	user_id,

    46 as stat_day_cnt, -- 特征统计天数
	
	count(*) as record_cnt, -- 记录数
	
	sum(case when type = 1 then 1 else 0 end)/46 as type1_cnt, -- type1记录数，浏览
	sum(case when type = 2 then 1 else 0 end)/46 as type2_cnt, -- type2记录数，加入购物车
	sum(case when type = 3 then 1 else 0 end)/46 as type3_cnt, -- type3记录数，购物车删除
	sum(case when type = 4 then 1 else 0 end)/46 as type4_cnt, -- type4记录数，下单
	sum(case when type = 5 then 1 else 0 end)/46 as type5_cnt, -- type5记录数，关注
	sum(case when type = 6 then 1 else 0 end)/46 as type6_cnt, -- type6记录数，点击
	
	sum(case when cate = 4 then 1 else 0 end)/46 as cate4_cnt, -- cate4记录数
	sum(case when cate = 5 then 1 else 0 end)/46 as cate5_cnt, -- cate5记录数
	sum(case when cate = 6 then 1 else 0 end)/46 as cate6_cnt, -- cate6记录数
	sum(case when cate = 7 then 1 else 0 end)/46 as cate7_cnt, -- cate7记录数
	sum(case when cate = 8 then 1 else 0 end)/46 as cate8_cnt, -- cate8记录数
	sum(case when cate = 9 then 1 else 0 end)/46 as cate9_cnt, -- cate9记录数
	sum(case when cate = 10 then 1 else 0 end)/46 as cate10_cnt, -- cate10记录数
	sum(case when cate = 11 then 1 else 0 end)/46 as cate11_cnt, -- cate11记录数

	count(distinct dt)/46 as active_day_cnt, -- 有记录的天数
	
	count(distinct case when cate = 6 and type = 1 then sku_id else null end)/46 as cate6_type1_sku_cnt, -- cate6，type1商品数
	count(distinct case when cate = 6 and type = 2 then sku_id else null end)/46 as cate6_type2_sku_cnt, -- cate6，type2商品数
	count(distinct case when cate = 6 and type = 3 then sku_id else null end)/46 as cate6_type3_sku_cnt, -- cate6，type3商品数
	count(distinct case when cate = 6 and type = 4 then sku_id else null end)/46 as cate6_type4_sku_cnt, -- cate6，type4商品数
	count(distinct case when cate = 6 and type = 5 then sku_id else null end)/46 as cate6_type5_sku_cnt, -- cate6，type5商品数
	count(distinct case when cate = 6 and type = 6 then sku_id else null end)/46 as cate6_type6_sku_cnt, -- cate6，type6商品数

	count(distinct case when cate = 4 and type = 1 then sku_id else null end)/46 as cate4_type1_sku_cnt, -- cate4，type1商品数
	count(distinct case when cate = 4 and type = 2 then sku_id else null end)/46 as cate4_type2_sku_cnt, -- cate4，type2商品数
	count(distinct case when cate = 4 and type = 3 then sku_id else null end)/46 as cate4_type3_sku_cnt, -- cate4，type3商品数
	count(distinct case when cate = 4 and type = 4 then sku_id else null end)/46 as cate4_type4_sku_cnt, -- cate4，type4商品数
	count(distinct case when cate = 4 and type = 5 then sku_id else null end)/46 as cate4_type5_sku_cnt, -- cate4，type5商品数
	count(distinct case when cate = 4 and type = 6 then sku_id else null end)/46 as cate4_type6_sku_cnt, -- cate4，type6商品数
	
	count(distinct case when cate = 5 and type = 1 then sku_id else null end)/46 as cate5_type1_sku_cnt, -- cate5，type1商品数
	count(distinct case when cate = 5 and type = 2 then sku_id else null end)/46 as cate5_type2_sku_cnt, -- cate5，type2商品数
	count(distinct case when cate = 5 and type = 3 then sku_id else null end)/46 as cate5_type3_sku_cnt, -- cate5，type3商品数
	count(distinct case when cate = 5 and type = 4 then sku_id else null end)/46 as cate5_type4_sku_cnt, -- cate5，type4商品数
	count(distinct case when cate = 5 and type = 5 then sku_id else null end)/46 as cate5_type5_sku_cnt, -- cate5，type5商品数
	count(distinct case when cate = 5 and type = 6 then sku_id else null end)/46 as cate5_type6_sku_cnt, -- cate5，type6商品数
	
	count(distinct case when cate = 8 and type = 1 then sku_id else null end)/46 as cate8_type1_sku_cnt, -- cate8，type1商品数
	count(distinct case when cate = 8 and type = 2 then sku_id else null end)/46 as cate8_type2_sku_cnt, -- cate8，type2商品数
	count(distinct case when cate = 8 and type = 3 then sku_id else null end)/46 as cate8_type3_sku_cnt, -- cate8，type3商品数
	count(distinct case when cate = 8 and type = 4 then sku_id else null end)/46 as cate8_type4_sku_cnt, -- cate8，type4商品数
	count(distinct case when cate = 8 and type = 5 then sku_id else null end)/46 as cate8_type5_sku_cnt, -- cate8，type5商品数
	count(distinct case when cate = 8 and type = 6 then sku_id else null end)/46 as cate8_type6_sku_cnt, -- cate8，type6商品数
	
	sum(case when dt = '2016-04-15' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last1day, -- 最后1天cate6，type1记录数
	sum(case when dt = '2016-04-15' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last1day, -- 最后1天cate6，type2记录数
	sum(case when dt = '2016-04-15' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last1day, -- 最后1天cate6，type3记录数
	sum(case when dt = '2016-04-15' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last1day, -- 最后1天cate6，type4记录数
	sum(case when dt = '2016-04-15' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last1day, -- 最后1天cate6，type5记录数
	sum(case when dt = '2016-04-15' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last1day, -- 最后1天cate6，type6记录数
	
	sum(case when dt = '2016-04-15' and cate = 4 and type = 1 then 1 else 0 end) as cate4_type1_last1day, -- 最后1天cate4，type1记录数
	sum(case when dt = '2016-04-15' and cate = 4 and type = 2 then 1 else 0 end) as cate4_type2_last1day, -- 最后1天cate4，type2记录数
	sum(case when dt = '2016-04-15' and cate = 4 and type = 3 then 1 else 0 end) as cate4_type3_last1day, -- 最后1天cate4，type3记录数
	sum(case when dt = '2016-04-15' and cate = 4 and type = 4 then 1 else 0 end) as cate4_type4_last1day, -- 最后1天cate4，type4记录数
	sum(case when dt = '2016-04-15' and cate = 4 and type = 5 then 1 else 0 end) as cate4_type5_last1day, -- 最后1天cate4，type5记录数
	sum(case when dt = '2016-04-15' and cate = 4 and type = 6 then 1 else 0 end) as cate4_type6_last1day, -- 最后1天cate4，type6记录数
	
	sum(case when dt = '2016-04-15' and cate = 5 and type = 1 then 1 else 0 end) as cate5_type1_last1day, -- 最后1天cate5，type1记录数
	sum(case when dt = '2016-04-15' and cate = 5 and type = 2 then 1 else 0 end) as cate5_type2_last1day, -- 最后1天cate5，type2记录数
	sum(case when dt = '2016-04-15' and cate = 5 and type = 3 then 1 else 0 end) as cate5_type3_last1day, -- 最后1天cate5，type3记录数
	sum(case when dt = '2016-04-15' and cate = 5 and type = 4 then 1 else 0 end) as cate5_type4_last1day, -- 最后1天cate5，type4记录数
	sum(case when dt = '2016-04-15' and cate = 5 and type = 5 then 1 else 0 end) as cate5_type5_last1day, -- 最后1天cate5，type5记录数
	sum(case when dt = '2016-04-15' and cate = 5 and type = 6 then 1 else 0 end) as cate5_type6_last1day, -- 最后1天cate5，type6记录数
	
	sum(case when dt = '2016-04-15' and cate = 8 and type = 1 then 1 else 0 end) as cate8_type1_last1day, -- 最后1天cate8，type1记录数
	sum(case when dt = '2016-04-15' and cate = 8 and type = 2 then 1 else 0 end) as cate8_type2_last1day, -- 最后1天cate8，type2记录数
	sum(case when dt = '2016-04-15' and cate = 8 and type = 3 then 1 else 0 end) as cate8_type3_last1day, -- 最后1天cate8，type3记录数
	sum(case when dt = '2016-04-15' and cate = 8 and type = 4 then 1 else 0 end) as cate8_type4_last1day, -- 最后1天cate8，type4记录数
	sum(case when dt = '2016-04-15' and cate = 8 and type = 5 then 1 else 0 end) as cate8_type5_last1day, -- 最后1天cate8，type5记录数
	sum(case when dt = '2016-04-15' and cate = 8 and type = 6 then 1 else 0 end) as cate8_type6_last1day, -- 最后1天cate8，type6记录数
	
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last3day, -- 最后3天cate6，type1记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last3day, -- 最后3天cate6，type2记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last3day, -- 最后3天cate6，type3记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last3day, -- 最后3天cate6，type4记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last3day, -- 最后3天cate6，type5记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last3day, -- 最后3天cate6，type6记录数
	
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 4 and type = 1 then 1 else 0 end) as cate4_type1_last3day, -- 最后3天cate4，type1记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 4 and type = 2 then 1 else 0 end) as cate4_type2_last3day, -- 最后3天cate4，type2记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 4 and type = 3 then 1 else 0 end) as cate4_type3_last3day, -- 最后3天cate4，type3记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 4 and type = 4 then 1 else 0 end) as cate4_type4_last3day, -- 最后3天cate4，type4记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 4 and type = 5 then 1 else 0 end) as cate4_type5_last3day, -- 最后3天cate4，type5记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 4 and type = 6 then 1 else 0 end) as cate4_type6_last3day, -- 最后3天cate4，type6记录数
	
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 5 and type = 1 then 1 else 0 end) as cate5_type1_last3day, -- 最后3天cate5，type1记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 5 and type = 2 then 1 else 0 end) as cate5_type2_last3day, -- 最后3天cate5，type2记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 5 and type = 3 then 1 else 0 end) as cate5_type3_last3day, -- 最后3天cate5，type3记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 5 and type = 4 then 1 else 0 end) as cate5_type4_last3day, -- 最后3天cate5，type4记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 5 and type = 5 then 1 else 0 end) as cate5_type5_last3day, -- 最后3天cate5，type5记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 5 and type = 6 then 1 else 0 end) as cate5_type6_last3day, -- 最后3天cate5，type6记录数
	
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 8 and type = 1 then 1 else 0 end) as cate8_type1_last3day, -- 最后3天cate8，type1记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 8 and type = 2 then 1 else 0 end) as cate8_type2_last3day, -- 最后3天cate8，type2记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 8 and type = 3 then 1 else 0 end) as cate8_type3_last3day, -- 最后3天cate8，type3记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 8 and type = 4 then 1 else 0 end) as cate8_type4_last3day, -- 最后3天cate8，type4记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 8 and type = 5 then 1 else 0 end) as cate8_type5_last3day, -- 最后3天cate8，type5记录数
	sum(case when dt between date_sub('2016-04-15', 2) and '2016-04-15' and cate = 8 and type = 6 then 1 else 0 end) as cate8_type6_last3day, -- 最后3天cate8，type6记录数

	sum(case when dt between date_sub('2016-04-15', 4) and '2016-04-15' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last5day, -- 最后5天cate6，type1记录数
	sum(case when dt between date_sub('2016-04-15', 4) and '2016-04-15' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last5day, -- 最后5天cate6，type2记录数
	sum(case when dt between date_sub('2016-04-15', 4) and '2016-04-15' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last5day, -- 最后5天cate6，type3记录数
	sum(case when dt between date_sub('2016-04-15', 4) and '2016-04-15' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last5day, -- 最后5天cate6，type4记录数
	sum(case when dt between date_sub('2016-04-15', 4) and '2016-04-15' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last5day, -- 最后5天cate6，type5记录数
	sum(case when dt between date_sub('2016-04-15', 4) and '2016-04-15' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last5day, -- 最后5天cate6，type6记录数

	sum(case when dt between date_sub('2016-04-15', 9) and '2016-04-15' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last10day, -- 最后10天cate6，type1记录数
	sum(case when dt between date_sub('2016-04-15', 9) and '2016-04-15' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last10day, -- 最后10天cate6，type2记录数
	sum(case when dt between date_sub('2016-04-15', 9) and '2016-04-15' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last10day, -- 最后10天cate6，type3记录数
	sum(case when dt between date_sub('2016-04-15', 9) and '2016-04-15' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last10day, -- 最后10天cate6，type4记录数
	sum(case when dt between date_sub('2016-04-15', 9) and '2016-04-15' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last10day, -- 最后10天cate6，type5记录数
	sum(case when dt between date_sub('2016-04-15', 9) and '2016-04-15' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last10day -- 最后10天cate6，type6记录数

from
	dev.dev_ftp_cc_action_unique
where
	dt <= '2016-04-15'
group by
	user_id;

-- 提取提交训练数据
select
	A.*,
	B.sku_id,
	case when B.sku_id is not null then 1 else 0 end as label
from
	dev.dev_ftp_cc_online_train_x A
left outer join
	dev.dev_ftp_cc_online_train_y B
on
	A.user_id = B.user_id;
	
-- 提取提交预测数据
select * from dev.dev_ftp_cc_online_prediction_x;
