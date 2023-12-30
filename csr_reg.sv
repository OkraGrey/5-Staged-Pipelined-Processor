module csr_reg
(
    input  logic         clk,
    input  logic         rst,
    input  logic [31: 0] addr,
    input  logic [31: 0] wdata,  
    input  logic [31: 0] pc,
    input  logic         trap,    
    input  logic         csr_rd,  
    input  logic         csr_wr,  
    input  logic         is_mret, 
    input  logic [31: 0] inst,
    output logic [31: 0] rdata,
    output logic [31: 0] epc,
    output logic         epc_taken 
);

    logic [31: 0] csr_mem [6];
    logic         is_device_int_en;
    logic         is_global_int_en;


    always_comb
    begin
        if (csr_rd)
        begin
            case (inst[31:20])
                12'h300: rdata = csr_mem[0]; // mstatus 
                12'h304: rdata = csr_mem[1]; // mie 
                12'h305: rdata = csr_mem[2]; // mtvec 
                12'h341: rdata = csr_mem[3]; // mepc 
                12'h342: rdata = csr_mem[4]; // mcause 
                12'h344: rdata = csr_mem[5]; // mip 
            endcase
        end
        else
        begin
            rdata = 32'b0; 
        end
    end


    always_ff @(posedge clk)
    begin
        if (rst)
        begin
            csr_mem[0] <= 32'b0;
            csr_mem[1] <= 32'b0;
            csr_mem[2] <= 32'b0;
            csr_mem[3] <= 32'b0;
            csr_mem[4] <= 32'b0;
            csr_mem[5] <= 32'b0;
        end
        else if (csr_wr)
        begin
            case (inst[31:20])
                12'h300: csr_mem[0] <= wdata; // mstatus
                12'h304: csr_mem[1] <= wdata; // mie
                12'h305: csr_mem[2] <= wdata; // mtvec
                12'h341: csr_mem[3] <= wdata; // mepc
                12'h342: csr_mem[4] <= wdata; // mcause
                12'h344: csr_mem[5] <= wdata; // mip
            endcase
        end


        if (trap)
        begin
            csr_mem[4]       <= 32'b0;                              
            csr_mem[5]       <= csr_mem[5] | 32'd128;               
            is_device_int_en = csr_mem[5][7] & csr_mem[1][7];
            is_global_int_en = csr_mem[0][3] & is_device_int_en;    
            if (is_global_int_en)
            begin
                csr_mem[3] = pc;                                    
                epc        <= csr_mem[2] + (csr_mem[4] << 2); 
                epc_taken  <= 1'b1;
            end
        end
        else if (is_mret)
        begin
            epc_taken <= 1'b1;
            epc       <= csr_mem[3]; 
        end
        else
        begin
            epc_taken <= 1'b0;
            epc <= pc;
        end
    end

endmodule