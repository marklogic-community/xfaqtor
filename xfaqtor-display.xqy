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

module "http://www.w3.org/2003/05/xpath-functions"

import module "http://www.w3.org/2003/05/xpath-functions" at "xfaqtor-lib.xqy"

define function print-go-home() as element()
{
  <div class="go-home">
    <a href="default.xqy">Return to the main listing</a></div>
}

define function print-go-admin() as element()
{
  <div class="go-admin">
    <a href="admin.xqy">Return to the admin listing</a></div>
}

define function print-intro() as element()
{
  (
  <h1 class="title">xfaqtor</h1>,
  <p class="intro">This FAQ is powered by Content Interaction Server.</p>
  )
}

define function print-search() as element()
{
  <form action="search.xqy" class="search-box">
    <input type="text" name="q"/>
    <input type="submit" value="Search"/>
  </form>
}

define function print-category($cat as xs:string) as element()
{
  <span>
    <h1>{$cat}</h1>
    {
      for $entry in get-sorted-live-entries($cat)
      return print-entry($entry)
    }
	<p class="return"><a href="#top">Return to top</a></p>
  </span>
}

(: Takes element(question) and element(answer) :)
define function is-new($item as element()) as xs:boolean
{
  let $threshold := xdt:dayTimeDuration("PT12H")
  let $threshold-moment := current-dateTime() - $threshold
  return xs:dateTime($item/date) > $threshold-moment
}

define function print-entry($entry as element(entry)) as element()
{
  let $question := $entry/question
  let $live-answers := $entry/answer[state = "live"]
  return
  <span xml:space="preserve">
  <dl class="xfaq">
    <dt>
	    {if (is-new($question)) then <span>New!</span> else ()}
	    {print-preserving($question/text/text())}
	  </dt>
    {
      for $answer in $live-answers
      return <dd>{if (is-new($answer)) then <span>New! </span> else ()}
                 {print-preserving($answer/text/text())}
      </dd>
    }
  </dl>
  <p class="add-answer">
    <a href="add-answer.xqy?questid={$question/@id}">Submit a new answer</a>
  </p>
  </span>
}


define function print-state-select-all($name as xs:string,
                                       $starter as xs:string) as element(select)
{
  let $sel := <x selected="selected"/>/@selected
  return
  <select name="{$name}">
    <option>
      { if ($starter = "all") then $sel else () } all
    </option>
    <option>
      { if ($starter = "submitted") then $sel else () } submitted
    </option>
    <option>
      { if ($starter = "live") then $sel else () } live
    </option>
    <option>
      { if ($starter = "dead") then $sel else () } dead
    </option>
  </select>
}

define function print-state-select($name as xs:string,
                                   $starter as xs:string) as element(select)
{
  let $sel := <x selected="selected"/>/@selected
  return
  <select name="{$name}">
    <option>
      { if ($starter = "submitted") then $sel else () } submitted
    </option>
    <option>
      { if ($starter = "live") then $sel else () } live
    </option>
    <option>
      { if ($starter = "dead") then $sel else () } dead
    </option>
  </select>
}

define function limit-string($str as xs:string, $max as xs:integer) as xs:string
{
  if (string-length($str) > $max) then
    concat(substring($str, 0, $max), "...")
  else
    $str
}

define function print-admin-entry($entry as element(entry),
                                  $states as xs:string*)
as element()
{
  (: print the question regardless of state :)
  <dl>
  <dt>{ print-admin-question($entry/question) }</dt>
  {
    for $answer in $entry//answer[state = $states]
    return <dd>{print-admin-answer($answer)}</dd>
  }
  <dd><a href="add-answer.xqy?questid={$entry/question/@id}">Submit a new answer</a></dd>
  </dl>
}

define function print-admin-question($question as element(question))
as element()
{
  let $id := data($question/@id)
  let $str := limit-string(string($question/text/text()), 80)
  return
  <div class="{$question/state/text()}">
  <a href="admin-question.xqy?questid={$id}">Question {$id}</a>: { $str }
  </div>
}

define function print-admin-answer($answer as element(answer))
as element()
{
  let $id := data($answer/@id)
  let $str := limit-string(string($answer/text/text()), 80)
  return
  <div class="{$answer/state/text()}">
  <a href="admin-answer.xqy?ansid={$id}">Answer {$id}</a>: { $str }
  </div>
}


define function print-preserving($texts as text()*) as item()*
{
  print-preserve-code(string-join($texts, ""))
}

define function print-preserve-code($str as xs:string) as item()*
{
  let $before-begin := substring-before($str, "<code>")
  let $after-begin := substring-after($str, "<code>")
  return
    if ($before-begin = "" and $after-begin = "")
    then preserve-newlines($str)
    else
  let $middle := substring-before($after-begin, "</code>")
  let $middle := if ($middle = "") then $after-begin else $middle
  let $after-end := substring-after($after-begin, "</code>")
  return (preserve-newlines($before-begin),
          <pre>{$middle}</pre>,
          print-preserve-code($after-end))
}

define function preserve-newlines($str as xs:string) as node()*
{
  for $line in tokenize($str, "\n")
  return ($line, <br/>)
}

