#!/usr/bin/coffee
#encoding: UTF-8

console.log "node-mqtt-gw: #{process.platform}"
isWin = /^win/.test(process.platform);
isMac = /^darwin/.test(process.platform);
isLin = /^linux/.test(process.platform);

if not isWin and not isMac and not isLin
  console.log "Warning: Unsupported Platform: #{process.platform}, assuming Unix"
  isLin=true


http = require("http")
express = require("express")
fs = require('fs');
hamlc = require 'haml-coffee'
cs = require 'coffee-script'
printf = require('printf');
sprintf = require('sprintf').sprintf;
koffee = require('./koffeescript.coffee')

getUserHome = () ->
  process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE;

console.log "HOME:",getUserHome()

options={jee: ["joo","jyy",123]}
cfile="#{getUserHome()}/koffee-html.yaml"

console.log "cfile:",cfile
try
  options = yaml.safeLoad(fs.readFileSync(cfile, 'utf8'));
  console.log options;
catch e
  console.log(e);
  console.log "no config!"


app = express()
console.log "workdir:",__dirname


app.get "/js/:page.js", (req, res) ->
  res.set('Content-Type', 'application/javascript');
  cof = fs.readFileSync "#{__dirname}/views/coffee/#{req.params.page}.coffee", "ascii"
  res.send cs.compile cof

app.get "/css/:page.css", (req, res) ->
  res.set('Content-Type', 'text/css');
  cof = fs.readFileSync "#{__dirname}/views/css/#{req.params.page}.css", "ascii"
  res.send cof

app.get "/:page.json", (req, res) ->
  console.log "json",req.query,"params:",req.params
  s=koffee.builder "test/koe.koffee"
  res.json {data:s}

app.get ["/ajax"], (req, res) ->
  #console.log "ajax:",req.query,"params:",req.params
  ret={}
  if req.query.act == "options"
    console.log "options",req.query.data
    options=req.query.data
    y=yaml.dump(options)
    fs.writeFile cfile, y, "utf-8", () ->
      console.log "wrote ok",y
      sse_out
        type: "options"
        options: options

  else if req.query.act == "compile"
    console.log "compiling ",req.query.koffee
    fs.writeFileSync "/tmp/tmp.koffee", req.query.koffee
    ret=
      c: koffee.builder "/tmp/tmp.koffee"
  else
    console.log "strange act",req.query.act
  res.json ret
  #res.json plist

app.get ["/:page.html","/:page.htm","/"], (req, res) ->
  console.log "doin haml:",req.query,"params:",req.params
  comp= hamlc.compile fs.readFileSync "#{__dirname}/views/index.haml", "ascii"
  str= comp
    plist: []
  res.send str

app.use (req, res) ->
  console.log "def:",req

  path=req._parsedUrl.pathname
  if (fs.existsSync("#{__dirname}/views/#{path}"))
    cof = fs.readFileSync "#{__dirname}/views/#{path}", "ascii"
    res.send cof
  else
    res.send(404);


app.listen 8888

stamp = () ->
  (new Date).getTime();


exitHandler = (options, err) ->
  if options.cleanup
    console.log "\nclean"
    sse_out
      "type": "sys"
      "msg": "shutdown"
  console.log err.stack  if err
  process.exit()  if options.exit
  return

process.stdin.resume()

#do something when app is closing
process.on "exit", exitHandler.bind(null,
  cleanup: true
)

#catches ctrl+c event
process.on "SIGINT", exitHandler.bind(null,
  exit: true
)

#catches uncaught exceptions
process.on "uncaughtException", exitHandler.bind(null,
  exit: true
)
