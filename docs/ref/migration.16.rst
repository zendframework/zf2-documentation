.. _migration.16:

Zend Framework 1.6
==================

When upgrading from a previous release to Zend Framework 1.6 or higher you should note the following migration notes.

.. _migration.16.zend.controller:

Zend_Controller
---------------

.. _migration.16.zend.controller.dispatcher:

Dispatcher Interface Changes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Users brought to our attention the fact that ``Zend_Controller_Front`` and ``Zend_Controller_Router_Route_Module`` were each using methods of the dispatcher that were not in the dispatcher interface. We have now added the following three methods to ensure that custom dispatchers will continue to work with the shipped implementations:

- ``getDefaultModule()``: should return the name of the default module.

- ``getDefaultControllerName()``: should return the name of the default controller.

- ``getDefaultAction()``: should return the name of the default action.

.. _migration.16.zend.file.transfer:

Zend_File_Transfer
------------------

.. _migration.16.zend.file.transfer.validators:

Changes when using validators
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As noted by users, the validators from ``Zend_File_Transfer`` do not work the same way like the default ones from ``Zend_Form``. ``Zend_Form`` allows the usage of a ``$breakChainOnFailure`` parameter which breaks the validation for all further validators when an validation error has occurred.

So we added this parameter also to all existing validators from ``Zend_File_Transfer``.

- Old method *API*: ``addValidator($validator, $options, $files)``.

- New method *API*: ``addValidator($validator, $breakChainOnFailure, $options, $files)``.

To migrate your scripts to the new *API*, simply add a ``FALSE`` after defining the wished validator.

.. _migration.16.zend.file.transfer.example:

.. rubric:: How to change your file validators from 1.6.1 to 1.6.2

.. code-block:: php
   :linenos:

   // Example for 1.6.1
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('FilesSize', array('1B', '100kB'));

   // Same example for 1.6.2 and newer
   // Note the added boolean false
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('FilesSize', false, array('1B', '100kB'));


