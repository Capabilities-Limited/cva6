..
   Copyright 2024 Thales DIS France SAS
   Licensed under the Solderpad Hardware License, Version 2.1 (the "License");
   you may not use this file except in compliance with the License.
   SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
   You may obtain a copy of the License at https://solderpad.org/licenses/

   Original Author: Jean-Roch COULON - Thales
   Survey of parameters: Jonathan Woodruff - Capabilities Limited

.. _cva6_user_cfg_doc:

These are notes on parameterising both the cv32a65x ("cv32") and th cv64a6_imafdc_sv39 ("cv64") configurations.
For each parameter, we tested whether it could build with a change, and how performance
changed in Dhrystone.
We tested the master branch of github.com/openhwgroup/cva6 from about 1 November 2024.
The repository was seeing frequent updates, so details are likely to change.

.. list-table:: ``cva6_user_cfg_t`` parameters
   :header-rows: 1

   * - Name
     - Type
     - Description
     - Notes

   * - ``XLEN``
     - ``int unsigned``
     - General Purpose Register Size (in bits)
     - Both cv64 and cv32 configurations built with opposite XLEN.

   * - ``RVA``
     - ``bit``
     - Atomic RISC-V extension
     - cv64 built and ran with this feature disabled.

   * - ``RVB``
     - ``bit``
     - Bit manipulation RISC-V extension
     - 

   * - ``RVV``
     - ``bit``
     - Vector RISC-V extension
     - I was not able to build with this extension enabled on cv64. I copied a configuration that claimed to support it, notably disabling the cvxif interface example, which is required for the vector extension, but it still failed to build at this time.

   * - ``RVC``
     - ``bit``
     - Compress RISC-V extension
     - cv64 built without compressed instrucitons, but Dhrystone failed to run, as it still used compressed instructions.

   * - ``RVH``
     - ``bit``
     - Hypervisor RISC-V extension
     - 

   * - ``RVZCB``
     - ``bit``
     - Zcb RISC-V extension
     - cv64 built and ran with Zcp disabled.

   * - ``RVZCMP``
     - ``bit``
     - Zcmp RISC-V extension
     - cv64 built and ran with Zcmp enabled (it was disabled by default).

   * - ``RVZiCond``
     - ``bit``
     - Zicond RISC-V extension
     - 

   * - ``RVZicntr``
     - ``bit``
     - Zicntr RISC-V extension
     - 

   * - ``RVZihpm``
     - ``bit``
     - Zihpm RISC-V extension
     - 

   * - ``RVF``
     - ``bit``
     - Floating Point
     - cv64 built and ran without RVF.  Performance was equivelant for Dhrystone, so no performance cost for enabling floating point.

   * - ``RVD``
     - ``bit``
     - Floating Point
     - cv64 built and ran without RVD. Performance was equivelant for Dhrystone.  RVF is required for RVD; RVD didn't build with RVD disabled.

   * - ``XF16``
     - ``bit``
     - Non standard 16bits Floating Point extension
     - 

   * - ``XF16ALT``
     - ``bit``
     - Non standard 16bits Floating Point Alt extension
     - 

   * - ``XF8``
     - ``bit``
     - Non standard 8bits Floating Point extension
     - 

   * - ``XFVec``
     - ``bit``
     - Non standard Vector Floating Point extension
     - 

   * - ``PerfCounterEn``
     - ``bit``
     - Perf counters
     - rv32 and rv64 built and ran without PerfCounterEn, and got equivelant performance.

   * - ``MmuPresent``
     - ``bit``
     - MMU
     - rv32 worked with enabled MMU, and rv64 worked with disabled MMU, and both ran Dhrystone with no change in performance.

   * - ``RVS``
     - ``bit``
     - Supervisor mode
     - 

   * - ``RVU``
     - ``bit``
     - User mode
     - 

   * - ``DebugEn``
     - ``bit``
     - Debug support
     - Enabling debug in cv32 slowed down performance by about 10\%.

   * - ``DmBaseAddress``
     - ``logic [63:0]``
     - Base address of the debug module
     - 

   * - ``HaltAddress``
     - ``logic [63:0]``
     - Address to jump when halt request
     - 

   * - ``ExceptionAddress``
     - ``logic [63:0]``
     - Address to jump when exception
     - 

   * - ``TvalEn``
     - ``bit``
     - Tval Support Enable
     - cv64 built and ran without TvalEn.  No change in performance.

   * - ``DirectVecOnly``
     - ``bit``
     - MTVEC CSR supports only direct mode
     - 

   * - ``NrPMPEntries``
     - ``int unsigned``
     - PMP entries number
     - Both cv32 and cv64 successfully built with 0 PMP entries (from 8) with no change in performance.

   * - ``PMPCfgRstVal``
     - ``logic [63:0][63:0]``
     - PMP CSR configuration reset values
     - 

   * - ``PMPAddrRstVal``
     - ``logic [63:0][63:0]``
     - PMP CSR address reset values
     - 

   * - ``PMPEntryReadOnly``
     - ``bit [63:0]``
     - PMP CSR read-only bits
     - 

   * - ``NrNonIdempotentRules``
     - ``int unsigned``
     - PMA non idempotent rules number
     - 

   * - ``NonIdempotentAddrBase``
     - ``logic [NrMaxRules-1:0][63:0]``
     - PMA NonIdempotent region base address
     - 

   * - ``NonIdempotentLength``
     - ``logic [NrMaxRules-1:0][63:0]``
     - PMA NonIdempotent region length
     - 

   * - ``NrExecuteRegionRules``
     - ``int unsigned``
     - PMA regions with execute rules number
     - 

   * - ``ExecuteRegionAddrBase``
     - ``logic [NrMaxRules-1:0][63:0]``
     - PMA Execute region base address
     - 

   * - ``ExecuteRegionLength``
     - ``logic [NrMaxRules-1:0][63:0]``
     - PMA Execute region address base
     - 

   * - ``NrCachedRegionRules``
     - ``int unsigned``
     - PMA regions with cache rules number
     - 

   * - ``CachedRegionAddrBase``
     - ``logic [NrMaxRules-1:0][63:0]``
     - PMA cache region base address
     - 

   * - ``CachedRegionLength``
     - ``logic [NrMaxRules-1:0][63:0]``
     - PMA cache region rules
     - 

   * - ``CvxifEn``
     - ``bit``
     - CV-X-IF coprocessor interface enable
     - cv64 built and ran with Cvxif disabled.  Performance was unchanged.

   * - ``NOCType``
     - ``noc_type_e``
     - NOC bus type
     - 

   * - ``AxiAddrWidth``
     - ``int unsigned``
     - AXI address width
     - 

   * - ``AxiDataWidth``
     - ``int unsigned``
     - AXI data width
     - cv32 did not build with AxiDataWidth changed from 64 to 128. This may be due to the simulation infrastructure rather than the core itself.

   * - ``AxiIdWidth``
     - ``int unsigned``
     - AXI ID width
     - 

   * - ``AxiUserWidth``
     - ``int unsigned``
     - AXI User width
     - 

   * - ``AxiBurstWriteEn``
     - ``bit``
     - AXI burst in write
     - cv32 worked with AxiBurstWriteEn turned on, but performance did not change.

   * - ``MemTidWidth``
     - ``int unsigned``
     - TODO
     - 

   * - ``IcacheByteSize``
     - ``int unsigned``
     - Instruction cache size (in bytes)
     - Both cv32a65x and cv64 built and ran with a range of ICacheSizes.

       .. image:: images/Cycles_vs_Instruction_Cache_Size_in_cv32a65x.png
         :width: 400
       .. image:: images/Cycles_vs_Instruction_Cache_Size_in_cv32a65x.png
         :width: 400

   * - ``IcacheSetAssoc``
     - ``int unsigned``
     - Instruction cache associativity (number of ways)
     - 

   * - ``IcacheLineWidth``
     - ``int unsigned``
     - Instruction cache line width
     - 

   * - ``DCacheType``
     - ``cache_type_t``
     - Cache Type
     - 

   * - ``DcacheIdWidth``
     - ``int unsigned``
     - Data cache ID
     - 

   * - ``DcacheByteSize``
     - ``int unsigned``
     - Data cache size (in bytes)
     - 

   * - ``DcacheSetAssoc``
     - ``int unsigned``
     - Data cache associativity (number of ways)
     - 

   * - ``DcacheLineWidth``
     - ``int unsigned``
     - Data cache line width
     - 

   * - ``DataUserEn``
     - ``int unsigned``
     - User field on data bus enable
     - 

   * - ``WtDcacheWbufDepth``
     - ``int unsigned``
     - Write-through data cache write buffer depth
     - 

   * - ``FetchUserEn``
     - ``int unsigned``
     - User field on fetch bus enable
     - 

   * - ``FetchUserWidth``
     - ``int unsigned``
     - Width of fetch user field
     - 

   * - ``FpgaEn``
     - ``bit``
     - Is FPGA optimization of CV32A6
     - 

   * - ``TechnoCut``
     - ``bit``
     - Is Techno Cut instanciated
     - 

   * - ``SuperscalarEn``
     - ``bit``
     - Enable superscalar* with 2 issue ports and 2 commit ports.
     - 

   * - ``NrCommitPorts``
     - ``int unsigned``
     - Number of commit ports. Forced to 2 if SuperscalarEn.
     - 

   * - ``NrLoadPipeRegs``
     - ``int unsigned``
     - Load cycle latency number
     - 

   * - ``NrStorePipeRegs``
     - ``int unsigned``
     - Store cycle latency number
     - 

   * - ``NrScoreboardEntries``
     - ``int unsigned``
     - Scoreboard length
     - 

   * - ``NrLoadBufEntries``
     - ``int unsigned``
     - Load buffer entry buffer
     - 

   * - ``MaxOutstandingStores``
     - ``int unsigned``
     - Maximum number of outstanding stores
     - 

   * - ``RASDepth``
     - ``int unsigned``
     - Return address stack depth
     - 

   * - ``BTBEntries``
     - ``int unsigned``
     - Branch target buffer entries
     - 

   * - ``BHTEntries``
     - ``int unsigned``
     - Branch history entries
     - 

   * - ``InstrTlbEntries``
     - ``int unsigned``
     - MMU instruction TLB entries
     - 

   * - ``DataTlbEntries``
     - ``int unsigned``
     - MMU data TLB entries
     - 

   * - ``UseSharedTlb``
     - ``bit unsigned``
     - MMU option to use shared TLB
     - 

   * - ``SharedTlbDepth``
     - ``int unsigned``
     - MMU depth of shared TLB
     - 
