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


<h1 class="title">Provide an answer.</h1>

{
  let $questid := xdmp:get-request-field("questid")
  let $text := xdmp:get-request-field("text")

  let $cancel := xdmp:get-request-field("cancel")
  return

  (: Do some input data checking :)
  if ($cancel) then
    xdmp:redirect-response("default.xqy")
  else if ($questid = "") then
    <span>
      <div class="error">The 'questid' parameter is missing</div>
      { print-go-home() }
    </span>
  else if (not($questid castable as xs:integer)) then
    <span>
      <div class="error">The 'questid' parameter must be an integer</div>
      { print-go-home() }
    </span>
  else if (normalize-space($text) = "") then
    <span>
      <div class="error">No answer text provided</div>
      { print-go-home() }
    </span>
  else
  
  let $question := get-question(xs:integer($questid))
  return
  
  if (empty($question)) then
    <span>
      <div class="error">Question id '{ $questid }' unknown</div>
      { print-go-home() }
    </span>
  else
  
  let $add := add-answer($question, $text)
  return

  <span>
    <div class="action-explain">
      Your answer has been recorded.  After administrator review it will be 
      posted on the live site.
    </div>
    { print-go-home() }
  </span>
}

<!-- @EndEditable -->
</body>
</html>
