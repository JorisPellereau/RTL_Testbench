#
# Description : AXI4 Testbench module Class for scenario
#
# Author  : J.P
# Date    : 13/12/2023
# Version : 1.1
#
#

import sys

class tb_axi4_cmd_class:

    # INIT of the class
    def __init__(self, scn_line_list):
        self.scn_line_list = scn_line_list
        

    # Perform an AXi4lite Write Access and wait for the end of the access
    def MASTER_AXI4LITE_WRITE(self, alias, addr, data, strobe, expc, timeout = None, timout_unity = None):
        """
        Add to the self.scn_line_list the command for the utilization of an AXI4 Lite Write Access
        Perform an AXi4lite Write Access and wait for the end of the access. This command is blocking

        :param alias: The ALIAS of the MASTER AXI4 Lite Module to use
        :param addr: The address of the AXI4 Lite access
        :param data: The DATA to write at the address
        :param strobe: The strobe value for the access
        :param expc: The result of the Access on 2 bits
        :param timeout: The value of the timeout (Default None - No Timeout)
        :param timeout_unity: The unity of the timeout

        :type alias: str
        :type addr: int
        :type data: int
        :type strobe: int
        :type expc: int
        :type timeout: int
        :type timeout_unity: str - "ms" "us" "ns" "ps"
        """

        line_to_print = ""

        if(timeout == None or timeout_unity == None):
            line_to_print = "0x{0:X} 0x{1:X} 0x{2:X} 0x{3:X}".format(addr, data, strobe, expc)

        elif(timeout != None and timeout_unity != None):
            line_to_print = "0x{0:X} 0x{1:X} 0x{2:X} 0x{3:X} {4} {5}".format(addr, data, strobe, expc, timeout, timout_unity)
        else:
            line_to_print = "Error: MASTER_AXI4LITE_WRITE - Wrong timeout and or timeout_unity values"
            
        line_to_print = "MASTER_AXI4LITE[" + alias + "] WRITE(" + line_to_print + ")"
        
        self.scn_line_list.append(line_to_print) # Add to the list the command

    # Perform an AXi4lite Read Access and wait for the end of the access
    def MASTER_AXI4LITE_READ(self, alias, addr, data, expc, timeout = None, timout_unity = None):
        """
        Add to the self.scn_line_list the command for the utilization of an AXI4 Lite Read Access
        Perform an AXi4lite Read Access and wait for the end of the access. This command is blocking

        :param alias: The ALIAS of the MASTER AXI4 Lite Module to use
        :param addr: The address of the AXI4 Lite access
        :param data: The Expected Read DATA at the address
        :param expc: The result of the Access on 2 bits
        :param timeout: The value of the timeout (Default None - No Timeout)
        :param timeout_unity: The unity of the timeout

        :type alias: str
        :type addr: int
        :type data: int
        :type expc: int
        :type timeout: int
        :type timeout_unity: str - "ms" "us" "ns" "ps"
        """

        line_to_print = ""

        if(timeout == None or timeout_unity == None):
            line_to_print = "0x{0:X} 0x{1:X} 0x{2:X}".format(addr, data, expc)

        elif(timeout != None and timeout_unity != None):
            line_to_print = "0x{0:X} 0x{1:X} 0x{2:X} {3} {4}".format(addr, data, expc, timeout, timout_unity)
        else:
            line_to_print = "Error: MASTER_AXI4LITE_READ - Wrong timeout and or timeout_unity values"
            
        line_to_print = "MASTER_AXI4LITE[" + alias + "] READ(" + line_to_print + ")"
        
        self.scn_line_list.append(line_to_print) # Add to the list the command
        

  
