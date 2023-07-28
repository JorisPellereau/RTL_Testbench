#
# Description : Class for scenario
#
# Author  : J.P
# Date    : 30/05/2022
# Version : 1.0
# Update  : 26/07/2023 : Ajout des commentaires sphinx 
#

class tb_data_checker_cmd_class:
    """
    This class contains all methods used for the utilization of the DATA CHECKER testbench module.
    """

    # INIT of the class
    def __init__(self, scn_line_list):
        """
        This the constructor of the class
        """
        self.scn_line_list = scn_line_list

    # Init File for DATA Checker
    def DATA_CHECKER_INIT(self, alias, index, file_path):
        """
        Add the the self.scn_line_list variable the command for the utilization of the INIT testbench command.

        :param alias: The ALIAS of the DATA_CHECKER module to use
        :param index: The index of the DATA_CHECKER module to use
        :param file_path: The file path and name of the file to collect data
        :type alias: str
        :type index: int
        :type file_path: str
        """
        line_to_print = "DATA_CHECKER[{0}] INIT({1}, {2})".format(alias, index, file_path)
        self.scn_line_list.append(line_to_print)

    # Close File for Data checker
    def DATA_CHECKER_CLOSE(self, alias, index):
        """
        Add the the self.scn_line_list variable the command for the utilization of the CLOSE testbench command.

        :param alias: The ALIAS of the DATA_CHECKER module to use
        :param index: The index of the DATA_CHECKER module to use
        :type alias: str
        :type index: int
        """
        line_to_print = "DATA_CHECKER[{0}] CLOSE({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)

    # Start Data checker
    def DATA_CHECKER_START(self, alias, index):
        """
        Add the the self.scn_line_list variable the command for the utilization of the START testbench command.

        :param alias: The ALIAS of the DATA_CHECKER module to use
        :param index: The index of the DATA_CHECKER module to use
        :type alias: str
        :type index: int
        """
        line_to_print = "DATA_CHECKER[{0}] START({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)

    # Stop Data checker
    def DATA_CHECKER_STOP(self, alias, index):
        """
        Add the the self.scn_line_list variable the command for the utilization of the STOP testbench command.

        :param alias: The ALIAS of the DATA_CHECKER module to use
        :param index: The index of the DATA_CHECKER module to use
        :type alias: str
        :type index: int
        """
        line_to_print = "DATA_CHECKER[{0}] STOP({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)
    
