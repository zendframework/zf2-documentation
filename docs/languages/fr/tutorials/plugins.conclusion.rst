.. EN-Revision: none
.. _learning.plugins.conclusion:

Conclusion
==========

Comprendre le concept des plugins et des chemins de préfixes aide à la compréhension du framework et de ses
composants. Les plugins sont utilisés à de nombreux endroits:

- ``Zend_Application``: ressources.

- ``Zend\Controller\Action``: aides d'action.

- ``Zend\Feed\Reader``: plugins.

- ``Zend_Form``: éléments, filtres, validateurs et décorateurs.

- ``Zend_View``: aides de vue.

Encore beaucoup d'autres endroits. Prennez en main ce concept et vous pourrez alors étendre de manière soutenue
le Zend Framework.

.. note::

   **Remarque**

   Notons que ``Zend\Controller\Front`` propose un système de plugin mais il ne s'utilise pas de la même manière
   que décrit dans ce tutoriel. Les plugins enregistrés auprès du contrôleur frontal doivent être instanciés
   directement et enregistrés de manière individuelle. Ceci est dû au fait que le système de plugins du
   contrôleur frontal date d'avant toute les possibilités d'extensions vues jusque ici et des changements dans
   son coeur sont difficiles tout en gardant la compatibilité avec les plugins déja existants.


