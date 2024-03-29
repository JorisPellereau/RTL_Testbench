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

modelsim_tcl_class_path = "/home/linux-jp/Documents/GitHub/RTL_Testbench/scripts/scn_generator/modelsim_tcl"
#"/home/linux-jp/Documents/GitHub/Verilog/Testbench/scripts/scn_generator/modelsim_tcl"
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
        :type alias: str
        :type data: int
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
        :type alias: str
        :type timeout: int
        :type unity: str - "ns" - "us" - "ms"
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
        :type alias: str
        :type timeout: int
        :type unity: str - "ns" - "us" - "ms"
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
        :type alias: str
        :type timeout: int
        :type unity: str - "ns" - "us" - "ms"
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
        :type alias: str
        :type timeout: int
        :type unity: str - "ns" - "us" - "ms"
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
        :type alias: str
        :type data: int
        :type test: str - "OK" - "ERROR"
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
        :type alias: str
        :type unity: str : "ps" - "ns" - "us" - "ms"
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

    # Load a Memory
    def LOAD_MEMORY(self, memory_rtl_path, mem_file):
        """
        :param memory_rtl_path: RTL Path of the Memory to load
        :param mem_file: The Memory file with path to load

        :type memory_rtl_path: str
        :type mem_file: str
        """

        self.MODELSIM_CMD("mem load -i {0} {1}".format(mem_file, memory_rtl_path))



    # Create a Modelsim Memory in hex format (mti) and 1 wordsperline
    def CREATE_MODELSIM_MEMORY(self, mem_file, data_list, rtl_mem_path, mem_data_width = 32, mem_depth = 256, default_data = 0):
        """
        :type data_list: list[list[int, string]]
        """

        mem_str_list = []
        max_addr_len = len(hex(mem_depth - 1)[2:]) # Get the string length ot the last addr

        mem_header_str = """// memory data file (do not edit the following line - required for mem load use)
// instance={0}
// format=mti addressradix=h dataradix=h version=1.0 wordsperline=1""".format(rtl_mem_path)
        mem_data = [hex(default_data)[2:]]*mem_depth

        # Update the mem_data in function of the data_list
        for i in data_list:
            mem_data[i[0]] = i[1]


        mem_str_list.append(mem_header_str)
        for i in range(0, mem_depth - 1):
         
            # Check if the addr in string format have the maximal length
            mem_str_list.append(" "*(max_addr_len - len(hex(i)[2:])) + hex(i)[2:] + ": " + mem_data[i])
       

        mem_final_str = "\n".join(mem_str_list)
        # Create the file
        with open(mem_file, "w") as file_w:
            file_w.writelines(mem_final_str)


    # Load data on a bus. Drive a valid signal and a bus data. One data per clock period
    def LOAD_BUS(self, alias_val, alias_data, alias_clk, data_list, timeout = 'none',unity = 'none'):
        """
        Append to the list self.scn_line_list the lines that permits to load data onto a bus.
        A valid signal is set to '1' for the 

        :param alias_val:  Alias of the VALID signal to control
        :param alias_data: Alias of the DATA signal to control
        :param alias_clk:  Alias of the CLK signal to use for the synchronization
        :param data_list:  Data list to set on the bus
        :param timeout:    Timeout value of the WTFS command
        :param unity:      Unity of the timeout
        :type alias_val:   str
        :type alias_data:  str
        :type alias_clk:   str
        :type data_list:   list[int]
        :type timeout:     int
        :type unity:       str
        """

        # Check if the type is a list
        if(type(data_list) == list):
            
            for i in range(0, len(data_list)):
                # Wait for a falling edge of the synchronization clock
                self.WTFS(alias   = alias_clk,
                          timeout = timeout,
                          unity   = unity)

                # Set the data on the bus
                self.SET(alias = alias_data,
                         data  = data_list[i])

                # Set the valid of the bus to '1'
                self.SET(alias = alias_val,
                         data  = 1)

            # Wait for a falling edge of the synchronization clock
            self.WTFS(alias   = alias_clk,
                      timeout = timeout,
                      unity   = unity)

            # Set 0 on the bus
            self.SET(alias = alias_data,
                     data  = 0)

            # Set the valid of the bus to '0'
            self.SET(alias = alias_val,
                     data  = 0)
      
        else:
            raise NameError("LOAD_BUS - type(data_list) /= list")
        
