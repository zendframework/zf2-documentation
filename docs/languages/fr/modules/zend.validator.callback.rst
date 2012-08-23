.. EN-Revision: none
.. _zend.validator.set.callback:

Callback (fonction de rappel)
=============================

``Zend_Validate_Callback`` permet de fournir une fonction de rappel utilisée pour valider la valeur.

.. _zend.validator.set.callback.options:

Options supportées par Zend_Validate_Callback
---------------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_Callback``\  :

- **callback**\  : spécifie la fonction de rappel qui sera utilisée pour la validation.

- **options**\  : spécifie les options additionnelles qui seront fournies à la fonction de rappel.

.. _zend.validator.set.callback.basic:

Utilisation classique
---------------------

Le plus simple est de posséder une fonction classique, qui sera utilisée pour valider la donnée. Soit la
fonction ci-après :

.. code-block:: php
   :linenos:

   function myMethod($value)
   {
       // ici de la validation à effectuer
       return true;
   }

Pour l'utiliser avec ``Zend_Validate_Callback`` vous devez simplement effectuer votre appel comme ceci:

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Callback('myMethod');
   if ($valid->isValid($input)) {
       // input semble valide
   } else {
       // input est invalide
   }

.. _zend.validator.set.callback.closure:

Utilisation avec les fonctions anonymes (closures)
--------------------------------------------------

PHP 5.3 introduit les `fonctions anonymes`_ ou fonctions de **fermeture**. PHP traite les fonctions anonymes comme
des fonctions de rappel valides, et il est donc possible d'utiliser celles-ci avec ``Zend_Validate_Callback``.
Exemple:

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Callback(function($value){
       // Validation ici
       return true;
   });

   if ($valid->isValid($input)) {
       // input semble valide
   } else {
       // input est invalide
   }

.. _zend.validator.set.callback.class:

Utilisation avec les méthodes de rappel
---------------------------------------

Bien sûr, il est aussi possible d'utiliser des méthodes de rappel:

.. code-block:: php
   :linenos:

   class MyClass
   {
       public function myMethod($value)
       {
           // Validation ici
           return true;
       }
   }

La définition de la fonction de rappel se fait alors dans un tableau contenant un objet de la classe et la
méthode à appeler:

.. code-block:: php
   :linenos:

   $object = new MyClass;
   $valid = new Zend_Validate_Callback(array($object, 'myMethod'));
   if ($valid->isValid($input)) {
       // input semble valide
   } else {
       // input est invalide
   }

Il est aussi possible d'utiliser une méthode statique comme fonction de rappel:

.. code-block:: php
   :linenos:

   class MyClass
   {
       public static function test($value)
       {
           // Validation ici
           return true;
       }
   }

   $valid = new Zend_Validate_Callback(array('MyClass', 'test'));
   if ($valid->isValid($input)) {
       // input semble valide
   } else {
       // input est invalide
   }

Enfin, PHP 5.3 définit la méthode magique ``__invoke()``. Si vous l'utilisez, alors un simple objet suffira comme
fonction de rappel:

.. code-block:: php
   :linenos:

   class MyClass
   {
       public function __invoke($value)
       {
           // Validation ici
           return true;
       }
   }

   $object = new MyClass();
   $valid = new Zend_Validate_Callback($object);
   if ($valid->isValid($input)) {
       // input semble valide
   } else {
       // input est invalide
   }

.. _zend.validator.set.callback.options2:

Ajouter des options
-------------------

``Zend_Validate_Callback`` permet d'utiliser des options, celles-ci seront alors passées comme argument
supplémentaires à la fonction de callback.

Soit la définition suivante:

.. code-block:: php
   :linenos:

   class MyClass
   {
       function myMethod($value, $option)
       {
           // De la validation ici
           return true;
       }
   }

Il extsite deux manières d'indiquer des options au validateur : via le constructeur ou sa méthode
``setOptions()``.

Via le constructeur, passez un tableau contenant les clés "callback" et "options":

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Callback(array(
       'callback' => array('MyClass', 'myMethod'),
       'options'  => $option,
   ));

   if ($valid->isValid($input)) {
       // input semble valide
   } else {
       // input est invalide
   }

Sinon, vous pouvez passer les options après:

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Callback(array('MyClass', 'myMethod'));
   $valid->setOptions($option);

   if ($valid->isValid($input)) {
       // input semble valide
   } else {
       // input est invalide
   }

Si des valeurs supplémentaires sont passées à ``isValid()`` elles seront utilisées comme arguments
supplémentaires lors de l'appel à la fonction de rappel, mais avant les options ``$options``.

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Callback(array('MyClass', 'myMethod'));
   $valid->setOptions($option);

   if ($valid->isValid($input, $additional)) {
       // input semble valide
   } else {
       // input est invalide
   }

Lors de l'appel à la fonction de rappel, la valeur à valider sera toujours passée comme premier argument à la
fonction de rappel suivie de toutes les autres valeurs passées à ``isValid()``; les autres options suivront. Le
nombre et le type d'options qui peuvent être utilisées est illimité.



.. _`fonctions anonymes`: http://php.net/functions.anonymous
