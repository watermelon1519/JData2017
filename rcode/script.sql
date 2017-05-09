-- dev.dev_ftp_action
-- dev.dev_ftp_comment
-- dev.dev_ftp_product
-- dev.dev_ftp_user

-- 忽略model_id去重
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

-- 特征工程v0
drop table if exists dev.dev_ftp_cc_feature_engineering_v0;
create table dev.dev_ftp_cc_feature_engineering_v0 stored as orc as
select
	user_id,
	count(*) as record_cnt,
	sum(case when type = 1 then 1 else 0 end) as type1_cnt,
	sum(case when type = 2 then 1 else 0 end) as type2_cnt,
	sum(case when type = 3 then 1 else 0 end) as type3_cnt,
	sum(case when type = 4 then 1 else 0 end) as type4_cnt,
	sum(case when type = 5 then 1 else 0 end) as type5_cnt,
	sum(case when type = 6 then 1 else 0 end) as type6_cnt,
	sum(case when cate = 4 then 1 else 0 end) as cate4_cnt,
	sum(case when cate = 5 then 1 else 0 end) as cate5_cnt,
	sum(case when cate = 6 then 1 else 0 end) as cate6_cnt,
	sum(case when cate = 7 then 1 else 0 end) as cate7_cnt,
	sum(case when cate = 8 then 1 else 0 end) as cate8_cnt,
	sum(case when cate = 9 then 1 else 0 end) as cate9_cnt,
	sum(case when cate = 10 then 1 else 0 end) as cate10_cnt,
	sum(case when cate = 11 then 1 else 0 end) as cate11_cnt,
	sum(case when dt = '2016-04-15' and cate = 6 and type = 1 then 1 else 0 end) as cate6_type1_last1day,
	sum(case when dt = '2016-04-15' and cate = 6 and type = 2 then 1 else 0 end) as cate6_type2_last1day,
	sum(case when dt = '2016-04-15' and cate = 6 and type = 3 then 1 else 0 end) as cate6_type3_last1day,
	sum(case when dt = '2016-04-15' and cate = 6 and type = 4 then 1 else 0 end) as cate6_type4_last1day,
	sum(case when dt = '2016-04-15' and cate = 6 and type = 5 then 1 else 0 end) as cate6_type5_last1day,
	sum(case when dt = '2016-04-15' and cate = 6 and type = 6 then 1 else 0 end) as cate6_type6_last1day
from
	dev.dev_ftp_cc_action_unique
group by
	user_id;
