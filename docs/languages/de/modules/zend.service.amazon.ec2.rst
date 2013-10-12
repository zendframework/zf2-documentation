.. EN-Revision: none
.. _zend.service.amazon.ec2:

Zend\Service\Amazon\Ec2
=======================

.. _zend.service.amazon.ec2.introduction:

Einführung
----------

``Zend\Service\Amazon\Ec2`` bietet ein Interface zu Amazon's Elastic Clound Computing (EC2).

.. _zend.service.amazon.ec2.whatis:

Was ist Amazon Ec2?
-------------------

Amazon EC2 ist ein Web Service der es erlaubt Server Instanzen in Amazon's Data Centern zu starten und zu managen
indem *API*\ s oder vorhandenen Tools und Utilities verwendet werden. Man kann Amazon EC2 Server Instanzen
jederzeit verwenden, solange man Sie benötigt, und für jeden legalen Zweck.

.. _zend.service.amazon.ec2.staticmethods:

Statische Methoden
------------------

Um die Verwendung der Ec2 Klasse einfacher zu machen gibt es zwei Methoden die von jedem der Ec2 Elemente
aufgerufen werden kann. Die erste statusche Methode ist *setKeys* welche nur die *AWS* Schlüssel als
Standardschlüssel definiert. Wenn man dann ein neues Objekt erstellt muß man keine Schlüssel mehr an den
Construktor übergeben.

.. _zend.service.amazon.ec2.staticmethods.setkeys:

.. rubric:: setKeys() Example

.. code-block:: php
   :linenos:

   Zend\Service\Amazon\Ec2\Ebs::setKeys('aws_key','aws_secret_key');

Um die Region zu setzen in der man arbeitet kann man *setRegion* aufrufen um die Amazon Ec2 Region zu setzen in der
man arbeitet. Aktuell sind nur zwei Regionen vorhanden, us-east-1 und eu-west-1. Wenn ein ungültiger Wert
übergeben wird, wird eine Exception geworfen die das ausgibt.

.. _zend.service.amazon.ec2.staticmethods.setregion:

.. rubric:: setRegion() Example

.. code-block:: php
   :linenos:

   Zend\Service\Amazon\Ec2\Ebs::setRegion('us-east-1');

.. note::

   **Setzen einer Amazon Ec2 Region**

   Alternativ kann man die Region setzen wenn man jede Klasse als dritten Parameter in der Construktor Methode
   erstellt.


