
.. _migration.18:

Zend Framework 1.8
==================

When upgrading from a previous release to Zend Framework 1.8 or higher you should note the following migration notes.


.. _migration.18.zend.controller:

Zend_Controller
---------------


.. _migration.18.zend.controller.router:

Standard Route Changes
^^^^^^^^^^^^^^^^^^^^^^

As translated segments were introduced into the new standard route, the '**@**' character is now a special character in the beginning of a route segment. To be able to use it in a static segment, you must escape it by prefixing it with second '**@**' character. The same rule now applies for the '**:**' character.


.. _migration.18.zend.locale:

Zend_Locale
-----------


.. _migration.18.zend.locale.defaultcaching:

Default caching
^^^^^^^^^^^^^^^

As with Zend Framework 1.8 a default caching was added. The reason behind this change was, that most users had performance problems but did not add caching at all. As the I18n core is a bottleneck when no caching is used we decided to add a default caching when no cache has been set to ``Zend_Locale``.

Sometimes it is still wanted to prevent caching at all even if this decreases performance. To do so you can simply disable caching by using the ``disableCache()`` method.


.. _migration.18.zend.locale.defaultcaching.example:

.. rubric:: Disabling default caching

.. code-block:: php
   :linenos:

   Zend_Locale::disableCache(true);


