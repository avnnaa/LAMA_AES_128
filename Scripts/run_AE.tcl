#  ________  ________  ________  ___  __    ________  ________  _______           ________  _______   ________           _________  ________  ___          
# |\   __  \|\   __  \|\   ____\|\  \|\  \ |\   __  \|\   ____\|\  ___ \         |\   __  \|\  ___ \ |\   ____\         |\___   ___\\   ____\|\  \         
# \ \  \|\  \ \  \|\  \ \  \___|\ \  \/  /|\ \  \|\  \ \  \___|\ \   __/|        \ \  \|\  \ \   __/|\ \  \___|_        \|___ \  \_\ \  \___|\ \  \        
#  \ \   ____\ \   __  \ \  \    \ \   ___  \ \   __  \ \  \  __\ \  \_|/__       \ \   __  \ \  \_|/_\ \_____  \            \ \  \ \ \  \    \ \  \       
#   \ \  \___|\ \  \ \  \ \  \____\ \  \\ \  \ \  \ \  \ \  \|\  \ \  \_|\ \       \ \  \ \  \ \  \_|\ \|____|\  \            \ \  \ \ \  \____\ \  \____  
#    \ \__\    \ \__\ \__\ \_______\ \__\\ \__\ \__\ \__\ \_______\ \_______\       \ \__\ \__\ \_______\____\_\  \            \ \__\ \ \_______\ \_______\
#     \|__|     \|__|\|__|\|_______|\|__| \|__|\|__|\|__|\|_______|\|_______|        \|__|\|__|\|_______|\_________\            \|__|  \|_______|\|_______|
#																									    \|_________|                                       
																									  
vcom -reportprogress 300 -work work ../AES_128/Sources/Package_AES.vhd 

vcom -reportprogress 300 -work work ../AES_128/Testbench/Package_AES_tb_AE.vhd 

vsim -gui work.package_aes_tb_ae

# add wave -divider Somme
# add wave -position insertpoint \
# sim:/Package_AES_tb_AE/anne_X 
# \
# sim:/Package_AES_tb_AE/anne2 \
# sim:/Package_AES_tb_AE/anne_add \
# sim:/Package_AES_tb_AE/test_anne

# add wave -divider Multiplication_par_X
# add wave -position insertpoint -radix hex\
# sim:/Package_AES_tb_AE/a_mult_X \
# sim:/Package_AES_tb_AE/mult_X_result \
# sim:/Package_AES_tb_AE/test_anne

# add wave -divider Multiplication
# add wave -position insertpoint -radix hex \
# sim:/Package_AES_tb_AE/a_mult \
# sim:/Package_AES_tb_AE/b_mult \
# sim:/Package_AES_tb_AE/mult_result \
# sim:/Package_AES_tb_AE/test_anne

# add wave -divider Inverse
# add wave -position insertpoint \
# sim:/Package_AES_tb_AE/a \
# sim:/Package_AES_tb_AE/a_inv \
# sim:/Package_AES_tb_AE/inv_ok \
# sim:/Package_AES_tb_AE/test_anne


restart -f; run 400ns;
