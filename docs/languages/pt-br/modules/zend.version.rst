.. EN-Revision: none
.. _zend.version.reading:

Obtendo a Versão do Zend Framework
==================================

``Zend_Version`` fornece a constante de classe ``Zend\Version\Version::VERSION`` que contém uma string que identifica o
número da versão de sua instalação do Zend Framework. ``Zend\Version\Version::VERSION`` pode conter "1.7.4", por
exemplo.

O método estático ``Zend\Version\Version::compareVersion($version)`` é baseado na função `version_compare()`_ do
*PHP*. Esse método retorna -1 se a versão especificada é mais antiga que a versão do Zend Framework instalado,
0 se forem iguais e 1 se a versão especificada é mais recente que a versão instalada.

.. _zend.version.reading.example:

.. rubric:: Exemplo do método compareVersion()

.. code-block:: php
   :linenos:

   // retorna -1, 0 ou 1
   $cmp = Zend\Version\Version::compareVersion('2.0.0');

O método estático ``Zend\Version\Version::getLatest()`` fornece o número da última versão estável disponível para
download no site `Zend Framework`_.

.. _zend.version.latest.example:

.. rubric:: Exemplo do método getLatest()

.. code-block:: php
   :linenos:

   // retorna 1.11.0 (ou uma versão posterior)
   echo Zend\Version\Version::getLatest();



.. _`version_compare()`: http://php.net/version_compare
.. _`Zend Framework`: http://framework.zend.com/download/latest
