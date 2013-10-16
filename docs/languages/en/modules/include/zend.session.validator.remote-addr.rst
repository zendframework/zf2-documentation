.. _zend.session.validator.remote-addr:

Remote Addr
-----------

``Zend\Session\Validator\RemoteAddr`` provides a validator to check the session against the originally stored
$_SERVER['REMOTE_ADDR'] variable.  Validation will fail in the event that this does not match and throws an
exception in ``Zend\Session\SessionManager`` after session_start() has been called.

Basic Usage
^^^^^^^^^^^

A basic example is one like the following:

.. code-block:: php
   :linenos:

   use Zend\Session\Validator\RemoteAddr;
   use Zend\Session\SessionManager;
   
   $manager = new SessionManager();
   $manager->getValidatorChain()->attach('session.validate', array(new RemoteAddr(), 'isValid'));

