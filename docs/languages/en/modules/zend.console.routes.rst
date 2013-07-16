.. _zend.console.routes:

Console routes and routing
===========================

Zend Framework 2 has :doc:`native MVC integration with console<zend.console.introduction>`,
which means that command line arguments are read and used to determine the appropriate
:doc:`action controller <zend.mvc.controllers>` and action method that will handle the request. Actions can
perform any number of task prior to returning a result, that will be displayed to the user in his console window.

There are several routes you can use with Console. All of them are defined in ``Zend\Mvc\Router\Console\*`` classes.


.. seealso::

    Routes are used to handle real commands, but they are not used to create help messages (usage information).
    When a zf2 application is run in console for the first time (without arguments) it can
    :doc:`display usage information <zend.console.modules>` that is provided by modules. To learn more about
    providing usage information, please read this chapter: :doc:`zend.console.modules`.


Router configuration
--------------------

All Console Routes are automatically read from the following configuration location:

.. code-block:: php
    :linenos:
    :emphasize-lines: 9-15

    // This can sit inside of modules/Application/config/module.config.php or any other module's config.
    array(
        'router' => array(
            'routes' => array(
                // HTTP routes are here
            )
        ),

        'console' => array(
            'router' => array(
                'routes' => array(
                    // Console routes go here
                )
            )
        ),
    )

Console Routes will only be processed when the application is run inside console (terminal) window. They have no
effect in web (http) request and will be ignored. It is possible to define only HTTP routes (only web application) or
only Console routes (which means we want a console-only application which will refuse to run in a browser).

A single route can be described with the following array:

.. code-block:: php
    :linenos:

    // inside config.console.router.routes:
    // [...]
    'my-first-route' => array(
        'type'    => 'simple',       // <- simple route is created by default, we can skip that
        'options' => array(
            'route'    => 'foo bar',
            'defaults' => array(
                'controller' => 'Application\Controller\Index',
                'action'     => 'password'
            )
        )
    )

We have created a ``simple`` console route with a name ``my-first-route``. It expects two parameters:
``foo`` and ``bar``. If user puts these in a console, ``Application\Controller\IndexController::passwordAction()`` action will be
invoked.


.. seealso::

    You can read more about how :doc:`ZF2 routing works in this chapter<zend.mvc.routing>`.

.. _basic-route:

Basic route
-----------
This is the default route type for console. It recognizes the following types of parameters:

* :ref:`Literal parameters <literal-params>` (i.e. ``create object (external|internal)``)
* :ref:`Literal flags <literal-flags>` (i.e. ``--verbose --direct [-d] [-a]``)
* :ref:`Positional value parameters <value-positional>` (i.e. ``create <modelName> [<destination>]``)
* :ref:`Value flags <value-flags>` (i.e. ``--name=NAME [--method=METHOD]``)


.. _literal-params:

Literal parameters
^^^^^^^^^^^^^^^^^^^

These parameters are expected to appear on the command line exactly the way they are spelled in the route. For example:

.. code-block:: php
    :linenos:

    'show-users' => array(
        'options' => array(
            'route'    => 'show users',
            'defaults' => array(
                'controller' => 'Application\Controller\Users',
                'action'     => 'show'
            )
        )
    )

This route will **only** match for the following command line

.. code-block:: bash

    > zf show users

It expects **mandatory literal parameters** ``show users``. It will not match if there are any more params,
or if one of the words
is missing. The order of words is also enforced.

We can also provide **optional literal parameters**, for example:

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'show-users' => array(
        'options' => array(
            'route'    => 'show [all] users',
            'defaults' => array(
                'controller' => 'Application\Controller\Users',
                'action'     => 'show'
            )
        )
    )

Now this route will match for both of these commands:

.. code-block:: bash

    > zf show users
    > zf show all users

We can also provide **parameter alternative**:

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'show-users' => array(
        'options' => array(
            'route'    => 'show [all|deleted|locked|admin] users',
            'defaults' => array(
                'controller' => 'Application\Controller\Users',
                'action'     => 'show'
            )
        )
    )

This route will match both without and with second parameter being one of the words, which enables us to capture
commands such:

.. code-block:: bash

    > zf show users
    > zf show locked users
    > zf show admin users
    etc.


.. note::

   Whitespaces in route definition are ignored. If you separate your parameters with more spaces,
   or separate alternatives and pipe characters with spaces, it won't matter for the parser. The above route
   definition is equivalent to: ``show [  all | deleted | locked | admin  ]   users``


