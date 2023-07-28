#
# Description : UART Testbench module Class for scenario
#
# Author  : J.P
# Date    : 24/04/2021
# Version : 1.0
#
# Modifications :
#                 - 26/07/2023 : Ajout des commentaires sphinx

import sys

class tb_uart_cmd_class:
    """
    This class contains all methods used for the utilization of the UART testbench module.
    """

    # INIT of the class
    def __init__(self, scn_line_list):#output_file_path, f):
        """
        Constructor of the class
        """
        self.scn_line_list = scn_line_list


    # UART TX START
    # alias : Alias of UART module - A string
    # data_list : a list of Hex data to write via UART
    def TX_START(self, alias, data_list):
        """
        Add the the self.scn_line_list variable the command for the utilization of the TX_START testbench command.

        :param alias: The ALIAS of the UART module to use
        :param data_list: the list of data to send on the UART module
        :type alias: str
        :type data_list: list[int]
        """
        line_to_print = ""
        for i in range(0, len(data_list) - 1):
            line_to_print = line_to_print + str(data_list[i]) + " "

        line_to_print = "UART[" + alias + "] TX_START(" + line_to_print + str(data_list[len(data_list) - 1]) + ")"
        self.scn_line_list.append(line_to_print)


    # UART RX_READ
    # alias : Alias of UART module - A string
    # data_list : a list of Hex data to read from UART
    def RX_READ(self, alias, data_list):
        """
        Add the the self.scn_line_list variable the command for the utilization of the RX_READ testbench command.

        :param alias: The ALIAS of the UART module to use
        :param data_list: the list of data to READ on the UART module
        :type alias: str
        :type data_list: list[int]
        """
        line_to_print = ""
        for i in range(0, len(data_list) - 1):
            line_to_print = line_to_print + str(data_list[i]) + " "
        
        line_to_print = "UART[" + alias + "] RX_READ(" + line_to_print + str(data_list[len(data_list) - 1]) + ")"
        self.scn_line_list.append(line_to_print)


    # UART RX_WAIT_DATA
    # alias : Alias of UART module - A string
    # data list : a list of Hex data to read from UART
    def RX_WAIT_DATA(self, alias, data_list):
        """
        Add the the self.scn_line_list variable the command for the utilization of the RX_WAIT_DATA testbench command.

        :param alias: The ALIAS of the UART module to use
        :param data_list: the list of data to check after each wait on the RX interface of the AURT module.
        :type alias: str
        :type data_list: list[int]
        """
        line_to_print = ""
        for i in range(0, len(data_list) - 1):
            line_to_print = line_to_print + str(data_list[i]) + " "
            
        line_to_print = "UART[" + alias + "] RX_WAIT_DATA(" + line_to_print + str(data_list[len(data_list) - 1]) + ")"
        self.scn_line_list.append(line_to_print)
