# Description:
#  Use Hubot to retrieve the latest LeaseWeb noc status messages
#
# Dependencies:
#   "nodepie": "0.5.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot noc status - get the last posts from the LeaseWeb NOC status feed
#   hubot noc maintenance - get the last posts from the LeaseWeb NOC maintenance feed

NodePie = require("nodepie")

nocStatusUrl = "http://leasewebnoc.com/rss/status"
nocMaintenanceUrl = "http://leasewebnoc.com/rss/maintenance"

module.exports = (robot) ->
  robot.respond /noc ?(status|posts|latest)/i, (msg) ->
    msg.http(nocStatusUrl).get() (err, res, body) ->
      if res.statusCode is not 200
        msg.send "Something's gone wrong"
      else
        feed = new NodePie(body)
        try
          feed.init()
          items = feed.getItems(0, 5)
          msg.send item.getDescription().split(")",1) + ") " + item.getTitle() + ": " + item.getPermalink() for item in items
        catch e
          console.log(e)
          msg.send "Something's gone wrong"

  robot.respond /noc ?(maint|maintenance)/i, (msg) ->
    msg.http(nocMaintenanceUrl).get() (err, res, body) ->
      if res.statusCode is not 200
        msg.send "Something's gone wrong"
      else
        feed = new NodePie(body)
        try
          feed.init()
          items = feed.getItems(0, 5)
          msg.send item.getDescription().split(")",1) + ") " + item.getTitle() + ": " + item.getPermalink()  for item in items
        catch e
          console.log(e)
          msg.send "Something's gone wrong"