.. _literal-flags:

Literal flags
^^^^^^^^^^^^^^

Flags are a common concept for console tools. You can define any number of optional and mandatory flags. The order of
flags is ignored. The can be defined in any order and the user can provide them in any other order.
 
Let's create a route with **optional long flags**

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'check-users' => array(
        'options' => array(
            'route'    => 'check users [--verbose] [--fast] [--thorough]',
            'defaults' => array(
                'controller' => 'Application\Controller\Users',
                'action'     => 'check'
            )
        )
    )


This route will match for commands like:

.. code-block:: bash

    > zf check users
    > zf check users --fast
    > zf check users --verbose --thorough
    > zf check users --thorough --fast

We can also define one or more **mandatory long flags** and group them as an alternative:

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'check-users' => array(
        'options' => array(
            'route'    => 'check users (--suspicious|--expired) [--verbose] [--fast] [--thorough]',
            'defaults' => array(
                'controller' => 'Application\Controller\Users',
                'action'     => 'check'
            )
        )
    )

This route will **only match** if we provide either ``--suspicious`` or ``--expired`` flag, i.e.:

.. code-block:: bash

    > zf check users --expired
    > zf check users --expired --fast
    > zf check users --verbose --thorough --suspicious

We can also use **short flags** in our routes and group them with long flags for convenience, for example:

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'check-users' => array(
        'options' => array(
            'route'    => 'check users [--verbose|-v] [--fast|-f] [--thorough|-t]',
            'defaults' => array(
                'controller' => 'Application\Controller\Users',
                'action'     => 'check'
            )
        )
    )

Now we can use short versions of our flags:

.. code-block:: bash

    > zf check users -f
    > zf check users -v --thorough
    > zf check users -t -f -v

.. _value-positional:

Positional value parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Value parameters capture any text-based input and come in two forms - positional and flags.

**Positional value parameters** are expected to appear in an exact position on the command line. Let's take a look at
 the following route definition:

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'delete-user' => array(
        'options' => array(
            'route'    => 'delete user <userEmail>',
            'defaults' => array(
                'controller' => 'Application\Controller\Users',
                'action'     => 'delete'
            )
        )
    )

This route will match for commands like:

.. code-block:: bash

    > zf delete user john@acme.org
    > zf delete user betty@acme.org

We can access the email value by calling ``$this->getRequest()->getParam('userEmail')`` inside of our controller
action (you can :ref:`read more about accessing values here <reading-values>`)

We can also define **optional positional value parameters** by adding square brackets:

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'delete-user' => array(
        'options' => array(
            'route'    => 'delete user [<userEmail>]',
            'defaults' => array(
                'controller' => 'Application\Controller\Users',
                'action'     => 'delete'
            )
        )
    )

In this case, ``userEmail`` parameter will not be required for the route to match. If it is not provided,
``userEmail`` parameter will not be set.

We can define any number of positional value parameters, for example:

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'create-user' => array(
        'options' => array(
            'route'    => 'create user <firstName> <lastName> <email> <position>',
            'defaults' => array(
                'controller' => 'Application\Controller\Users',
                'action'     => 'create'
            )
        )
    )

This allows us to capture commands such as:

.. code-block:: bash

    > zf create user Johnny Bravo john@acme.org Entertainer

.. note::

    Command line arguments on all systems must be properly escaped, otherwise they will not be passed to our
    application correctly. For example, to create a user with two names and a complex position description,
    we could write something like this:

    .. code-block:: bash

        > zf create user "Johnan Tom" Bravo john@acme.org "Head of the Entertainment Department"

.. _value-flags:

Value flag parameters
^^^^^^^^^^^^^^^^^^^^^

Positional value parameters are only matched if they appear in the exact order as described in the route. If we do
not want to enforce the order of parameters, we can define **value flags**.

**Value flags** can be defined and matched in any order. They can digest text-based values, for example:

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'find-user' => array(
        'options' => array(
            'route'    => 'find user [--id=] [--firstName=] [--lastName=] [--email=] [--position=] ',
            'defaults' => array(
                'controller' => 'Application\Controller\Users',
                'action'     => 'find'
            )
        )
    )

This route will match for any of the following routes:

.. code-block:: bash

    > zf find user
    > zf find user --id 29110
    > zf find user --id=29110
    > zf find user --firstName=Johny --lastName=Bravo
    > zf find user --lastName Bravo --firstName Johny
    > zf find user --position=Executive --firstName=Bob
    > zf find user --position "Head of the Entertainment Department"

