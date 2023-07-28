#
# Description : AXI4 Testbench module Class for scenario
#
# Author  : J.P
# Date    : 20/05/2023
# Version : 1.0
#
#

import sys

# Axi4Lite Manager Configuration from OSVVM
# 0 : WRITE_ADDRESS_VALID_DELAY_CYCLES    - Value type : integer
# 1 : WRITE_DATA_VALID_DELAY_CYCLES       - Value type : integer
# 2 : WRITE_DATA_VALID_BURST_DELAY_CYCLES - Value type : integer
# 3 : READ_ADDRESS_VALID_DELAY_CYCLES     - Value type : integer
# 4 : WRITE_RESPONSE_READY_BEFORE_VALID   - Value type : boolean
# 5 : READ_DATA_READY_BEFORE_VALID        - Value type : boolean
# 6 : WRITE_RESPONSE_READY_DELAY_CYCLES   - Value type : integer
# 7 : READ_DATA_READY_DELAY_CYCLES        - Value type : integer
# 8 : WRITE_ADDRESS_READY_TIME_OUT        - Value type : integer
# 9 : WRITE_DATA_READY_TIME_OUT           - Value type : integer
# 10 : READ_ADDRESS_READY_TIME_OUT        - Value type : integer
# 11 : WRITE_RESPONSE_VALID_TIME_OUT      - Value type : integer
# 12 : READ_DATA_VALID_TIME_OUT           - Value type : integer

class tb_axi4_cmd_class:

    # INIT of the class
    def __init__(self, scn_line_list):
        self.scn_line_list = scn_line_list

        # Dict Configuration init
        self.config_dict = dict()
        self.config_dict["WRITE_ADDRESS_VALID_DELAY_CYCLES"]    = 0
        self.config_dict["WRITE_DATA_VALID_DELAY_CYCLES"]       = 0
        self.config_dict["WRITE_DATA_VALID_BURST_DELAY_CYCLES"] = 0
        self.config_dict["READ_ADDRESS_VALID_DELAY_CYCLES"]     = 0
        self.config_dict["WRITE_RESPONSE_READY_BEFORE_VALID"]   = False
        self.config_dict["READ_DATA_READY_BEFORE_VALID"]        = False
        self.config_dict["WRITE_RESPONSE_READY_DELAY_CYCLES"]   = 0
        self.config_dict["READ_DATA_READY_DELAY_CYCLES"]        = 0
        self.config_dict["WRITE_ADDRESS_READY_TIME_OUT"]        = 25
        self.config_dict["WRITE_DATA_READY_TIME_OUT"]           = 25
        self.config_dict["READ_ADDRESS_READY_TIME_OUT"]         = 25
        self.config_dict["WRITE_RESPONSE_VALID_TIME_OUT"]       = 25
        self.config_dict["READ_DATA_VALID_TIME_OUT"]            = 25


    # CONFIG
    # alias : Alias of AXI4 Master module - A string
    # data_list : a list of parameter for MASTER AXI4 Lite
    def MASTER_AXI4LITE_CONFIG(self, alias, config_dict):
        line_to_print = ""
        for i in config_dict.keys():
            line_to_print = line_to_print + i + " " + str(config_dict[i])
            line_to_print = "MASTER_AXI4LITE[" + alias + "] CONFIG(" + line_to_print + str(data_list[len(data_list) - 1]) + ")"
            self.scn_line_list.append(line_to_print)


    # UART RX_READ
    # alias : Alias of UART module - A string
    # data_list : a list of Hex data to read from UART
    # def RX_READ(self, alias, data_list):
    #     line_to_print = ""
    #     for i in range(0, len(data_list) - 1):
    #         line_to_print = line_to_print + str(data_list[i]) + " "
        
    #     line_to_print = "UART[" + alias + "] RX_READ(" + line_to_print + str(data_list[len(data_list) - 1]) + ")"
    #     self.scn_line_list.append(line_to_print)


    # UART RX_WAIT_DATA
    # alias : Alias of UART module - A string
    # data list : a list of Hex data to read from UART
    # def RX_WAIT_DATA(self, alias, data_list):
    #     line_to_print = ""
    #     for i in range(0, len(data_list) - 1):
    #         line_to_print = line_to_print + str(data_list[i]) + " "
            
    #     line_to_print = "UART[" + alias + "] RX_WAIT_DATA(" + line_to_print + str(data_list[len(data_list) - 1]) + ")"
    #     self.scn_line_list.append(line_to_print)
