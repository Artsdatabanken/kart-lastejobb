#!/usr/bin/python
import sys
import psycopg2
import psycopg2.extras
import json

def createConnectionString():
  config = json.load(open(sys.argv[2]))
  return "host='%s' dbname='%s' user='%s' password='%s'" % (config['host'], config['db'], config['user'], config['pass'])

def executeSql(sqlFile):
  conn = psycopg2.connect(createConnectionString())
  old_isolation_level = conn.isolation_level
  conn.set_isolation_level(0)
  cursor = conn.cursor()
  cursor.execute(open(sqlFile).read())
  result = cursor.fetchall()
  conn.commit()
  cursor.close()
  conn.set_isolation_level(old_isolation_level)
  conn.close()
  return result

def writeResults(sqlFile, output):
  conn = psycopg2.connect(createConnectionString())
  old_isolation_level = conn.isolation_level
  conn.set_isolation_level(0)
  cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
  cursor.execute(open(sqlFile).read())
  result = cursor.fetchall()
  conn.commit()
  cursor.close()
  conn.set_isolation_level(old_isolation_level)
  conn.close()
  with open(output, 'w') as outfile:
    json.dump(result, outfile)

if len(sys.argv) == 3: executeSql(sys.argv[1])
else: writeResults(sys.argv[1], sys.argv[3])
