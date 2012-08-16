.. EN-Revision: none
.. _zend.view.helpers.initial.baseurl:

BaseUrl Helper
==============

Wärend die meisten *URL*\ s die vom Framework erstellt werden automatisch die Basis *URL* vorangestellt haben,
müssen Entwickler die Basis *URL* Ihren eigenen *URL*\ s voranstellen damit die Pfade zu den Ressourcen korrekt
sind.

Die Verwendung des BasisUrl Helfers ist sehr geradlinig:

.. code-block:: php
   :linenos:

   /*
    * Das folgende nimmt an das die Basis URL der Seite/Anwendung "/mypage" ist.
    */

   /*
    * Ausdruck:
    * <base href="/mypage/" />
    */
   <base href="<?php echo $this->baseUrl(); ?>" />

   /*
    * Ausdruck:
    * <link rel="stylesheet" type="text/css" href="/mypage/css/base.css" />
    */
   <link rel="stylesheet" type="text/css"
        href="<?php echo $this->baseUrl('css/base.css'); ?>" />

.. note::

   Der Einfachheit halber entfernen wir die Eingangs-*PHP* Datei (z.B. "``index.php``") von der Basis *URL* die in
   ``Zend_Controller`` enthalten war. Trotzdem kann das in einigen Situationen Probleme verursachen. Wenn eines
   Eintritt kann man ``$this->getHelper('BaseUrl')->setBaseUrl()`` verwenden um seine eigene BasisUrl zu setzen.


