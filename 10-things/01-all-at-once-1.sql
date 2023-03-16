-- Setup
drop table if exists #demo1;
create table #demo1
(
    column_a int not null,
    column_b int not null
)
go

insert into #demo1 values
    (1, 2),
    (3, 4)
go

-- View the data
select * from #demo1;
go

-- What's going to happen?
update #demo1 set column_a = column_b, column_b = column_a;
go

-- View the data
select * from #demo1;
go