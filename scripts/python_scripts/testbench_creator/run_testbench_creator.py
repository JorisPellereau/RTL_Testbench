import sys
from PySide2 import QtCore, QtGui, QtWidgets
import numpy as np

from testbench_creator_class import *

app    = QtWidgets.QApplication(sys.argv)
dialog = testbench_creator_class()
dialog.exec_()
