.. _user-guide.overview:

###############################
Introducción a Zend Framework 2
###############################

Este tutorial está diseñado para brindar una introducción al uso de Zend Framework 2 
mediante la creación de una aplicación simple con una base de datos, utilizando el paradigma 
Modelo-Vista-Controlador. Al final tendrás una aplicación ZF2 funcionando y podrás 
revisar el código para saber mas acerca de como funciona todo.
.. _user-guide.overview.assumptions:

Algunas suposiciones
-------------------

En este tutorial asumimos que está ejecutando PHP 5.3.10 con el servidor web Apache
y MySQL, accesible mediante la extensión PDO. La instalación de Apache debe tener
instalada y configurada la extensión mod_rewrite.

También debes asegurarte que Apache esté configurado para soportar archivos `.htaccess``. Este
cambio generalmente se realiza en la configuración 

.. code-block:: apache

    AllowOverride None

a

.. code-block:: apache

    AllowOverride  All

en el archivo ``httpd.conf``. Revisa la documentación de tu distribución para detalles más exactos. 
No vas a poder navegar a ninguna página aparte de la página de inicio de este tutorial si no tienes 
configurado correctamente mod_rewrite y el archivo .htaccess

Tutorial de la aplicación 
-------------------------

La aplicación que vamos a crear es un simple sistema de inventario para mostrar
los discos que poseemos. La página principal va a listar nuestra colección y nos va a permitir agregar, 
modificar y eliminar CDs. Vamos a necesitar cuatro páginas en nuestro sitio web:

+--------------------+---------------------------------------------------------------+
| Página             | Descripción                                                   |
+====================+===============================================================+
| Lista de discos    | Mostrará el listado de discos y nos brindará enlaces para     |
|                    | poder editar y borrar. Ademas nos brindará, un enlace que nos |
|                    | permita agregar nuevos discos                                 |
+--------------------+---------------------------------------------------------------+
| Agregar nuevo disco| Esta página tendrá un formulario para agregar nuevos Discos.  |
+--------------------+---------------------------------------------------------------+
| Editar un disco    | Esta página tendrá un formulario para editar nuevos Discos    |
+--------------------+---------------------------------------------------------------+
| Eliminar un disco  | T Esta página confimará si que queremos eliminar un disco     |
|                    | y luego se eliminará.                                         |
+--------------------+---------------------------------------------------------------+


También vamos a necesitar guardar la información en una base de datos. 
Vamos a necesitar una sola tabla con estos campos:

+------------+--------------+-------+-----------------------------+
| Campo      | Tipo         | Null? | Notas                       |
+============+==============+=======+=============================+
| id         | integer      | No    | Primary key, auto-increment |
+------------+--------------+-------+-----------------------------+
| artist     | varchar(100) | No    |                             |
+------------+--------------+-------+-----------------------------+
| title      | varchar(100) | No    |                             |
+------------+--------------+-------+-----------------------------+

