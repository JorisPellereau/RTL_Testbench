# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# Usd in order to resolved the problem 
import errno
import sphinx.util.osutil
sphinx.util.osutil.ENOENT = errno.ENOENT
sphinx.util.osutil.EPIPE = errno.EPIPE
sphinx.util.osutil.EINVAL = errno.EINVAL

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
import pathlib
# sys.path.insert(0, os.path.abspath('.'))
sys.path.insert(0, os.path.abspath('../../../scripts/scn_generator/'))
#sys.path.insert(0, os.path.abspath('/home/linux-jp/Documents/GitHub/Verilog/Testbench/scripts/scn_generator/modelsim_tcl'))

# -- Project information -----------------------------------------------------

project   = 'Generic Testbench Documentation'
copyright = '2023, J.P'
author    = 'J.P'

version = '0'

# The full version, including alpha/beta/rc tags
release = '0.1'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.duration',
    'sphinx.ext.graphviz',
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx_hwt',
#    'sphinxvhdl.vhdl',
    'symbolator_sphinx',
    'sphinx.ext.todo',
    'sphinx.ext.inheritance_diagram'
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []


source_encoding = 'utf-8-sig'

#rst_epilog = 'JOJO'
#rst_prolog = 'TITI'

keep_warnings = True
#suppress_warnings
nitpicky = False
numfig = True

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
#html_theme = 'alabaster'
#html_theme = 'bizstyle'
html_theme = 'haiku'
#html_theme = 'Read the Docs'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# Symbolator Configuration
symbolator_cmd = '/home/linux-jp/.local/bin/symbolator'
symbolator_cmd_args = ['-t', '--scale=2']
symbolator_output_format = 'png'  # 'svg' is other format

# TODO Configuration
todo_include_todos = True


# DEBUG
print(sys.executable)
print(sys.path)
