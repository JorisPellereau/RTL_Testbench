import sys



import generic_tb_cmd_class
import scn_class

# Create SCN Class
generic_cmd_scn_xx = scn_class.scn_class("toto.txt")


# Print SET
generic_cmd_scn_xx.print_line("-- TTOTOTOTOTO\n")
generic_cmd_scn_xx.print_line("-- \n")
                         

for i in range(0, 100):
    generic_cmd_scn_xx.generic_tb_cmd.SET("TOTO", i)

generic_cmd_scn_xx.print_line("\n")

generic_cmd_scn_xx.print_line("\n")


generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 10, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 10, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 10, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 10, "ms")
generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 666, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 666, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 666, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 666, "ms")
generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 56, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 56, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 56, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTR("TOTO", 56, "ms")

generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 10, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 10, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 10, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 10, "ms")
generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 666, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 666, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 666, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 666, "ms")
generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 56, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 56, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 56, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTF("TOTO", 56, "ms")


generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 10, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 10, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 10, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 10, "ms")
generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 666, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 666, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 666, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 666, "ms")
generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 56, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 56, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 56, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTRS("TOTO", 56, "ms")

generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 10, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 10, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 10, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 10, "ms")
generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 666, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 666, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 666, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 666, "ms")
generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 56, "ps")
generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 56, "ns")
generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 56, "us")
generic_cmd_scn_xx.generic_tb_cmd.WTFS("TOTO", 56, "ms")

generic_cmd_scn_xx.generic_tb_cmd.CHK("TITI", 0xFEFEFEFE, "ERROR")
generic_cmd_scn_xx.generic_tb_cmd.CHK("TITI", 0xFEFEFEF0, "ERROR")
generic_cmd_scn_xx.generic_tb_cmd.CHK("TITI", 0xFEFEFEF8, "ERROR")
generic_cmd_scn_xx.generic_tb_cmd.CHK("TITI", 0xFEFEFEF6, "ERROR")
generic_cmd_scn_xx.generic_tb_cmd.CHK("TITI", 0xFEFEFEF4, "ERROR")

generic_cmd_scn_xx.generic_tb_cmd.MODELSIM_CMD("force - freeze ...")


generic_cmd_scn_xx.print_line("-- END OF SIMULATION\n\n")



generic_cmd_scn_xx.END_TEST()
