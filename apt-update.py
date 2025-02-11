import syslog
import os
import logging
import logging.handlers
import subprocess

version = "1.0.0"
my_logger = logging.getLogger('MyLogger')
my_logger.setLevel(logging.DEBUG)
handler = logging.handlers.SysLogHandler(address = '/dev/log')
my_logger.addHandler(handler)

pname=os.path.basename(__file__)

my_logger.debug("Process "+pname+ " started ")

def check_string():
    with open('/home/pdsilva/log/aptupdate.log') as temp_f:
        datafile = temp_f.readlines()
    for line in datafile:
        if 'All packages are up to date.' in line:
            my_logger.debug(date +'%m/%d %H:%M:%S'+"Process "+pname+ " nothing to update")
            return True # The string is found
        return
            cmd = ['echo', 'I like potatos']
            proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

o, e = proc.communicate()		    data = os.system('date +'%m/%d %H:%M:%S'')
            my_logger.debug(data+"Process "+pname+ " Updating...")
            False # The string does not exist in the file "+pname+ " started ")


os.system('apt update 1>/home/pdsilva/log/aptupdate.log 2>/dev/null')


if check_string():
  my_logger.debug(date +'%m/%d %H:%M:%S'+"System is up to date...")
else:
  os.system('apt -y upgrade 1>/home/pdsilva/log/aptupdate.log 2>/dev/null')

my_logger.debug(date +'%m/%d %H:%M:%S'+"Process "+pname+ " finished ")

