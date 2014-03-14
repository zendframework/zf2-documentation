.. _zend.view.helpers.initial.url:

View Helper - URL
=================

The URL-ViewHelper is used to create a string representation of the routes that you define within your application. The
syntax for the ViewHelper is ``$this->url($name, $params, $options, $reuseMatchedParameters)`` and is
to be understood in the following manner:

- ``$name``: The name of the route you want to output
- ``$params``: An array of parameters that is defined within the respective route configuration
- ``$options``: An array of options that will be used to create the url
- ``$reuseMatchedParams``: defines if current matched parameters of the route should be used to create the new url

Let's take a look at how this ViewHelper is used in real world applications:

.. _zend.view.helpers.initial.url.basicusage:

Basic Usage
-----------

The following example shows a simple configuration for a news module. The route is called ``news`` and it has two 
**optional** parameters called ``action`` and ``id``.

.. code-block:: php
   :linenos:

   // In a configuration array (e.g. returned by some module's module.config.php)
   'router' => array(
       'routes' => array(
           'news' => array(
               'type'    => 'segment',
               'options' => array(
                   'route'       => '/news[/:action][/:id]',
                   'constraints' => array(
                       'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                   ),
                   'defaults' => array(
                       'controller' => 'news',
                       'action'     => 'index',
                   ),
               )
           )
       )
   ),

First, let's use the ViewHelper to create the output for the url ``/news`` without any of the optional parameters 
being used

.. code-block:: html
   :linenos:

   <a href="<?php echo $this->url('news');?>">News Index</a>

This will render the output:

.. code-block:: html
   :lineos:
   
   <a href="/news">News Index</a>
   
Now let's assume we want to get a link to display the detail page of a single news entry. For this task the optional 
parameters ``action`` and ``id`` need to have values assigned. This is how you do it:

.. code-block:: html
   :lineos:
   
   <a href="<?php echo $this->url('news', array('action' => 'details', 'id' =>42));?>">Details of News #42</a>
   
This will render the output:

.. code-block:: html
   :lineos:
   
   <a href="/news/details/42">News Index</a>
   
.. _zend.view.helpers.initial.url.queryparams:

Query Parameters
----------------

Following SEO rules it is not a good trait to put pagination parameters into the route, for example the following
URL would be considered a bad practise ``/news/archive/page/13``, instead of putting the pagination parameter into the
route it'd be better to have it set as a query parameter like this ``/news/archive?page=13``. To achieve this you'll 
need to make use of the ``$options`` parameter from the ViewHelper.

We will use the same route configuration as showcased above:


.. code-block:: php
   :linenos:

   // In a configuration array (e.g. returned by some module's module.config.php)
   'router' => array(
       'routes' => array(
           'news' => array(
               'type'    => 'segment',
               'options' => array(
                   'route'       => '/news[/:action][/:id]',
                   'constraints' => array(
                       'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                   ),
                   'defaults' => array(
                       'controller' => 'news',
                       'action'     => 'index',
                   ),
               )
           )
       )
   ),
   
To create query parameters you need to assign them as the third parameter using the ``query`` key like this:

.. code-block:: html
   :lineos:
   <?php
   $url = $this->url(
       'news',
       array('action' => 'archive'),
       array(
           'query' => array(
               'page' => 13
           )
       )
   );
   ?>
   <a href="<?php echo $url;?>">News Archive Page #13</a>
   
The above code-sample would output:

.. code-block:: html
   :lineos:
   
   <a href="/news/archive?page=13">News Archive Page #13</a>
   
.. _zend.view.helpers.initial.url.reusingmatchedparameters:

Reusing Matched Parameters
--------------------------

When you're on a route that has many parameters, often times it makes sense to simply reuse currently matched 
parameters instead of assigning them new all over. In this case the parameter ``$reuseMatchedParams`` will come in 
handy.

For a simply example we will imagine us being on a detail page for our news-route. And now we want to display links to
the ``èdit`` and ``delete`` actions without having to assign the ID again. This is how you would do it:

.. code-block:: html
   :lineos:
   
   // Currently url /news/details/777
   
   <a href="<?php echo $this->url('news', array('action' => 'edit'), null, true);?>">Edit Me</a>
   <a href="<?php echo $this->url('news', array('action' => 'delete'), null, true);?>">Edit Me</a>
   
Notice the ``true`` parameter. This will tell the ViewHelper to use the matched ``id`` (``777``) when creating the new 
url-output:

.. code-block:: html
   :lineos:
   
   <a href="/news/edit/777">Edit Me</a>
   <a href="/news/delete/777">Edit Me</a>
   
**Shorthand**

Due to the fact that re-using parameters is a use-case that can happen when no route-options are set the third
parameter for the URL ViewHelper will be checked against their type and when it's a boolean it will automatically
assume to be the fourth parameters instead. See this example:

.. code-block:: php
   :lineos:
   
   $this->url('news', array('action' => 'archive'), null, true);
   // is equal to
   $this->url('news', array('action' => 'archive'), true);
   
   
