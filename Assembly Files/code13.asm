.ORG 0
50

.ORG 20
NOT R6;

.ORG 50
LDM R1, 20;
NOP ;
NOP ;
JMP R1; 
INC R1;	  # this statement shouldn't be executed
 
