.. _zend.escaper.theory-of-operation:

Theory of Operation
===================

``Zend\Escaper`` provides methods for escaping output data, dependent on the context in which the data will be used.
Each method is based on peer-reviewed rules and is in compliance with the current OWASP recommendations.

The escaping follows a well known and fixed set of encoding rules for each key HTML context, which are defined by
OWASP. These rules cannot be impacted or negated by browser quirks or edge-case HTML parsing unless the browser 
suffers a catastrophic bug in it's HTML parser or Javascript interpreter - both of these are unlikely.

The contexts in which ``Zend\Escaper`` should be used are **HTML Body**, **HTML Attribute**, **Javascript**, **CSS**
and **URL/URI** contexts.

.. _zend.escaper.theory-of-operation.problem-with-inconsistent-functionality

The Problem with Inconsistent Functionality
-------------------------------------------

At present, programmers orient towards the following PHP functions for each common HTML context:

 - **HTML Body**: htmlspecialchars() or htmlentities()
 - **HTML Attribute**: htmlspecialchars() or htmlentities()
 - **Javascript**: addslashes() or json_encode()
 - **CSS**: n/a
 - **URL/URI**: rawurlencode() or urlencode()


In practice, these decisions appear to depend more on what PHP offers, and if it can be interpreted as offering 
sufficient escaping safety, than it does on what is recommended in reality to defend against XSS. While these 
functions can prevent some forms of XSS, they do not cover all use cases or risks and are therefore insufficient 
defenses.

Using htmlspecialchars() in a perfectly valid HTML5 unquoted attribute value, for example, is completely useless 
since the value can be terminated by a space (among other things) which is never escaped. Thus, in this instance, 
we have a conflict between a widely used HTML escaper and a modern HTML specification, with no specific function 
available to cover this use case. While it's tempting to blame users, or the HTML specification authors, escaping 
just needs to deal with whatever HTML and browsers allow.

Using addslashes(), custom backslash escaping or json_encode() will typically ignore HTML special characters such as
ampersands which may be used to inject entities into Javascript. Under the right circumstances, browser will convert
these entities into their literal equivalents before interpreting Javascript thus allowing attackers to inject 
arbitrary code.

Inconsistencies with valid HTML, insecure default parameters, lack of character encoding awareness, and misrepresentations
of what functions are capable of by some programmers - these all make escaping in PHP an unnecessarily convoluted 
quest.

To circumvent the lack of escaping methods in PHP, ``Zend\Escaper`` addresses the need to apply context-specific
escaping in web applications. It implements methods that specifically target XSS and offers programmers a tool to
secure their applications without misusing other inadequate methods, or using, most likely incomplete, home-grown
solutions.
