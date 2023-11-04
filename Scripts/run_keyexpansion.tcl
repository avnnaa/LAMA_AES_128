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


vsim -gui work.KeyExpansion_tb

add wave -divider In_Out
add wave -position insertpoint -radix hex\
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/clk \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/rstn \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/key_in

add wave -divider Lecture_Sous_Cles
add wave -position insertpoint -radix hex \
sim:/keyexpansion_tb/key_select  \
sim:/keyexpansion_tb/key_out  \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/OK_GEN

add wave -divider Nb_Round
add wave -position insertpoint  \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/cpt

add wave -divider W0
add wave -position insertpoint -radix hex \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/temp_w0  \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/w0_rotword   \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/w0_sub   \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/RconXORtemp \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/w0_old \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/w0

add wave -divider W1
add wave -position insertpoint -radix hex \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/temp_w1  \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/w1_old \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/w1

add wave -divider W2
add wave -position insertpoint -radix hex \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/temp_w2  \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/w2_old \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/w2

add wave -divider W3
add wave -position insertpoint -radix hex \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/temp_w3  \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/w3_old \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/w3

add wave -divider Sbox
add wave -position insertpoint -radix hex \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/adress \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/w0_sub

add wave -divider Rcon
add wave -position insertpoint -radix hex \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/key_prev \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/key_in \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/OK_GEN \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/Gen_Key \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/Key_out_temp \
sim:/keyexpansion_tb/TOP_KEY/key_expansion_inst/Rcon

add wave -position end  sim:/keyexpansion_tb/TOP_KEY/flag
add wave -position insertpoint -radix hex \
sim:/keyexpansion_tb/TOP_KEY/key_out

restart -f; run 1000 ns;
