#
# Description : I2C Testbench module Class for scenario
#
# Author  : J.P
# Date    : 02/02/2024
# Version : 1.0
#
# Modifications :
#                 

class tb_i2c_cmd_class:
    """
    This class contains all methods used for the utilization of the I2C MASTER/SLAVE testbench module.
    """

    # INIT of the class
    def __init__(self, scn_line_list):
        """
        Constructor of the class
        """
        self.scn_line_list = scn_line_list


    # I2C SLAVE SET Addr
    def I2C_SLAVE_SET_ADDR(self, alias, addr):
        """
        Add the the self.scn_line_list variable the command for the utilization of the I2C_SLAVE SET_ADDR testbench command.

        :param alias: The ALIAS of the I2C Slave module to use
        :param addr: The ADDR of the SLAVE I2C
        :type alias: str
        :type addr: int on 7 bits
        """

        line_to_print = "I2C_SLAVE[" + alias + "] SET_ADDR({0})".format(addr)
        self.scn_line_list.append(line_to_print)


    # I2C SLAVE LOAD_TX_DATA
    def I2C_SLAVE_LOAD_TX_DATA(self, alias, data):
        """
        Add the the self.scn_line_list variable the command for the utilization of the I2C_SLAVE LOAD_TX_DATA testbench command.

        :param alias: The ALIAS of the I2C Slave module to use
        :param data: the data or the the list of data to load in the I2C SLAVE TX MEMORY
        :type alias: str
        :type data: int or list[int]
        """
        line_to_print = ""

        if(type(data) == list):
            for i in range(0, len(data) - 1):
                line_to_print = line_to_print + str(data[i]) + " "
            line_to_print = line_to_print + str(data[len(data) - 1])
        elif(type(data) == int):
            line_to_print = str(data)
        
        line_to_print = "I2C_SLAVE[" + alias + "] LOAD_TX_DATA(" + line_to_print + ")"
        self.scn_line_list.append(line_to_print)


    # I2C SLACE CHECK_RX_DATA
    def I2C_SLAVE_CHECK_RX_MEMORY(self, alias, data):
        """
        Add the the self.scn_line_list variable the command for the utilization of the I2C_SLAVE CHECK_RX_DATA testbench command.

        :param alias: The ALIAS of the I2C Slave module to use
        :param data: the data or the the list of data to check  in the I2C SLAVE RX MEMORY
        :type alias: str
        :type data: int or list[int]
        """
        line_to_print = ""

        if(type(data) == list):
            for i in range(0, len(data) - 1):
                line_to_print = line_to_print + str(data[i]) + " "
                line_to_print = line_to_print + str(data_list[len(data_list) - 1])
        elif(type(data) == int):
            line_to_print = str(data)
        
        line_to_print = "I2C_SLAVE[" + alias + "] CHECK_RX_DATA(" + line_to_print + ")"
        self.scn_line_list.append(line_to_print)
