@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.1\\bin
call %xv_path%/xelab  -wto 6104a0bc73364625952fe940f7187c0d -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot shift_reg_tb_behav xil_defaultlib.shift_reg_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
