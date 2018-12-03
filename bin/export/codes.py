# coding=utf-8

import sys
import psycopg2
import psycopg2.extras
import json

def createConnectionString():
  config = json.load(open(sys.argv[1]))
  return "host='%s' dbname='%s' user='%s' password='%s'" % (config['host'], config['db'], config['user'], config['pass'])

def executeSql(sqlFile):
  conn = psycopg2.connect(createConnectionString())
  old_isolation_level = conn.isolation_level
  conn.set_isolation_level(0)
  cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
  cursor.execute(open(sqlFile).read())
  result = cursor.rowcount
  conn.commit()
  cursor.close()
  conn.set_isolation_level(old_isolation_level)
  conn.close()
  return result

result = 1
while result > 0:
    result = executeSql('../../sql/insertParents.sql')