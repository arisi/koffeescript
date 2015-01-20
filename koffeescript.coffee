#!/usr/bin/coffee
#encoding: UTF-8


fs = require('fs');
util = require('util');
sprintf = require('sprintf-js').sprintf;
exec = require('child_process').exec;
puts=util.puts
lines=[]
source=[]
imported={}


match = (s,exp) ->
  rePattern = new RegExp(exp)
  s.match(rePattern);

replace = (s,exp,replacement) ->
  rePattern = new RegExp(exp)
  s.replace(rePattern,replacement);

emit = (s,debug) ->
  #puts "emit:: '#{s}'"
  #c+="#{s} // #{debug}\n"
  str=""
  for ii in [0...ind]
    str+="  "
  str+="#{s}"

  if debug
    c+=sprintf("%-50.50s// %-15.15s: %s\n",str,source[row].replace(/\.koffee/,""),lo[row])
  else
    c+="#{str}\n"


types=["char","int","boolean"]

c=""

fn=process.argv[2]


freader = (ffn) ->
  if imported[ffn]
    puts "Error: Recursive/Double Import detected and Averted '#{ffn}' !"
    return
  imported[ffn]=true
  frow=0
  for dada in fs.readFileSync(ffn, "utf-8").split("\n")
    frow+=1
    dada=replace dada, /(#[^"]*)$/,""
    dada=replace dada, /;*$/,""
    continue if dada=="" or match dada,/^\s*$/
    if hit=match dada,/^\s*require\s+\"(.+)\"\s*$/
      console.log "IMPORT #{hit[1]}"
      freader "#{hit[1]}.koffee"
    else
      lines.push dada
      source.push "#{ffn}:#{frow}"

freader fn

row=0
i={}
l={}
lo={}
atoms={}
amax=1


for line in lines
  indent=0
  lo[row]=line
  if hit=match line,/^(\s*)/
    indent=hit[1].length
    i[row]=indent/2
  line=replace line, /\sand\s/,"&&" #this needs to be done only on operands -- not identifiers, not strings
  line=replace line, /\sor\s/,"||"
  line=replace line, /\snot\s/,"!"

  re= /(:[a-zA-Z_][a-zA-Z_0-9]*)/g
  while (m=re.exec(line))!= null
    a=m[0]
    if !atoms[a]
      atoms[a]=amax
      amax+=1
    anum=atoms[a]
    newline=line[0...m.index]+"(#{anum})"+line[m.index+a.length..-1]
    line=newline
  line[0..1]="xx"
  l[row]=line[indent..-1]

  row+=1
l[row]=""
i[row]=0
row+=1
rows=row
row=0
instruct=false
infunc=false
incond={}
oind=0
#console.log l
emit("#include \"koffeescript.h\"","");
emit("","");
for row in [0...rows]
  line=l[row]
  ind=i[row]
  intofunc=false
  #puts ">#{row}:#{i[row]}:#{line}"
  #puts "levels: #{ind} #{oind}"
  if ind<oind # coming down.. check old levels
    for ii in [oind..ind] by -1
      if incond[ii]
        #puts "CHECK IND LEVEL #{ii}"
        if ind==ii and match line,/else/
          #puts "ELSE COMES"
        else
          #puts "COND ENDS"
          emit "  }",""
          incond[ii]=false
  if ind==0
    if instruct
      #puts "STRUCT ENDS"
      emit "} #{instruct};",""
      emit("","");
      instruct=false
    if infunc
      #puts "FUNC ENDS"
      emit "}",""
      emit("","");
      infunc=false
  if hit=match line,/^struct ([a-zA-Z_]+)\s*$/
    if ind==0
      instruct=hit[1]
      puts "struct #{instruct}"
      emit "typedef struct {",line
    else
      puts "Error: Struct must not be indented"
  else if hit=match line,/^for\s+(.+)\s*$/
    incond[ind]=true
    rest=hit[1]
    #puts "incodition"
    emit "for (#{rest}) {",line
  else if hit=match line,/^while\s+(.+)\s*$/
    incond[ind]=true
    rest=hit[1]
    #puts "incodition"
    emit "while (#{rest}) {",line
  else if hit=match line,/^if\s+(.+)\s*$/
    incond[ind]=true
    rest=hit[1]
    #puts "incodition"
    emit "if (#{rest}) {",line
  else if incond[ind] and hit=match line,/^else\s+if\s*(.+)\s*$/
    rest=hit[1]
    #puts "incodition continues"
    emit "} else if (#{rest}) {",line
  else if incond[ind]  and hit=match line,/^else\s*$/
    rest=hit[1]
    #puts "incodition continues "
    emit "} else {",line

  else if hit=match line,/^([a-zA-Z_]+ )*([a-zA-Z_]+) ([a-zA-Z_][a-zA-Z_0-9]*)(?:(\[.*\])){0,1}\s*(?:=(.*)){0,1}\s*$/
    #console.log hit
    typep=hit[1]||""
    type=hit[2]
    sym=hit[3]
    dim=hit[4]||""
    init=hit[5]
    args=false
    #puts "*** type=#{type}, sym=#{sym}, dim=#{dim}, init=#{init}"
    if init and hit=match init,/^\s*\((.*)\)\s*->/
      args=hit[1]
      #puts "ISFUNC!!! args=#{args}"
      init=""
      intofunc=true
   # if not intofunc and (not dim or dim=="[]")
   #   dim=""
   #   sym="*#{sym}"

    if intofunc
      emit "#{typep}#{type} #{sym}(#{args}) {",line
      infunc=sym
    else if init
      emit "#{typep}#{type} #{sym}#{dim}=#{init};",line
    else
      emit "#{typep}#{type} #{sym}#{dim};",line
  else
    #puts "CCCCCCCCCCCCCCc command???"
    ret=""
    if infunc and i[row+1]==0 and not incond[ind-1] #last line of function
      if not match line,/^\s*return/
        #puts "***********LAST LINE****************, not return! #{incond[ind-1]} #{line}"
        ret="return "
    if hit=match line,/^([a-zA-Z_]+) (.+)$/
      cmd=hit[1]
      rest=hit[2]
      #puts "::#{cmd }::#{rest}::"
      if not match rest,/\(.+\)/
        #puts "NO PAREN"
        emit "#{ret}#{cmd}  ( #{rest} );",line
      else
        emit "#{ret}#{line};",line
    else
      emit "#{ret}#{line};",line
  row+=1
  oind=ind

puts "-----------------"
#puts c
fs.writeFile "test.c", c, (error) ->
  if error
    console.error("Error writing file", error)
  else
    child = exec "make test",  (error, stdout, stderr) ->
      #puts stdout
      errs=stderr.split("\n")
      fail=false
      fails=[]
      for e in errs
        if match e,/error:/
          fail=true
          fails.push e
      if not fail
        child = exec "./test #{process.argv[3]}",  (error, stdout, stderr) ->
          puts "executed: ./test #{process.argv[3]}"
          puts stdout
          puts stderr
      else
        puts "********************* FAILED"
        rn=1
        for r in c.split("\n")
          puts "#{rn}:#{r}"
          rn+=1
        puts "********************* FAILED"
        for f in fails
          puts f

