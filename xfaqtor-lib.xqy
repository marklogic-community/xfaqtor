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

(: Return a monotonically increasing integer (xs:integer) value.              
   Store the value in the root node of doc("ids.xml").                   
   You could enhance this file to store IDs for multiple uses.          
   Logic is to fetch the current id, add one if it exists or assign the
   value to one if it doesn't yet exist, then replace or insert the new
   value before returning it.
:)
define function next-id() as xs:integer
{
  let $id := doc("ids.xml")/id
  let $next-val :=
    if ($id castable as xs:integer) then xs:integer($id) + 1
    else 1
  let $next-node := <id>{$next-val}</id>
  let $insert :=
    if ($id) then xdmp:node-replace($id, $next-node)
    else xdmp:document-insert("ids.xml", $next-node)
  return $next-val
}


(: Return all category strings. :)
define function get-live-category-names() as xs:string*
{
  for $s in distinct-values(input()//question[state="live"]/category)
  return xs:string($s)
}

define function get-all-category-names() as xs:string*
{
  for $s in distinct-values(input()//question/category)
  return xs:string($s)
}

define function get-sorted-live-entries($category as xs:string)
as element(entry)*
{
  for $entry in input()/entry[question/state="live"]
                             [question/category = $category]
  order by xs:dateTime($entry/question/date)
  return $entry
}


(: Search for a word or phrase across all live question text blocks,
   then return the containing <question> element.
:)
define function search-questions($phrase as xs:string)
as element(question)*
{
  cts:search(input()//question[state = "live"]/text, $phrase)[1 to 20]
    /ancestor::question
}

(: Similar to the above but using a more advanced search form to query
   against live answers.
:)
define function search-answers($phrase as xs:string)
as element(answer)*
{
  cts:search(input()//answer[state = "live"],
             cts:element-word-query(xs:QName("text"), $phrase))[1 to 20]
}

(: Search for a word or phrase across all live questions or answers.
   The returned values are relevance ranked.  The results have a numeric
   "score" but here we're not utilizing it.  We just return the containing
   <entry> element.
:)
define function search-entries($phrase as xs:string)
as element(entry)*
{
  cts:search(input()//*[state = "live"],
             cts:element-word-query(xs:QName("text"), $phrase))[1 to 20]
      /ancestor::entry
}


define function get-question($id as xs:integer) as element(question)?
{
  input()//question[@id = $id]
}

define function get-answer($id as xs:integer) as element(answer)?
{
  input()//answer[@id = $id]
}


define function get-entries-in-categories($categories as xs:string*)
as element(entry)*
{
  input()/entry[question/category = $categories][question/state = "live"]
}


define function get-entries-in-states($state as xs:string*)
as element(entry)*
{
  input()/entry[question/state = $state or answer/state = $state]
}




define function add-question($category as xs:string,
                             $text as xs:string) as element(question)
{
  if ($text = "") then error("Add question called with empty text") else
  let $next-id := next-id()
  let $new-question :=
    <question id="{$next-id}">
      <category>{$category}</category>
      <state>submitted</state>
      <date>{current-dateTime()}</date>
      <text xml:space="preserve">{$text}</text>
    </question>
  let $insert := xdmp:document-insert(
                         concat("question-", xs:string($next-id)),
                         <entry>{$new-question}</entry>)
  return $new-question
}

define function change-question($question as element(question),
                                $category as xs:string,
                                $text as xs:string,
                                $state as xs:string) as element(question)
{
  if ($text = "") then error("Change question called with empty text") else
  if (not($state = ("submitted", "live", "dead"))) then error("No state") else
  let $new-question :=
    <question>
      { $question/@id, $question/category }
      <state>{ $state }</state>
      { $question/date }
      <text xml:space="preserve">{$text}</text>
    </question>
  let $replace := xdmp:node-replace($question, $new-question)
  return $new-question
}


define function add-answer($question as element(question),
                           $text as xs:string) as element(answer)
{
  if ($text = "") then error("Add answer called with empty text") else
  let $new-answer :=
    <answer id="{next-id()}">
      <state>submitted</state>
      <date>{current-dateTime()}</date>
      <text xml:space="preserve">{$text}</text>
    </answer>
  let $insert := xdmp:node-insert-child($question/.., $new-answer)
  return $new-answer
}

define function change-answer($answer as element(answer),
                              $text as xs:string,
                              $state as xs:string) as element(answer)
{
  if ($text = "") then error("Change answer called with empty text") else
  let $new-answer :=
    <answer>
      { $answer/@id }
      <state>{$state}</state>
      { $answer/date }
      <text xml:space="preserve">{$text}</text>
    </answer>
  let $replace := xdmp:node-replace($answer, $new-answer)
  return $new-answer
}



(:
 - - - - - Destructive calls below here - - - - -
 - - - - - These shouldn't be exposed in normal use of the app - - - - -
:)

define function delete-entries($entries as element(entry)*)
{
  for $entry in $entries
  return xdmp:node-delete($entry)
}

define function delete-answers($answers as element(answer)*)
{
  for $a in $answers
  return xdmp:node-delete($a)
}

