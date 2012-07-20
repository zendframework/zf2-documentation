.. _zend.view.helpers.initial.inlinescript:

L'aide de vue InlineScript
==========================

L'élément HTML *<script>* est utilisé pour fournir des éléments de script côté client ou pour lier des
ressources distantes contenant des scripts s'exécutant côté client. L'aide de vue *InlineScript* vous permet de
gérer ces deux cas. Elle est dérivée de l'aide :ref:`HeadScript <zend.view.helpers.initial.headscript>`, et
chaque méthode de cette aide est donc disponible ; cependant, vous devez utiliser la méthode ``inlineScript()``
au lieu de ``headScript()``.

.. note::

   **Utiliser InlineScript pour des scripts dans le corps ("body") HTML**

   *InlineScript*, peut être utilisé quand vous souhaitez inclure des scripts dans votre *body* HTML. Placer ces
   scripts en fin de votre document est une bonne pratique pour améliorer la vitesse de distribution de votre
   page, particulièrement quand vous utilisez des scripts d'analyses fournis par des tiers.

   Certaines librairies JS doivent être incluses dans la partie *head* du HTML ; utilisez l'aide vue
   :ref:`HeadScript <zend.view.helpers.initial.headscript>` pour ces scripts.


