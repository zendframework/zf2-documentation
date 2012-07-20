.. _zend.view.helpers.initial.json:

L'aide de vue JSON
==================

Quand vous créez des vues qui retournent du *JSON*, il est important de paramétrer aussi les en-têtes de
réponse appropriés. L'aide vue *JSON* réalise exactement cela. De plus, par défaut, elle désactive l'éventuel
layout (s'il est activé), puisque les layouts sont rarement utilisés dans les réponses *JSON*.

L'aide de vue *JSON* ajoute l'en-tête suivant :

.. code-block:: text
   :linenos:

   Content-Type: application/json

Beaucoup de librairies *AJAX* recherche cet en-tête quand elles analysent les réponses pour déterminer comment
le contenu doit être géré.

L'utilisation de l'aide de vue *JSON* est très simple :

.. code-block:: php
   :linenos:

   <?php echo $this->json($this->data) ?>

.. note::

   **Keeping layouts and enabling encoding using Zend_Json_Expr**

   Each method in the *JSON* helper accepts a second, optional argument. This second argument can be a boolean flag
   to enable or disable layouts, or an array of options that will be passed to ``Zend_Json::encode()`` and used
   internally to encode data.

   To keep layouts, the second parameter needs to be boolean ``TRUE``. When the second parameter is an array,
   keeping layouts can be achieved by including a *keepLayouts* key with a value of a boolean ``TRUE``.

   .. code-block:: php
      :linenos:

      // Boolean true as second argument enables layouts:
      echo $this->json($this->data, true);

      // Or boolean true as "keepLayouts" key:
      echo $this->json($this->data, array('keepLayouts' => true));

   ``Zend_Json::encode`` allows the encoding of native *JSON* expressions using ``Zend_Json_Expr`` objects. This
   option is disabled by default. To enable this option, pass a boolean ``TRUE`` to the *enableJsonExprFinder* key
   of the options array:

   .. code-block:: php
      :linenos:

      <?php echo $this->json($this->data, array(
          'enableJsonExprFinder' => true,
          'keepLayouts'          => true,
      )) ?>


