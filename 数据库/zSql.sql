-- Sql语句仓库
-- 库级操作
	-- 创建数据库
		CREATE DATABasE shop;
-- 表级操作
	-- 创建表
		create table product(
			product_id integer(11) primary key not null auto_increment,
			product_name varchar(100) not null,
			product_type varchar(32) not null,
			product_purchase_price double(10,2),
			product_sale_price double(10,2),
			product_purchase_date date
			);
	-- 主键于末尾设置
		create table product(
			product_id integer(11) not null auto_increment,
			product_name varchar(100) not null,
			product_type varchar(32) not null,
			product_purchase_price double(10,2),
			product_sale_price double(10,2),
			product_purchase_date date,
			primary key('product_id')
			);
		-- auto_increment不能应用于char类型,可以应用于integer类型
	-- 删除表
		drop table product;
	-- 修改表
		-- 增加字段
			alter table product add column product_number integer(11);
		-- 删除字段
			alter table product drop column product_number;
		-- 修改列名
			alter table product product_perchase_date product_purchase_date date;
	-- 查看表结构
		desc product;
	-- 记录操作
		-- 增
			-- 插入语句中date类型字段对应位置可以放一个日期格式的字符串
				insert into product(product_name,product_type,product_purchase_price,product_sale_price,product_purchase_date) values("联想小新","笔记本电脑",4000,4500,'2020-01-25');
			-- 把一个表中的数据复制到另一个表中 可以用于备份数据表
				insert into productbk select * from product
		-- 删
			-- 删除表中数据但不删除表结构
				delete from product;
				delete * from product where product_type="手机"; 
		-- 改
			-- update 
				update product set product_purchase_date ='2009-10-10' where product_id=1;
				update product set product_sale_price = product_sale_price * 10 where product_type='厨房用具'
			--与日期相关的修改
				(sqlServer)
				update T_ENG_BOMCHILD_A set FCHANGETIME='2021-02-23 16:06:24.521' where FID=531326 AND FCHANGETIME='2020-02-23 16:06:24.521';
		-- 查
		    -- 查询表中所有记录
		    	select * from tablename;
		    -- 查询的时候给列设置别名
		    	select product_id as id from product;
		    -- 设置中文别名的时候要使用双引号 貌似不用中文也可以
		    	select product_id as "产品编码" from product;
		    -- 查询常数,把某些字段的查询结果设置为常数
		    	select 'iphone12' as product_name,"手机" as "product_type","5000" as product_purchase_price,"5500" as product_sale_price,"2021-01-25" as product_purchase_date,100 as product_number;
		    -- 查询结果去重
		    	select distinct product_type from product;
		    -- where
		    	select product_name from product where product_type="衣服";
		    -- sum
		    	select sum(product_sale_price),sum(product_purchase_price) from product;
		    -- avg
		    	select avg(product_sale_price),avg(product_purchase_price) from product;
		    -- max min
			    select max(product_sale_price) from product;
			    select min(product_purchase_price) from product;
		    -- count 返回表的行数，不会统计字段值为null的记录
		    	select count(*) from product;
		    -- group by 分组 
			    select product_type,count(*) from product group by product_type;
			    select product_purchase_price,count(*) from product where product_type="衣服" group by product_purchase_price;
		    -- having 选出满足条件的分组
		    	select product_type,count(*) from product group by product_type having count(*)=2;
		    -- ASC 升序 默认 DESC 降序
		    	select product_id, product_name, product_sale_price, product_purchase_price from product order by sale_price desc;
		    	-- 指定多个排序键
		    	select * from product order by product_sale_price desc,product_id desc;
		    -- 视图
				-- 创建视图 也可以以视图为基础创建视图
					create view productview(product_type,type_counts) as select product_type,count(*) from product group by product_type;
				-- 使用视图
					select * from productview;
					select product_type,type_counts from productview;
				-- 删除视图
					drop view productview;
				-- 查看视图
					show table status where comment='view';
			-- 子查询 可以理解为一张一次性视图  我理解为一次中间查询，或者说为其他查询做基础的查询
				select product_type,type_counts from (select product_type,count(*) as type_counts from product group by product_type) as productview; 
			-- 关联子查询(有空研究sql各语句的执行顺序)
			-- 查询所有商品中单价超出其所属商品种类平均价格的商品
				select product_name,product_sale_price from product as p1 where p1.product_sale_price > (select avg(product_sale_price) from product as p2 where p2.product_type=p1.product_type);
				select product_name,product_sale_price from product as p1 where p1.product_sale_price > (select avg(product_sale_price) from product as p2 where p2.product_type=p1.product_type group by product_type );
			-- 与日期相关的查询
				(sqlserver)
				select FCHANGETIME from T_ENG_BOMCHILD_A where FID=531326 AND FCHANGETIME>='2021-02-23 16:04:24';
			-- 函数、谓词
				-- 集合运算
					-- 表的相加union 
						select * from product union select * from product2;
						-- 不包含重复行
							select product_name,product_sale_price from product union select product_name,product_sale_price from product2;
					-- 包含重复行
						select product_name,product_sale_price from product union all select product_name,product_sale_price from product2;
					-- 选取表中公共部分(mysql不支持)
						select product_id ,product_name from product intersect select product_id,product_name from product2;
					-- 从表A中去掉与表B重复的部分(mysql不支持)
						select product_id ,product_name from product except select product_id,product_name from product2;
				-- 联结 join
					-- 内联结 A B中 A中某个元素等于B中某个元素
						select p1.product_name,p1.product_sale_price,p2.id from product as p1 inner join code as p2 on p1.product_type=p2.name;
					-- 外联结(以两个表其中一个为基准，另一个表中没有的属性以null填充)
						-- 左外链接
							select p1.product_name,p1.product_sale_price,p2.id from product as p1 left outer join code as p2 on p1.product_type=p2.name;
						-- 右外链接
							select p1.product_name,p1.product_sale_price,p2.id from product as p1 right outer join code as p2 on p1.product_type=p2.name;
-- 事务
	-- mysql
		-- 开始事务
			start transaction
		-- 提交事务
			commit
		-- 回滚
			roll back
-- 特殊应用
	-- 查询表中某个字段重复的数据
    	select * from tablename a where (a.name) in (select * FORM tablename group by name having COUNT(*) > 1);
    -- 查询表中最大的10条数据
    	select * from tbl_emp order by emp_id desc limit 0,10



