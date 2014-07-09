.. _learning.view.placeholders.standard:

Standard Placeholders
=====================

In the :ref:`previous section <learning.view.placeholders.basics>`, we learned about the ``placeholder()`` view
helper, and how it can be used to aggregate custom content. In this section, we'll look at some of the concrete
placeholders shipped with Zend Framework, and how you can use them to your advantage when creating complex
composite layouts.

Most of the shipped placeholders are for generating content for the **<head>** section of your layout content -- an
area you typically cannot manipulate directly via your application view scripts, but one you may want to influence.
As examples: you may want your title to contain certain content on every page, but specific content based on the
controller and/or action; you may want to specify *CSS* files to load based on what section of the application
you're in; you may need specific JavaScript scripts loaded at different times; or you may want to set the
**DocType** declaration.

Zend Framework ships with placeholder implementations for each of these situations, and several more.

.. _learning.view.placeholders.standard.doctype:

Setting the DocType
-------------------

**DocType** declarations are troublesome to memorize, and often essential to include in your document to ensure the
browser properly renders your content. The ``doctype()`` view helper allows you to use simple string mnemonics to
specify the desired **DocType**; additionally, other helpers will query the ``doctype()`` helper to ensure the
output generated conforms with the requested **DocType**.

As an example, if you want to use the *XHTML1* Strict *DTD*, you can simply specify:

.. code-block:: php
   :linenos:

   $this->doctype('XHTML1_STRICT');

Among the other available mnemonics, you'll find these common types:

**XHTML1_STRICT**
   *XHTML* 1.0 Strict

**XHTML1_TRANSITIONAL**
   *XHTML* 1.0 Transitional

**HTML4_STRICT**
   *HTML* 4.01 Strict

**HTML4_Loose**
   *HTML* 4.01 Loose

**HTML5**
   *HTML* 5

You can assign the type and render the declaration in a single call:

.. code-block:: php
   :linenos:

   echo $this->doctype('XHTML1_STRICT');

However, the better approach is to assign the type in your bootstrap, and then render it in your layout. Try adding
the following to your bootstrap class:

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend\Application\Bootstrap\Bootstrap
   {
       protected function _initDocType()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');
       }
   }

Then, in your layout script, simply ``echo()`` the helper at the top of the file:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <!-- ... -->

This will ensure that your DocType-aware view helpers render the appropriate markup, ensure that the type is set
well before the layout is rendered, and provide a single location to change the DocType.

.. _learning.view.placeholders.standard.head-title:

Specifying the Page Title
-------------------------

Often, a site will include the site or business name as part of the page title, and then add additional information
based on the location within the site. As an example, the ``zend.com`` website includes the string "``Zend.com``"
on all pages, and the prepends information based on the page: "Zend Server -``Zend.com``". Within Zend Framework,
the ``headTitle()`` view helper can help simplify this task.

At its simplest, the ``headTitle()`` helper allows you to aggregate content for the **<title>** tag; when you echo
it, it then assembles it based on the order in which segments are added. You can control the order using
``prepend()`` and ``append()``, and provide a separator to use between segments using the ``setSeparator()``
method.

Typically, you should specify any segments common to all pages in your bootstrap, similar to how we define the
doctype. In this case, we'll define a ``_initPlaceholders()`` method for operating on all the various placeholders,
and specify an initial title as well as a separator.

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend\Application\Bootstrap\Bootstrap
   {
       // ...

       protected function _initPlaceholders()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');

           // Set the initial title and separator:
           $view->headTitle('My Site')
                ->setSeparator(' :: ');
       }

       // ...
   }

Within a view script, we might want to add another segment:

.. code-block:: php
   :linenos:

   <?php $this->headTitle()->append('Some Page'); // place after other segments ?>
   <?php $this->headTitle()->prepend('Some Page'); // place before ?>

In our layout, we will simply echo the ``headTitle()`` helper:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <?php echo $this->headTitle() ?>
       <!-- ... -->

This will generate the following output:

.. code-block:: html
   :linenos:

   <!-- If append() was used: -->
   <title>My Site :: Some Page</title>

   <!-- If prepend() was used: -->
   <title>Some Page :: My Site</title>

.. _learning.view.placeholders.standard.head-link:

Specifying Stylesheets with HeadLink
------------------------------------

Good *CSS* developers will often create a general stylesheet for sitewide styles, and individual stylesheets for
specific sections or pages of the website, and load these latter conditionally so as to decrease the amount of data
needing to be transferred on each request. The ``headLink()`` placeholder makes such conditional aggregation of
stylesheets trivial within your application.

