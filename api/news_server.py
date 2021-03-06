#!/usr/bin/env python3

from bottle import run, route, abort, response
from bs4 import BeautifulSoup
from django.utils import feedgenerator
import feedparser
import sys
import threading
import time
import requests
import datetime

PUBLIC = {}
PUBLIC_ATOM = ""

class Fetcher(threading.Thread):
  def run(self):
    self.event = threading.Event()
    self.update_feed_data()
    while not self.event.wait(timeout=900):
      self.update_feed_data()

  def retrieve_op_data(self, topic_url):
    text = ""
    date = "2017-01-01T00:00:00Z"
    try:
      body = requests.get(topic_url).text
      soup = BeautifulSoup(body, "html.parser")
      op = soup.find("div", { "class": "blockpost1" })
      p = op.find("div", { "class":"postmsg"}).find("p")
      for br in p.findAll("br"):
        br.replace_with(' ')
      text = p.prettify(formatter="html")
      date = op.find("h2").find("a").text
      date = date.replace(" ", "T") + "Z"
      if "Today" in date:
        date = date.replace("Today", datetime.datetime.utcnow().strftime("%Y-%m-%d"))
      elif "Yesterday" in date:
        date = date.replace("Yesterday", (datetime.datetime.utcnow() - datetime.timedelta(days=1)).strftime("%Y-%m-%d"))
    except BaseException as e:
      print("ERROR:", e)
    return { "updated": date, "summary": text }

  def update_feed_data(self):
    feed = feedparser.parse("https://forums.bunsenlabs.org/extern.php?action=feed&fid=12&type=atom")
    refeed = feedgenerator.Atom1Feed('BunsenLabs Linux News', 'https://forums.bunsenlabs.org/viewforum.php?id=12', "")
    def mapper(e):
      opdata = self.retrieve_op_data(e['link'])
      return {  "link":       self.head(e['link'], '&'),
                "date":       self.head(e['updated'], 'T'),
                "updated":    self.head(opdata['updated'], 'T'),
                "op_summary": opdata['summary'],
                "title":      " ".join(e['title'].split()) }
    entries = list(map(mapper, feed.entries))
    # JSON API
    global PUBLIC
    PUBLIC = { "entries": entries, "ts": int(time.time()) }
    # ATOM XML API
    for e in entries:
      refeed.add_item(e["title"], e["link"], e["op_summary"],
          updateddate = datetime.datetime.strptime(e["updated"], "%Y-%m-%dT%H:%M:%SZ"))
    global PUBLIC_ATOM
    PUBLIC_ATOM = refeed.writeString("utf-8")

  @staticmethod
  def head(s, sep):
    return s.split(sep)[0]


@route('/feed/news')
def index():
  return PUBLIC

@route('/feed/news/atom')
def idex():
  response.content_type = "application/atom+xml; charset=utf-8"
  return PUBLIC_ATOM

if __name__ == "__main__":
  fetcher = Fetcher()
  fetcher.start()
  run(host="localhost", port=10102, server="cherrypy")
