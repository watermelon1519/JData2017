-- dev.dev_ftp_action
-- dev.dev_ftp_comment
-- dev.dev_ftp_product
-- dev.dev_ftp_user

-- 提交阶段：该用户2016-04-16到2016-04-20是否下单P中的商品

-- 离线验证：该用户2016-04-09到2016-04-13是否下单P中的商品
-- 离线训练特征数据：2016-03-01到2016-04-01
-- 离线预测特征数据：2016-03-01到2016-04-08
-- 离线训练标记数据：2016-04-02到2016-04-06
-- 提交预测特征数据：2016-03-01到2016-04-15

-- 全量数据：忽略model_id去重
drop table if exists dev.dev_ftp_cc_action_unique;
create table dev.dev_ftp_cc_action_unique stored as orc as
select
	user_id,
	sku_id,
	time,
	type,
	cate,
	brand,
	min(to_date(time)) as dt
from
	dev.dev_ftp_action
where
	user_id <> 'user_id'
group by
	user_id,
	sku_id,
	time,
	type,
	cate,
	brand;

-- 离线训练特征表
-- 离线训练特征数据：2016-03-01到2016-04-01
-- 共计32天
drop table if exists dev.dev_ftp_cc_offline_train_x;
create table dev.dev_ftp_cc_offline_train_x stored as orc as
select
	user_id,

    32 as stat_day_cnt, -- 特征统计天数
	
	count(*) as record_cnt, -- 记录数
	
	sum(case when type = 1 then 1 else 0 end)/32 as type1_cnt, -- type1记录数，浏览
	sum(case when type = 2 then 1 else 0 end)/32 as type2_cnt, -- type2记录数，加入购物车
	sum(case when type = 3 then 1 else 0 end)/32 as type3_cnt, -- type3记录数，购物车删除
	sum(case when type = 4 then 1 else 0 end)/32 as type4_cnt, -- type4记录数，下单
	sum(case when type = 5 then 1 else 0 end)/32 as type5_cnt, -- type5记录数，关注
	sum(case when type = 6 then 1 else 0 end)/32 as type6_cnt, -- type6记录数，点击
	
	sum(case when cate = 4 then 1 else 0 end)/32 as cate4_cnt, -- cate4记录数
	sum(case when cate = 5 then 1 else 0 end)/32 as cate5_cnt, -- cate5记录数
	sum(case when cate = 6 then 1 else 0 end)/32 as cate6_cnt, -- cate6记录数
	sum(case when cate = 7 then 1 else 0 end)/32 as cate7_cnt, -- cate7记录数
	sum(case when cate = 8 then 1 else 0 end)/32 as cate8_cnt, -- cate8记录数
	sum(case when cate = 9 then 1 else 0 end)/32 as cate9_cnt, -- cate9记录数
	sum(case when cate = 10 then 1 else 0 end)/32 as cate10_cnt, -- cate10记录数
	sum(case when cate = 11 then 1 else 0 end)/32 as cate11_cnt, -- cate11记录数
	
	sum(case when dt = '2016-04-01' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last1day, -- 最后1天cate6，type1记录数
	sum(case when dt = '2016-04-01' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last1day, -- 最后1天cate6，type2记录数
	sum(case when dt = '2016-04-01' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last1day, -- 最后1天cate6，type3记录数
	sum(case when dt = '2016-04-01' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last1day, -- 最后1天cate6，type4记录数
	sum(case when dt = '2016-04-01' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last1day, -- 最后1天cate6，type5记录数
	sum(case when dt = '2016-04-01' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last1day, -- 最后1天cate6，type6记录数
	
	sum(case when dt = '2016-04-01' and cate = 5 and type = 1 then 1 else 0 end) as cate5_type1_last1day, -- 最后1天cate5，type1记录数
	sum(case when dt = '2016-04-01' and cate = 5 and type = 2 then 1 else 0 end) as cate5_type2_last1day, -- 最后1天cate5，type2记录数
	sum(case when dt = '2016-04-01' and cate = 5 and type = 3 then 1 else 0 end) as cate5_type3_last1day, -- 最后1天cate5，type3记录数
	sum(case when dt = '2016-04-01' and cate = 5 and type = 4 then 1 else 0 end) as cate5_type4_last1day, -- 最后1天cate5，type4记录数
	sum(case when dt = '2016-04-01' and cate = 5 and type = 5 then 1 else 0 end) as cate5_type5_last1day, -- 最后1天cate5，type5记录数
	sum(case when dt = '2016-04-01' and cate = 5 and type = 6 then 1 else 0 end) as cate5_type6_last1day, -- 最后1天cate5，type6记录数
	
	sum(case when dt between date_sub('2016-04-01', 2) and '2016-04-01' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last3day, -- 最后3天cate6，type1记录数
	sum(case when dt between date_sub('2016-04-01', 2) and '2016-04-01' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last3day, -- 最后3天cate6，type2记录数
	sum(case when dt between date_sub('2016-04-01', 2) and '2016-04-01' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last3day, -- 最后3天cate6，type3记录数
	sum(case when dt between date_sub('2016-04-01', 2) and '2016-04-01' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last3day, -- 最后3天cate6，type4记录数
	sum(case when dt between date_sub('2016-04-01', 2) and '2016-04-01' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last3day, -- 最后3天cate6，type5记录数
	sum(case when dt between date_sub('2016-04-01', 2) and '2016-04-01' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last3day, -- 最后3天cate6，type6记录数
	
	count(distinct case when cate = 6 and type = 1 then sku_id else null end)/32 as cate6_type1_sku_cnt, -- cate6，type1商品数
	count(distinct case when cate = 6 and type = 2 then sku_id else null end)/32 as cate6_type2_sku_cnt, -- cate6，type2商品数
	count(distinct case when cate = 6 and type = 3 then sku_id else null end)/32 as cate6_type3_sku_cnt, -- cate6，type3商品数
	count(distinct case when cate = 6 and type = 4 then sku_id else null end)/32 as cate6_type4_sku_cnt, -- cate6，type4商品数
	count(distinct case when cate = 6 and type = 5 then sku_id else null end)/32 as cate6_type5_sku_cnt, -- cate6，type5商品数
	count(distinct case when cate = 6 and type = 6 then sku_id else null end)/32 as cate6_type6_sku_cnt, -- cate6，type6商品数

	count(distinct case when cate = 5 and type = 1 then sku_id else null end)/32 as cate5_type1_sku_cnt, -- cate5，type1商品数
	count(distinct case when cate = 5 and type = 2 then sku_id else null end)/32 as cate5_type2_sku_cnt, -- cate5，type2商品数
	count(distinct case when cate = 5 and type = 3 then sku_id else null end)/32 as cate5_type3_sku_cnt, -- cate5，type3商品数
	count(distinct case when cate = 5 and type = 4 then sku_id else null end)/32 as cate5_type4_sku_cnt, -- cate5，type4商品数
	count(distinct case when cate = 5 and type = 5 then sku_id else null end)/32 as cate5_type5_sku_cnt, -- cate5，type5商品数
	count(distinct case when cate = 5 and type = 6 then sku_id else null end)/32 as cate5_type6_sku_cnt -- cate5，type6商品数
from
	dev.dev_ftp_cc_action_unique
where
	dt <= '2016-04-01'
group by
	user_id;
		
-- 离线训练标记表
-- 离线训练标记数据：2016-04-02到2016-04-06
drop table if exists dev.dev_ftp_cc_offline_train_y;
create table dev.dev_ftp_cc_offline_train_y stored as orc as
select
	user_id,
	max(sku_id) as sku_id
from
	dev.dev_ftp_cc_action_unique
where
	dt between '2016-04-02' and '2016-04-06' and
	cate = 6 and
	type = 4
group by
	user_id;
	
-- 离线验证标记表
-- 离线验证：该用户2016-04-09到2016-04-13是否下单P中的商品
drop table if exists dev.dev_ftp_cc_offline_verify_y;
create table dev.dev_ftp_cc_offline_verify_y stored as orc as
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

-- 离线预测特征表
-- 离线预测特征数据：2016-03-01到2016-04-08
-- 共计39天
drop table if exists dev.dev_ftp_cc_offline_prediction_x;
create table dev.dev_ftp_cc_offline_prediction_x stored as orc as
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
	
	sum(case when dt = '2016-04-08' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last1day, -- 最后1天cate6，type1记录数
	sum(case when dt = '2016-04-08' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last1day, -- 最后1天cate6，type2记录数
	sum(case when dt = '2016-04-08' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last1day, -- 最后1天cate6，type3记录数
	sum(case when dt = '2016-04-08' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last1day, -- 最后1天cate6，type4记录数
	sum(case when dt = '2016-04-08' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last1day, -- 最后1天cate6，type5记录数
	sum(case when dt = '2016-04-08' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last1day, -- 最后1天cate6，type6记录数
	
	sum(case when dt = '2016-04-08' and cate = 5 and type = 1 then 1 else 0 end) as cate5_type1_last1day, -- 最后1天cate5，type1记录数
	sum(case when dt = '2016-04-08' and cate = 5 and type = 2 then 1 else 0 end) as cate5_type2_last1day, -- 最后1天cate5，type2记录数
	sum(case when dt = '2016-04-08' and cate = 5 and type = 3 then 1 else 0 end) as cate5_type3_last1day, -- 最后1天cate5，type3记录数
	sum(case when dt = '2016-04-08' and cate = 5 and type = 4 then 1 else 0 end) as cate5_type4_last1day, -- 最后1天cate5，type4记录数
	sum(case when dt = '2016-04-08' and cate = 5 and type = 5 then 1 else 0 end) as cate5_type5_last1day, -- 最后1天cate5，type5记录数
	sum(case when dt = '2016-04-08' and cate = 5 and type = 6 then 1 else 0 end) as cate5_type6_last1day, -- 最后1天cate5，type6记录数
	
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last3day, -- 最后3天cate6，type1记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last3day, -- 最后3天cate6，type2记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last3day, -- 最后3天cate6，type3记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last3day, -- 最后3天cate6，type4记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last3day, -- 最后3天cate6，type5记录数
	sum(case when dt between date_sub('2016-04-08', 2) and '2016-04-08' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last3day, -- 最后3天cate6，type6记录数
	
	count(distinct case when cate = 6 and type = 1 then sku_id else null end)/39 as cate6_type1_sku_cnt, -- cate6，type1商品数
	count(distinct case when cate = 6 and type = 2 then sku_id else null end)/39 as cate6_type2_sku_cnt, -- cate6，type2商品数
	count(distinct case when cate = 6 and type = 3 then sku_id else null end)/39 as cate6_type3_sku_cnt, -- cate6，type3商品数
	count(distinct case when cate = 6 and type = 4 then sku_id else null end)/39 as cate6_type4_sku_cnt, -- cate6，type4商品数
	count(distinct case when cate = 6 and type = 5 then sku_id else null end)/39 as cate6_type5_sku_cnt, -- cate6，type5商品数
	count(distinct case when cate = 6 and type = 6 then sku_id else null end)/39 as cate6_type6_sku_cnt, -- cate6，type6商品数
    
	count(distinct case when cate = 5 and type = 1 then sku_id else null end)/39 as cate5_type1_sku_cnt, -- cate5，type1商品数
	count(distinct case when cate = 5 and type = 2 then sku_id else null end)/39 as cate5_type2_sku_cnt, -- cate5，type2商品数
	count(distinct case when cate = 5 and type = 3 then sku_id else null end)/39 as cate5_type3_sku_cnt, -- cate5，type3商品数
	count(distinct case when cate = 5 and type = 4 then sku_id else null end)/39 as cate5_type4_sku_cnt, -- cate5，type4商品数
	count(distinct case when cate = 5 and type = 5 then sku_id else null end)/39 as cate5_type5_sku_cnt, -- cate5，type5商品数
	count(distinct case when cate = 5 and type = 6 then sku_id else null end)/39 as cate5_type6_sku_cnt -- cate5，type6商品数
from
	dev.dev_ftp_cc_action_unique
where
	dt <= '2016-04-08'
group by
	user_id;

-- 提取离线训练数据
select
	A.*,
	B.sku_id,
	case when B.sku_id is not null then 1 else 0 end as label
from
	dev.dev_ftp_cc_offline_train_x A
left outer join
	dev.dev_ftp_cc_offline_train_y B
on
	A.user_id = B.user_id;
	
-- 提取离线预测数据
select * from dev.dev_ftp_cc_offline_prediction_x;

-- 提取离线验证数据
select * from dev.dev_ftp_cc_offline_verify_y;
	
	
	
	
	
