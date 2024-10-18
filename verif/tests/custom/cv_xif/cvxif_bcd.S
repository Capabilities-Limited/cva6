# See LICENSE for license details.

#*****************************************************************************
# Copyright 2022 Thales DIS design services SAS
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
# You may obtain a copy of the License at https:#solderpad.org/licenses/
#
#----------------------------------------------------------------------------------

#include "cvxif_macros.h"

  #-------------------------------------------------------------
  # Custom tests
  #-------------------------------------------------------------

  .globl main
main:

# core of the test

    LOAD_RS(a0, 12345678);
    LOAD_RS(a1, 23456789);

    CUS_BCDfromBin(01010,01010);
    CUS_BCDfromBin(01011,01011);
    CUS_BCDADD(01010,01011,01100);
    CUS_BCDADD(01011,01010,01101);

# (example of) final self-check test
  xor a2, a3, a2;
  beqz a2, pass;

fail:
  # Failure post-processing (messages, ecall setup etc.)
  li a0, 0x0;
  jal exit;

pass:
  # Success post-processing (messages, ecall setup etc.)
  li a0, 0x0;
  jal exit;
