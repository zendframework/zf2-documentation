.. _zend.view.helpers.initial.partial:

View Helper - Partial
=====================

.. _zend.view.helpers.initial.partial.introduction:

Introduction
------------

The ``Partial`` view helper is used to render a specified template within its own variable scope. The primary use
is for reusable template fragments with which you do not need to worry about variable name clashes.

A sibling to the ``Partial``, the ``PartialLoop`` view helper allows you to pass iterable data, and render a
partial for each item.

.. note::

   **PartialLoop Counter**

   The ``PartialLoop`` view helper gives access to the current
   position of the array within the view script via ``$this->partialLoop()->getPartialCounter()``. This provides an easy way to have alternating colors on table rows for
   example.

.. _zend.view.helpers.initial.partial.usage:

Basic Usage
-----------

Basic usage of partials is to render a template fragment in its own view scope. Consider the following partial
script:

.. code-block:: php
   :linenos:

   <?php // partial.phtml ?>
   <ul>
       <li>From: <?php echo $this->escapeHtml($this->from) ?></li>
       <li>Subject: <?php echo $this->escapeHtml($this->subject) ?></li>
   </ul>

You would then call it from your view script using the following:

.. code-block:: php
   :linenos:

   <?php echo $this->partial('partial.phtml', array(
       'from' => 'Team Framework',
       'subject' => 'view partials')); ?>

Which would then render:

.. code-block:: html
   :linenos:

   <ul>
       <li>From: Team Framework</li>
       <li>Subject: view partials</li>
   </ul>

.. note::

   **What is a model?**

   A model used with the ``Partial`` view helper can be one of the following:

   - **Array**. If an array is passed, it should be associative, as its key/value pairs are assigned to the view
     with keys as view variables.

   - **Object implementing toArray() method**. If an object is passed an has a ``toArray()`` method, the results of
     ``toArray()`` will be assigned to the view object as view variables.

   - **Standard object**. Any other object will assign the results of ``get_object_vars()`` (essentially all public
     properties of the object) to the view object.

   If your model is an object, you may want to have it passed **as an object** to the partial script, instead of
   serializing it to an array of variables. You can do this by setting the 'objectKey' property of the appropriate
   helper:

   .. code-block:: php
      :linenos:

      // Tell partial to pass objects as 'model' variable
      $view->partial()->setObjectKey('model');

      // Tell partial to pass objects from partialLoop as 'model' variable
      // in final partial view script:
      $view->partialLoop()->setObjectKey('model');

   This technique is particularly useful when passing ``Zend\Db\ResultSet\ResultSet``\s to ``partialLoop()``,
   as you then have full access to your row objects within the view scripts, allowing you to call methods on them
   (such as retrieving values from parent or dependent rows).

.. _zend.view.helpers.initial.partial.partialloop:

Using PartialLoop to Render Iterable Models
-------------------------------------------

Typically, you'll want to use partials in a loop, to render the same content fragment many times; this way you can
put large blocks of repeated content or complex display logic into a single location. However this has a
performance impact, as the partial helper needs to be invoked once for each iteration.

The ``PartialLoop`` view helper helps solve this issue. It allows you to pass an iterable item (array or object
implementing **Iterator**) as the model. It then iterates over this, passing, the items to the partial script as
the model. Items in the iterator may be any model the ``Partial`` view helper allows.

Let's assume the following partial view script:

.. code-block:: php
   :linenos:

   <?php // partialLoop.phtml ?>
       <dt><?php echo $this->key ?></dt>
       <dd><?php echo $this->value ?></dd>

And the following "model":

.. code-block:: php
   :linenos:

   $model = array(
       array('key' => 'Mammal', 'value' => 'Camel'),
       array('key' => 'Bird', 'value' => 'Penguin'),
       array('key' => 'Reptile', 'value' => 'Asp'),
       array('key' => 'Fish', 'value' => 'Flounder'),
   );

In your view script, you could then invoke the ``PartialLoop`` helper:

.. code-block:: php
   :linenos:

   <dl>
   <?php echo $this->partialLoop('partialLoop.phtml', $model) ?>
   </dl>

.. code-block:: html
   :linenos:

   <dl>
       <dt>Mammal</dt>
       <dd>Camel</dd>

       <dt>Bird</dt>
       <dd>Penguin</dd>

       <dt>Reptile</dt>
       <dd>Asp</dd>

       <dt>Fish</dt>
       <dd>Flounder</dd>
   </dl>