#!/usr/bin/python
import sys
import psycopg2
import json

def createConnectionString():
  config = json.load(open(sys.argv[2]))
  return "host='%s' dbname='%s' user='%s' password='%s'" % (config['host'], config['db'], config['user'], config['pass'])

def executeSql(sqlFile):
  conn = psycopg2.connect(createConnectionString())
  cursor = conn.cursor()
  cursor.execute(open(sqlFile).read())
  conn.commit()
  cursor.close()
  conn.close()

executeSql(sys.argv[1])
