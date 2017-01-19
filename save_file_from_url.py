#before use this sciript
#$pip install beautifulsoup

import sys,urllib, re, urlparse
from BeautifulSoup import BeautifulSoup


url = ''

#%%

#if not len(sys.argv) == 2:
#    print >> sys.stderr, "Usage: %s <URL>" % (sys.argv[0],)
#    sys.exit(1)

#%%
#get first layer folder lst in url
f = urllib.urlopen(url)
soup = BeautifulSoup(f)
#soup

url_list = []
for i in soup.findAll( 'a', attrs={'href': re.compile('(?i)(/)$')}):
    folder_url = urlparse.urljoin(url, i['href'])
    print "folder URL: ", folder_url
    url_list.append(folder_url)

#%%
#download all the pdf file in url_list
for url in url_list:
    #print url
    f = urllib.urlopen(url)
    soup = BeautifulSoup(f)
    for i in soup.findAll( 'a', attrs={'href': re.compile('(?i)(pdf)$')}):
        full_url = urlparse.urljoin(url, i['href'])
        print "pdf URL: ", full_url
        folder_name =full_url.split('/')[-2]
        file_name = full_url.split('/')[-1]
        full_name = '/' + folder_name + '/' + file_name
        urllib.urlretrieve (full_url, full_name)
