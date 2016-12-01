#!/usr/bin/env python

import commands

class redis_monitor:
	redis_bin='/opt/redis/bin/redis-cli'

	def __init__(self,password,port,item):
		self.Password = password
		self.Port = int(port)
		self.items = item
	
	def Monitor_items(self):
		try:
			code,res = commands.getstatusoutput("%s -a %s -p %d info | grep %s | awk -F: '{print$2}'" %(redis_monitor.redis_bin,self.Password,self.Port,self.items))
		except ValueError,e:
			print e
			print 'error'
		else: 
			res_m = int(res)/1024/1024
			return res_m

if __name__ == '__main__':
	obj=redis_monitor('quB1BY3njv0e1212b7BFw92',6779,'used_memory_rss')
	Redis_use_Mem=obj.Monitor_items()
	print Redis_use_Mem
