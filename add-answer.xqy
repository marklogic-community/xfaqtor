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


<h1 class="title">Provide an answer. </h1>
<p class="intro">Your question will be submitted to the FAQ editor before
  posting.</p>

{
  let $questid := xdmp:get-request-field("questid")
  return

  (: Do some input data checking :)
  if ($questid = "") then
    <span>
      <div class="error">The 'questid' parameter is missing</div>
      { print-go-home() }
    </span>
  else if (not($questid castable as xs:integer)) then
    <span>
      <div class="error">The 'questid' parameter must be an integer</div>
      { print-go-home() }
    </span>
  else

  let $question := get-question(xs:integer($questid))
  return

  <span>
    <dl class="xfaq"><dt>{$question/text/text()}</dt></dl>
    <form action="add-answer-go.xqy" class="xfaq-answer">
      <input type="hidden" name="questid" value="{$questid}"/>
      <dl class="entrybox">
      <dt>Your answer:</dt>
      <dd><textarea name="text" cols="40" rows="5"> </textarea></dd>
      </dl>
    
      <input type="submit" name="answer" value="Answer!"/>
      <input type="submit" name="cancel" value="Cancel"/>
    </form>
  </span>
}

<p class="intro">Hint: Use &lt;code&gt; tags around code blocks for better
  formatting.</p>


<!-- @EndEditable -->
</body>
</html>
