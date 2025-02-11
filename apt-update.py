import syslog
import os
import logging
import logging.handlers

version = "1.0.1"
my_logger = logging.getLogger('MyLogger')
my_logger.setLevel(logging.DEBUG)
handler = logging.handlers.SysLogHandler(address = '/dev/log')
my_logger.addHandler(handler)

pname=os.path.basename(__file__)

my_logger.debug("Process "+pname+ " started ")

def check_string():
    with open('/tmp/aptupdate.log') as temp_f:
        datafile = temp_f.readlines()
    for line in datafile:
        if 'All packages are up to date.' in line:
            return True # The string is found
    return False  # The string does not exist in the file "+pname+ " started ")


os.system('apt update 1>/tmp/aptupdate.log 2>/dev/null')



if check_string():
  my_logger.debug("System is up to date...")
  my_logger.debug("Process "+pname+ " RUNNING OUT no more to do")
else:
  my_logger.debug("Process "+pname+ " RUNNING IN we have packages do update")
  os.system('apt -y upgrade 1>/tmp/aptupdate.log 2>/dev/null')

my_logger.debug("Process "+pname+ " finished ")

