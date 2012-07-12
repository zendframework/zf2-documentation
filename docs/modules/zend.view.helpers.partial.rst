
Partial Helper
==============

The ``Partial`` view helper is used to render a specified template within its own variable scope. The primary use is for reusable template fragments with which you do not need to worry about variable name clashes. Additionally, they allow you to specify partial view scripts from specific modules.

A sibling to the ``Partial`` , the ``PartialLoop`` view helper allows you to pass iterable data, and render a partial for each item.

.. note::
    **PartialLoop Counter**

    The ``PartialLoop`` view helper assigns a variable to the view namedpartialCounterwhich passes the current position of the array to the view script. This provides an easy way to have alternating colors on table rows for example.

.. note::
    **What is a model?**

    A model used with the ``Partial`` view helper can be one of the following:

    - Array. If an array is passed, it
    - should be associative, as its key/value pairs are
    - assigned to the view with keys as view variables.
    - Object implementing toArray() method. If an object is
    - passed an has a toArray() method, the results of
    - toArray() will be assigned to the view
    - object as view variables.
    - Standard object. Any other object
    - will assign the results of
    - object_get_vars() (essentially all public
    - properties of the object) to the view object.


    If your model is an object, you may want to have it passedas an objectto the partial script, instead of serializing it to an array of variables. You can do this by setting the 'objectKey' property of the appropriate helper:

.. code-block:: php
    :linenos:
    
    // Tell partial to pass objects as 'model' variable
    $view->partial()->setObjectKey('model');
    
    // Tell partial to pass objects from partialLoop as 'model' variable
    // in final partial view script:
    $view->partialLoop()->setObjectKey('model');
    

    This technique is particularly useful when passing ``Zend_Db_Table_Rowset`` s to ``partialLoop()`` , as you then have full access to your row objects within the view scripts, allowing you to call methods on them (such as retrieving values from parent or dependent rows).


