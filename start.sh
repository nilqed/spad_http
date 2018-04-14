#!/bin/bash
python ./spadkernel/install.py --user 
jupyter notebook &
fricas -eval ")r start" 
exit

