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


<h1 class="title">Ask a Question</h1>
<p class="intro">Your question will be submitted to the FAQ editor before
  posting.</p>

<form action="add-question-go.xqy" method="get" class="xfaq-ask">
  <dl class="entrybox">
  <dt>Your Question:</dt>
  <dd><textarea name="text" cols="40" rows="5"> </textarea></dd>
  </dl>

  <dl>
  <dt>Choose a Category:</dt>
  {
    <dd>
    <select name="old-category">
      <option value="">Choose a Category</option>
      {
        for $cat in get-live-category-names()
        return <option>{$cat}</option>
      }
    </select>
    </dd>
  }
  </dl>

  <dl>
  <dt>Or Create a New Category</dt>
  <dd><input type="text" name="new-category"/></dd>
  </dl>
 
  <input type="submit" name="ask" value="Ask!"/>
  <input type="submit" name="cancel" value="Cancel"/>
</form>

  <p class="intro">Hint: Use &lt;code&gt; tags around code blocks for better
    formatting.</p>



<!-- @EndEditable -->
</body>
</html>
