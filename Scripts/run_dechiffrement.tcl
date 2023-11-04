#  ________  ________  ________  ___  ________  _________        ________  _______   ________   _______   ________  ________  _________  ___  ________  ________           ________  _______   ________           ________  ________  ___  ___  ________                 ________  ___       _______   ________      
# |\   ____\|\   ____\|\   __  \|\  \|\   __  \|\___   ___\     |\   ____\|\  ___ \ |\   ___  \|\  ___ \ |\   __  \|\   __  \|\___   ___\\  \|\   __  \|\   ___  \        |\   ___ \|\  ___ \ |\   ____\         |\   ____\|\   __  \|\  \|\  \|\   ____\               |\   ____\|\  \     |\  ___ \ |\   ____\     
#  \ \  \___|\ \  \___|\ \  \|\  \ \  \ \  \|\  \|___ \  \_|     \ \  \___|\ \   __/|\ \  \\ \  \ \   __/|\ \  \|\  \ \  \|\  \|___ \  \_\ \  \ \  \|\  \ \  \\ \  \       \ \  \_|\ \ \   __/|\ \  \___|_        \ \  \___|\ \  \|\  \ \  \\\  \ \  \___|_  ____________\ \  \___|\ \  \    \ \   __/|\ \  \___|_    
#   \ \_____  \ \  \    \ \   _  _\ \  \ \   ____\   \ \  \       \ \  \  __\ \  \_|/_\ \  \\ \  \ \  \_|/_\ \   _  _\ \   __  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \       \ \  \ \\ \ \  \_|/_\ \_____  \        \ \_____  \ \  \\\  \ \  \\\  \ \_____  \|\____________\ \  \    \ \  \    \ \  \_|/_\ \_____  \   
#    \|____|\  \ \  \____\ \  \\  \\ \  \ \  \___|    \ \  \       \ \  \|\  \ \  \_|\ \ \  \\ \  \ \  \_|\ \ \  \\  \\ \  \ \  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \       \ \  \_\\ \ \  \_|\ \|____|\  \        \|____|\  \ \  \\\  \ \  \\\  \|____|\  \|____________|\ \  \____\ \  \____\ \  \_|\ \|____|\  \  
#      ____\_\  \ \_______\ \__\\ _\\ \__\ \__\        \ \__\       \ \_______\ \_______\ \__\\ \__\ \_______\ \__\\ _\\ \__\ \__\   \ \__\ \ \__\ \_______\ \__\\ \__\       \ \_______\ \_______\____\_\  \         ____\_\  \ \_______\ \_______\____\_\  \              \ \_______\ \_______\ \_______\____\_\  \ 
#     |\_________\|_______|\|__|\|__|\|__|\|__|         \|__|        \|_______|\|_______|\|__| \|__|\|_______|\|__|\|__|\|__|\|__|    \|__|  \|__|\|_______|\|__| \|__|        \|_______|\|_______|\_________\       |\_________\|_______|\|_______|\_________\              \|_______|\|_______|\|_______|\_________\
#      \|_________|                                                                                                                                                                                \|_________|       \|_________|                  \|_________|                                           \|_________|                                    
																									  
vcom -reportprogress 300 -work work Y:/AES_128/Sources/Package_Galois.vhd 
vcom -reportprogress 300 -work work Y:/AES_128/Sources/KeyExpansion/Package_AES_KeyExpansion.vhd 
vcom -reportprogress 300 -work work Y:/AES_128/Sources/KeyExpansion/Key_Expansion.vhd 
vcom -reportprogress 300 -work work Y:/AES_128/Sources/KeyExpansion/rom_sbox.vhd 
vcom -reportprogress 300 -work work Y:/AES_128/Sources/KeyExpansion/Top_Key_Expansion.vhd 
vcom -reportprogress 300 -work work Y:/AES_128/Testbench/KeyExpansion_tb.vhd 
vcom -reportprogress 300 -work work Y:/AES_128/Sources/Dechifrement/packagedechiffrement.vhd
vcom -reportprogress 300 -work work Y:/AES_128/Sources/Dechifrement/rom_invsbox.vhd
vcom -reportprogress 300 -work work Y:/AES_128/Sources/Dechifrement/dechiffrement_pipeline.vhd
vcom -reportprogress 300 -work work Y:/AES_128/Sources/Dechifrement/Top_AES.vhd
vcom -reportprogress 300 -work work Y:/AES_128/Testbench/Dechiffrement_tb.vhd

vsim -gui work.Dechiffrement_tb

add wave -divider Datas_IN/OUT
add wave -position insertpoint -radix hex sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/*

add wave -divider Signaux
add wave -position insertpoint -radix hex \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/Nbit \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/resetn \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/clk \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/state \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/flag \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/key \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/out_data \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/reg_key \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/reg_state \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/data_out \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/addr \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/en \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/zero_state \
sim:/dechiffrement_tb/TOP_DU_TOP/dechiff_inst/zero_state_2

restart -f; run 400 ns;