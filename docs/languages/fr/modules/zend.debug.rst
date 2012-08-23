.. EN-Revision: none
.. _zend.debug.dumping:

Afficher des informations
=========================

La méthode statique ``Zend_Debug::dump()`` affiche et/ou retourne les informations concernant une expression.
Cette technique simple de débogage est commune, parce que facile à utiliser de façon ad hoc et n'exigeant aucune
initialisation, aucun outils spéciaux, ou environnement de mise au point.

.. _zend.debug.dumping.example:

.. rubric:: Exemple avec la méthode dump()

.. code-block:: php
   :linenos:

   Zend_Debug::dump($var, $label = null, $echo = true);

L'argument ``$var`` définit l'expression ou la variable que l'on veut examiner avec ``Zend_Debug::dump()``.

L'argument ``$label`` est un texte arbitraire à placer avant la sortie de ``Zend_Debug::dump()``. Ceci est utile
lorsque vous souhaitez afficher à l'écran des informations concernant plusieurs variables.

Le booléen ``$echo`` indique s'il faut (ou non) afficher la sortie de ``Zend_Debug::dump()``. Si ``TRUE``, la
sortie sera affichée. Quel que soit l'état de ``$echo``, la sortie est toujours retournée.

Il peut être utile de savoir que la méthode ``Zend_Debug::dump()`` enveloppe la fonction *PHP* `var_dump()`_. Si
le flux est reconnu à destination d'un contenu Web, l'affichage de ``var_dump()`` est échappé avec
`htmlspecialchars()`_ et est enveloppé entre des balises (X)HTML ``<pre> et </pre>``.

.. tip::

   **Déboguer avec Zend_Log**

   Utiliser ``Zend_Debug::dump()`` est ce qui convient le mieux pour le débogage durant le développement de
   l'application. Vous pouvez facilement ajouter ou retirer du code que vous souhaitez visualiser.

   Vous pouvez aussi considérer le composant :ref:`Zend_Log <zend.log.overview>`\ si vous souhaitez rendre
   permanent du code de débogage. Par exemple, vous pouvez utiliser le niveau de log ``DEBUG`` et le :ref:`flux
   d'écriture Stream du log <zend.log.writers.stream>` pour afficher la chaîne retournée par
   ``Zend_Debug::dump()``.



.. _`var_dump()`: http://php.net/var_dump
.. _`htmlspecialchars()`: http://php.net/htmlspecialchars
