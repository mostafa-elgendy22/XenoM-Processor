.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10

.ORG 6  #this is int 0
200

.ORG 8  #this is int 2
250

.ORG 200 #this is int 0
AND R0,R0,R0    #N=0,Z=1
OUT R6
#RTI          #POP PC and flags restored

.ORG 250 #this is int 2
SETC
AND R0,R0,R0    #N=0,Z=1
OUT R2
#RTI          #POP PC and flags restored

.ORG 10

LDM R1 , BBBB;
NOP ;
NOP ;
OUT R1 ;
NOP ;
NOP ;
IN R4 ;
NOP ;
NOP ;
INT 0;