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


<h1 class="title">Ask a Question</h1>

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
  
  let $cancel := xdmp:get-request-field("cancel")
  return

  (: Do some input data checking :)
  if ($cancel) then
    xdmp:redirect-response("default.xqy")
  else if ($category = "") then 
    <span>
      <div class="error">No category provided</div>
      { print-go-home() }
    </span>
  else if (normalize-space($text) = "") then
    <span>
      <div class="error">No question text provided</div>
      { print-go-home() }
    </span>
  else

  let $add := add-question($category, $text)
  return

  <span>
    <div class="action-explain">
      Your question has been recorded.  After administrator review it will be
      posted on the live site.
    </div>
    { print-go-home() }
  </span>
}

<!-- @EndEditable -->
</body>
</html>
