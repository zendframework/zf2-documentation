.. _zend.view.helpers.initial.identity:

Identity Helper
---------------

The ``Identity`` helper allows for getting the identity from the ``AuthenticationService``.

For the ``Identity`` helper to work, a ``Zend\Authentication\AuthenticationService`` name or alias must be
defined and recognized by the ``serviceLocator``.

``Identity`` returns the identity in the ``AuthenticationService`` or `null` if no identity is available.

As an example:

.. code-block:: php
   :linenos:

    <?php
        if ($user = $this->identity()) {
            echo 'Logged in as ' . $this->escapeHtml($user->getUsername());
        } else {
            echo 'Not logged in';
        }
    ?>
