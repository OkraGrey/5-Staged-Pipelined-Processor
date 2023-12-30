# 5-Staged-Pipelined-Processor

# This is a complete implementation for a 5 staged pipeline processor
# The pipeline consists of following stages 

# 5 stages include 
# Instruciton Fetch  (IF)
# Instruction Decode (ID)
# Execute            (EX)
# Memory Hit         (MEM)
# Write Back         (WB)

# Supported Instructions

# Processor is based on risc-v 32 bit architecture and support all six types of instructions
# specified by risc-v i.e I,R,J,S,U and B type

# Support for timer interrupt is also added in the code 
# Timer interrupt will be generated adter 100 units of time (see timer.sv)
# Current Pc will be stored into mepc CSR register and pc will jump to interrupt handler
# After the successful run of interrupt handling routine
# mret will be called and value of pc will be returned to the point of interrupt

# This is a brief introduction regarding the tested capabilities of this processor
 






