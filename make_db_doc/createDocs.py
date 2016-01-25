import numpy as np
import argparse
import pymssql
import getpass


def get_connection():
    USERNAME = "LSST-2"
    HOST = "fatboy-private.phys.washington.edu"
    DATABASE = "LSSTCATSIM"
    password = getpass.getpass('Enter passwd for %s on %s:%s:' % (USERNAME, HOST, DATABASE))
    return pymssql.connect(user=USERNAME,
                           password=password,
                           host=HOST,
                           database=DATABASE)


def executeQuery(DBconnection, queryString, param=None):
    db = DBconnection.cursor()
    db.execute(queryString, param)
    result = db.fetchall()
    db.close()
    return np.asarray(result)


def xstr(s):
    return s or ""


def pkstr(s):
    if s:
        return 'PK'
    else:
        return ''


# THREE PAGE HEADER FORMATS
def printConfluencePageHeader(OUTPUT):
    print >>OUTPUT, " = ImSim Base Catalog Database Docs= "


def printHTMLPageHeader(OUTPUT):
    print >>OUTPUT, """<style type="text/css">
table.gridtable {
    font-family: verdana,arial,sans-serif;
    font-size:11px;
    color:#333333;
    border-width: 1px;
    border-color: #666666;
    border-collapse: collapse;
}
table.gridtable th {
    border-width: 1px;
    padding: 8px;
    border-style: solid;
    border-color: #666666;
    background-color: #dedede;
}
table.gridtable td {
    border-width: 1px;
    padding: 8px;
    border-style: solid;
    border-color: #666666;
    background-color: #ffffff;
}
</style>
"""


def printTracPageHeader(OUTPUT):
    print >>OUTPUT, """
= ImSim Base Catalog Database Docs=

[[TOC]]

"""

printPageHeader = {'confluence': printConfluencePageHeader,
                   'trac': printTracPageHeader,
                   'html': printHTMLPageHeader
                   }


# THREE OBJECT HEADER FORMATS
def printConfluenceHeader(object, OUTPUT):
    print >>OUTPUT, '{expand:%s}' % (object[2])
    print >>OUTPUT, """
    * *Object Type:* %s
    * *Last Modified:* %s
    * *Row Count:* %s
    * *Description:*  %s
    """ % (object[3], object[6], xstr(object[8]), object[7].replace(u'\xa0', u' '))


def printTracHeader(object, OUTPUT):
    print >>OUTPUT, '=== `%s` ===' % (object[2])
    print >>OUTPUT, """
    * '''Object Type:''' %s
    * '''Last Modified:''' %s
    * '''Row Count:''' %s
    * '''Description:'''  `%s`
    """ % (object[3], object[6], xstr(object[8]), object[7].replace(u'\xa0', u' '))


def printHTMLHeader(object, OUTPUT):
    print >>OUTPUT, '<h2>%s</h2>' % (object[2])
    print >>OUTPUT, """<ul>
    <li> <b>Object Type:</b> %s
    <li> <b>Last Modified:</b> %s
    <li> <b> Description: </b> %s
    </ul>
    """ % (object[3], object[6], object[7].replace(u'\xa0', u' ').replace(u'\r\n', u'<br>'))


printHeader = {'confluence': printConfluenceHeader,
               'trac': printTracHeader,
               'html': printHTMLHeader
               }


# THREE COLUMN DESCRIPTION FORMATS
def printConfluenceColumns(columns, OUTPUT):
    if len(columns) == 0:
        print >>OUTPUT, '{expand}'
        return
    print >>OUTPUT, "*Columns*"
    print >>OUTPUT, """|| Name || Data Type || Max Length (Bytes) || Allow Nulls || Identity || PK || Descriptions ||"""
    for column in columns:
        print >>OUTPUT, '| {{%s}} | %s | %s | %s | %s | %s | %s |' % (column[0], column[1], column[2],
                                                                      xstr(column[3]), xstr(column[4]),
                                                                      pkstr(column[7]), xstr(column[6]))


