import os
import sys
from PySide2 import QtCore, QtGui, QtWidgets
import numpy as np

from datetime import *

import testbench_files


class testbench_creator_class(QtWidgets.QDialog):


   


    def __init__(self, parent = None):
        QtWidgets.QDialog.__init__(self,parent)

        self.grid_layout = QtWidgets.QGridLayout()
        self.setLayout(self.grid_layout)

        self.generic_module_info_list = []

        # STR file constants
        self.tb_str_cst = testbench_files

        # File Name constants
        self.testbench_filename         = "tb_top.sv"
        self.testbench_setup_filename   = "testbench_setup.sv"
        self.testbench_clk_gen_filename = "clk_gen.sv"

        
        # == INIT PARAM ==
        self.set_injector_param_list = [["Alias Number : ", "1"],
                                        ["SET INJECTOR WIDTH : ", "32"]]

        self.set_injector_param_list_qt = self.tb_custom_module_parameters(self.set_injector_param_list)

        self.check_level_param_list = [["Alias Number : ", "1"],
                                       ["Check Level Width", "1"]]

        self.check_level_param_list_qt = self.tb_custom_module_parameters(self.check_level_param_list)
        
        self.wait_event_param_list    = [["Alias Number : ", "1"]] # Always size to 1
        self.wait_event_param_list_qt = self.tb_custom_module_parameters(self.wait_event_param_list)

        
        self.last_init_param = None
        self.data_collector_param_list = [["Alias : "                           , "DATA_COLLECTOR_COVERAGE"],
                                          ["Number of parallel collector :"     , "1"],
                                          ["Data Width : "                      , "32"]]
        
        self.data_collector_param_list_qt = self.tb_custom_module_parameters(self.data_collector_param_list)

        self.data_checker_param_list = [["Alias : "                      , "DATA_CHECKER_CRC"],
                                        ["Number parallel checker : "    , "1"],
                                        ["DATA_CHECKER Data Width : "    , "32"]]
        
        self.data_checker_param_list_qt = self.tb_custom_module_parameters(self.data_checker_param_list)

        
        self.uart_param_list = [["Alias : "                     , "UART_XX"],
                                ["Number of parallel UART :"    , "1"],
                                ["Data Width (7-8-9) : "        , "8"],
                                ["Buffer Addr Width : "         , "8"],
                                ["STOP Bit Number (1 or 2) : "  , "1"],
                                ["POLARITY ('0' or '1') : "     , "'1'"],
                                ["PARITY (None - Even - Odd): " , "None"],
                                ["BAUDRATE (bauds): "           , "9600"] ,
                                ["STOP Bit Number : "           , "1"],
                                ["FIRST Bit (LSB or MSB) : "    , "LSB"],
                                ["CLOCK FREQUENCY (Hz) : "      , "20000000"]]

        self.uart_param_list_qt = self.tb_custom_module_parameters(self.uart_param_list)

        self.custom_tb_module_parameters_position = 3
        
        # == TITLE ==
        self.title = QtWidgets.QLabel("TESTBENCH CREATOR")
        
        # == PATH of Generated Testbench ==
        self.tb_path_text    = QtWidgets.QLabel("Path of generated Testbench :")
        init_path = os.path.dirname(os.path.abspath(__file__)) # Get path where script is executed
        self.tb_path_to_edit = QtWidgets.QLineEdit(init_path)#"./tb_sources/XXX")

        # == CLOCK GENERATOR PARAMETERS ==
        self.clk_gen_label_qt = QtWidgets.QLabel("Clock & Reset Generator PARAMETERS :")
        self.clk_gen_param_list = [["Clock Half Period [ps] : "            , "10000"],
                                   ["Waiting time before reset [ps] :"     , "100000"]]
        
        self.clk_gen_param_list_qt = self.tb_custom_module_parameters(self.clk_gen_param_list)
        
        # == GENERIC TESTBENCH MODULES ==
        self.generic_tb_module_label_qt = QtWidgets.QLabel("GENERIC TESTBENCH Modules :")
        self.generic_tb_module_list     = ["SET INJECTOR", "CHECK LEVEL", "WAIT EVENT"]
        self.generic_tb_modules_list_qt = QtWidgets.QListWidget()
        self.generic_tb_modules_list_qt.addItems(self.generic_tb_module_list)

        
        # == Selection of Custom Testbench Modules ==
        self.custom_tb_modules_label_qt = QtWidgets.QLabel("CUSTOM TESTBENCH Modules :")
        self.custom_tb_modules_list = QtWidgets.QListWidget()
        
        self.item_list = ["DATA_COLLECTOR",
                          "DATA_CHECKER",
                          "UART"]
        self.custom_tb_modules_list.addItems(self.item_list) # Custom TB Module List

        # == ADD Select Custom Testbench Modules ==
        self.button_add_select_custom_tb_modules = QtWidgets.QPushButton("ADD Custom Testbench Module")
        self.button_del_sel_custom_tb_modules    = QtWidgets.QPushButton("DELETE Custom Testbench Module")

        # == Testbench Info List ==
        self.tb_info_list_qt = QtWidgets.QListWidget()
        self.custom_tb_info_list = []
        
        # == GENERATE BUTTON ==
        self.button_generer_tb = QtWidgets.QPushButton("Generate Testbench")

        # Init Grid
        self.init_grid_layout()
        
        # Update Click
        self.click_update()



        
    def init_grid_layout(self):
        self.grid_layout.addWidget(self.title,             0, 0)
        
        self.grid_layout.addWidget(self.tb_path_text,      1, 0)
        self.grid_layout.addWidget(self.tb_path_to_edit,   1, 1)

        self.grid_layout.addWidget(self.clk_gen_label_qt, 2, 0)
        self.add_to_grid_layout(self.clk_gen_param_list_qt)

        self.grid_layout.addWidget(self.generic_tb_module_label_qt, self.grid_layout.rowCount(), 0)
        self.grid_layout.addWidget(self.custom_tb_modules_label_qt, self.grid_layout.rowCount()-1, 1)
                
        self.grid_layout.addWidget(self.generic_tb_modules_list_qt, self.grid_layout.rowCount(), 0)
        self.grid_layout.addWidget(self.custom_tb_modules_list,  self.grid_layout.rowCount()-1, 1)

        # == Custom TB Modules display on several lines ==

        # Custom
        self.add_to_grid_layout(qt_param_list = self.data_collector_param_list_qt)
        self.add_to_grid_layout(qt_param_list = self.data_checker_param_list_qt)
        self.add_to_grid_layout(qt_param_list = self.uart_param_list_qt)
                                
        # Generic
        self.add_to_grid_layout(qt_param_list = self.set_injector_param_list_qt)
        self.add_to_grid_layout(qt_param_list = self.check_level_param_list_qt)
        self.add_to_grid_layout(qt_param_list = self.wait_event_param_list_qt)
        
        self.grid_layout.addWidget(self.button_add_select_custom_tb_modules, self.grid_layout.rowCount(), 0)

        self.grid_layout.addWidget(self.tb_info_list_qt,           self.grid_layout.rowCount(), 0)
        self.grid_layout.addWidget(self.button_del_sel_custom_tb_modules, self.grid_layout.rowCount(), 0)
        self.grid_layout.addWidget(self.button_generer_tb,      self.grid_layout.rowCount(), 0)

        self.hide_all_module_param()
        #        self.button_generer_tb.hide()
        #self.grid_layout.addWidget(self.button_add_select_custom_tb_modules,      10, 0)
