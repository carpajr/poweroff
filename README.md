# poweroff
Simple code (very rudimentary) to poweroff computers using google spreadsheets

# Context
* A university's library that has about 60 computers
  * 20% with Ubuntu Linux
  * 80% with Windows Vista, 7 and 10
* Few employees that have several duties during labor
* Someone interested in automates several tasks that could be done with less effort (it's me!)

# How it works
1. A simple spreadsheet in googledocs store the work days and work period of the library. There is two computer groups: ordinary and lab. The last are the computers allocated inside a specific room and are used in courses, seminars and workshops. These computers are power off more frequently than the ordinary computers that represents all other PCs in the library.

2. The main script runs in a server that checks periodically the CSV response of the spreadsheet and save this data in specific directories. This files will be requested by HTTP for clients offering to them the processed information (it's like a boolean flag to trigger the shutdown). So, in web folder we could be:
/infra/poweroff/ordinary/index.htm
/infra/poweroff/lab/index.htm

Acessed by a domain: 
http://domain/infra/poweroff/ordinary/

Results:
on/off

3. Scripts made in shell script (Linux stations) and powershell (Windows stations) were installed in OS schedulers and checks each 10 min if its time to power off.

* The power on is handle by RTC Schedule by each computer BIOS. I tried to make this different using WOL (Wake-On-Lan) but all switches in the network refuses broadcast signal to WOL.

# What is available
1. Spreadsheet access (read)
2. Server script
3. Client script

# Questions?
Please, get in touch! :)

