.. _zend.form.i18n:

Internacionalización de Zend_Form
=================================

Cada vez más, desarrolladores necesitan adaptar su contenido para multiples idiomas y regiones. ``Zend_Form``
intenta hacer de ésta una tarea trivial, y provee funcionalidad en ambas :ref:`Zend_Translator <zend.translator>`
y :ref:`Zend_Validate <zend.validate>` para realizar esa funcionalidad.

Por defecto, no se realiza ninguna internacionalización (I18n). Para iniciar las caraterísticas de I18n en
``Zend_Form``, se necesitará instanciar un objeto ``Zend_Translator`` con un adaptador apropiado, y adjuntarlo a
``Zend_Form`` y/o ``Zend_Validate``. Ver la :ref:`documentación Zend_Translator <zend.translator>` para más
información sobre crear el objeto traducción y los archivos de traducción

.. note::

   **La Traducción Puede Ser Deshabilitado Por Item**

   Se puede deshabilitar la traducción para cualquier formulario, elemento, grupo de visualización o
   subformulario llamando al método ``setDisableTranslator($flag)`` o pasando la opción ``disableTranslator`` al
   objeto. Puede ser de mucha ayuda cuando se quiere deshabilitar selectivamente la traducción para elementos
   individuales o grupo de elementos.

.. _zend.form.i18n.initialization:

Inicializando I18n en formularios
---------------------------------

Para poder inicializar I18n en formularios, se necesitará un objeto ``Zend_Translator`` o un objeto
``Zend_Translator_Adapter``, como se detalló en la documentación ``Zend_Translator``. Una vez que se tenga el
objeto traducción, existen varias opciones:

- **Fácil:** añadirlo al registro. Todos los componentes I18n de Zend Framework descubrirán automáticamente un
  objeto traducción que está en el registro con la clave 'Zend_Translator' y lo usará para ejecutar la
  traducción y/o la localización:

  .. code-block:: php
     :linenos:

     // use la clave 'Zend_Translator'; $translate es un objeto Zend_Translator:
     Zend_Registry::set('Zend_Translator', $translate);

  Será recibido por ``Zend_Form``, ``Zend_Validate`` y ``Zend_View_Helper_Translator``.

- Si todo lo que le preocupa es traducir los mensajes de error de validación, puede registrar el objeto
  traducción con ``Zend_Validate_Abstract``:

  .. code-block:: php
     :linenos:

     // Decir a todas las clases de validación que se use un adaptador especifico de traducción
     Zend_Validate_Abstract::setDefaultTranslator($translate);

- Alternativamente, se puede adjuntar al objeto ``Zend_Form`` como un traductor global. Tiene el mismo efecto que
  traduciendo los mensajes de error de validación.

  .. code-block:: php
     :linenos:

     // Decir a todas las clases del formulario usar un adaptador especifico, así como también
     // use este adaptador para traducir mensajes de error de validación
     Zend_Form::setDefaultTranslator($translate);

- Finalmente, se puede adjuntar un traductor a una instancia especifica de un formulario o a elementos especificar
  usando sus métodos ``setTranslator()``:

  .. code-block:: php
     :linenos:

     // Decir a *esta* instancia del formulario que use un adaptador especifico de traducción;
     // será usado para traducir mensajes de error de validación para todos los
     // elementos:
     $form->setTranslator($translate);

     // Decir a *este* elemento usar un adaptador especifico de traducción; será
     // usado para traducir los mensajes de error de validación para este
     // elemento en particular:
     $element->setTranslator($translate);

.. _zend.form.i18n.standard:

Objetivos estándar I18n
-----------------------

Ahora que ya se tiene adjuntado un objeto de traducción, ¿qué se puede traducir exactamente por defecto?

- **Mensajes de error de validación.** Los mensajes de error de validación pueden ser traducidos. Para hacerlo,
  use la variedad de constantes de códigos de error de ``Zend_Validate`` las clases de validación como los ID del
  mensaje. Para más información sobre esos códigos, ver la documentación :ref:`Zend_Validate <zend.validate>`.

  Alternativamente, desde la versión 1.6.0, se pueden proveer cadenas de traducción usando los mensajes de error
  actuales como mensajes identificadores. Este es el caso preferido de uso para 1.6.0 en adelante, así como
  también se volverá obsoleta la traducción de las claves de mensajes en versiones futuras.

- **Etiquetas.** Las etiquetas elemento serán traducidas, si una traducción existe.

- **Leyendas de campos.** Grupos de visualización y subformularios se generan por defecto en fieldsets. El
  decorador de fieldsets intenta traducir la leyenda antes de generar el fieldset.

- **Descripciones de formularios y elementos.** Todos los tipos de formulario (elemento, formulario, visualización
  de grupos, subformularios) permiten especificar una descripción opcional. El decorador Description puede
  generarlo y por defecto tomará el valor e intentará traducirlo.

- **Valores multi-opción.** Para los múltiples items que heredan de ``Zend_Form_Element_Multi`` (incluyendo el
  MultiCheckbox, Multiselect y elementos Radio), la valores de opciones (no claves) serán traducidos si una
  traducción esta disponible; eso significa que las etiquetas de opciones presentadas al usuario serán
  traducidas.

- **Submit y etiquetas Button.** Los múltiples elementos Submit y Button (Button, Submit y Reset) traducirán la
  etiqueta mostrada al usuario.


