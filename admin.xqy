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

{
  let $state := xdmp:get-request-field("state", "all") (: default = all :)
  let $states :=
    if ($state = "all") then ("submitted", "live", "dead") else $state
  return
  
  <span>
    <form>
      Limit view to state: { print-state-select-all("state", $state) }
      <input type="submit" value="Change State"/>
    </form>
  
    {
      for $entry in get-entries-in-states($states)
      return print-admin-entry($entry, $states)
    }
  
    <a href="add-question.xqy">Submit a new question</a>
  </span>
}


<!-- @EndEditable -->
</body>
</html>
