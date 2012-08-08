.. EN-Revision: none
.. _learning.quickstart.intro:

Introducción a MVC & ZF
=======================

.. _learning.quickstart.intro.zf:

Zend Framework
--------------

Zend Framework es un framework de código abierto y orientado a objectos para facilitar el desarrollo de
aplicaciones web con *PHP* 5. A menudo es considerado una 'biblioteca de componentes', debido a que estos poseen
bajo acoplamiento entre sí lo cual permite reutilizarlos con un alto grado de independencia. Proporciona además
una sofisticada implementación del patrón Modelo-Vista-Controlador (*MVC*) el cual puede ser utilizado para fijar
la estructura básica de las aplicaciones desarrolladas con el framework. Encontrarás la lista completa de los
componentes de Zend Framework junto a breves descripciones de los mismos en la `lista de componentes`_. En este
tutorial te ayudaremos a familiarizarte con aquellos componentes del framework utilizados de manera más frecuente
incluyendo ``Zend_Controller``, ``Zend_Layout``, ``Zend_Config``, ``Zend_Db``, ``Zend_Db_Table`` y
``Zend_Registry``.

Utilizando dichos componentes construiremos en pocos minutos una sencilla aplicación de ejemplo en la cual nos
serviremos de una base de datos para registrar los comentarios que dejen los usuarios de un sitio web. Puedes
descargar el código fuente completo para esta aplicación de los siguientes enlaces:

- `formato zip`_

- `formato tar.gz`_

.. _learning.quickstart.intro.mvc:

Modelo-Vista-Controlador
------------------------

En resumen ¿qué es exactamente el patrón *MVC* del que tanto hablan? ¿y por qué debería importarte? *MVC* no
es sólo un acrónimo de tres letras (*TLA*) que puedes utilizar para impresionar a tus amigos, actualmente *MVC*
se ha convertido en un estándar para el diseño de las aplicaciones web modernas. Y por buenas razones ya que
ayuda a modelar de forma precisa la separación de intereses permitiendo agrupar en distintas partes de la
aplicación el código que se relaciona con la presentación, el que implementa la lógica de negocios y el que
accede a los datos. Muchos desarrolladores encuentran indispensable dicha separación para ayudarlos a mantener su
código organizado, especialmente cuando más de un desarrollador se encuentra trabajando en la misma aplicación.

.. note::

   **Más información**

   Profundicemos un poco y veamos cada parte de este patrón por separado:

   .. image:: ../images/learning.quickstart.intro.mvc.png
      :width: 321
      :align: center

   - **Modelo**- ofrece las funcionalidades básicas de la aplicación incluyendo las rutinas de acceso a datos y
     la lógica de negocios.

   - **Vista**- se encarga de generar lo que se presenta al usuario a partir de los datos que recibe del
     controlador, al mismo tiempo que recogen los datos que brindan los usuarios. Es la parte de la aplicación
     donde encontrarás el *HTML*.

   - **Controlador**- son los que unen el patrón. Según el pedido del usuario y otras variables ellos pueden
     decidir ejecutar otro controlador o manipular los datos del modelo para luego asignarle el resultado a una
     vista en particular. Muchos expertos en *MVC* recomiendan `mantener el controlador lo más limpio posible`_.

   Podríamos `extendernos aún más`_ sobre este patrón pero por ahora ya posees los conocimientos suficientes
   que te permitirán entender la aplicación que vamos a construir.



.. _`lista de componentes`: http://framework.zend.com/about/components
.. _`formato zip`: http://framework.zend.com/demos/ZendFrameworkQuickstart.zip
.. _`formato tar.gz`: http://framework.zend.com/demos/ZendFrameworkQuickstart.tar.gz
.. _`mantener el controlador lo más limpio posible`: http://weblog.jamisbuck.org/2006/10/18/skinny-controller-fat-model
.. _`extendernos aún más`: http://ootips.org/mvc-pattern.html
