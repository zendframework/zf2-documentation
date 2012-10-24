.. _user-guide.modules:

#######
Módulos
#######

Zend Framework 2 utiliza un sistema de módulos para organizar el código específico
para cada etapa en su correspondiente módulo. El módulo Application que provee la
aplicación esqueleto se utiliza para proveer la configuración de bootstrapping, error y
enrutamiento para toda la aplicación. Se utiliza habitualmente para proveer controladores
de nivel de aplicación para, se podría decir, la página de inicio de una aplicación, pero 
no vamos a utilizar la que viene por defecto en este tutorial, pues queremos que la página
de inicio sea la lista de albums, la cual va a vivir en nuestro módulo.

Vamos a poner todo nuestro código en el módulo Album, el cual va a contener nuestros
controladores, modelos, formularios y vistas. Además vamos a necesitar algunos archivos de
configuración.

Comencemos con las carpetas requeridas.

Configurando el módulo Album
----------------------------

Comience creando una carpeta llamada ``Album`` con los siguientes
subdirectorios para guardar los archivos del módulo:

.. code-block:: text

    zf2-tutorial/
        /module
            /Album
                /config
                /src
                    /Album
                        /Controller
                        /Form
                        /Model
                /view
                    /album
                        /album

Como puede ver, el módulo ``Album`` posee directorios separados para los diferentes
tipos de archivos que va a tener. Los archivos PHP que contienen clases con el
namespace ``Album`` viven en el directorio ``src/Album``, por lo que podemos tener
múltiples namespaces dentro de nuestro módulo cuando sea necesario. El directorio de vistas
tiene también un subdirectorio llamado ``album`` para las vistas de nuestro módulo.

Para poder cargar y configurar un módulo, Zend Framework 2 tiene un
``ModuleManager``. Este módulo buscará ``Module.php`` en la raíz del directorio
del módulo (``module/Album``) y espera encontrar una clase llamada ``Album\Module``
dentro de ella. Esto es, las clases dentro de un módulo dado llevarán el namespace del
nombre del mismo, el cual es el nombre del directorio del módulo.

Cree el archivo Module.php en el módulo Album:

.. code-block:: php

    // module/Album/Module.php
    namespace Album;
    
    class Module
    {
        public function getAutoloaderConfig()
        {
            return array(
                'Zend\Loader\ClassMapAutoloader' => array(
                    __DIR__ . '/autoload_classmap.php',
                ),
                'Zend\Loader\StandardAutoloader' => array(
                    'namespaces' => array(
                        __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                    ),
                ),
            );
        }
    
        public function getConfig()
        {
            return include __DIR__ . '/config/module.config.php';
        }
    }

El ``ModuleManager`` llamará a ``getAutoloaderConfig()`` y ``getConfig()``
automáticamente por nosotros.

Autoload de archivos
^^^^^^^^^^^^^^^^^^^

Nuestro método ``getAutoloaderConfig()`` devuelve un array que es compatible con
el método ``AutoloaderFactory`` de ZF2. Lo configuramos para agregar un archivo classmap al
``ClassmapAutoloader``, y además agregar el namespace del módulo a
``StandardAutoloader``. El autoloader estándar requiere un namespace y la
ruta donde encontrar los archivos de ese namespace. Es obediente con PSR-0 por lo que
las clases se referencian directamente a sus archivos por las reglas PSR-0
<https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md>`_.

Como estamos en modo desarrollo, no necesitamos cargar archivos a través del classmap, por lo que proveemos un array
vacío para el classmap autoloader. Creamos ``autoload_classmap.php`` con este contenido:

.. code-block:: php

    <?php
    // module/Album/autoload_classmap.php:
    return array();

Como este es un array vacío, siempre que el autoloader busque una clase dentro del
namespace ``Album``, retrocederá hasta el `StandardAutoloader`` por nosotros.

.. note::

    Note que si bien estamos utilizando composer, como alternativa, podría no implementar
    ``getAutoloaderConfig()`` y en su lugar añadir ``"Application":
    "module/Application/src"`` a la clave ``psr-0`` en ``composer.json``. Si sigue
    este camino, necesita ejecutar ``php composer.phar update`` para actualizar
    los ficheros autoload de composer.

Configuración
-------------

Habiendo registrado el autoloader, démosle una mirada rápida al método ``getConfig()``
en ``Album\Module``. Este método simplemente carga el archivo
``config/module.config.php``.

Cree el siguiente archivo de configuración para el módulo ``Album``:

.. code-block:: php

    // module/Album/config/module.config.php:
    return array(
        'controllers' => array(
            'invokables' => array(
                'Album\Controller\Album' => 'Album\Controller\AlbumController',
            ),
        ),
        'view_manager' => array(
            'template_path_stack' => array(
                'album' => __DIR__ . '/../view',
            ),
        ),
    );

La información de la configuración es pasada a los componentes relevantes por el
``ServiceManager``. Necesitamos dos secciones iniciales: ``controller`` y
``view_manager``. La sección controller provee una lista de todos los controladores
que provee el módulo. Necesitaremos un controlador, ``AlbumController``, que
referenciaremos como ``Album\Controller\Album``. La clave del controlador debe
ser única a través de todos los módulos, por lo que utilizaremos el nombre de
nuestro módulo como prefijo.

Dentro de la sección ``view_manager``, añadimos nuestro directorio de vistas a la
configuración de ``TemplatePathStack``. Esto le permitirá encontrar los scripts de vista
para el módulo ``Album`` que están almacenados en nuestro directorio ``views/``.

Informando a la aplicación acerca de nuestro nuevo módulo
---------------------------------------------------------

Ahora necesitamos decirle al ``ModuleManager`` que este nuevo módulo existe. Esto se hace
en el archivo ``config/application.config.php`` de la aplicación, el cual es provisto por la
aplicación esqueleto. Actualiza este archivo para que la sección ``modules`` contenga el
módulo ``Album``, y el fichero ahora se parecerá a esto:

(Los cambios requeridos están resaltados utilizando comentarios.)

.. code-block:: php

    // config/application.config.php:
    return array(
        'modules' => array(
            'Application',
            'Album',                  // <-- Add this line
        ),
        'module_listener_options' => array( 
            'config_glob_paths'    => array(
                'config/autoload/{,*.}{global,local}.php',
            ),
            'module_paths' => array(
                './module',
                './vendor',
            ),
        ),
    );

Como puede ver, agregamos nuestro módulo ``Album`` en la lista de módulos
después del módulo ``Application``.

Ahora tenemos el módulo preparado y listo para ponerle nuestro código personalizado.
