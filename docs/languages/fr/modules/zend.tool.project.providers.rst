.. _zend.tool.project.providers:

Fournisseurs de Zend_Tool_Project
=================================

Ci-dessous, vous trouverez un tableau de tous les fournisseurs embarqués avec ``Zend_Tool_Project``.

.. _zend.tool.project.project-provider:

.. table:: Options du fournisseur Project

   +------------------+-------------------------------------+--------------------------------------------------------+--------------------------------------------------------------------------------+
   |Nom du fournisseur|Actions disponibles                  |Paramètres                                              |Utilisation en CLI                                                              |
   +==================+=====================================+========================================================+================================================================================+
   |Controller        |Création                             |create = [name, indexActionIncluded=true]               |zf create controller foo                                                        |
   +------------------+-------------------------------------+--------------------------------------------------------+--------------------------------------------------------------------------------+
   |Action            |Création                             |create - [name, controllerName=index, viewIncluded=true]|zf create action bar foo (ou zf create action --name bar --controlller-name=foo)|
   +------------------+-------------------------------------+--------------------------------------------------------+--------------------------------------------------------------------------------+
   |Controller        |Création                             |create - [name, indexActionIncluded=true]               |zf create controller foo                                                        |
   +------------------+-------------------------------------+--------------------------------------------------------+--------------------------------------------------------------------------------+
   |Profile           |Visualisation                        |show - []                                               |zf show profile                                                                 |
   +------------------+-------------------------------------+--------------------------------------------------------+--------------------------------------------------------------------------------+
   |View              |Création                             |create - [controllerName,actionNameOrSimpleName]        |zf create view foo bar (ou zf create view -c foo -a bar)                        |
   +------------------+-------------------------------------+--------------------------------------------------------+--------------------------------------------------------------------------------+
   |Test              |Création / Activation / Désactivation|create - [libraryClassName]                             |zf create test My_Foo_Baz / zf disable test / zf enable test                    |
   +------------------+-------------------------------------+--------------------------------------------------------+--------------------------------------------------------------------------------+


