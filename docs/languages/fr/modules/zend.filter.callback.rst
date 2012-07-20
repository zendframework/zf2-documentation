.. _zend.filter.set.callback:

Callback
========

Ce filtre vous permet d'utiliser votre propre fonction en tant que filtre de ``Zend_Filter``. Nul besoin de créer
un filtre si une fonction ou méthode fait déja le travail.

Par exemple un filtre qui inverse une chaine.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Callback('strrev');

   print $filter->filter('Hello!');
   // retourne "!olleH"

C'est très simple de passer une fonction à appliquer comme filtre. Dans le cas de méthodes de classes, passez un
tableau comme callback.

.. code-block:: php
   :linenos:

   // Notre classe
   class MyClass
   {
       public function Reverse($param);
   }

   // La définition du filtre
   $filter = new Zend_Filter_Callback(array('MyClass', 'Reverse'));
   print $filter->filter('Hello!');

Pour récupérer la fonction de filtrage actuelle, utilisez ``getCallback()`` et pour en affecter une nouvelle,
utilisez ``setCallback()``.

Il est aussi possible de définir des paramètres par défaut qui sont alors passés à la méthode appelée
lorsque le filtre est exécuté.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Callback(
       array(
           'callback' => 'MyMethod',
           'options'  => array('key' => 'param1', 'key2' => 'param2')
       )
   );
   $filter->filter(array('value' => 'Hello'));

L'appel manuel à une telle fonction se serait fait comme cela:

.. code-block:: php
   :linenos:

   $value = MyMethod('Hello', 'param1', 'param2');

.. note::

   Notez que passer une fonction qui ne peut être appelée mènera à une exception.


