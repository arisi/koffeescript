#!/usr/bin/coffee
#encoding: UTF-8

fs = require('fs');
exec = require('child_process').exec;
sprintf = require('/home/arisi/projects/node-mqtt-gw/node_modules/sprintf-js').sprintf;

match = (s,exp) ->
  rePattern = new RegExp(exp)
  s.match(rePattern);
exports.match=match

replace = (s,exp,replacement) ->
  rePattern = new RegExp(exp)
  s.replace(rePattern,replacement);

exports.runner = (target) ->
  args=""
  for arg in process.argv[3..-1]
    if match arg,/\s+/
      args+=" \"#{arg}\""
    else
      args+=" #{arg}"
  #puts "executing: #{target} #{args}"
  child = exec "#{target} #{args}",  (error, stdout, stderr) ->
    #puts "executed: #{target} #{args}"
    console.log stdout
    if stderr and stederr>""
      console.log stderr

exports.builder = (fn,cfn,target) ->
  c=""
  lines=[]
  source=[]
  imported={}

  emit = (s,debug) ->
    #puts "emit:: '#{s}'"
    #c+="#{s} // #{debug}\n"
    if match s,/^#encoding/
      return
    if  match s,/^#\!/
      return
    str=""
    for ii in [0...ind]
      str+="  "
    str+="#{s}"

    if debug
      c+=sprintf("%-50.50s// %-15.15s: %s\n",str,source[row].replace(/\.koffee/,""),lo[row])
    else
      c+="#{str}\n"

  freader = (ffn) ->
    if imported[ffn]
      console.log "Error: Recursive/Double Import detected and Averted '#{ffn}' !"
      return
    imported[ffn]=true
    frow=0
    for dada in fs.readFileSync(ffn, "utf-8").split("\n")
      frow+=1
      if hit=match dada,/^\s*require\s+\"(.+)\"\s*$/
        req=hit[1]
        #console.log "IMPORT #{req}"
        if match req,/.+\.h$/
          dada="#include \"#{req}\""
          lines.push dada
          source.push "#{ffn}:#{frow}"
        else
          if match req,/.+\.koffee$/
            freader "#{hit[1]}"
          else
            freader "#{hit[1]}.koffee"
      else
        dada=replace dada, /(\/\/[^"]*)$/,""
        #dada=replace dada, /;*$/,"" -- later -- pragma stuff
        continue if dada=="" or match dada,/^\s*$/
        lines.push dada
        source.push "#{ffn}:#{frow}"

  freader fn

  do_cmd = (line,extra_ind) ->
    ret=""
    ind+=extra_ind
    if infunc and i[row+1]==0 and not incond[ind-1] #last line of function
      if not match line,/^\s*return/
        #puts "***********LAST LINE****************, not return! #{incond[ind-1]} #{line}"
        ret="return "
    if line==""
      console.log "crap '#{line}'"
    else if hit=match line,/^([a-zA-Z_]+)\s+(.+)$/
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
    ind-=extra_ind

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
    line=replace line, /\sand\s/," && " #this needs to be done only on operands -- not identifiers, not strings
    line=replace line, /\sor\s/," || "
    line=replace line, /\snot\s/," ! "

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
  suspend=false
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
            emit "}",""
            incond[ii]=false

    if suspend
      console.log "suspended #{line}"
      emit(line,line)
      continue
    if hit=match line,/^#pragma\s+(no_)*koffee\s*$/
      console.log "PRAGMAA!! #{hit[1]}"
      if not hit[1]
        suspend=false
        intofunc=false
      else
        suspend=true
      console.log "PRAGMAA!! #{hit[1]} -> #{suspend}"

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
        #puts "struct #{instruct}"
        emit "typedef struct {",line
      else
        console.log "Error: Struct must not be indented"
    else if hit=match line,/^for\s+(.+)\s*$/
      incond[ind]="for"
      rest=hit[1]
      #console.log "foooor"
      if hit=match rest,/^(.+)\s+in\s+\[(.+)\.\.(.+)\]\s+by\s+(.+)\s*$/
        #console.log "range !!",hit
        v=hit[1]
        s=hit[2]
        e=hit[3]
        step=hit[4]
        rest="#{v}=(#{s});#{v}<(#{e});#{v}+=(#{step})"
      else if hit=match rest,/^(.+)\s+in\s+\[(.+)\.\.(.+)\]\s*$/
        #console.log "range !!",hit
        v=hit[1]
        s=hit[2]
        e=hit[3]
        rest="#{v}=(#{s});#{v}<(#{e});#{v}+=1"
      emit "for (#{rest}) {",line
    else if hit=match line,/^while\s+(.+)\s*$/
      incond[ind]="while"
      rest=hit[1]
      #puts "incodition"
      emit "while (#{rest}) {",line
    else if hit=match line,/^(.+)\s+if\s+(.+)\s+then\s+(.+)\s+else\s+(.+)\s*/
      res=hit[1]
      cond=hit[2]
      f=hit[3]
      s=hit[4]
      #puts "tripla #{cond},#{f},#{s}"
      emit "#{res} (#{cond}) ? (#{f}) : (#{s});",line
    else if hit=match line,/^(.+)\s+if\s+(.+)\s*/
      res=hit[1]
      cond=hit[2]
      #puts "if lopussa #{cond},#{res}"
      emit "if (#{cond}) {",line
      do_cmd(res,1)
      #emit "  #{res}; ",""
      emit "}",
    else if hit=match line,/^(.+)\s+while\s+(.+)\s*/
      res=hit[1]
      cond=hit[2]
      #puts "if lopussa #{cond},#{res}"
      emit "while (#{cond}) {",line
      do_cmd(res,1)
      emit "}",
    else if hit=match line,/^(.+)\s+until\s+(.+)\s*/
      res=hit[1]
      cond=hit[2]
      #puts "if lopussa #{cond},#{res}"
      emit "while (! (#{cond})) {",line
      do_cmd(res,1)
      emit "}",
    else if hit=match line,/^switch\s+(.+)\s*$/
      incond[ind]="switch"
      rest=hit[1]
      #puts "incodition"
      emit "switch (#{rest}) {",line
    else if hit=match line,/^when\s+(.+)\s+then\s+(.+)\s*$/
      rest=hit[1]
      emit "case (#{hit[1]}):",line
      do_cmd(hit[2],1)
      emit "  break;",""
    else if incond[ind-1]=="switch" and hit=match line,/^else\s(.+)\s*$/
      emit "default:",line
      do_cmd(hit[1],1)
      emit "  break;",""
    else if hit=match line,/^if\s+(.+)\s*$/
      incond[ind]="if"
      rest=hit[1]
      #puts "incodition"
      emit "if (#{rest}) {",line
    else if incond[ind]=="if" and hit=match line,/^else\s+if\s*(.+)\s*$/
      rest=hit[1]
      #puts "incodition continues"
      emit "} else if (#{rest}) {",line
    else if incond[ind]=="if" and hit=match line,/^else\s*$/
      rest=hit[1]
      #puts "incodition continues "
      emit "} else {",line

    else if hit=match line,/^([a-zA-Z_]+\s+)*([a-zA-Z_]+)\s+((?:[\*]{0,1}\s*)[a-zA-Z_][a-zA-Z_0-9]*)(?:(\[.*\])){0,1}\s*(?:=\s*(.*)){0,1}\s*$/
      #variable declaration OR function start
      typep=hit[1]||""
      type=hit[2]
      sym=hit[3]
      dim=hit[4]||""
      init=hit[5]
      args=false
      if init and ind==0 and hit=match init,/^\s*\((.*)\)\s*->/ #function decl
        args=hit[1]
        init=""
        intofunc=true
      if intofunc
        emit "#{typep}#{type} #{sym}(#{args}) {",line
        infunc=sym
      else if init
        emit "#{typep}#{type} #{sym}#{dim}=",line
        do_cmd(init,1)
      else
        emit "#{typep}#{type} #{sym}#{dim};",line
    else
      #puts "CCCCCCCCCCCCCCc command???"
      do_cmd(line,0)
    row+=1
    oind=ind

  if not cfn
    return c
  fs.writeFileSync cfn, c
  if not target
    return cfn

  cc="gcc -I /usr/local/include/koffeescript #{cfn} -o #{target}"
  #puts cc
  child = exec cc,  (error, stdout, stderr) ->
    #puts stdout
    errs=stderr.split("\n")
    fail=false
    fails=[]
    for e in errs
      if match e,/error:/
        fail=true
        fails.push e
    if not fail
      exports.runner(target)
      return true
    else
      console.log "********************* FAILED"
      rn=1
      for r in c.split("\n")
        console.log "#{rn}:#{r}"
        rn+=1
      console.log cc
      for f in fails
        console.log f
      return false

