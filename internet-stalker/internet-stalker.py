#!/usr/bin/env python2.6
# -*- coding: utf-8 -*-

import feedparser
import re
import urllib
import os
import json
import sys
import codecs
from markdown import markdown
from datetime import datetime

flickr_thumb = "http://www.flickr.com/favicon.ico"
git_thumb = "http://repo.or.cz/git-favicon.png"
facebook_thumb = "http://www.facebook.com/favicon.ico"
reddit_thumb = "http://www.reddit.com/favicon.ico"
lastfm_thumb = "http://www.last.fm/favicon.ico"
blog_thumb = "https://www.blogger.com/favicon.ico"

html_header = u"""
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <title>hortont · stalker</title>
    <style>
*
{
    font-family: "Helvetica" sans;
    color: #555;
}

div.item
{
    -moz-border-radius: 7px;
    -webkit-border-radius: 7px;
    border: 1px solid #ccc;
    padding: 2px;
}

p.title
{
    font-weight: bold;
    margin-bottom: 2px;
}

a.alink
{
    color: #555;
    text-decoration: none;
}

p
{
    margin: 0px;
    padding: 0px;
}

img.favicon
{
    margin: 4px;
    width: 16px;
    height: 16px;
}

span.date
{
    font-weight: normal;
    font-size: .8em;
    color: #666;
    float: right;
}
    </style>
</head>
<body>
<table>
"""

html_footer = u"""
</table>
</body>
</html>
"""

def generateEntry(e):
    e["date"] = datetime(*e["date"][:6]).strftime("%Y.%m.%d@%H:%M")
    return u"""
        <tr><td class="itemContent">
            <div class="item"><a href="%(link)s" class="alink">
                <table width="100%%"><tr>
                <td width="28px"><img src="%(thumb)s" class="favicon"/></td>
                <td>
                <p class="title">
                    <span class="date">%(date)s</span>
                    %(title)s
                </p>
                <p class="content">%(content)s</p>
                </td>
                </tr></table>
            </a></div>
        </td></tr>""" % e

def usage():
    print "Usage: %(cmd)s user_data.json" % { "cmd" : sys.argv[0] }
    sys.exit(1)

def downloadFile(url):
	webFile = urllib.urlopen(url)
	data = webFile.read()
	webFile.close()
	return data

def readFile(fn):
    fileHandle = codecs.open(fn, encoding='utf-8')
    fileContents = fileHandle.read()
    fileHandle.close()
    return fileContents

def getGitCommits(acct):
    d = feedparser.parse(acct["url"])
    for e in d.entries:
        if acct["name"] == e.author_detail.name:
            yield { "title" : "(" + d.feed.title + ") " + e.title,
                    "date" : e.updated_parsed,
                    "link" : e.link,
                    "thumb" : git_thumb,
                    "content" : "" }

def getFlickrPosts(acct):
    url = re.search("atom\+xml[^\>]*href=\"([^\"]*)\"", downloadFile("http://www.flickr.com/photos/" + acct["name"])).group(1)
    d = feedparser.parse(url)
    for e in d.entries:
        thumb = re.search("img src=\"([^\"]*_m.jpg)\"", downloadFile(e.link + "sizes/s/")).group(1)
        yield { "title" : e.title,
                "date" : e.updated_parsed,
                "link" : e.link,
                "thumb" : flickr_thumb,
                "content" : "<img src=\"" + thumb + "\"/>" }

def getFacebookStatuses(acct):
    d = feedparser.parse(acct["url"])
    for e in d.entries:
        yield { "title" : re.sub("^" + acct["name"] + " ", "", e.title),
                "date" : e.updated_parsed,
                "link" : "#",
                "thumb" : facebook_thumb,
                "content" : "" }

def getRedditComments(acct):
    d = feedparser.parse("http://www.reddit.com/user/" + acct["name"] + "/.rss")
    for e in d.entries:
        yield { "title" : re.sub("^" + acct["name"] + " on ", "", e.title),
                "date" : e.updated_parsed,
                "link" : e.link,
                "thumb" : reddit_thumb,
                "content" : markdown(e.description) }

def getLastfmScrobbles(acct):
    d = feedparser.parse("http://ws.audioscrobbler.com/1.0/user/" + acct["name"] + "/recenttracks.rss")
    for e in d.entries:
        yield { "title" : e.title,
                "date" : e.updated_parsed,
                "link" : e.link,
                "thumb" : lastfm_thumb,
                "content" : "" }

def getBlogPosts(acct):
    d = feedparser.parse(acct["url"])
    for e in d.entries:
        yield { "title" : e.title,
                "date" : e.updated_parsed,
                "link" : e.link,
                "thumb" : blog_thumb,
                "content" : e.description }


typeFuncs = { "git" : getGitCommits,
              "flickr" : getFlickrPosts,
              "facebook" : getFacebookStatuses,
              "reddit" : getRedditComments,
              "lastfm" : getLastfmScrobbles,
              "blog" : getBlogPosts }

def generateTimeline(fn):
    data = json.loads(readFile(fn))
    items = [ ]
    for type in data.keys():
        for acct in data[type]:
            items.extend(list(typeFuncs[type](acct)))
    items.sort(lambda x, y: cmp(x["date"], y["date"]), reverse=True)
    print html_header
    for i in items:
        print generateEntry(i)
    print html_footer

if __name__ == '__main__':
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout)
    if len(sys.argv) != 2:
        usage()
    else:
        generateTimeline(sys.argv[1])
