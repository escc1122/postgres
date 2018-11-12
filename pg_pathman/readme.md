select 
    srvname as name, 
    srvowner::regrole as owner, 
    fdwname as wrapper, 
    srvoptions as options
from pg_foreign_server
join pg_foreign_data_wrapper w on w.oid = srvfdw;

create server server_db0 foreign data wrapper postgres_fdw options(host '127.0.0.1',port '5432',dbname 'db0');

create user mapping for postgres server server_db0 options(user 'postgres',password 'postgres');

select * from pg_user_mappings;

CREATE FOREIGN TABLE pg_pathman_test
(
    id smallint,
    crt_time timestamp without time zone NOT NULL
) server server_db0 options (schema_name 'public',table_name 'pg_pathman_test');

select * from pg_pathman_test;

CREATE TABLE public.pg_pathman_main
(
    id smallint,
    crt_time timestamp without time zone NOT NULL
)

select create_range_partitions('pg_pathman_main'::regclass,             -- 主表OID
                        'crt_time',                        -- 分区列名
                        '2020-01-01 00:00:00'::timestamp,  -- 开始值
                        interval '1 year',                -- 间隔；interval 类型，用于时间分区表
                        10,                                -- 分多少个区
                        false) ;                           -- 不迁移数据

select attach_range_partition('pg_pathman_main' ::REGCLASS,    -- 主表OID
                       'pg_pathman_test' ::REGCLASS,    -- 分区表OID
                    '2018-01-01 00:00:00'::timestamp,  -- 起始值
                    '2019-12-31 23:59:59'::timestamp  -- 结束值
					  );


select add_range_partition('pg_pathman_main'::regclass,    -- 主表OID
                    '2018-01-01 00:00:00'::timestamp,  -- 起始值
                    '2019-12-31 23:59:59'::timestamp,  -- 结束值
					'pg_pathman_test' --分區名	  
						  );
						  
select * from pg_pathman_main;		  
