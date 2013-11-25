#! /usr/bin/env python

import os
import sys

if len(sys.argv) != 2:
	print "Usage: {0} <input directory>".format(sys.argv[0])
	exit()

if os.access(sys.argv[1], os.F_OK) == False:
	print "{0} is not a valid directory.".format(sys.arrgv[1])
	exit()

files = os.listdir(sys.argv[1])

if len(files) == 0:
	print "Target directory empty."
	exit()

for inputFile in files:
	if len(inputFile) == 10 and inputFile.split('.')[1] == 'txt':
		ipf = open(sys.argv[1] + '/' + inputFile, 'r+w')
		firstLine = ipf.readline()
		firstSplit = firstLine.split(', ')
		newFirst = "{0} \n{1} \n{2}".format(firstSplit[0], firstSplit[1], firstSplit[2])
		ipf.seek(0)
		ipf.write(newFirst)
		sys.stdout.write("{0}".format(inputFile) + "\b"*len(inputFile))