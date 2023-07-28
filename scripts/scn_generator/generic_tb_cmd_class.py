#
# Description : Class of GENERIC TESTBENCH COMMAND
#
# Author  : J.P
# Date    : 23/07/2023
# Version : 1.1
#
# Modifications :
#  - 23/07/2023 : Ajout des commentaires pour doc sphinx

import sys

modelsim_tcl_class_path = "/home/linux-jp/Documents/GitHub/Verilog/Testbench/scripts/scn_generator/modelsim_tcl"
sys.path.append(modelsim_tcl_class_path)
# Add TCL modelsim class
import modelsim_tcl_class


class generic_tb_cmd_class:
    """
    This class contains all the methods of generic command for the Generic Testbench
    """


    # INIT of the class
    def __init__(self, scn_line_list):#, f):
        """
        Constructor of the class generic_tb_cmd_class
        """
        self.scn_line_list = scn_line_list
        self.modelsim_tcl_class = modelsim_tcl_class.modelsim_tcl_class() # Add modelsim_tcl_class

    # Print the SET command with Data in HEXA
    # data : integer
    def SET(self, alias, data):
        """
        Append to the list self.scn_line_list the line to print with the command SET

        :param alias: Alias of the SET command
        :param data:  Data of the SET command
        :param type alias: str
        :param data: int
        """
        line_to_print = "SET[{0}] ({1})".format(alias, hex(data))# + alias + " " + hex(data) + "\n"
        self.scn_line_list.append(line_to_print) # Add Line to List

    # Print WTR commands
    # Timeout is optionnal
    def WTR(self, alias, timeout = 'none', unity = 'none'):
        """
        Append to the list self.scn_line_list the line to print with the command WTR
        If arguments timeout or unity is set to None, no timeout is applied

        :param alias: Alias of the SET command
        :param timeout: The timeout of the WTR command
        :param unity: Unity of the timeout
        :param type alias: str
        :param timeout: int
        :param unity: str - "ns" - "us" - "ms"
        """
        if(timeout == 'none' and unity == 'none'):            
            line_to_print = "WTR[{0}]".format(alias)# + alias + "\n"
            self.scn_line_list.append(line_to_print)
        else:
             line_to_print = "WTR[{0}] ({1} {2})".format(alias, str(timeout), unity)# + alias + " " + str(timeout) + " " + unity + "\n"
             self.scn_line_list.append(line_to_print)


    # Print WTF commands
    # Timeout is optionnal
    def WTF(self, alias, timeout = 'none', unity = 'none'):
        """
        Append to the list self.scn_line_list the line to print with the command WTF
        If arguments timeout or unity is set to None, no timeout is applied

        :param alias: Alias of the SET command
        :param timeout: The timeout of the WTR command
        :param unity: Unity of the timeout
        :param type alias: str
        :param timeout: int
        :param unity: str - "ns" - "us" - "ms"
        """
        if(timeout == 'none' and unity == 'none'):            
            line_to_print = "WTF[{0}]".format(alias)# + alias + "\n"
            self.scn_line_list.append(line_to_print)
        else:
             line_to_print = "WTF[{0}] ({1} {2})".format(alias, str(timeout), unity)# + alias + " " + str(timeout) + " " + unity + "\n"
             self.scn_line_list.append(line_to_print)


    # Print WTRS commands
    # Timeout is optionnal
    def WTRS(self, alias, timeout = 'none', unity = 'none'):
        """
        Append to the list self.scn_line_list the line to print with the command WTRS
        If arguments timeout or unity is set to None, no timeout is applied

        :param alias: Alias of the SET command
        :param timeout: The timeout of the WTR command
        :param unity: Unity of the timeout
        :param type alias: str
        :param timeout: int
        :param unity: str - "ns" - "us" - "ms"
        """
        if(timeout == 'none' and unity == 'none'):            
            line_to_print = "WTRS[{0}]".format(alias)# + alias + "\n"
            self.scn_line_list.append(line_to_print)
        else:
             line_to_print = "WTRS[{0}] ({1} {2})".format(alias, str(timeout), unity)# + alias + " " + str(timeout) + " " + unity + "\n"
             self.scn_line_list.append(line_to_print)


    # Print WTFS commands
    # Timeout is optionnal
    def WTFS(self, alias, timeout = 'none', unity = 'none'):
        """
        Append to the list self.scn_line_list the line to print with the command WTFS
        If arguments timeout or unity is set to None, no timeout is applied

        :param alias: Alias of the SET command
        :param timeout: The timeout of the WTR command
        :param unity: Unity of the timeout
        :param type alias: str
        :param timeout: int
        :param unity: str - "ns" - "us" - "ms"
        """
        if(timeout == 'none' and unity == 'none'):            
            line_to_print = "WTFS[{0}]".format(alias)# + alias + "\n"
            self.scn_line_list.append(line_to_print)
        else:
             line_to_print = "WTFS[{0}] ({1} {2})".format(alias, str(timeout), unity)# + alias + " " + str(timeout) + " " + unity + "\n"
             self.scn_line_list.append(line_to_print)

    # Print CHK Commands
    # data : int
    # test : "OK" or "ERROR"
    def CHK(self, alias, data, test):
        """
        Append to the list self.scn_line_list the line to print with the command CHK

        :param alias: Alias of the CHK command
        :param data: Expected data to check
        :param test: Expected test
        :param type alias: str
        :param data: int
        :param test: str - "OK" - "ERROR"
        """
        line_to_print = "CHK[{0}] ({1} {2})".format(alias, hex(data), test)# + "] (" + hex(data) + " " + test + ")\n"
        self.scn_line_list.append(line_to_print)
        
    # Print WAIT commands
    # duree : int
    # unity : "ps", "ns", "us", "ms"
    def WAIT(self, duree, unity):
        """
        Append to the list self.scn_line_list the line to print with the command WAIT

        :param duree: Duration of the Wait
        :param unity: Unity of the wait duration
        :param type alias: str
        :param unity: str : "ps" - "ns" - "us" - "ms"
        """
        line_to_print = "WAIT[] ({0} {1})".format(str(duree), unity)# + str(duree) + " " + unity + "\n"
        self.scn_line_list.append(line_to_print)

    # Print Modelsim Command
    def MODELSIM_CMD(self, modelsim_cmd):
        """
        Append to the list self.scn_line_list the line to print. It contains a Modelsim Command

        :param modelsim_cmd: The entire modelsim command to print
        :type modelsim_cmd: str
        """
        line_to_print = "MODELSIM_CMD[] (\"{0}\")".format(modelsim_cmd)# + " (\"" + modelsim_cmd + "\")" + "\n"
        self.scn_line_list.append(line_to_print)

    # Save Memory in a file from modelsim command
    def SAVE_MEMORY(self, memory_path, memory_file):
        """
        Append to the list self.scn_line_list the line to print. It contains a Modelsim Command for a memory save

        :param memory_path: The RTL path of the Memory to Save
        :param memory_file: The memory file
        :type memory_path: str
        :type memory_file: str
        """
        modelsim_cmd = "mem save -o " + memory_file + " -f mti -noaddress -compress -data hex -addr hex -wordsperline 1 " + memory_path
        self.MODELSIM_CMD(modelsim_cmd)
        

    # Check a signal Value in modelsim environment
    # signal_path : str - path of signal to checl
    # value_to_check : int - value to check
    def CHECK_SIGNAL_VALUE(self, signal_path, value_to_check):
        """
        Append to the list self.scn_line_list the line to print. It contains a Modelsim Command use in order to check a signal from TCL

        :param signal_path: The RTL signal path to check
        :param value_to_check: The expected value of the signal
        :type signal_path: str
        :type value_to_check: int
        """
        
        # internal variables
        var_name       = "signal_to_check"
        value_to_check = str(value_to_check) # Cast it to string

        self.scn_line_list.append("//-- Check if : {0} == {1}".format(signal_path, value_to_check))
                
        # Set variable in modelsim
        set_var_cmd_str = self.modelsim_tcl_class.tcl_set_signal_2_var(var_name    = var_name,
                                                                       signal_path = signal_path)
        self.MODELSIM_CMD(set_var_cmd_str)

        # Check variable/signal in modelsim
        test_signal_value_cmd_str = self.modelsim_tcl_class.tcl_test_signal_value(var_name   = var_name,
                                                                                  test_value = value_to_check)
        self.MODELSIM_CMD(test_signal_value_cmd_str)




    # Check a memory content in modelsim environment
    # memory_rtl_path : str - path of memory to check
    # memory_to_check : list - a list with memory content - HEX FORMAT
    # digit_number : int - number of digit in memory data
    def CHECK_MEMORY(self, memory_rtl_path, memory_to_check, digit_number):
        """
        Append to the list self.scn_line_list the line to print. It contains a Modelsim Command use to check a memory content

        :param memory_rtl_path: The RTL memory path
        :param memoty_to_check: The content of the memory to check
        :param digit_number: Number of digit in memory data
        :type memory_rtl_path: str
        :type memoty_to_check: list[int]
        :type digit_number: int
        """
        # internal variables
        var_name       = "memory_to_check"

        # Convert memory_to_check to a string for TCL check
        memory_to_check_str = "\"{"
        for i in range(0, len(memory_to_check)):

            # Add Space str only on data between range memory
            if(i == 0 or i == len(memory_to_check)):
                space_str = ""
            else:
                space_str = " "
                
            if(type(memory_to_check[i]) == int):
                str_tmp = "{{{0:0" + str(digit_number) + "X" + "}}}"
                memory_to_check_str = memory_to_check_str + space_str + str_tmp.format(memory_to_check[i])
            elif(type(memory_to_check[i]) == str):
                memory_to_check_str = memory_to_check_str + space_str + "{" + "X"*digit_number + "}"
        memory_to_check_str = memory_to_check_str + "}\""
        
        self.scn_line_list.append("//-- Check memory content of {0} == {1}".format(memory_rtl_path, memory_to_check_str))
                
        # Set variable in modelsim (memory to check)
        set_var_cmd_str = self.modelsim_tcl_class.tcl_set_signal_2_var(var_name    = var_name,
                                                                       signal_path = memory_rtl_path)
        self.MODELSIM_CMD(set_var_cmd_str)

        # Set variable in modelsim (reference value)
        memory_ref = "memory_ref"
        set_var_cmd_str = self.modelsim_tcl_class.tcl_set_value_2_var(var_name = memory_ref,
                                                                      value    = memory_to_check_str)
        self.MODELSIM_CMD(set_var_cmd_str)
        
        # Check variable/signal in modelsim with an other variable
        test_signal_value_cmd_str = self.modelsim_tcl_class.tcl_test_signal_value(var_name      = var_name,
                                                                                  test_value    = memory_ref,
                                                                                  test_variable = True)
        self.MODELSIM_CMD(test_signal_value_cmd_str)