.. note::

    The order of flags is irrelevant for the parser.

.. note::

    The parser understands values that are provided after equal symbol (=) and separated by a space. Values without
    whitespaces can be provided after = symbol or after a space. Values with one more whitespaces however, must be
    properly quoted and written after a space.

In previous example, all value flags are optional. It is also possible to define **mandatory value flags**:

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'rename-user' => array(
        'options' => array(
            'route'    => 'rename user --id= [--firstName=] [--lastName=]',
            'defaults' => array(
                'controller' => 'Application\Controller\Users',
                'action'     => 'rename'
            )
        )
    )

The ``--id`` parameter **is required** for this route to match. The following commands will work with this route:

.. code-block:: bash

    > zf rename user --id 123
    > zf rename user --id 123 --firstName Jonathan
    > zf rename user --id=123 --lastName=Bravo


.. _reading-values:

Catchall route
--------------

This special route will catch all console requests, regardless of the parameters provided.

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'default-route' => array(
        'options' => array(
            'type'     => 'catchall',
            'defaults' => array(
                'controller' => 'Application\Controller\Index',
                'action'     => 'consoledefault'
            )
        )
    )

.. note::

    This route type is rarely used. You could use it as a last console route, to display usage information. Before
    you do so, read about the :doc:`preferred way of displaying console usage information <zend.console.modules>`.
    It is the recommended way and will guarantee proper inter-operation with other modules in your application.


Console routes cheat-sheet
---------------------------

+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Param type                          | Example route definition     |  Explanation                                                                  |
+=====================================+==============================+===============================================================================+
| **Literal params**                                                                                                                                 |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Literal                             | ``foo bar``                  | "foo" followed by "bar"                                                       |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Literal alternative                 | ``foo (bar|baz)``            | "foo" followed by "bar" or "baz"                                              |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Literal, optional                   | ``foo [bar]``                | "foo", optional "bar"                                                         |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Literal, optional alternative       | ``foo [bar|baz]``            | "foo", optional "bar" or "baz"                                                |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| **Flags**                                                                                                                                          |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Flag long                           | ``foo --bar``                | "foo" as first parameter, "--bar" flag before or after                        |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Flag long, optional                 | ``foo [--bar]``              | "foo" as first parameter, optional "--bar" flag before or after               |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Flag long, optional, alternative    | ``foo [--bar|--baz]``        | "foo" as first parameter, optional "--bar" or "--baz", before or after        |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Flag short                          | ``foo -b``                   | "foo" as first parameter, "-b" flag before or after                           |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Flag short, optional                | ``foo [-b]``                 | "foo" as first parameter, optional "-b" flag before or after                  |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Flag short, optional, alternative   | ``foo [-b|-z]``              | "foo" as first parameter, optional "-b" or "-z", before or after              |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Flag long/short alternative         | ``foo [--bar|-b]``           | "foo" as first parameter, optional "--bar" or "-b" before or after            |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| **Value parameters**                                                                                                                               |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Value positional param              | ``foo <bar>``                | "foo" followed by any text (stored as "bar" param)                            |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Value positional param, optional    | ``foo [<bar>]``              | "foo", optionally followed by any text (stored as "bar" param)                |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Value Flag                          | ``foo --bar=``               | "foo" as first parameter, "--bar" with a value, before or after               |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Value Flag, optional                | ``foo [--bar=]``             | "foo" as first parameter, optionally "--bar" with a value, before or after    |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| **Parameter groups**                                                                                                                               |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Literal params group                | ``foo (bar|baz):myParam``    | "foo" followed by "bar" or "baz" (stored as "myParam" param)                  |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Literal optional params group       | ``foo [bar|baz]:myParam``    | "foo" followed by optional "bar" or "baz" (stored as "myParam" param)         |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Long flags group                    | ``foo (--bar|--baz):myParam``| "foo", "bar" or "baz" flag before or after (stored as "myParam" param)        |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Long optional flags group           | ``foo [--bar|--baz]:myParam``| "foo", optional "bar" or "baz" flag before or after (as "myParam" param)      |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Short flags group                   | ``foo (-b|-z):myParam``      | "foo", "-b" or "-z" flag before or after (stored as "myParam" param)          |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
| Short optional flags group          | ``foo [-b|-z]:myParam``      | "foo", optional "-b" or "-z" flag before or after (stored as "myParam" param) |
+-------------------------------------+------------------------------+-------------------------------------------------------------------------------+
