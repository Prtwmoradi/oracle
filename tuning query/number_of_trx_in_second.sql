select /*+index (......)*/ count(id), substr(c_date,1,16) from ....... doc where 
             c_date >= :fdate and
	     c_date <= :tdate
 	     group by substr(c_date,1,16);