XFAQTOR 1.0.0


WHAT IS XFAQTOR?

xfaqtor is an automated Frequently Asked Questions (FAQ) management tool
written in XQuery against the Mark Logic Content Interaction Server.  It has
support for keyword-based search, user-submitted questions and answers, state
management of questions and answers (submitted, live, dead), and a separate
admin console for managing states.  Consisting of about 1,000 lines of XQuery
code, it's a useful sample application for learning how to program in XQuery
-- while at the same time being robust enough to drive the FAQ at
http://xqzone.marklogic.com/xfaqtor.

Written in less than one man-day, this application is but a toy compared with
the types of applications you can write with XQuery on top of a content
database.  For a more real-world extension of this idea, imagine integrating
this FAQ with book materials, article archives, and knowledge base entries --
all pulled together into a common element store with a unified granular search
mechanism.


INSTALLING XFAQTOR

To install xfaqtor, copy the included files to an HTTP root under a Content
Interaction Server installation.  For example, on Windows you can copy the
files to C:\Program Files\Mark Logic CIS\Docs\xfaqtor, a subdirectory under
the default "Docs" server listening on port 8000.  With the files installed
you can access the application using the URLs:

http://localhost:8000/xfaqtor/default.xqy  (for the client view)
http://localhost:8000/xfaqtor/admin.xqy    (for the admin view)


ADDING QUESTIONS AND ANSWERS

On startup you won't see any questions or answers.  Click on the displayed
links to add a few questions.  Then you have to go to the admin page then to
see a listing of the submitted questions to mark them live.  Then go back to
the main listing and add an answer (or multiple) to each question.  Don't
forget to use the admin tool to make them live too.

Hint: You can use <code> tags around any code blocks in your questions or
answers to keep them from being reformatted.


EXAMING THE XFAQTOR DISPLAY CODE

When examining the xfaqtor code, start with default.xqy.  This page renders
the main listing.  Inside default.xqy you will see several HTML comments like
this:

<!-- @BeginEditable id="title" -->

You can ignore these.  They are part of the xq:zone templating mechanism.
When the xfaqtor source files are published to the live xq:zone site, these
tags help them get styled to match the xq:zone template.  They still work fine
without the templating, just with a simpler look and feel.

Within the <body> area you see XQuery calls to print-intro() and
print-search().  These functions are imported from the xfaqtor-display.xqy
library module (see the first two lines doing the import).  The rest of
default.xqy iterates over every "live category name" (categories for which
there's a live question) and prints each with a call to print-category() (also
from xfaqtor-display.xqy).

Within xfaqtor-display.xqy you see several no-argument print functions for
printing common components and some more advanced print functions that take an
argument and return a rendered version.  The functions toward the bottom get
more advanced with support for parsing the raw question and answer strings for
<code> instances to convert them to <code> elements.

The search.xqy file looks similar to default.xqy except toward the top it
fetches the "q" parameter and uses search-entries() to execute the search.
You'll find search-entries() in xfaqtor-lib.xqy, the other library module.


EXAMINING THE XFAQTOR DATABASE CODE

The xfaqtor-lib.xqy file contains functions for interacting with the
underlying content database.  The next-id() function at the top manages the
unique id integers used as question and answer identifiers.  These come in
handy as query string parameters.  Within the function you can see the use of
document insertion and node replacement calls.

The get-xxx() calls execute XPath statements to return nodes matching a given
criteria.

The search-xxx() calls expose different search capabilities (not all of which
are exposed to the user, that's an exercise left to the reader).

The add-xxx() and change-xxx() calls support the addition and editing of
questions and answers and manage the database insert and replace calls
necessary to persist any changes.

The delete-xxx() functions show how you'd manage deletes, but for safety they
aren't exposed even via the admin function.  Bogus entries can simply be
marked "dead" to suppress display.


DEPLOYING XFAQTOR

To deploy xfaqtor on http://xqzone.marklogic.com/xfaqtor/, we placed the
client files under the HTTP server for port 80.  The admin files are on
another port, protected behind a password.  If deploying in a private
workgroup, you wouldn't necessarily need the split.


FUTURE DIRECTIONS

Two basic features missing in xfaqtor are the ability to bulk load questions
and answers and to reorder existing questions and answers.  We'll add these
eventually because we'll need them on xq:zone, but perhaps someone else wants
to take a crack at it?  The code is open source under the Apache 2.0 license.

Bulk loading should be fairly simple.  Design a web form that allows you to
enter multiple questions and answers, and write a simple handler that fetches
the submitted data and uses the calls in xfaqtor-lib.xqy to enter the content.

Adding reordering will require more comprehensive changes.  You'll need to
design a mechanism to indicate relative order in the XML document (perhaps a
priority attribute) and to conveniently let the orders be reassigned (perhaps
using a numbered listing with editable numbers).  The order can be applied by
changing the "order by" predicate in get-sorted-live-entries() to use the
priority number instead of the date field.


Best of luck!  Join the general@xqzone mailing list to keep up with the
latest.
