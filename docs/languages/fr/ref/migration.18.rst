.. _migration.18:

Zend Framework 1.8
==================

Lors de la migration d'un version précédente vers Zend Framework 1.8 ou plus récent vous devriez prendre note de
ce qui suit.

.. _migration.18.zend.controller:

Zend_Controller
---------------

.. _migration.18.zend.controller.router:

Changement de la route standard
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Comme les segments traduits ont été ajoutés dans la nouvelle route standard, le caractère *@* est maintenant un
caractère spécial au début d'un segment de route. Pour être capable de l'utiliser dans un segment statique,
vous devez l'échapper en le préfixant avec un second *@*. La même règle s'applique aussi au caractère *:*.

.. _migration.18.zend.locale:

Zend_Locale
-----------

.. _migration.18.zend.locale.defaultcaching:

Default caching
^^^^^^^^^^^^^^^

As with Zend Framework 1.8 a default caching was added. The reason behind this change was, that most users had
performance problems but did not add caching at all. As the I18n core is a bottleneck when no caching is used we
decided to add a default caching when no cache has been set to ``Zend_Locale``.

Sometimes it is still wanted to prevent caching at all even if this decreases performance. To do so you can simply
disable caching by using the ``disableCache()`` method.

.. _migration.18.zend.locale.defaultcaching.example:

.. rubric:: Disabling default caching

.. code-block:: php
   :linenos:

   Zend_Locale::disableCache(true);


