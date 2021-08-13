#!/usr/bin/env python
#coding:utf-8
from email.mime.text import MIMEText
from email.header import Header
import smtplib

sender='xxxxx@qq.com'
sender_pass='xxxxxxxxxxxxxx'
host='smtp.qq.com'
recivers=['xxxxxxxx@xxx.com']
def mail():
	message=MIMEText('python 邮件发送111','plain','utf-8')
	message['From']='{}'.format(sender)
	message['To']=','.join(recivers)
	message['Subject']='邮件测试222'

	try:
		smtpobj=smtplib.SMTP_SSL(host,465)#启用ssl，端口为465
		
		smtpobj.login(sender,sender_pass)

		smtpobj.sendmail(sender,recivers,message.as_string())
		print('sucess')
		smtpobj.quit()
	except:
		print('error')

mail()