def printTracColumns(columns, OUTPUT):
    if len(columns) == 0:
            return
    print >>OUTPUT, "'''Columns'''"
    print >>OUTPUT, """||= '''Name'''  =||= '''Data Type''' =||= '''Max Length (Bytes)''' =||= '''Allow Nulls''' =||= '''Identity''' =||= '''PK''' =||='''Descriptions'''   =||"""
    for column in columns:
        print >>OUTPUT, '|| `%s` || %s || %s || %s || %s ||%s ||%s ||' % (column[0], column[1], column[2],
                                                                          xstr(column[3]), xstr(column[4]),
                                                                          pkstr(column[7]), xstr(column[6]))


def printHTMLColumns(columns, OUTPUT):
    if len(columns) == 0:
        return
    print >>OUTPUT, """<table style='color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;font-family: verdana,arial,sans-serif;font-size:11px;'>
<th>Name  </th><th> Data Type </th><th> Max Length (Bytes) </th><th> Allow Nulls </th><th> Identity </th><th> Descriptions </th>"""
    for column in columns:
        print >>OUTPUT, '<tr><td>%s </td><td> %s </td><td> %s </td><td> %s </td><td> %s </td><td>%s</td></tr>' % (
                        column[0], column[1], column[2], column[3], column[4], column[6])
    print >>OUTPUT, "</table>"


printColumns = {'confluence': printConfluenceColumns,
                'trac': printTracColumns,
                'html': printHTMLColumns
                }


def printConfluenceIndexes(indexes, OUTPUT):
    if len(indexes) > 0:
        print >>OUTPUT, "*Indexes*"
        print >>OUTPUT, """|| Index Name || Columns ||"""
        for index in indexes:
            print >>OUTPUT, '| {{%s}} | {{%s}} |' % (index[0], index[1])
    print >>OUTPUT, '{expand}'


def printTracIndexes(indexes, OUTPUT):
    if len(indexes) > 0:
        print >>OUTPUT, "'''Indexes'''"
        print >>OUTPUT, """||= ''' Index Name'''  =||= '''Columns''' =||"""
        for index in indexes:
            print >>OUTPUT, '|| `%s` || `%s` ||' % (index[0], index[1])


def printHTMLIndexes(indexes, OUTPUT):
    if len(indexes) > 0:
        print >>OUTPUT, "<table style='color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;font-family: verdana,arial,sans-serif;font-size:11px;'>"
        print >>OUTPUT, "<th>Index Name  </th><th> Columns </th> "
        for index in indexes:
            print >>OUTPUT, '<tr><td>%s </td><td> %s </td></tr>' % (index[0], index[1])


printIndexes = {'confluence': printConfluenceIndexes,
                'trac': printTracIndexes,
                'html': printHTMLIndexes
                }


parser = argparse.ArgumentParser(description='Print Documentation Markup')
parser.add_argument('format',
                    help='one of "trac", "confluence", "html"',
                    default='html')
parser.add_argument('outfile',
                    help='Output filename',
                    default='output.wiki')
# parser.add_argument('--update', action='store_true', dest='doUpdate',
#                    help='Run stored procedure to update backend extended properties of tables.')
args = parser.parse_args()

DBconnection = get_connection()
OUTPUT = open(args.outfile, 'wb')

# if args.doUpdate:
#     print "Running spUpdateAllDescriptions"
#     db = DBconnection.cursor()
#     db.execute("EXEC [dbo].[spUpdateAllDescriptions]")


printPageHeader[args.format](OUTPUT)

getObjectQueryStr = open('getObjects.sql', 'rb').read()
objects = executeQuery(DBconnection, getObjectQueryStr)

sectionString = {'confluence': ' h3. %s',
                 'trac': '== %s ==',
                 'html': '<h1> %s </h1>'
                 }

sectionName = ''
for object in objects:
    print object[0]
    if object[4] != sectionName:
        sectionName = object[4]
        print >>OUTPUT,  sectionString[args.format] % (sectionName)

    printHeader[args.format](object, OUTPUT)

    # GET COLUMNS
    getColumnQueryStr = open('getColumns.sql', 'rb').read()
    columns = executeQuery(DBconnection, getColumnQueryStr, int(object[0]))
    printColumns[args.format](columns, OUTPUT)

    #GET INDEXES
    getIndexQueryStr = open('getIndexes.sql', 'rb').read()
    indexes = executeQuery(DBconnection, getIndexQueryStr, int(object[0]))
    printIndexes[args.format](indexes, OUTPUT)

OUTPUT.close()
