import module "http://www.w3.org/2003/05/xpath-functions" at "xfaqtor-lib.xqy"
import module "http://www.w3.org/2003/05/xpath-functions" at "xfaqtor-display.xqy"

xdmp:set-response-content-type("text/html"),

<html xml:space="preserve">
<!-- @Template href="/default.tmpl" -->
<head>
<link rel="stylesheet" type="text/css" href="style.css" />
<!-- @BeginEditable id="title" -->
<title>XFAQtor</title>
<!-- @EndEditable -->
</head>
<!-- @BeginEditable id="bodytagstart" -->
<body class="help">
<!-- @EndEditable -->

<!-- @BeginEditable id="body" -->


{
  let $sel := <x selected="selected"/>/@selected
  let $ansid := xdmp:get-request-field("ansid")
  return

  if ($ansid = "") then
    <span>
      <div class="error">The 'ansid' parameter is missing</div>
      { print-go-home() }
    </span>
  else if (not($ansid castable as xs:integer)) then
    <span>
      <div class="error">The 'ansid' parameter must be an integer</div>
      { print-go-admin() }
    </span>
  else

  let $answer := get-answer(xs:integer($ansid))
  return

  if (empty($answer)) then
    <span>
      <div class="error">Answer id '{ $ansid }' unknown</div>
      { print-go-home() }
    </span>
  else

  <form action="admin-answer-go.xqy" method="post" class="xfaq-answer">
    <input type="hidden" name="ansid" value="{$ansid}"/>

    <dl class="entrybox">
    <dt>Edit Answer:</dt>
    <dd><textarea name="text" cols="40" rows="5">{$answer/text/text()}</textarea></dd>
    </dl>
  
    <dl>
    <dt>Edit State:</dt>
    <dd> { print-state-select("state", $answer/state) } </dd>
    </dl>
  
    <input type="submit" name="change" value="Change!"/>
    <input type="submit" name="cancel" value="Cancel"/>
  </form>
}


<!-- @EndEditable -->
</body>
</html>
