# -*- coding: utf-8 -*-
"""
Created on Sun Dec 12 21:17:50 2021

@author: Mostafa Kamal
"""
from Syntax import COMMENT_LINE,instruction_size,LABEL_SYNTAX,INSTRUCTIONS_SYNTAX,write_memory,MEMORY_FILE_HEADER,first_valid_writing_location
import re
import os


file_dir = os.path.dirname(os.path.realpath('__file__'))
file_path = os.path.join(file_dir, "..\\Assembly Files\\" + input("Assembly file name (.asm) : "))
file = open(file_path, "r")

matchers = {
            "comment": re.compile(COMMENT_LINE),
            "label": re.compile(LABEL_SYNTAX['textformat']),
            "instructions": [re.compile(instruction_syntax['textformat']) for instruction_syntax in INSTRUCTIONS_SYNTAX]
}

parsed_instructions= []
labels_to_addresses = {}
current_address = 0
current_line = 0
syntax_error_encountered = False 
for line in file:
    current_line = current_line + 1
    
    #A comment or an empty line ---> Ignore
    if matchers['comment'].match(line):
        continue
    
    #Is it a label ?
    match = matchers['label'].match( LABEL_SYNTAX['preprocessor'](line) )
    #A label ---> Remember the address it's labelling
    if match:
        labels_to_addresses[match.groups[0]] = current_address
        continue
    
    #If we got here, the line is an instruction for sure (or a syntax error)
    sz = instruction_size(line)
    if sz is None:
        print("Error encountered at line",current_line)
        print("------------------------------------------------------------------")
        syntax_error_encountered = True
    else:
        current_address = current_address + sz
        #Determine which kind of instruction it is
        kind = 0
        match = None
        #By matching it agianst all possible syntaxes we know for instructions
        for matcher in matchers['instructions']:
            pp = INSTRUCTIONS_SYNTAX[kind]['preprocessor']
            match = matcher.match(pp(line))
            if match: break
            
            kind = kind + 1
        
        if match is None:
            syntax_error_encountered = True
            print("Syntax Error: Unrecognized Instruction",line," at line ",current_line)
            print("--------------------------------------------------------------")
        else:
            parsed_instructions.append((match,kind,current_line))
     
if syntax_error_encountered:
    print("Aborting due to syntax errors")
else:
    file_path = os.path.join(file_dir, "..\\Memory Files\\" + input("Memory file name(.mem) : "))
    output = open(file_path, "w")
    output.write(MEMORY_FILE_HEADER)
    syntax_error_encountered = False
    curr_addr = first_valid_writing_location(output)
    for match,kind,linenum in parsed_instructions:
        
        #Now that we have matched the instruction and determined it's kind, time to lookup what we matched
        machine_representations = []
        for i,lookup_source in enumerate(INSTRUCTIONS_SYNTAX[kind]['lookup']):
            try:
                if type(lookup_source) == type(dict()):
                    machine_representations.append(lookup_source[match.groups()[i]])
                #The lookup source is a callable
                else:
                    machine_representations.append(lookup_source(*match.groups()))
                   
            #Lookup failure, invoke the appropriate handler
            except :   
                    handler = INSTRUCTIONS_SYNTAX[kind]['onlookupFailure'][i]
                    handler(*match.groups())
                    print("Error encountered at line",linenum)
                    print("Aborting due to syntax errors")
                    syntax_error_encountered = True 
                    break
        if syntax_error_encountered: break 
    
        #Finally, invoke the translator callable to turn the machine_representations into it's final form
        machine_code = INSTRUCTIONS_SYNTAX[kind]['translator'](*machine_representations)
        
        curr_addr = write_memory(machine_code,output,curr_addr)
    
    output.close()
        
        
        
        
        