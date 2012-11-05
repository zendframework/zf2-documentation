.. EN-Revision: none
.. _zend.mail.different-transports:

Używanie innych transportów
===========================

W przypadku gdy chcesz wysłać różne e-maile poprzez różne połączenia, możesz także przekazać obiekt
transportu bezpośrednio do metody *send()* bez wcześniejszego wywołania *setDefaultTransport()*. Przekazany
obiekt nadpisze domyślny transport dla aktualnego wywołania *send()*:

.. _zend.mail.different-transports.example-1:

.. rubric:: Używanie innych transportów

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();
   // tworzymy wiadomość...
   $tr1 = new Zend\Mail_Transport\Smtp('server@example.com');
   $tr2 = new Zend\Mail_Transport\Smtp('other_server@example.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // znów używamy domyślnego transportu


.. note::

   **Dodatkowe transporty**

   Dodatkowe transporty mogą być napisane poprzez zaimplementowanie interfejsu *Zend\Mail_Transport\Interface*.


