BEGIN {
    while(("/inet/tcp/0/irc.libera.chat/6667" |& getline))
       print 
}