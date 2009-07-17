#!/usr/bin/env python2.6
# -*- coding: utf-8 -*-

import codecs
import urllib
import os
import re
import json
import sys

def usage():
    print "Usage: %(cmd)s reddit_username" % {'cmd': sys.argv[0]}
    sys.exit(1)

def downloadFile(url):
	webFile = urllib.urlopen(url)
	data = webFile.read()
	webFile.close()
	return data

def scrapeComments(data):
    parsed = json.loads(data)["data"]["children"];
    for i in parsed:
        el = i["data"]
        try:
            yield "<b>%(score)d</b> (+%(ups)d -%(downs)d) <a href='%(url)s'>here</a>: <br><p>%(str)s</p>" % {
                "url" : "http://www.reddit.com/r/all/comments/" + re.sub("^.*_", "", el["link_id"]) + "/arst/" + el["id"],
                "score" : el["ups"] - el["downs"],
                "ups" : el["ups"],
                "downs" : el["downs"],
                "str" : el["body_html"].replace("&gt;",">").replace("&lt;","<").replace("\n"," ")}
        except:
            1 # probably a post, not a comment

def scrapeNextPageURL(data):
    ret = re.search("""<a href=\"([^\"]*)\" rel=\"([^\"]*)\" >next<\/a>""", data)
    if ret is not None:
        return ret.group(1)
    return None

def scrapeRedditAccount(username):
    url = "http://www.reddit.com/user/" + username + "/?"
    comments = []
    while url is not None:
        comments = comments + list(scrapeComments(downloadFile(url.replace("?",".json?"))))
        url = scrapeNextPageURL(downloadFile(url))
    return comments

if __name__ == '__main__':
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout)
    if len(sys.argv) != 2:
        usage()
    else:
        comments = scrapeRedditAccount(sys.argv[1])
        comments.sort(lambda x, y: cmp(int(re.sub(r"^<b>([0-9]*)</b> .*$",r"\1",x)), int(re.sub(r"^<b>([0-9]*)</b> .*$",r"\1",y))), reverse=True)
        print "".join(comments);