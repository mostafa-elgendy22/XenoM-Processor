# -*- coding: utf-8 -*-
"""
Created on Sun Dec 12 21:17:48 2021

@author: Mostafa Kamal
"""
MEMORY_FILE_HEADER = '''// memory data file (do not edit the following line - required for mem load use)
// instance=/ram_registers_counter/RAAM/Cells
// format=mti addressradix=d dataradix=b version=1.0 wordsperline=1
'''
#1- This indicates to the assembler which lines to discard right away
#-------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------
#Strings that indicate the rest of the line is comment
COMMENT_STARTING_MARKERS = [
                               '#' , #Python-like
                               '//', #C-like
                               ';' , #x86 assembly
                               '--'  #SQL
                         ]  
#-------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------
ONE_WORD_OPCODES = {"NOP" ,"SETC","RTI","RET","HLT","MOV","NOT",
                    "PUSH","POP" ,"IN" ,"OUT","JMP","JN" ,"JZ" ,
                    "JC"  ,"CALL","INT","AND","SUB","ADD","INC"}

TWO_WORD_OPCODES = { "LDM","IADD","STD","LDD" }
#2- This is used by the assembler to calculate an address for a label, by accumulating the sizes of all instructions that preceded it
def instruction_size(instruction):
    #TODO: This doesn't handle comments well, consider NOP#comment
    opcode = instruction.strip().split(' ',1)[0].upper()
    
    if   opcode in ONE_WORD_OPCODES:
        return 1 
    elif opcode in TWO_WORD_OPCODES:
        return 2
    else:
        print("Syntax Error: Unrecognized Opcode ",opcode," In ",instruction)
        return None
#-------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------
OPTIONAL_WHITESPACE = r"\s*"
WHITESPACE = r"\s+"

ALPHA  = r"[a-zA-Z_]+"
NUMBER = r"[0-9]+"
ALPHANUMERICAL = ALPHA+ "|" +NUMBER

COMMENT = r"(?:"+ r"|".join(COMMENT_STARTING_MARKERS) +").*"
OPTIONAL_COMMENT = r"(?:"+ COMMENT +")?"

REG_NAME = r"[R][0-7]"
OFFSET_REG_NAME = NUMBER +r"\("+ REG_NAME +r"\)"

ARG_SEPERATOR = OPTIONAL_WHITESPACE +r","+ OPTIONAL_WHITESPACE
LINE_END =  OPTIONAL_WHITESPACE +OPTIONAL_COMMENT+"$"
COMMENT_LINE = r"^"+ LINE_END

#3- This is used by the assembler to recognize a label and extract it's name
LABEL_SYNTAX = {
                "preprocessor": lambda line: line.strip(),
                "textformat": r"^("+ ALPHANUMERICAL +r")"+ OPTIONAL_WHITESPACE +r":"+ LINE_END
            }
#-------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------
ZERO_ARG_OPCODES = {'NOP','SETC','RTI','RET','HLT'}
ONE_ARG_OPCODES = {"PUSH","POP" ,"IN" ,"OUT","JMP","JN" ,"JZ" ,"JC"  ,"CALL","INT","NOT","INC"}
TWO_ARG_OPCODES = {"MOV","LDM"}
THREE_ARG_OPCODES1 = {"ADD","SUB","AND"}
THREE_ARG_OPCODES2 = {"IADD"}
THREE_ARG_OPCODES3 = {"STD","LDD"}

REGISTER_NAMES_TO_REGISTER_ADDRESSES = {f"{r}{i}":'{0:03b}'.format(i) for r in ("R") for i in range(0,8)}

def tonum(numstr):
    result = int(numstr)
    if result >= 0 and result < 2**16: 
        return '{0:016b}'.format(result)

    raise BaseException()
    
def twoarg_instructions_second_argument_lookup(opcode,arg):                                                                                
    if opcode == "MOV":
        return REGISTER_NAMES_TO_REGISTER_ADDRESSES[arg]
    
    return tonum(arg)

#TODO: Invert MOV argument order if necessary
def twoarg_instructions_translator(opcode,arg1,arg2):
    translation = ['10',opcode,arg1]
    if opcode == "0001": #LDM
        translation.append("0"*6) #zero padding
        translation.append(arg2)
        translation.append("0") #zero padding
    else:
        translation.append(arg2)
        translation.append("0"*4) #zero padding
    
    return ''.join(translation)

INVALID_REG = lambda arg: print(arg," is not a valid register name")
PP = lambda line: line.strip().upper()

