set partNumber $::env(XILINX_PART)
set boardName  $::env(XILINX_BOARD)

set ipName xlnx_axi_fifo

create_project $ipName . -part $partNumber
set_property board_part $boardName [current_project]

create_ip -name axi_fifo_mm_s -vendor xilinx.com -library ip -module_name $ipName
set_property -dict [list CONFIG.C_HAS_AXIS_TKEEP {true} \
                         CONFIG.C_RX_FIFO_DEPTH {4096} \
                         CONFIG.C_RX_FIFO_PE_THRESHOLD {10} \
                         CONFIG.C_RX_FIFO_PF_THRESHOLD {4000} \
                         CONFIG.C_TX_FIFO_DEPTH {4096} \
                         CONFIG.C_TX_FIFO_PE_THRESHOLD {10} \
                         CONFIG.C_TX_FIFO_PF_THRESHOLD {4000} \
                   ] [get_ips $ipName]

generate_target {instantiation_template} [get_files ./$ipName.srcs/sources_1/ip/$ipName/$ipName.xci]
generate_target all [get_files  ./$ipName.srcs/sources_1/ip/$ipName/$ipName.xci]
create_ip_run [get_files -of_objects [get_fileset sources_1] ./$ipName.srcs/sources_1/ip/$ipName/$ipName.xci]
launch_run -jobs 8 ${ipName}_synth_1
wait_on_run ${ipName}_synth_1
