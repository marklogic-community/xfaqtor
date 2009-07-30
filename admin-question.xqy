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
xquery version "1.0-ml";
import module namespace xfl = "http://www.marklogic.com/xfaqtor-lib" at "xfaqtor-lib.xqy";
import module namespace xfd = "http://www.marklogic.com/xfaqtor-display" at "xfaqtor-display.xqy";

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
  let $questid := xdmp:get-request-field("questid")
  return

  (: Do some input data checking :)
  if ($questid = "") then
    <span>
      <div class="error">The 'questid' parameter is missing</div>
      { xfd:print-go-home() }
    </span>
  else if (not($questid castable as xs:integer)) then
    <span>
      <div class="error">The 'questid' parameter must be an integer</div>
      { xfd:print-go-home() }
    </span>
  else

  let $question := xfl:get-question(xs:integer($questid))
  return

  if (empty($question)) then
    <span>
      <div class="error">Question id '{ $questid }' unknown</div>
      { xfd:print-go-admin() }
    </span>
  else

  <form action="admin-question-go.xqy" method="post" class="xfaq-ask">
    <input type="hidden" name="questid" value="{$questid}"/>
  
    <dl class="entrybox">
    <dt>Edit Question:</dt>
    <dd><textarea name="text" cols="40" rows="5">{$question/text/text()}</textarea></dd>
    </dl>
  
    <dl>
    <dt>Edit Category:</dt>
    {
      <dd>
      <select name="old-category">
        {
          for $cat in xfl:get-all-category-names()
          return
          <option>
            { if ($question/category = $cat) then $sel else () } {$cat}
          </option>
        }
      </select>
      </dd>
    }
    </dl>
    <dl>
    <dt>Or Create a New Category</dt>
    <dd><input type="text" name="new-category"/></dd>
    </dl>
  
    <dl>
    <dt>Edit Stat</dt>
    <dd> { xfd:print-state-select("state", $question/state) } </dd>
    </dl>
  
    <input type="submit" name="change" value="Change!"/>
    <input type="submit" name="cancel" value="Cancel"/>
  </form>
}


<!-- @EndEditable -->
</body>
</html>
