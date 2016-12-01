#!/usr/bin/env python
from check_redis import redis_monitor
import sys

Total_mem=10240
Warn_mem = 6000
Circtl_mem = 9000

class redis_use_memory(redis_monitor):
	
	pass

mem_val=redis_use_memory('quB1BY3njv0edffdfHldfBFw92',6779,'used_memory_rss')

Current_use_Mem=mem_val.Monitor_items()


if Current_use_Mem < int(sys.argv[1]):
	print "OK -connect counts is %s | Current=$NUM;Warning=$Warn;Critical=$Crit" % Current_use_Mem
	sys.exit(0)
elif Current_use_Mem > int(sys.argv[1]) and Current_use_Mem < int(sys.argv[2]):
	print "Warning -connect counts is %s | Current=$NUM;Warning=$Warn;Critical=$Crit" % Current_use_Mem
	sys.exit(1)
else:
	#Current_use_Mem > sys.argv[2]:
	print "Critical -connect counts is %s | Current=$NUM;Warning=$Warn;Critical=$Crit" % Current_use_Mem
	sys.exit(2)


