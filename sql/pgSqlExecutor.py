#!/usr/bin/python
import psycopg2
import json

def createConnectionString():
  config = json.load(open(sys.argv[3]))['postgis']
  conn_string="host='%s' dbname='%s' user='%s' password='%s'" % (config['host'], config['db'], config['user'], config['pass'])

def readFile(file):
  with open(file, 'r') as myfile:
    data=myfile.read().replace('\n', '')
  return data

def executeSql(sqlFile):
  conn = psycopg2.connect(createConnectionString())
  cursor = conn.cursor()
  cursor.execute(readFile(sqlFile))

executeSql(sys.argv[2])
