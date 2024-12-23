select /*+ gather_plan_statistics */* from t_branch t1 natural join t_basebranch  t2


;


select * from table(dbms_xplan.display_cursor(format=>'ALLSTATS LAST +cost +bytes +outline'))