#        self.grid_layout.replaceWidget(self.button_generer_tb, self.button_add_select_custom_tb_modules)

    def add_to_grid_layout(self, qt_param_list):

        # Update for the 1st time        
        for i in range(0, len(qt_param_list)):
            nb_row = self.grid_layout.rowCount()
            self.grid_layout.addWidget(qt_param_list[i][0], nb_row, 0)
            self.grid_layout.addWidget(qt_param_list[i][1], nb_row, 1)

       
            
    
    def print_debug(self):
        print("DEBUG !!!")


    
    def click_update(self):

        # == GENEARTION of TESTBENCH ==
        self.button_generer_tb.clicked.connect(self.generate_testbench)

        # == GENERIC ITEM LIST CLICK ==
        self.generic_tb_modules_list_qt.itemClicked.connect(self.list_click_generic_mngt)

        
        # == CUSTOM ITEM LIST CLICK ==
        self.custom_tb_modules_list.itemClicked.connect(self.list_click_custom_mngt)

        # == ADD Custom TB Module Mngt ==
        self.button_add_select_custom_tb_modules.clicked.connect(self.add_sel_module_to_tb_info_list)

        # == REMOVE Custom TB Module Mngt ==
        self.button_del_sel_custom_tb_modules.clicked.connect(self.remove_info_to_list)
        
    # == FUNCTION on CLICK ==

    def add_sel_module_to_tb_info_list(self):

        # Get info of selected TB Module 

        if(self.custom_tb_modules_list.currentRow() == 0):
       
            print("Data collector Added !")

            info_tmp = self.get_custom_module_info(qt_param_list = self.data_collector_param_list_qt) # Get Info
            
            self.add_info_to_list(info_tmp, module_type = "DATA_COLLECTOR")
            
        elif(self.custom_tb_modules_list.currentRow() == 1):
            info_tmp = self.get_custom_module_info(qt_param_list = self.data_checker_param_list_qt) # Get Info
            
            self.add_info_to_list(info_tmp, module_type = "DATA_CHECKER")
            print("DAta checker Added !")
        elif(self.custom_tb_modules_list.currentRow() == 2):
            print("UART added !")
            info_tmp = self.get_custom_module_info(qt_param_list = self.uart_param_list_qt) # Get Info
            
            self.add_info_to_list(info_tmp, module_type = "UART")
            
    def generate_testbench(self):

        expected_path     = self.tb_path_to_edit.text()
        list_file_in_path = os.listdir(expected_path)

        file_setup_str = ""
        self.get_generic_module_info() # Get info of Generic TB Modules
        #print(self.generic_module_info_list)
        print(self.custom_tb_info_list)

        # == Fill Testbench Setup File ==
        # Fill Generics
        file_setup_str = self.tb_str_cst.testbench_setup_generic_str.format(self.generic_module_info_list[0][0][1],
                                                                            self.generic_module_info_list[0][1][1],
                                                                            "1000",

                                                                            self.generic_module_info_list[1][0][1],
                                                                            self.generic_module_info_list[1][0][1],
                                                                            self.generic_module_info_list[1][1][1],

                                                                            self.generic_module_info_list[3][0][1], 1,

                                                                            self.generic_module_info_list[2][0][1],
                                                                            self.generic_module_info_list[2][0][1],
                                                                            self.generic_module_info_list[2][1][1])
        
        # Fill with custom
        for i in self.custom_tb_info_list:
            print(i)
            if(i[len(i) - 1] == "DATA_COLLECTOR"):
                print("Add Data Collector to Constant..")
                file_setup_str = file_setup_str + self.tb_str_cst.data_collector_str.format(i[0][1],
                                                                                            i[0][1],
                                                                                            i[1][1],
                                                                                            i[0][1],
                                                                                            i[2][1],
                )
                
            elif(i[len(i) - 1] == "DATA_CHECKER"):
                print("Add Data checker to Constant ..")
                file_setup_str = file_setup_str + self.tb_str_cst.data_checker_str.format(i[0][1],
                )
                
            elif(i[len(i) - 1] == "UART"):
                print("Add UART to Constant ..")
                file_setup_str = file_setup_str + self.tb_str_cst.uart_cst_str.format(i[0][1],
                                                                                      i[0][1], i[1][1],
                                                                                      i[0][1], i[2][1],
                                                                                      i[0][1], i[3][1],
                                                                                      i[0][1], i[4][1],
                                                                                      i[0][1], i[5][1],
                                                                                      i[0][1], i[6][1],
                                                                                      i[0][1], i[7][1],
                                                                                      i[0][1], i[8][1],
                                                                                      i[0][1], i[9][1],
                )
                # Check if file exist
                
        print(file_setup_str)
        # =================================

        # == TB TOP ==
        includes_str = self.tb_str_cst.include_testbench_setup_str.format(expected_path) + self.tb_str_cst.include_sequencer_str # Fill Includes
        # Fill with custom
        tb_custom_str = ""
        for i in self.custom_tb_info_list:
            print(i)
            if(i[len(i) - 1] == "DATA_COLLECTOR"):
                print("Add Data Collector to includes tb_custom_str...")
                
                tb_custom_str += self.tb_str_cst.data_collector_intf_str.format(i[0][1], i[0][1], i[0][1])
                tb_custom_str += self.tb_str_cst.data_collector_wrapper_str.format(i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1])
                
            elif(i[len(i) - 1] == "DATA_CHECKER"):
                print("Add Data checker to includes tb_custom_str..")
               
            elif(i[len(i) - 1] == "UART"):
                print("Add UART to includes tb_custom_str...")
                tb_custom_str += self.tb_str_cst.uart_checker_intf_str.format(i[0][1], i[0][1], i[0][1], i[0][1])
                tb_custom_str += self.tb_str_cst.uart_checker_wrapper_str.format(i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1], i[0][1])
                
        # ============

        # == CLK_GEN Configuration ==
        clk_gen_str = self.tb_str_cst.clk_gen_str.format(self.generic_module_info_list[0][0][1],
                                                         self.generic_module_info_list[0][1][1])
        
        # ===========================
        
        # Create Testbench tb_top.sv
        if(self.testbench_filename not in list_file_in_path):

            tb_top_str = self.tb_str_cst.tb_top_str.format(includes_str, tb_custom_str, self.tb_str_cst.sequencer_class_str)
            
            print("%s not in directory - Creating it ...")

            tb_file = open(expected_path + "/" + self.testbench_filename, "w")
            tb_file.writelines(tb_top_str)
            tb_file.close()
        
            print("%s generated !!" %(self.testbench_filename))

        # Create Testbench Setup
        if(self.testbench_setup_filename not in list_file_in_path):
            print("%s not in directory - Creating it .." %(self.testbench_setup_filename))

            file_cst = open(expected_path + "/" + self.testbench_setup_filename, "w")
            file_cst.writelines(file_setup_str)
            file_cst.close()

        # Create clk_gen
        if(self.testbench_clk_gen_filename not in list_file_in_path):
            print("%s not in directory - Creating it .." %(self.testbench_clk_gen_filename))

            file_clk_gen = open(expected_path + "/" + self.testbench_clk_gen_filename, "w")
            file_clk_gen.writelines(clk_gen_str)
            file_clk_gen.close()
            
    def list_click_custom_mngt(self):


        if(self.custom_tb_modules_list.currentRow() == 0):
            print("DATA_COLLECTOR selected !")
            self.hide_all_module_param()
            self.tb_custom_module_parameters_show_or_hide(self.data_collector_param_list_qt, "SHOW")

            
        elif(self.custom_tb_modules_list.currentRow() == 1):
            
            print("DATA_CHECKER selected !")
            self.hide_all_module_param()
            self.tb_custom_module_parameters_show_or_hide(self.data_checker_param_list_qt, "SHOW")
            
        elif(self.custom_tb_modules_list.currentRow() == 2):
            
            print("UART selected !")
            self.hide_all_module_param()
            self.tb_custom_module_parameters_show_or_hide(self.uart_param_list_qt, "SHOW")
            
        else:
            print("error !!")

    def list_click_generic_mngt(self):
        if(self.generic_tb_modules_list_qt.currentRow() == 0):
            print("SET INJECTOR selected !")
            self.hide_all_module_param()
            self.tb_custom_module_parameters_show_or_hide(self.set_injector_param_list_qt, "SHOW")
            
        elif(self.generic_tb_modules_list_qt.currentRow() == 1):
            print("CHECK LEVEL selected !")
            self.hide_all_module_param()
            self.tb_custom_module_parameters_show_or_hide(self.check_level_param_list_qt, "SHOW")
        elif(self.generic_tb_modules_list_qt.currentRow() == 2):
            print("WAIT EVENT selected !")
            self.hide_all_module_param()
            self.tb_custom_module_parameters_show_or_hide(self.wait_event_param_list_qt, "SHOW")
    # ====================================


    # == TOOLS ==
    def tb_custom_module_parameters(self, param_list = [["DATA_COLLECTOR Alias : "     , "TOTO"],
                                                        ["DATA_COLLECTOR Number :"     , "1"],
                                                        ["DATA_COLLECTOR Data Width : ", "32"]]):
        
        qt_param_list = []
        for i in range(0, len(param_list)):
            qt_param_list.append([QtWidgets.QLabel(param_list[i][0]), QtWidgets.QLineEdit(param_list[i][1])])        
        
        return qt_param_list


    def tb_custom_module_parameters_show_or_hide(self, param_list, show_or_hide = "HIDE"):
        for i in param_list:
            for j in i:                
                j.hide() if show_or_hide == "HIDE" else j.show()


    def hide_all_module_param(self):
        # Custom
        self.tb_custom_module_parameters_show_or_hide(self.data_collector_param_list_qt, "HIDE")
        self.tb_custom_module_parameters_show_or_hide(self.data_checker_param_list_qt, "HIDE")
        self.tb_custom_module_parameters_show_or_hide(self.uart_param_list_qt, "HIDE")

        # Generic
        self.tb_custom_module_parameters_show_or_hide(self.set_injector_param_list_qt, "HIDE")
        self.tb_custom_module_parameters_show_or_hide(self.check_level_param_list_qt, "HIDE")
        self.tb_custom_module_parameters_show_or_hide(self.wait_event_param_list_qt, "HIDE")

    def get_custom_module_info(self, qt_param_list):

        custom_module_info_list = []

        for i in qt_param_list:
            custom_module_info_list.append([i[0].text(), i[1].text()])

        return custom_module_info_list

    def get_generic_module_info(self):
        self.generic_module_info_list = [] # Init list
        self.generic_module_info_list.append(self.get_custom_module_info(self.clk_gen_param_list_qt))
        self.generic_module_info_list.append(self.get_custom_module_info(self.set_injector_param_list_qt))
        self.generic_module_info_list.append(self.get_custom_module_info(self.check_level_param_list_qt))
        self.generic_module_info_list.append(self.get_custom_module_info(self.wait_event_param_list_qt))
        

    def add_info_to_list(self, info_list, module_type):
        info_list = info_list + [module_type]
        if(info_list not in self.custom_tb_info_list):
            self.custom_tb_info_list.append(info_list)   # Add in list
            self.tb_info_list_qt.addItem(str(info_list)) # Add Item in QtWidget List


    def remove_info_to_list(self, current_info):

        # Get Row of current item
#        self.tb_info_list_qt.getItem()
        current_row = self.tb_info_list_qt.currentRow() # Get Current ROW
        if(current_row != -1):
            self.tb_info_list_qt.takeItem(current_row) # Remove ROW
            self.custom_tb_info_list.pop(current_row)
        print("remove : current row : %d" %(current_row))
#        if(current_info in self.custom_tb_info_list):
#            sefl.tb_info_list_qt.remove(current_info)

   
