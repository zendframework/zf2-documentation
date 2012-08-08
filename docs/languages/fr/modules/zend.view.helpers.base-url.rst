.. EN-Revision: none
.. _zend.view.helpers.initial.baseurl:

Aide BaseUrl
============

La plupart des *URL*\ s générées par le framework possèdent l'*URL* de base préfixée automatiquement. Les
développeurs ont besoin de la rajouter à la main à leurs propres *URL*\ s afin de garder une correspondance
chemins - ressources correcte.

L'utilisation de l'aide de vue BaseUrl est très simple:

.. code-block:: php
   :linenos:

   /*
    * Imaginons une URL de base dans page/application de "/mypage".
    */

   /*
    * affiche:
    * <base href="/mypage/" />
    */
   <base href="<?php echo $this->baseUrl(); ?>" />

   /*
    * affiche:
    * <link rel="stylesheet" type="text/css" href="/mypage/css/base.css" />
    */
   <link rel="stylesheet" type="text/css"
        href="<?php echo $this->baseUrl('css/base.css'); ?>" />

.. note::

   Pour plus de simplicité, le fichier *PHP* (par exemple "``index.php``") est enelevé de l'*URL* de base gérée
   par ``Zend_Controller``. Cependant, si ceci vous gène, utilisez ``$this->getHelper('BaseUrl')->setBaseUrl()``
   pour affecter votre propre BaseUrl.


