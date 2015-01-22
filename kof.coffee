#!/usr/bin/coffee
#encoding: UTF-8

fs = require('fs');
path = require('path');
require("coffee-script")
koffee = require('./koffeescript.coffee')
argv = require('minimist')(process.argv.slice(2));
#console.dir(argv);

if argv.C
  #console.dir argv
  if not fs.existsSync argv.C
    console.log "Error: Source File: '#{argv.C}' Not Found"
    return -1

  if not argv.O
    s=koffee.builder argv.C
    if s
      console.log s
    else
      console.log "Errors!"
    return s
  else
    s=koffee.builder argv.C,argv.O
    if s
      console.log "Compiled '#{argv._[0]}' to '#{argv.O}' OK"
    else
      console.log "Errors!"
    return s
else
  if not argv._[0]
    console.log "kof -- Koffeescript Compiler \nUsage:\nkof [-C] source.kof [-O object.o]"
    return -1

fn=process.argv[2]
afn=path.basename fn
apath=path.dirname (path.resolve fn)

cache_path="#{apath}/.koffee.cache"
target="#{cache_path}/#{afn}.bin"
cfn="#{cache_path}/#{afn}.c"
#console.log cfn

if not fs.existsSync fn
  console.log "Error: Source File '#{fn}' Not Found"
  return -1

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

return 0
