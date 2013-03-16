.. EN-Revision: none
.. _zend.captcha.operation:

Opération Captcha
=================

Tous les adaptateurs *CAPTCHA* implémentent ``Zend\Captcha\Adapter``, qui ressemble à ceci :

.. code-block:: php
   :linenos:

   interface Zend\Captcha\Adapter extends Zend\Validate\Interface
   {
       public function generate();

       public function render(Zend_View $view, $element = null);

       public function setName($name);

       public function getName();

       public function getDecorator();

       // De plus, pour satisfaire Zend\Validate\Interface :
       public function isValid($value);

       public function getMessages();

       public function getErrors();
   }

Le mutateur et l'accesseur "name" sont utilisés pour spécifier et récupérer l'identifiant du *CAPTCHA*.
``getDecorator()`` peut être utilisé pour spécifier un décorateur ``Zend_Form`` soit par son nom ou en
retournant un objet décorateur. Les vraies clés sont utilisées sauf pour ``generate()`` et ``render()``.
``generate()`` est utilisé pour créer l'élément *CAPTCHA*. Ce processus typiquement stockera l'élément en
session ainsi il pourra être utilisé pour comparaison dans les requêtes suivantes. ``render()`` est utilisé
pour effectuer le rendu de l'information que représente le *CAPTCHA*- en image, en texte Figlet, en problème
logique, ou tout autre type de *CAPTCHA*.

Un cas d'utilisation typique pourrait ressembler à ceci :

.. code-block:: php
   :linenos:

   // Créer une instance de Zend_View
   $view = new Zend\View\View();

   // Requête original :
   $captcha = new Zend\Captcha\Figlet(array(
       'name' => 'foo',
       'wordLen' => 6,
       'timeout' => 300,
   ));
   $id = $captcha->generate();
   echo $captcha->render($view);

   // Lors de la requête suivante :
   // suppose que $captcha a été paramétré avant,
   // et que $value est la valeur soumise :
   if ($captcha->isValid($_POST['foo'], $_POST)) {
       // Validated!
   }