To accomplish this, ``headLink()`` defines a number of "virtual" methods (via overloading) to make the process
trivial. The ones we will be concerned with are ``appendStylesheet()`` and ``prependStylesheet()``. Each takes up
to four arguments, ``$href`` (the relative path to the stylesheet), ``$media`` (the *MIME* type, which defaults to
"text/css"), ``$conditionalStylesheet`` (which can be used to specify a "condition" under which the stylesheet will
be evaluated), and ``$extras`` (an associative array of key and value pairs, commonly used to specify a key for
"media"). In most cases, you will only need to specify the first argument, the relative path to the stylesheet.

In our example, we'll assume that all pages need to load the stylesheet located in "``/styles/site.css``" (relative
to the document root); we'll specify this in our ``_initPlaceholders()`` bootstrap method.

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend\Application\Bootstrap\Bootstrap
   {
       // ...

       protected function _initPlaceholders()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');

           // Set the initial title and separator:
           $view->headTitle('My Site')
                ->setSeparator(' :: ');

           // Set the initial stylesheet:
           $view->headLink()->prependStylesheet('/styles/site.css');
       }

       // ...
   }

Later, in a controller or action-specific view script, we can add more stylesheets:

.. code-block:: php
   :linenos:

   <?php $this->headLink()->appendStylesheet('/styles/user-list.css') ?>

Within our layout view script, once again, we simply echo the placeholder:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <?php echo $this->headTitle() ?>
       <?php echo $this->headLink() ?>
       <!-- ... -->

This will generate the following output:

.. code-block:: html
   :linenos:

   <link rel="stylesheet" type="text/css" href="/styles/site.css" />
   <link rel="stylesheet" type="text/css" href="/styles/user-list.css" />

.. _learning.view.placeholders.standard.head-script:

Aggregating Scripts Using HeadScript
------------------------------------

Another common tactic to prevent long page load times is to only load JavaScript when necessary. That said, you may
need several layers of scripts: perhaps one for progressively enhancing menus on the site, and another for
page-specific content. In these situations, the ``headScript()`` helper presents a solution.

Similar to the ``headLink()`` helper, ``headScript()`` provides the ability to append or prepend scripts to the
collection, and then echo the entire set. It provides the flexibility to specify either script files themselves to
load, or explicit JavaScript. You also have the option of capturing JavaScript via
``captureStart()``/``captureEnd()``, which allows you to simply inline the JavaScript instead of requiring an
additional call to your server.

Also like ``headLink()``, ``headScript()`` provides "virtual" methods via overloading as a convenience when
specifying items to aggregate; common methods include ``prependFile()``, ``appendFile()``, ``prependScript()``, and
``appendScript()``. The first two allow you to specify files that will be referenced in a **<script>** tag's
``$src`` attribute; the latter two will take the content provided and render it as literal JavaScript within a
**<script>** tag.

In this example, we'll specify that a script, "``/js/site.js``" needs to be loaded on every page; we'll update our
``_initPlaceholders()`` bootstrap method to do this.

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend\Application\Bootstrap\Bootstrap
   {
       // ...

       protected function _initPlaceholders()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');

           // Set the initial title and separator:
           $view->headTitle('My Site')
                ->setSeparator(' :: ');

           // Set the initial stylesheet:
           $view->headLink()->prependStylesheet('/styles/site.css');

           // Set the initial JS to load:
           $view->headScript()->prependFile('/js/site.js');
       }

       // ...
   }

Within a view script, we might then add an extra script file to source, or capture some JavaScript to include in
our document.

.. code-block:: php
   :linenos:

   <?php $this->headScript()->appendFile('/js/user-list.js') ?>
   <?php $this->headScript()->captureStart() ?>
   site = {
       baseUrl: "<?php echo $this->baseUrl() ?>"
   };
   <?php $this->headScript()->captureEnd() ?>

Within our layout script, we then simply echo the placeholder, just as we have all the others:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <?php echo $this->headTitle() ?>
       <?php echo $this->headLink() ?>
       <?php echo $this->headScript() ?>
       <!-- ... -->

This will generate the following output:

.. code-block:: html
   :linenos:

   <script type="text/javascript" src="/js/site.js"></script>
   <script type="text/javascript" src="/js/user-list.js"></script>
   <script type="text/javascript">
   site = {
       baseUrl: "<?php echo $this->baseUrl() ?>"
   };
   </script>

.. note::

   **InlineScript Variant**

   Many browsers will often block display of a page until all scripts and stylesheets referenced in the **<head>**
   section have loaded. If you have a number of such directives, this can impact how soon somebody can start
   actually viewing the page.

   One way around this is to emit your **<script>** tags just prior to closing the **<body>** of your document.
   (This is a practice specifically recommend by the `Y! Slow project`_.)

   Zend Framework supports this in two different ways:

   - You can render your ``headScript()`` tag wherever you like in your layout script; just because the title
     references "head" does not mean it needs to be rendered in that location.

   - Alternately, you may use the ``inlineScript()`` helper, which is simply a variant on ``headScript()``, and
     retains the same behavior, but uses a separate registry.



.. _`Y! Slow project`: http://developer.yahoo.com/yslow/
