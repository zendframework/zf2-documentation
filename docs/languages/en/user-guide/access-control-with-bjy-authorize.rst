.. _user-guide.access-control-with-bjy-authorize.rst

Access control with BjyAuthorize
================================

We now want to restrict access to our controllers to disallow actions
to unauthorized users.

To solve this problem, we're going to use `BjyAuthorize`_, which attaches
event listeners that check the authentication status of our user and halts
the application when unauthorized access is detected.

This is just one of the modules that can provide this sort of functionality,
and is specifically built on top of the the ``Zend\Permissions\Acl`` component.

If you want to use ``Zend\Permissions\Rbac`` instead, you could use `ZfcRbac`_
or look up the `modules repository`_.

Installing BjyAuthorize
-----------------------

To install `BjyAuthorize`_, simply run following:

.. code-block:: bash

    php composer.phar require bjyoungblood/bjy-authorize:1.2.*

.. note::

    Another way to install `BjyAuthorize`_ is to download it and place it into the ``module/``
    directory in your application.

We can then enable it in our modules list:

.. code-block:: php
    :emphasize-lines: 5

    <?php
    return array(
    'modules' => array(
        'ZfcBase',
        'ZfcUser',
        'BjyAuthorize',                  // <-- Add this line
        'Application',
        'Album',
    ),

    // ...

We also need to import the `sql schema definitions`_ for our ACL roles:

.. code-block:: sql

   CREATE TABLE IF NOT EXISTS `user_role` (
     `role_id` varchar(255) NOT NULL,
     `is_default` tinyint(1) NOT NULL,
     `parent` varchar(255) DEFAULT NULL,
     PRIMARY KEY (`role_id`)
   );

   CREATE TABLE IF NOT EXISTS `user_role_linker` (
     `user_id` int(11) unsigned NOT NULL,
     `role_id` varchar(255) NOT NULL,
     PRIMARY KEY (`user_id`,`role_id`),
     KEY `role_id` (`role_id`)
   );

So far, nothing should have changed in how our album application behaves.

Configuring BjyAuthorize
------------------------

We now want to disable access to actions that modify/add/delete our album records.
To do so, we have to configure `BjyAuthorize`_ so that the access control
rules look like following:

+----------------------+----------------------------------------------------------+
| Acl Roles            | Granted access                                           |
+======================+==========================================================+
| ``guest``, ``admin`` | ``Application\Controller\IndexController::indexAction``  |
+----------------------+----------------------------------------------------------+
| ``guest``, ``admin`` | ``Album\Controller\AlbumController::indexAction``        |
+----------------------+----------------------------------------------------------+
| ``admin``            | ``Album\Controller\AlbumController::addAction``          |
+----------------------+----------------------------------------------------------+
| ``admin``            | ``Album\Controller\AlbumController::editAction``         |
+----------------------+----------------------------------------------------------+
| ``admin``            | ``Album\Controller\AlbumController::deleteAction``       |
+----------------------+----------------------------------------------------------+
| ``guest``, ``admin`` | ``ZfcUser\Controller\UserController``                    |
+----------------------+----------------------------------------------------------+

First, let's add the ``admin`` and ``guest`` roles to our ``user_role`` table:

.. code-block:: sql

    INSERT INTO user_role VALUES ('guest', 0, NULL);
    INSERT INTO user_role VALUES ('admin', 0, NULL);

Let us create a ``config/autoload/bjy-authorize.global.php`` file with following contents:

.. code-block:: php

    <?php

    return array(
        'bjyauthorize' => array(
            // role providers are invoked when the list of existing roles
            // is required by bjy-authorize
            'role_providers' => array(
                'BjyAuthorize\Provider\Role\ZendDb' => array(
                    'table'             => 'user_role',
                    'role_id_field'     => 'role_id',
                    'parent_role_field' => 'parent',
                ),
            ),

            // guards are listeners acting as firewall for our application
            'guards' => array(
                'BjyAuthorize\Guard\Controller' => array(
                    array(
                        'controller' => 'Application\Controller\Index',
                        'action'     => 'index',
                        'roles'      => array('guest', 'admin'),
                    ),
                    array(
                        'controller' => 'Album\Controller\Album',
                        'action'     => 'index',
                        'roles'      => array('guest', 'admin'),
                    ),
                    array(
                        'controller' => 'Album\Controller\Album',
                        'action'     => 'add',
                        'roles'      => array('admin'),
                    ),
                    array(
                        'controller' => 'Album\Controller\Album',
                        'action'     => 'edit',
                        'roles'      => array('admin'),
                    ),
                    array(
                        'controller' => 'Album\Controller\Album',
                        'action'     => 'delete',
                        'roles'      => array('admin'),
                    ),
                    array(
                        'controller' => 'zfcuser',
                        // no action specified - all actions allowed!
                        'roles'      => array('guest', 'admin'),
                    ),
                ),
            ),
        ),
    );

This will attach a `BjyAuthorize\Guard\Controller`_ listener to our application, which
basically uses the names assigned to the controller services names and their actions
method names as resource names.

If we try to access ``http://zf2-tutorial.localhost/album/add`` now, we will see
a ``403 unauthorized`` error message.

Let's assign the ``admin`` role to our user. Following SQL query will assign the
role ``admin`` to all currently existing users:

.. code-block:: sql
   INSERT INTO `user_role_linker` SELECT `user_id`, 'admin' FROM `user`;

Now we can try again at ``http://zf2-tutorial.localhost/album/add``.
If we logout at ``http://zf2-tutorial.localhost/user/logout``, we will see the
``403 unauthorized`` error again.

.. _`BjyAuthorize`: https://github.com/bjyoungblood/BjyAuthorize/
.. _`ZfcRbac`: https://github.com/ZF-Commons/ZfcRbac
.. _`modules repository`: http://modules.zendframework.com/
.. _`sql schema definitions`: https://github.com/bjyoungblood/BjyAuthorize/blob/1.2.3/data/schema.sql
.. _`BjyAuthorize\Guard\Controller`: https://github.com/bjyoungblood/BjyAuthorize/blob/1.2.3/src/BjyAuthorize/Guard/Controller.php