def LDD_STD_translator(opcode,arg1,arg2,arg3): 
    machine_representations = ['11',opcode,arg1]
    
    if opcode == "1000": #LDD
        machine_representations.append(arg3)
    else:
        machine_representations.append(arg1)
    
    machine_representations.append(arg3)
    
    machine_representations.append(arg2)
    
    machine_representations.append('0')
    return ''.join(machine_representations)
    
    
#4- This is used by the assembler to recognize an instruction and extract it's fields
INSTRUCTIONS_SYNTAX = [#A list because there are several syntaxes for an instructions

                         #Zero-Arg instructions: <opcode> 
                         {
                            "preprocessor": PP ,
                            "textformat": r"^("+ r"|".join(ZERO_ARG_OPCODES) +")"+ LINE_END,
                            "lookup":[ 
                                      {
                                       "NOP": "0000", 
                                       "SETC":"0001", 
                                       "RTI": "0010", 
                                       "RET": "0011", 
                                       "HLT": "0100"   
                                      }
                                     ],
                            "onlookupFailure": [
                                lambda opcode: print(opcode," is not a valid zero-argument instruction")
                            ],
                            "translator": lambda opcode: "00"+ opcode +"0"*10 #Zero padding
                         },
                         
                         #One-Arg instructions: <opcode> <arg>, where <arg> is either a register (R0..R7) or an interrupt index (0..7)
                         {
                            "preprocessor": PP,
                            "textformat": r"^("+ r"|".join(ONE_ARG_OPCODES) +")"+ WHITESPACE +r"([R]?[0-7])" +LINE_END,
                            "lookup":[ 
                                      {
                                        "NOT": "0000", 
                                        "INC": "0001", 
                                        "PUSH":"0010", 
                                        "POP" :"0011", 
                                        "IN"  :"0100", 
                                        "OUT" :"0101", 
                                        "JMP" :"1000", 
                                        "JN"  :"1001", 
                                        "JZ"  :"1010", 
                                        "JC"  :"1011", 
                                        "CALL":"1100", 
                                        "INT" :"1101" 
                                      },
                                      dict(REGISTER_NAMES_TO_REGISTER_ADDRESSES,**{f"{i}":'{0:03b}'.format(i) for i in range(0,4)})
                                     ],
                            "onlookupFailure": [
                                lambda opcode,arg: print(opcode," is not a valid one-argument instruction"),
                                lambda opcode,arg: print(arg," is not a valid ", "interrupt index" if opcode == "INT" else "register name")
                                    
                            ],
                            "translator": lambda opcode,arg: "01"+ opcode +arg +"0"*7 #Zero padding
                         },
                         
                         #Two-Arg instructions: <opcode> <arg1> <arg2>, <arg1> is destination register, 
                         #<arg2> is either a source register in case of MOV or a 16-bit immediate in case of LDM
                         {
                            "preprocessor": PP,
                            "textformat": r"^("+ r"|".join(TWO_ARG_OPCODES) +")"+ WHITESPACE +r"("+ REG_NAME +r")"+ ARG_SEPERATOR +r"("+ REG_NAME +"|"+ NUMBER +r")" +LINE_END,
                            "lookup":[ 
                                      {"MOV": "0000", "LDM": "0001"},
                                      REGISTER_NAMES_TO_REGISTER_ADDRESSES,
                                      lambda opcode,arg1,arg2: twoarg_instructions_second_argument_lookup(opcode, arg2)
                                     ],
                            "onlookupFailure": [
                                lambda opcode,arg1,arg2: print(opcode," is not a valid two-argument instruction"),
                                lambda opcode,arg1,arg2: INVALID_REG(arg1),
                                lambda opcode,arg1,arg2: INVALID_REG(arg2) if opcode == "MOV" else print(arg2, " is not a valid 16-bit decimal immediate")
                                    
                            ],
                            "translator": lambda opcode,arg1,arg2: twoarg_instructions_translator(opcode,arg1,arg2)
                         },
                         
                         #Three-Arg first variant: <opcode> <reg> <reg> <reg> 
                         {
                            "preprocessor": PP,
                            "textformat": r"^("+ r"|".join(THREE_ARG_OPCODES1) +")"+ WHITESPACE +r"("+ REG_NAME +r")"+ ARG_SEPERATOR +r"("+ REG_NAME +r")"+ ARG_SEPERATOR +r"("+ REG_NAME +r")" +LINE_END,
                            "lookup":[ 
                                      {"AND": "0000", "SUB":"0001", "ADD": "0010" },
                                      REGISTER_NAMES_TO_REGISTER_ADDRESSES,
                                      REGISTER_NAMES_TO_REGISTER_ADDRESSES,
                                      REGISTER_NAMES_TO_REGISTER_ADDRESSES
                                     ],
                            "onlookupFailure": [
                                lambda opcode,arg1,arg2,arg3: print(opcode," is not a valid three-argument instruction"),
                                lambda opcode,arg1,arg2,arg3: INVALID_REG(arg1),
                                lambda opcode,arg1,arg2,arg3: INVALID_REG(arg2),
                                lambda opcode,arg1,arg2,arg3: INVALID_REG(arg3)
                            ],
                            "translator": lambda opcode,arg1,arg2,arg3: "11"+ opcode+ arg1+ arg2+ arg3 +"0" #Zero Padding
                         },
                         
                         #Three-Arg second variant: IADD <reg> <reg> <constant> 
                         {
                            "preprocessor": PP,
                            "textformat": r"^("+ r"|".join(THREE_ARG_OPCODES2) +")"+ WHITESPACE +r"("+ REG_NAME +r")"+ ARG_SEPERATOR +r"("+ REG_NAME +r")"+ ARG_SEPERATOR +r"("+ NUMBER +r")" +LINE_END,
                            "lookup":[ 
                                      {"IADD": "0111" },
                                      REGISTER_NAMES_TO_REGISTER_ADDRESSES,
                                      REGISTER_NAMES_TO_REGISTER_ADDRESSES,
                                      lambda opcode,arg1,arg2,arg3: tonum(arg3)
                                     ],
                            "onlookupFailure": [
                                lambda opcode,arg1,arg2,arg3: print(opcode," is not a valid three-argument instruction"),
                                lambda opcode,arg1,arg2,arg3: INVALID_REG(arg1),
                                lambda opcode,arg1,arg2,arg3: INVALID_REG(arg2),
                                lambda opcode,arg1,arg2,arg3: print(arg3," is not a valid 16 bit decimal immediate")
                            ],
                            "translator": lambda opcode,arg1,arg2,arg3: "11"+ opcode+ arg1+ arg2 +"000"+ arg3 +"0" #Zero Padding
                         },
                         
                         #Three-Arg third variant: <opcode> <reg> <offset> <reg>  
                         {
                            "preprocessor": PP,
                            "textformat": r"^("+ r"|".join(THREE_ARG_OPCODES3) +")"+ WHITESPACE +r"("+ REG_NAME +r")"+ ARG_SEPERATOR +r"("+ NUMBER +r")"+ ARG_SEPERATOR +r"("+ REG_NAME +r")" +LINE_END,
                            "lookup":[ 
                                      {"STD": "1001", "LDD": "1000"},
                                      REGISTER_NAMES_TO_REGISTER_ADDRESSES,
                                      lambda opcode,arg1,arg2,arg3: tonum(arg2),
                                      REGISTER_NAMES_TO_REGISTER_ADDRESSES
                                     ],
                            "onlookupFailure": [
                                lambda opcode,arg1,arg2,arg3: print(opcode," is not a valid three-argument instruction"),
                                lambda opcode,arg1,arg2,arg3: INVALID_REG(arg1),
                                lambda opcode,arg1,arg2,arg3: print(arg2," is not a valid 16 bit decimal immediate"),
                                lambda opcode,arg1,arg2,arg3: INVALID_REG(arg3)
                            ],
                            "translator": lambda opcode,arg1,arg2,arg3: LDD_STD_translator(opcode,arg1,arg2,arg3)
                         }             
]

def first_valid_writing_location(file):
    num = int(input("Enter the address of first instruction in the program in decimal : "))
    first_valid_writing_location = '{0:032b}'.format(num)
    
    file.write("0: "+first_valid_writing_location[0:16])
    file.write("\n")
    file.write("1: "+first_valid_writing_location[16:32])
    file.write("\n")
    
    return num

def write_memory(machine_code,file,curr_addr):
    #print("writing ",machine_code," \nat ",curr_addr)
    file.write(str(curr_addr)+": ")
    instr_length = len(machine_code)
    if   instr_length == 16: 
        file.write(machine_code)
    elif instr_length == 32: 
        #print("writing ",machine_code[0:16])
        file.write(machine_code[0:16])
        curr_addr = curr_addr+1 
        file.write("\n")
        file.write(str(curr_addr)+": ")
        #print("writing ",machine_code[16:32])
        file.write(machine_code[16:32])
    else:
        print("WARNING: INVALID MACHINE CODE ENCOUNTERED")

    curr_addr = curr_addr+1
    file.write("\n")
    return curr_addr








    
     