import requests
import unicodecsv as csv
import io
import urllib

file_share_id = "1tFzLX1xJJXaxWl9zP5LrL0SWU8iOpz0kH9hT_bKHnw8"
url = "https://docs.google.com/spreadsheets/d/{0}/export?format=csv".format(file_share_id)

headers={}
headers["User-Agent"]= "Mozilla/5.0 (Windows NT 6.2; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0"
headers["DNT"]= "1"
headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
headers["Accept-Encoding"] = "deflate"
headers["Accept-Language"]= "en-US,en;q=0.5"
lines = []

r = requests.get(url)

data = {}
cols = []

reader = csv.reader( urllib.urlopen(url), encoding='utf-8' )
rownum = 0

for row in reader:
    if rownum == 0:
        for col in row:
            data[col] = ''
            cols.append(col)

    else:
        i = 0
        for col in row:
            data[cols[i]] = col
            i = i +1

        print data
rownum = rownum + 1
print (r.text)
