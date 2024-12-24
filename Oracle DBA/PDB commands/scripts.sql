show pdbs;
alter pluggable database "the name of the pdb" open;
alter pluggable database all open;
alter pluggable database all close;
alter session set container= prod;
show con_name;
alter PLUGGABLE database open;
--- when you alter your session it does not need to write the name again;

alter session set container= cdb$root;
