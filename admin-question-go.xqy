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
  let $text := xdmp:get-request-field("text")

  (: Get the old category, then try getting the new category with the first :)
  (: value acting as a fallback default. :)
  let $category := xdmp:get-request-field("old-category", "")
  let $category :=
    if ($category = "") then
      xdmp:get-request-field("new-category", "")
    else
      $category
  let $questid := xdmp:get-request-field("questid")
  let $state := xdmp:get-request-field("state", "")

  let $cancel := xdmp:get-request-field("cancel")
  return

  (: Do some input data checking :)
  if ($cancel) then
    xdmp:redirect-response("admin.xqy")
  else if ($category = "") then 
    <span>
      <div class="error">No category provided</div>
      { print-go-admin() }
    </span>
  else if (normalize-space($text) = "") then
    <span>
      <div class="error">No question text provided</div>
      { print-go-admin() }
    </span>
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
      { print-go-admin() }
    </span>
  else
  
  let $chg := change-question($question, $category, $text, $state)
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
