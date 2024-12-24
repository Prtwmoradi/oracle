# oracle uses two main files: listener.ora, tnsnames.ora
#tcp: standard communication protocol used for client/server communication over a network
#IPC: used only for the client and oracle db are installed in the system
lsnrctl start
lsnrctl stop
lsnrctl status
lsnrctl reload
lsnrctl trace <level>
lsnrctl services
#if you want to force the listener to be up to not to wait to call the listener: alter system register;

