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
  let $ansid := xdmp:get-request-field("ansid")
  let $text := xdmp:get-request-field("text")
  let $state := xdmp:get-request-field("state", "")

  let $cancel := xdmp:get-request-field("cancel")
  return

  (: Do some input data checking :)
  if ($cancel) then
    xdmp:redirect-response("admin.xqy")
  else if ($ansid = "") then
    <span>
      <div class="error">The 'ansid' parameter is missing</div>
      { print-go-home() }
    </span>
  else if (not($ansid castable as xs:integer)) then
    <span>
      <div class="error">The 'ansid' parameter must be an integer</div>
      { print-go-admin() }
    </span>
  else if (normalize-space($text) = "") then
    <span>
      <div class="error">No answer text provided</div>
      { print-go-admin() }
    </span>
  else if (not($state = ("submitted", "live", "dead"))) then
    <span>
      <div class="error">State '{$state}' unknown</div>
      { print-go-admin() }
    </span>
  else

  let $answer := get-answer(xs:integer($ansid))
  return

  if (empty($answer)) then
    <span>
      <div class="error">Answer id '{ $ansid }' unknown</div>
      { print-go-admin() }
    </span>
  else

  let $chg := change-answer($answer, $text, $state)
  return
  <span>
    <div class="action-explain">
      Your changes have been made.
    </div>
    { print-go-admin() }
  </span>
}


<!-- @EndEditable -->
</body>
</html>
