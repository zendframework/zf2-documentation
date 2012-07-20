.. _zend.acl.refining:

Perfeccionamiento de los controles de acceso
============================================

.. _zend.acl.refining.precise:

Definir mejor los controles de acceso
-------------------------------------

El *ACL* básico según lo definido en la :ref:`sección anterior <zend.acl.introduction>` demuestra cómo los
diversos privilegios se pueden otorgar sobre todo el *ACL* (todos los recursos). En la práctica, sin embargo, los
controles de acceso tienden a tener excepciones y diversos grados de complejidad. ``Zend_Acl`` permite lograr estos
refinamientos de una manera sencilla y flexible.

Para el *CMS* del ejemplo se ha determinado que, si bien el grupo 'staff' cubre las necesidades de la gran mayoría
de usuarios, hay una necesidad de un nuevo grupo 'marketing' que requiere el acceso al boletín de noticias y las
últimas noticias en el *CMS*. El grupo es bastante auto suficiente y tendrá la capacidad de publicar y de
archivar los boletines de noticias y las últimas noticias.

Primero revisamos el registro del rol para reflejar estos cambios. Hemos determinado que el grupo 'marketing' tiene
los mismos permisos básicos que 'staff', así que definimos 'marketing' de tal manera que herede los permisos de
'staff':

.. code-block:: php
   :linenos:

    // El nuevo grupo de Marketing hereda los permisos de Staff
    $acl->addRole(new Zend_Acl_Role('marketing'), 'staff');

A continuación, la nota que por encima de los controles de acceso se refieren a recursos específicos (por
ejemplo, "boletín informativo", "últimas noticias", "anuncio de noticias"). Ahora añadimos estos recursos:

.. code-block:: php
   :linenos:

   // Crear recursos para las reglas
    // newsletter
    $acl->addResource(new Zend_Acl_Resource('newsletter'));

    // news
   $acl->addResource(new Zend_Acl_Resource('news'));

    // Últimas Noticias
   $acl->addResource(new Zend_Acl_Resource('latest'), 'news');

    // anuncio de noticias
   $acl->addResource(new Zend_Acl_Resource('announcement'), 'news');

Entonces es simplemente una cuestión de la definición de estas normas más específicas en ámbitos de la *ACL*:

.. code-block:: php
   :linenos:

    //
    Marketing debe ser capaz de archivar y publicar boletines informativos y
    // las últimas noticias
    $acl->allow('marketing',
    array('newsletter', 'latest'),
    array('publish', 'archive'));

    // Staff (y marketing, por herencia), se le denega el permiso a
    // revisar las últimas noticias
    $acl->deny('staff', 'latest', 'revise');

    // Todos (incluyendo los administradores) tienen permiso denegado para
    // archivar anuncios y noticias
    $acl->deny(null, 'announcement', 'archive');

Ahora podemos consultar el *ACL* con respecto a los últimos cambios:

.. code-block:: php
   :linenos:

    echo $acl->isAllowed('staff', 'newsletter', 'publish') ?
    "allowed" : "denied";
    // denegado

    echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
    "allowed" : "denied";
    // permitido

    echo $acl->isAllowed('staff', 'latest', 'publish') ?
    "allowed" : "denied";
    // denegado

    echo $acl->isAllowed('marketing', 'latest', 'publish') ?
    "allowed" : "denied";
    // permitido

    echo $acl->isAllowed('marketing', 'latest', 'archive') ?
    "allowed" : "denied";
    // permitido

    echo $acl->isAllowed('marketing', 'latest', 'revise') ?
    "allowed" : "denied";
    // denegado

    echo $acl->isAllowed('editor', 'announcement', 'archive') ?
    "allowed" : "denied";
    // denegado

    echo $acl->isAllowed('administrator', 'announcement', 'archive') ?
    "allowed" : "denied";
    // denegado


.. _zend.acl.refining.removing:

Eliminar los controles de acceso
--------------------------------

Para eliminar una o más reglas *ACL*, simplemente utilice el método ``removeAllow()`` o ``removeDeny()``. Al
igual que con ``allow()`` y ``deny()``, puede utilizar un valor ``NULL`` para indicar que el método es aplicable a
todos los roles, recursos y/o privilegios:

.. code-block:: php
   :linenos:

   // Elimina la prohibición de leer las últimas noticias de staff (y marketing,
   // por herencia)
   $acl->removeDeny('staff', 'latest', 'revise');

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
    "allowed" : "denied";
   // permitido

   // Elimina la autorización para publicar y archivar los boletines
   // marketing
   $acl->removeAllow('marketing',
                     'newsletter',
                     array('publish', 'archive'));

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // denegado

   echo $acl->isAllowed('marketing', 'newsletter', 'archive') ?
   "allowed" : "denied";

   // denegado


Los privilegios pueden ser modificados de manera incremental como se ha indicado anteriormente, pero un valor
``NULL`` para los privilegios anula tales cambios incrementales:

.. code-block:: php
   :linenos:

   //Permitir al grupo de "marketing" todos los permisos a las últimas noticias
   $acl->allow('marketing', 'latest');

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
   "allowed" : "denied";
   //permitido

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
   "allowed" : "denied";
   //permitido

   echo $acl->isAllowed('marketing', 'latest', 'anything') ?
   "allowed" : "denied";
   // permitido


