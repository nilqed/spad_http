#!/bin/bash
python ./spadkernel/install.py --user 
jupyter notebook &
fricas -eval ")r start" 
jupyter notebook stop 8888
exit

