// Copyright 2024 Thales DIS France SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Guillaume Chauvon

module copro_alu
  import cvxif_instr_pkg::*;
#(
    parameter int unsigned NrRgprPorts = 2,
    parameter int unsigned XLEN = 32,
    parameter type hartid_t = logic,
    parameter type id_t = logic,
    parameter type registers_t = logic

) (
    input  logic                  clk_i,
    input  logic                  rst_ni,
    input  registers_t            registers_i,
    input  opcode_t               opcode_i,
    input  hartid_t               hartid_i,
    input  id_t                   id_i,
    input  logic       [     4:0] rd_i,
    output logic       [XLEN-1:0] result_o,
    output hartid_t               hartid_o,
    output id_t                   id_o,
    output logic       [     4:0] rd_o,
    output logic                  valid_o,
    output logic                  we_o
);

  logic [XLEN-1:0] result_n, result_q;
  hartid_t hartid_n, hartid_q;
  id_t id_n, id_q;
  logic valid_n, valid_q;
  logic [4:0] rd_n, rd_q;
  logic we_n, we_q;

  assign result_o = result_q;
  assign hartid_o = hartid_q;
  assign id_o     = id_q;
  assign valid_o  = valid_q;
  assign rd_o     = rd_q;
  assign we_o     = we_q;

  localparam W = XLEN;
  function automatic logic [W-1:0] BCDfromBin (logic [W-1:0] bin);
    // Code adapted from https://en.wikipedia.org/wiki/Double_dabble
    logic [W+(W-4)/3:0] bcd = 0;          // initialize with zeros
    bcd[W-1:0] = bin;                     // initialize with input vector
    for(int i = 0; i <= W-4; i = i+1)     // iterate on structure depth
      for(int j = 0; j <= i/3; j = j+1)   // iterate on structure width
        if (bcd[W-i+4*j -: 4] > 4)        // if > 4
          bcd[W-i+4*j -: 4] = bcd[W-i+4*j -: 4] + 4'd3; // add 3
    return bcd[W-1:0];
  endfunction
  function automatic logic [W-1:0] BCDADD (logic [W-1:0] x, logic [W-1:0] y);
    logic [W-1:0] sum;   // full sum result
    logic [4:0] tmp = 0; // temporary digit result (could be up to 9+9+8=24)
    logic [3:0] c = 0;   // carry bits
    for(int i = 3; i<W; i = i+4) begin // For each nibble
      tmp = {1'b0,x[i-:4]} + {1'b0,y[i-:4]} + {1'b0,c}; // Add the next nibble with room for overflow
      c = 0;
      for (int j = 0; j < 2; j = j+1)
        if (tmp >= 10) begin // Add one to carry for each "10" in temp.
          c += 1;
          tmp = tmp - 10;   // Leave tmp less than 10.
        end
      sum[i-:4] = tmp[3:0] ;
    end
    return sum;
  endfunction

  always_comb begin
    case (opcode_i)
      cvxif_instr_pkg::BCDfromBIN: begin
        result_n = BCDfromBin(registers_i[0]);
        hartid_n = hartid_i;
        id_n     = id_i;
        valid_n  = 1'b1;
        rd_n     = rd_i;
        we_n     = 1'b1;
      end
      cvxif_instr_pkg::BCDADD: begin
        result_n = BCDADD(registers_i[0], registers_i[1]);
        hartid_n = hartid_i;
        id_n     = id_i;
        valid_n  = 1'b1;
        rd_n     = rd_i;
        we_n     = 1'b1;
      end
      default: begin
        result_n = '0;
        hartid_n = '0;
        id_n     = '0;
        valid_n  = '0;
        rd_n     = '0;
        we_n     = '0;
      end
    endcase
  end

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      result_q <= '0;
      hartid_q <= '0;
      id_q     <= '0;
      valid_q  <= '0;
      rd_q     <= '0;
      we_q     <= '0;
    end else begin
      result_q <= result_n;
      hartid_q <= hartid_n;
      id_q     <= id_n;
      valid_q  <= valid_n;
      rd_q     <= rd_n;
      we_q     <= we_n;
    end
  end

endmodule
