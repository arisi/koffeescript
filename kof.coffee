#!/usr/bin/coffee
#encoding: UTF-8

fs = require('fs');
util = require('util');
path = require('path');
require("coffee-script")
koffee = require('./koffeescript.coffee')
argv = require('minimist')(process.argv.slice(2));
#console.dir(argv);

if argv.C
  if not argv.O
    s=koffee.builder argv._[0]
    if s
      console.log s
    else
      console.log "Errors!"
    return
  else
    s=koffee.builder argv._[0],argv.O
    if s
      console.log "Compiled '#{argv._[0]}' to '#{argv.O}' OK"
    else
      console.log "Errors!"
    return
else
  if not argv._[0]
    console.log "No Arguments?"
    return

fn=process.argv[2]
afn=path.basename fn
apath=path.dirname (path.resolve fn)

cache_path="#{apath}/.koffee.cache"
target="#{cache_path}/#{afn}.bin"
cfn="#{cache_path}/#{afn}.c"

if not fs.existsSync cache_path
  fs.mkdirSync cache_path

fd=fs.openSync fn,"r"
stat=fs.fstatSync fd
fs.closeSync(fd)

cache=false
if fs.existsSync target
  fd=fs.openSync target,"r"
  tstat=fs.fstatSync fd
  fs.closeSync(fd)

  if tstat.mtime> stat.mtime
    cache=true

if not cache
  koffee.builder fn,cfn,target #this also runs after build
else
  koffee.runner(target)
