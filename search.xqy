import module "http://www.w3.org/2003/05/xpath-functions" at "xfaqtor-lib.xqy"
import module "http://www.w3.org/2003/05/xpath-functions" at "xfaqtor-display.xqy"

xdmp:set-response-content-type("text/html"),

let $q := xdmp:get-request-field("q")
let $entries := search-entries($q)

return


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

<form action="search.xqy">
  <input type="text" name="q" value="{$q}"/>
  <input type="submit" value="Search"/>
</form>

{ print-go-home() }

<hr />
<h2>Search results for "{ $q }":</h2>

{
  if (empty($entries)) then <div class="error">No entries</div> else
  for $entry in $entries
  return print-entry($entry)
}


<!-- @EndEditable -->
</body>
</html>
