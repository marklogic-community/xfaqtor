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


{ print-intro() }

<a name="top"></a>
{ print-search() }

<p>
<a href="add-question.xqy">Submit a new question</a>
</p>

{
  (: We could also have logic to display a single category :)
  let $names := get-live-category-names()
  return
  if (empty($names)) then
    <div class="error">No 'live' entries yet</div>
  else
    for $cat in $names
    return print-category($cat)
}



<!-- @EndEditable -->
</body>
</html>
