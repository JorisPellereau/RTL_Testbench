#
# Description : Class for scenario
#
# Author  : J.P
# Date    : 28/11/2021
# Version : 1.0
# Update  : 26/07/2023 : Ajout des commentaires pour sphinx
#

class tb_data_collector_cmd_class:
    """
    This class contains all methods used for the utilization of the DATA_COLLECTOR testbench module.
    """

    # INIT of the class
    def __init__(self, scn_line_list):
        """
        This is the constructor of the class
        """
        self.scn_line_list = scn_line_list

    # Init File for DATA Collector
    def DATA_COLLECTOR_INIT(self, alias, index, file_path):
        """
        Add the the self.scn_line_list variable the command for the utilization of the INIT testbench command.

        :param alias: The ALIAS of the DATA_COLLECTOR module to use
        :param index: The index of the DATA_COLELCTOR module to use
        :param file_path: The file path and name of the file to collect data
        :type alias: str
        :type index: int
        :type file_path: str
        """
        line_to_print = "DATA_COLLECTOR[{0}] INIT({1}, {2})".format(alias, index, file_path)
        self.scn_line_list.append(line_to_print)

    # Close File for Data collector
    def DATA_COLLECTOR_CLOSE(self, alias, index):
        """
        Add the the self.scn_line_list variable the command for the utilization of the CLOSE testbench command.

        :param alias: The ALIAS of the DATA_COLLECTOR module to use
        :param index: The index of the DATA_COLELCTOR module to use
        :type alias: str
        :type index: int
        """
        line_to_print = "DATA_COLLECTOR[{0}] CLOSE({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)

    # Start Data colector
    def DATA_COLLECTOR_START(self, alias, index):
        """
        Add the the self.scn_line_list variable the command for the utilization of the START testbench command.

        :param alias: The ALIAS of the DATA_COLLECTOR module to use
        :param index: The index of the DATA_COLELCTOR module to use
        :type alias: str
        :type index: int
        """
        line_to_print = "DATA_COLLECTOR[{0}] START({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)

    # Stop Data collector
    def DATA_COLLECTOR_STOP(self, alias, index):
        """
        Add the the self.scn_line_list variable the command for the utilization of the STOP testbench command.

        :param alias: The ALIAS of the DATA_COLLECTOR module to use
        :param index: The index of the DATA_COLELCTOR module to use
        :type alias: str
        :type index: int
        """
        line_to_print = "DATA_COLLECTOR[{0}] STOP({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)
    
