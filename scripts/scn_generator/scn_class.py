#
# Description : Class for scenario
#
# Author  : J.P
# Date    : 01/03/2021
# Version : 1.0
# Update : - 24/04/2021 - Add UART Testbench class
#          - 27/11/2021 - Modif. class in order to inherites from Commands class
#          - 26/04/2023 - Add commentary for sphinx documentation
#          - 13/12/2023 - Add tb_axi4_cmd_class

import sys
import os
import inspect

# Import Class
import generic_tb_cmd_class
import tb_uart_cmd_class
import tb_data_collector_cmd_class
import tb_data_checker_cmd_class
import tb_axi4_cmd_class

# Extends of generic_tb_cmd_class
class scn_class(generic_tb_cmd_class.generic_tb_cmd_class,
                tb_uart_cmd_class.tb_uart_cmd_class,
                tb_data_collector_cmd_class.tb_data_collector_cmd_class,
                tb_data_checker_cmd_class.tb_data_checker_cmd_class,
                tb_axi4_cmd_class.tb_axi4_cmd_class
                ):

    """
    This class is the top level class for the utilisation of the testbench module commands.
    """
    
    # INIT of the class
    def __init__(self):

        """
        Constructor of the class. It initializes variables for the scenario.
        """
        # INIT Variables
        self.END_TEST_counter          = 0                           # Counter of END_TEST in file        
        self.scn_line_list             = []                          # List of line to write in file
        self.absolute_path_from_caller = inspect.stack()[1].filename # Absolute file path from Caller
        self.out_file                  = os.path.splitext(os.path.basename(self.absolute_path_from_caller))[0] + ".txt" # Create txt file
        self.step_counter              = 0 # Step Counter Init - First sTEP start at 1
        self.sub_step_counter          = 0 # Sub Step Counter
        super().__init__(self.scn_line_list) # Init Class
        
        

    # Print a Custom Line in SCN
    def print_line(self, line_2_print):
        """
        Add a line in the self.scn_line_list variable

        :param line_2_print: The line to add in the scenario file
        :type line_2_print: str
        """
        self.scn_line_list.append(line_2_print)


    # Print a Comment Line in SCN
    def print_comment(self, line_2_print):
        """
        Add a comment line in the self.scn_line_list variable

        :param line_2_print: The comment line to add in the scenario file
        :type line_2_print: str
        """
        self.scn_line_list.append("//-- " + line_2_print)


    def print_line_break(self, line_break_nb):
        """
        Display in the transcript an emplty line. 
        """
        for i in range(0, line_break_nb):
            self.scn_line_list.append("\n")


    # Print Step
    def print_step(self, line_2_print):
        """
        Add a STEP number in commentary format in the self.scn_line_list variable

        :param line_2_print: The STEP to add in the commentary
        :type line_2_print: str
        """
        self.step_counter += 1 # Inc Step Counter
        self.sub_step_counter = 0 # Reset the sub step counter
        self.scn_line_list.append("\n//================================")
        self.scn_line_list.append("//-- STEP {0} : ".format(self.step_counter) + line_2_print)
        self.scn_line_list.append("//================================\n")
        


    # Print SUB Step
    def print_sub_step(self, line_2_print):
        """
        Add a SUB STEP number in commentary format in the self.scn_line_list variable

        :param line_2_print: The SUB STEP to add in the commentary
        :type line_2_print: str
        """
        self.scn_line_list.append("\n//--------------------------------")
        self.scn_line_list.append("//-- STEP {0}.{1} : ".format(self.step_counter, self.sub_step_counter) + line_2_print)
        self.scn_line_list.append("//--------------------------------\n")
        self.sub_step_counter += 1 # Inc Sub Step Counter

        
    # Close PY SCN file and print END_TEST
    def END_TEST(self):
        """
        Add the END_TEST command in the self.scn_line_list variable. Finaly Closed the scenario file.
        """
        # Add End test to list
        line_to_print = "END_TEST\n"
        self.scn_line_list.append(line_to_print)

        output_str = "\n".join(self.scn_line_list) # Add \n between element of the list
        
        if(self.END_TEST_counter == 0):                               
            f = open(self.out_file, "w") # Open file as Write for 1st time
        else:
            f = open(self.out_file, "a") # Open file in append mode of a new END_TEST is detected
            
        f.write(output_str)        # Write to file
        f.close()                  # Close file
        self.END_TEST_counter += 1 # Inc Counter of END_TEST
        self.scn_line_list = []    # Flush list because it is write in file
