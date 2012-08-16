.. EN-Revision: none
.. _requirements:

****************************
Requisitos de Zend Framework
****************************

Zend Framework requiere un intérprete *PHP* 5 con un servidor web configurado para manejar scripts *PHP*
correctamente. Algunas características requieren extensiones adicionales o características de servidor web; en
muchos casos el framework puede ser utilizado sin ellos, aunque el rendimiento puede sufrir o las características
auxiliares pueden no ser completamente funcionales. Un ejemplo de dicha dependencia es mod_rewrite en un entorno
Apache, que puede ser utilizado para ejecutar "pretty *URL*" como "``http://www.example.com/user/edit``". Si
mod_rewrite no está habilitado, Zend Framework puede ser configurado para apoyar las *URL* como
"``http://www.example.com?controller=user&action=edit``". La pretty *URL*, puede ser utilizada para acortar las
*URL* de representación textual o para la optimisation de los motores de búsqueda(*SEO*), pero no afectan
directamente a la funcionalidad de la aplicación.

.. _requirements.version:

Versión de PHP
--------------

Zend recomienda *PHP* 5.2.3 o superior por mejoras en la seguridad críticas y en el rendimiento, aunque Zend
Framework requiere sólo *PHP* 5.1.4 o posterior.

Zend Framework tiene una extensa colección de unidades de prueba, que puede ejecutar utilizando PHPUnit 3.0 o
posterior.

.. _requirements.extensions:

Extensiones de PHP
------------------

Usted encontrará un cuadro con todas las extensiones que suelen encontrarse en *PHP* y debajo cómo se usan en
Zend Framework. Usted debe verificar que las extensiones de componentes Zend Framework que estará usando en su
aplicación están disponibles en sus entornos *PHP*. Muchas aplicaciones no exigirán de cada extensión que
figuran a continuación.

Una dependencia de tipo "hard" indica que los componentes o clases no pueden funcionar correctamente si las
respectivas extensiones no están disponibles, mientras que una dependencia de tipo "soft" indica que el componente
puede usar la extensión si está disponible pero funcionará correctamente si no lo está. Muchos de los
componentes utilizarán automáticamente determinadas extensiones si están disponibles para optimizar el
rendimiento pero ejecutarán el código con una funcionalidad similar en el propio componente si las extensiones no
están disponibles.

.. include:: requirements.php.extensions.table.rst
.. _requirements.zendcomponents:

Componentes de Zend Framework
-----------------------------

Más abajo hay un cuadro que enumera todos los Componentes de Zend Framework y que extensión de PHP necesitan.
Esto puede ayudar a guiarlo para saber que extensiones son necesarias para su aplicación. No todas las extensiones
utilizados por Zend Framework son necesarias en cada aplicación.

Una dependencia de tipo "hard" indica que los componentes o clases no pueden funcionar correctamente si las
extensiones respectivas no están disponibles, mientras que una dependencia de tipo "soft" indica que el componente
puede usar la extensión si está disponible, pero funcionará correctamente si no lo está. Muchos de los
componentes utilizarán automáticamente determinadas extensiones si están disponibles para optimizar el
rendimiento, pero ejecutará un código con una funcionalidad similar en el propio componente si las extensiones no
están disponibles.

.. include:: requirements.zendcomponents.table.rst
.. _requirements.dependencies:

Dependencias de Zend Framework
------------------------------

A continuación encontrará un cuadro de Componennetes de Zend Framework y sus dependencias a otros Componentes de
Zend Framework. Esto puede ser de ayuda si usted necesita tener sólo componentes individuales en lugar del Zend
Framework completo.

Una dependencia de tipo "hard" indica que los componentes o clases no funcionarán correctamente si los respectivos
componentes dependientes no están disponibles, mientras que una dependencia de tipo "soft" indica que el
componente puede necesitar el componente dependiente en situaciones especiales o con adaptadores especiales.

.. note::

   Incluso si es posible separar componentes indiduales para usarlo desde Zend Framework completo, usted debe tener
   en cuenta que esto puede conducir a problemas cuando se perdieron los ficheros o los componentes se utilizan
   dinámicamente.

.. include:: requirements.dependencies.table.rst

