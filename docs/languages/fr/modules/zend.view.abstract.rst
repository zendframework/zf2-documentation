.. _zend.view.abstract:

Zend_View_Abstract
==================

``Zend_View_Abstract`` est la classe de base à partir de laquelle ``Zend_View`` est construite ; ``Zend_View``
elle-même l'étend simplement et déclare une implémentation concrète de la méthode ``_run()`` (qui est
invoquée par ``render()``).

De nombreux développeurs constatent qu'ils veulent étendre ``Zend_View_Abstract`` afin d'ajouter des
fonctionnalités supplémentaires, et inévitablement se trouvent confrontés face à des problèmes avec ce
design, qui inclut un certain nombre de membres privés. Ce document a pour but d'expliquer les décisions qui ont
poussé à ce design.

``Zend_View`` est une sorte de moteur anti-template dans lequel on utilise nativement *PHP* pour la réalisation du
template. Avec comme résultat, tout le *PHP* est disponible, et les scripts de vue héritent de la portée des
objets appelants.

C'est ce dernier point qui est important dans le choix de la décision de ce design. En interne,
``Zend_View::_run()`` réalise simplement ceci :

.. code-block:: php
   :linenos:

   protected function _run()
   {
       include func_get_arg(0);
   }

Ainsi, les scripts de vue ont accès à l'objet courant(``$this``), **et toute méthode ou membres et cet objet**.
Puisque beaucoup d'opérations dépendent de membres ayant une portée limitée, ceci pose un problème : les
scrips de vue peuvent potentiellement faire des appels à ces méthodes ou modifier des propriétés critiques
directement. Imaginer un script surchargeant par inadvertance ``$_path`` ou ``$_file``- tout appel suivant à
``render()`` ou aux aides de vue sera cassé !

Heureusement, *PHP* 5 a une réponse à ceci avec ses déclarations de visibilité : les membres privés se sont
pas accessibles par un objet étendant une classe donnée. Ceci a permis la conception actuelle : ``Zend_View``
**étend** ``Zend_View_Abstract``, les scripts de vues sont ainsi limités aux seuls méthodes et membres *public*
ou *protected* de ``Zend_View_Abstract``- limitant effectivement les actions qu'il peut exécuter, et nous
permettant de sécuriser des secteurs critiques d'un risque de modification par les scripts de vue.


