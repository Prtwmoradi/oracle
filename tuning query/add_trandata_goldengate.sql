--all column

alter table fcb.T_FIELDCHANGELOG            add supplemental log data (all) columns;

---pk
alter table fcb.T_FIELDCHANGELOG            add supplemental log data (primary key) columns;


-unique

alter table fcb.T_FIELDCHANGELOG            add supplemental log data (unique) columns;

--fk

alter table fcb.T_FIELDCHANGELOG            add supplemental log data (foreign key) columns;
