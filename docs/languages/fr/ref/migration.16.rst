.. _migration.16:

Zend Framework 1.6
==================

Lors de la migration d'un version précédente vers Zend Framework 1.6 ou plus récent vous devriez prendre note de
ce qui suit.

.. _migration.16.zend.controller:

Zend_Controller
---------------

.. _migration.16.zend.controller.dispatcher:

Changement dans l'interface Dispatcher
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les utilisateurs ont porté à notre connaissance le fait que ``Zend_Controller_Front`` et
``Zend_Controller_Router_Route_Module`` utilisent tous les deux des méthodes du distributeur qui ne sont pas dans
l'interface associée. Nous avons donc ajouté les trois méthodes suivantes pour s'assurer que les distributeurs
personnalisés continueront à fonctionner avec les implémentations embarquées :

- ``getDefaultModule()``\  : retourne le nom du module par défaut.

- ``getDefaultControllerName()``\  : retourne le nom du contrôleur par défaut.

- ``getDefaultAction()``\  : retourne le nom de l'action par défaut.

.. _migration.16.zend.file.transfer:

Zend_File_Transfer
------------------

.. _migration.16.zend.file.transfer.validators:

Changements quand vous utilisez des validateurs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Certaines remarques des utilisateurs indiquaient que les validateurs de ``Zend_File_Transfer`` ne fonctionnaient
pas comme ceux par défaut fournis avec ``Zend_Form``. ``Zend_Form`` permet par exemple l'utilisation du paramètre
*breakChainOnFailure* qui stoppe la validation de tous les validateurs suivants dès qu'une erreur de validation
apparaît.

Nous avons donc ajouter ce paramètre à tous les validateurs existants pour ``Zend_File_Transfer``.

- Ancienne *API*\  : *addValidator($validator, $options, $files)*.

- Nouvelle *API*\  : *addValidator($validator, $breakChainOnFailure, $options, $files)*.

Pour migrer vos scripts vers la nouvelle *API*, ajoutez simplement un a ``FALSE`` après voir défini le validateur
souhaité.

.. _migration.16.zend.file.transfer.example:

.. rubric:: Changer les validateurs de fichiers de 1.6.1 vers 1.6.2

.. code-block:: php
   :linenos:

   // Exemple pour 1.6.1
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('FilesSize', array('1B', '100kB'));

   // Même exemple pour 1.6.2 et plus récent
   // Notez l'ajout du booléen false
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('FilesSize', false, array('1B', '100kB'));


