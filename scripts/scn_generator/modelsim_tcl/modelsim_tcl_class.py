import os
import sys

class modelsim_tcl_class:
    """
    This class contains methods used for the utilization of MODELSIM TCL commands
    """


    def __init__(self):
        """
        This is the constructor of the class
        """
        None
        
    # Set A specific TCL variable to a value of  specific signal (from its RTL path)
    def tcl_set_signal_2_var(self, var_name, signal_path):
        """
        Generate the TCL command : set a specific TCL variable to a value of a specific signal

        :param var_name: The name of the variable to set
        :param signal_path: the RTL path of the signal to set in the variable
        :type var_name: str
        :type signal_path: str
        :return: the TCL command
        :rtype: str
        """
        tcl_set_var_cmd = "set " + var_name + " [examine " + signal_path + "]"
        return tcl_set_var_cmd

    # Set a value to a variable
    def tcl_set_value_2_var(self, var_name, value):
        """
        Generate the TCL command : set a value to a variable

        :param var_name: The name of the variable to set
        :param value: the value to set in the variable
        :type var_name: str
        :type value: int
        :return: the TCL command
        :rtype: str
        """
        tcl_set_value_to_var_cmd = "set " + var_name + " " + value
        return tcl_set_value_to_var_cmd

    # Add message in MODELSIM Prompt
    # message : str - message to print inpromt
    # severity : str - "error" or "note" or "warning"
    def tcl_add_message(self, message, severity = "note"):
        """
        Generate the TCL command : add message in MODELSIM prompt

        :param message: The message to print in the Modelsim prompt
        :param severity: The severity of the message
        :type message: str
        :type severity: str - Value : "error" - "note" - "warning"
        :return: the TCL command
        :rtype: str
        """
        tcl_add_message_cmd = "add message -severity {0} \"{1}\"".format(severity, message)
        return tcl_add_message_cmd

    # Create test value TCL Command
    def tcl_test_signal_value(self, var_name, test_value, test_variable = False):
        """
        Generate the TCL command : create a test of a value

        :param var_name: The variable name
        :param test_value: The expected test value
        :param test_variable: Selection of the test for the comparison
        :type var_name: str
        :type test_value: int
        :type test_variable: bool - default value : False
        :return: the TCL command
        :rtype: str
        """
        msg_if_true  = self.tcl_add_message("${0} == {1} => OK".format(var_name, test_value), severity = "note")
        msg_if_false = self.tcl_add_message("${0} /= {1} => KO".format(var_name, test_value), severity = "error")

        # Case compare a variable between a specific value
        if(test_variable == False):
            tcl_test_signal_value_cmd = "if {{${0} == \"{1}\"}} {{{2}}} else {{{3}}}".format(var_name, test_value, msg_if_true, msg_if_false)
        # Case compare a variable with an other variable
        elif(test_variable == True):
            tcl_test_signal_value_cmd = "if {{${0} == ${1}}} {{{2}}} else {{{3}}}".format(var_name, test_value, msg_if_true, msg_if_false)
        return tcl_test_signal_value_cmd
