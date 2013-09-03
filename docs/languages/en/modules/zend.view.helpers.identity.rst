.. _zend.view.helpers.initial.identity:

View Helper - Identity
======================

.. _zend.view.helpers.initial.identity.introduction:

Introduction
------------

The ``Identity`` helper allows for getting the identity from the ``AuthenticationService``.

For the ``Identity`` helper to work, a ``Zend\Authentication\AuthenticationService`` name or alias must be
defined and recognized by the ``ServiceManager``.

``Identity`` returns the identity in the ``AuthenticationService`` or `null` if no identity is available.

.. _zend.view.helpers.initial.identity.basicusage:

Basic Usage
-----------

.. code-block:: php
   :linenos:

    <?php
        if ($user = $this->identity()) {
            echo 'Logged in as ' . $this->escapeHtml($user->getUsername());
        } else {
            echo 'Not logged in';
        }
    ?>

.. _zend.view.helpers.initial.identity.servicemanager:

Using with ServiceManager
-------------------------

When invoked, the ``Identity`` plugin will look for a service by the name or alias
``Zend\Authentication\AuthenticationService`` in the ``ServiceManager``.
You can provide this service to the ``ServiceManager`` in a configuration file:

.. code-block:: php
    :linenos:

    // In a configuration file...
    return array(
        'service_manager' => array(
            'alias' => array(
                'Zend\Authentication\AuthenticationService' => 'my_auth_service',
            ),
            'invokables' => array(
                'my_auth_service' => 'Zend\Authentication\AuthenticationService';
                },
            ),
        ),
    );