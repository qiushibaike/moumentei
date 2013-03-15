--set @time=now() - interval 1 hour;
select @count:=count(*) from articles where created_at >= now() - interval 1 hour;
set @year = year(curdate());
set @month = month(curdate());
set @day = day(curdate());

update `year` set `count`=`count`+@count where `year` = @year;
update `month` set `count`=`count`+@count where `year` = @year and `month` = @month;
update `day` set `count`=`count`+@count where `year` = @year and `month` = @month and `day` = @day;
