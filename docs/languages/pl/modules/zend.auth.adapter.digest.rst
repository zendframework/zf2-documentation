.. _zend.auth.adapter.digest:

Uwierzytelnianie Digest
=======================

.. _zend.auth.adapter.digest.introduction:

Wprowadzenie
------------

`Uwierzytelnianie Digest`_ jest metodą uwierzytelniania *HTTP*, która udoskonala `uwierzytelnianie Basic`_
dostarczając sposób uwierzytelniania bez konieczności przesyłania hasła w postaci czystego tekstu poprzez
sieć.

Ten adapter pozwala na uwierzytelnianie w oparciu o pliki tekstowe zawierające linie, w których znajdują się
podstawowe elementy uwierzytelniania digest:

- nazwa użytkownika, jak na przykład "**joe.user**"

- nazwa obszaru, jak na przykład "**Administrative Area**"

- skrót *MD5* nazwy użytkownika, nazwy obszaru oraz hasła, oddzielonych dwukropkami

Powyższe elementy są oddzielone dwukropkami, tak jak w poniższym przykładzie (w którym hasłem jest
"**somePassword**"):

.. code-block:: text
   :linenos:

   someUser:Some Realm:fde17b91c3a510ecbaf7dbd37f59d4f8

.. _zend.auth.adapter.digest.specifics:

Parametry
---------

Adapter uwierzytelniania digest, ``Zend_Auth_Adapter_Digest``, wymaga ustawienia kilku wejściowych parametrów:

- filename - plik na podstawie którego przeprowadzane są zapytania uwierzytelniania

- realm - obszar uwierzytelniania Digest

- username - użytkownik uwierzytelniania Digest

- password - hasło dla użytkownika danego obszaru

Te parametry muszą być ustawione przed wywołaniem metody ``authenticate()``.

.. _zend.auth.adapter.digest.identity:

Tożsamość
---------

Adapter uwierzytelniania digest zwraca obiekt ``Zend_Auth_Result``, który został wypełniony danymi tożsamości
w postaci tablicy posiadajacej klucze **realm** oraz **username**. Odpowiednie wartości tablicy powiązane z tymi
kluczami odpowiadają wartościom ustawionym przed wywołaniem metody ``authenticate()``.

.. code-block:: php
   :linenos:

   $adapter = new Zend_Auth_Adapter_Digest($filename,
                                           $realm,
                                           $username,
                                           $password);

   $result = $adapter->authenticate();

   $identity = $result->getIdentity();

   print_r($identity);

   /*
   Array
   (
       [realm] => Some Realm
       [username] => someUser
   )
   */



.. _`Uwierzytelnianie Digest`: http://en.wikipedia.org/wiki/Digest_access_authentication
.. _`uwierzytelnianie Basic`: http://en.wikipedia.org/wiki/Basic_authentication_scheme
