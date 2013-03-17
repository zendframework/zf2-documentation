.. _user-guide.authentication-with-zfc-user:

Authentication with ZfcUser
===========================

Our module is now complete, but we still want to be able to login/logout
and to disallow unwanted operations on our user list.

We will first start with authentication.

Installing ZfcUser
------------------

`ZfcUser`_ is a module that simplifies handling of authentication and secure handling
of authentication credentials.

To install `ZfcUser`_, you can use composer:

.. code-block:: bash

    php composer.phar require "zf-commons/zfc-user": "0.1.*"

.. note::

    Another way to install `ZfcUser`_ is to download it and place it into the ``module/``
    directory in your application. You will also need to download `ZfcBase`_, and place
    it in the ``module/`` directory as well.

Once installed, we have to enable `ZfcUser`_ in our ``config/application.config.php``

.. code-block:: php
    :emphasize-lines: 3,4

        <?php
        return array(
            'modules' => array(
                'ZfcBase',                  // <-- Add this line
                'ZfcUser',                  // <-- Add this line
                'Application',
                'Album',
            ),

            // ...st_inconveniente

We now have to import the `schema definitions`_ for `ZfcUser`_ in our database:

.. code-block:: sql

   CREATE TABLE user
   (
       user_id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
       username VARCHAR(255) DEFAULT NULL UNIQUE,
       email VARCHAR(255) DEFAULT NULL UNIQUE,
       display_name VARCHAR(50) DEFAULT NULL,
       password VARCHAR(128) NOT NULL,
       state SMALLINT
   );

Now we can visit our page at ``http://zf2-tutorial.localhost/user/register`` and create
our own account. We can add the login/logout links to your pages by putting something like
following code somewhere in your ``module/Application/view/layout/layout.phtml``:

.. code-block:: php

   <?php if ($this->zfcUserIdentity()) : ?>
       <a href="<?php echo $this->escapeHtmlAttr($this->url('zfcuser/logout')); ?>">Logout</a>
   <?php else: ?>
       <a href="<?php echo $this->escapeHtmlAttr($this->url('zfcuser/login')); ?>">Login</a>
   <?php endif; ?>

The ``zfcUserIdentity`` helper is provided by `ZfcUser`_

.. _`ZfcUser`: https://github.com/ZF-Commons/ZfcUser
.. _`ZfcBase`: https://github.com/ZF-Commons/ZfcBase
.. _`schema definitions`: https://github.com/ZF-Commons/ZfcUser/blob/0.1.1/data/schema.sql