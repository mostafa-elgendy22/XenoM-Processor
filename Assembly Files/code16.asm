.ORG 0  
10

.ORG 6
200

.ORG 200 #this is int 0
INC R4 ;
RTI ;

.ORG 10
LDM R6, 50 ;
NOP;
NOP;
INT 0;
LDM R7, AA ;