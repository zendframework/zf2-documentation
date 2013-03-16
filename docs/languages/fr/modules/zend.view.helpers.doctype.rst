.. EN-Revision: none
.. _zend.view.helpers.initial.doctype:

L'aide de vue Doctype
=====================

Les documents HTML et *XHTML* valides doivent inclure une déclaration ``DOCTYPE``. Sans compter qu'ils sont
difficiles à garder en mémoire, ceux-ci peuvent aussi affecter la façon dont certains éléments du document
peuvent être rendus (par exemple, les échappements CDATA dans *<script>* et les éléments *<style>*.

L'aide *Doctype* vous permet de spécifier un des types suivants :

- ``XHTML11``

- ``XHTML1_STRICT``

- ``XHTML1_TRANSITIONAL``

- ``XHTML1_FRAMESET``

- ``XHTML_BASIC1``

- ``HTML4_STRICT``

- ``HTML4_LOOSE``

- ``HTML4_FRAMESET``

- ``HTML5``

Vous pouvez aussi spécifier un doctype personnalisé du moment que celui-ci soit correctement formé.

L'aide *Doctype* est une implémentation concrète de l':ref:`aide Conteneur
<zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.doctype.basicusage:

.. rubric:: Utilisation basique de l'aide Doctype

Vous pouvez spécifier le doctype à n'importe quel moment. Cependant, les aides de vues qui utilisent pour leur
affichage ne le reconnaissent qu'une fois qu'il a été paramétré, donc la manière la plus simple est de le
spécifier dans votre fichier d'amorçage :

.. code-block:: php
   :linenos:

   $doctypeHelper = new Zend\View_Helper\Doctype();
   $doctypeHelper->doctype('XHTML1_STRICT');

Ensuite vous l'affichez en début de votre layout :

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>

.. _zend.view.helpers.initial.doctype.retrieving:

.. rubric:: Récupérer le Doctype

Si vous avez besoin du doctype, vous pouvez le récupérer par l'appel de ``getDoctype()`` sur l'objet.

.. code-block:: php
   :linenos:

   $doctype = $view->doctype()->getDoctype();

Typiquement, vous pouvez simplement vouloir savoir si le doctype est *XHTML* ou non ; pour ceci, la méthode
``isXhtml()`` vous suffira :

.. code-block:: php
   :linenos:

   if ($view->doctype()->isXhtml()) {
       // faire qqch de différent
   }

Vous pouvez aussi vérifier si le doctype représente un document *HTML5*\  :

.. code-block:: php
   :linenos:

   if ($view->doctype()->isHtml5()) {
       // faire qqch de différent
   }


