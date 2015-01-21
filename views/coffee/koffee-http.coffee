term=null
pause=false
init={}
ceditor=null
editor=null

stamp = () ->
  (new Date).getTime();

ajax_data = (data) ->
  console.log "ajax:",data
  if data.c
    ceditor.setValue data.c
    ceditor.clearSelection()
  $(".adata").html(data.now)

@ajax = (obj) ->
  console.log "doin ajax"
  $.ajax
    url: "/ajax"
    type: "GET"
    dataType: "json",
    contentType: "application/json; charset=utf-8",
    data: obj
    success: (data) ->
      ajax_data(data)
      return
    error: (xhr, ajaxOptions, thrownError) ->
      alert thrownError
      return

delta = (s) ->
  if s
    ((stamp()-s)/1000).toFixed(1)
  else
    100000000
buf=""


@ajax_form = (fn) ->
  console.log "formi!"
  data={}
  $("##{fn} :input").each () ->
    fn=[this.name]
    if fn and fn>""
      val=$(this).val();
      data[fn]=val
      console.log "#{fn}: #{val}"
  console.log ">",data
  ajax
    act: "options"
    data: data

update_form = () ->
  console.log "init",init
  dust.render "form_template", init.options, (err, out) ->
    if err
      console.log "dust:",err,out
    $("#form").html out

dust.helpers.age = (chunk, context, bodies, params) ->
  if t=params.t
    age=((stamp()-t)/1000).toFixed(1)
  else
    age=""
  return chunk.write age

old=""

myTimer = () ->
  n=editor.getValue()
  if n!=old
    ajax
      act: "compile"
      koffee: n

    old=n


jQuery ($, undefined_) ->
  #ajax
  #  send: "\nauth 1682\n"

  $("script[type='text/template']").each (index) ->
    console.log index + ": " + $(this).attr("id")
    dust.loadSource(dust.compile($("#"+$(this).attr("id")).html(),$(this).attr("id")))
    return

  editor = ace.edit("koffee");
  editor.setTheme("ace/theme/textmate")
  editor.session.setValue("")
  editor.getSession().setTabSize(2)
  editor.getSession().setUseSoftTabs(true)
  editor.clearSelection()
  editor.setOptions({fontSize: "9pt"})
  editor.setTheme("ace/theme/vibrant_ink");
  editor.setValue("""
//# Welcome to play with KoffeeScript:

//# Easy Structures:
struct rekordi
  int eka
  int toka

int *jepulis = (int arvo) ->
  &arvo

int main = (int argc,char** argv) ->
  printf "oujee\\n"
  int *p= jepulis "12"

  if argc>3
    printf "ok"
  else
    printf "blah"

  // Nice loops:
  for x in [0..7]
    printf "luuppi %d\\n",x
  for x in [0..7] by 2
    printf "luuppi %d\\n",x

  switch argc
    when 1 then printf "ok"
    when 2 then printf "not ok"
    else printf "blah"

  printf "argumentti hukassa\\n" if argc<2

  printf "jee %d\\n",i while i<20

  0 // Note: last statement is return value!

//# You can even use raw-C:
#pragma no_koffee
int raakaa=12;
char **s;
#pragma koffee

""")
  editor.clearSelection()
  editor.gotoLine(0)
  editor.focus(0)
  editor.getSession().setMode("ace/mode/coffee");
  #editor.session.$mode.$highlightRules.setKeywords({"keyword": "struct|bar|baz"})

  ceditor = ace.edit("cee");
  ceditor.setTheme("ace/theme/textmate")
  ceditor.session.setValue("")
  ceditor.getSession().setTabSize(2)
  ceditor.getSession().setUseSoftTabs(true)
  ceditor.clearSelection()
  ceditor.gotoLine(0)
  ceditor.setOptions({fontSize: "9pt"})
  ceditor.setTheme("ace/theme/vibrant_ink");
  ceditor.getSession().setMode("ace/mode/c_cpp");

  setInterval(->
    myTimer()
    return
  , 1000)


  console.log "ok"

