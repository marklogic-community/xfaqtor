(:
 : Copyright (c) 2004 Mark Logic Corporation
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 : http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :
 : The use of the Apache License does not indicate that this project is
 : affiliated with the Apache Software Foundation.
 :)

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
