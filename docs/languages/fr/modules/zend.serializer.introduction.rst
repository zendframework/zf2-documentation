.. EN-Revision: none
.. _zend.serializer.introduction:

Introduction
============

``Zend_Serializer`` utilise une interface basée sur des adaptateurs afin de générer des représentations
stockables de types php et inversement.

.. _zend.serializer.introduction.example.dynamic:

.. rubric:: Utiliser ``Zend_Serializer``

Pour instancier un sérialiseur, vous devriez utiliser la méthode de fabrique d'adaptateurs:

.. code-block:: php
   :linenos:

   $serializer = Zend\Serializer\Serializer::factory('PhpSerialize');
   // $serializer est instance de Zend\Serializer\Adapter\AdapterInterface,
   // précisément Zend\Serializer\Adapter\PhpSerialize

   try {
       $serialized = $serializer->serialize($data);
       // $serialized est une chaîne

       $unserialized = $serializer->unserialize($serialized);
       // ici $data == $unserialized
   } catch (Zend\Serializer\Exception $e) {
       echo $e;
   }

La méthode ``serialize`` génère une chaîne. Pour regénérer la donnée utilisez la méthode ``unserialize``.

Si une erreur survient à la sérialisation ou désérialisation, ``Zend_Serializer`` enverra une
``Zend\Serializer\Exception``.

Pour configurer l'adaptateur, vous pouvez passer un tableau ou un objet instance de ``Zend_Config`` à la méthode
``factory`` ou aux méthode ``un-/serialize``:

.. code-block:: php
   :linenos:

   $serializer = Zend\Serializer\Serializer::factory('Wddx', array(
       'comment' => 'serialized by Zend_Serializer',
   ));

   try {
       $serialized = $serializer->serialize($data, array('comment' => 'change comment'));
       $unserialized = $serializer->unserialize($serialized, array(/* options pour unserialize */));
   } catch (Zend\Serializer\Exception $e) {
       echo $e;
   }

Les options passées à ``factory`` sont valides pour l'objet crée. Vous pouvez alors changer ces options grâce
à la méthode ``setOption(s)``. Pour changer des options pour un seul appel, passez celles-ci en deuxième
argument des méthodes ``serialize`` ou ``unserialize``.

.. _zend.serializer.introduction.example.static.php:

.. rubric:: Utiliser l'interface statique de Zend_Serializer

Vous pouvez enregistrer une adaptateur spécifique comme adaptateur par défaut à utiliser avec
``Zend_Serializer``. Par défaut, l'adaptateur enregistré est ``PhpSerialize`` mais vous pouvez le changer au
moyen de la méthode statique ``setDefaultAdapter()``.

.. code-block:: php
   :linenos:

   Zend\Serializer\Serializer::setDefaultAdapter('PhpSerialize', $options);
   // ou
   $serializer = Zend\Serializer\Serializer::factory('PhpSerialize', $options);
   Zend\Serializer\Serializer::setDefaultAdapter($serializer);

   try {
       $serialized   = Zend\Serializer\Serializer::serialize($data, $options);
       $unserialized = Zend\Serializer\Serializer::unserialize($serialized, $options);
   } catch (Zend\Serializer\Exception $e) {
       echo $e;
   }


