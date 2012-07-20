.. _zend.version.reading:

Получение версии Zend Framework
===============================

``Zend_Version`` имеет константу ``Zend_Version::VERSION``, которая содержит
строку с номером версии текущей инсталляции Zend Framework. Например,
``Zend_Version::VERSION`` может содержать "1.7.4".

Статический метод ``Zend_Version::compareVersion($version)`` основан на
*PHP*-функции `version_compare()`_. Метод возвращает -1, если указанная
версия более поздняя, чем версия установленного Zend Framework; 0,
если они одинаковые, и +1, если указанная версия более ранняя,
чем версия установленного Zend Framework.

.. _zend.version.reading.example:

.. rubric:: Пример использования метода compareVersion()

.. code-block:: php
   :linenos:

   // возвращает -1, 0 или 1
   $cmp = Zend_Version::compareVersion('2.0.0');

Статический метод ``Zend_Version::getLatest()`` возвращает номер версии
последнего стабильного релиза, доступного для скачивания на
сайте `Zend Framework`_.

.. _zend.version.latest.example:

.. rubric:: Пример использования метода getLatest()

.. code-block:: php
   :linenos:

   // возвращает 1.11.0 (или более позднюю версию)
   echo Zend_Version::getLatest();



.. _`version_compare()`: http://php.net/version_compare
.. _`Zend Framework`: http://framework.zend.com/download/latest
