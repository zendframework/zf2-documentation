.. _zend.layout.introduction:

Introducción
============

``Zend_Layout`` implementa un patrón clásico "Vista en dos etapas" (Two Step View) permitiendo a los
desarrolladores colocar el contenido de la aplicación dentro de otra vista, usualmente representando la plantilla
del sitio. Tales plantillas son a menudo denominadas **layouts** por otros proyectos, y Zend Framework ha adoptado
este término por consistencia.

Los objetivos principales de ``Zend_Layout`` son los siguientes:

- Automatizar la selección y renderizado de layouts cuando se usan con los componentes *MVC* de Zend Framework.

- Proveer ámbitos separados para variables relacionadas al diseño y contenido.

- Permitir configuraciones, incluyendo el nombre del layout, resolución (inflexión) del script layout, y ruta del
  script layout.

- Permitir deshabilitar layouts, cambiar el script de diseño y otras condiciones; permitir estas acciones dentro
  de los controladores y scripts de vista.

- Seguir normas de resolución similares (inflexión) como el :ref:`ViewRenderer
  <zend.controller.actionhelpers.viewrenderer>`, pero permitiendo también el uso de normas distintas

- Permitir el uso de los componentes *MVC* de Zend Framework.


