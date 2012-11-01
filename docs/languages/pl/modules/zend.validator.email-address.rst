.. EN-Revision: none
.. _zend.validator.set.email_address:

EmailAddress
============

Klasa *Zend\Validate\EmailAddress* pozwala ci na przeprowadzenie weryfikacji adresu email. Weryfikator wpierw
dzieli adres email na część lokalną oraz na nazwę serwera, a następnie próbuje sprawdzić je w oparciu o
znane specyfikacje dla adresów email oraz adresów serwerów.

**Podstawowe użycie**

Poniżej podstawowy przykład użycia:

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\EmailAddress();
      if ($validator->isValid($email)) {
          // adres email wygląda na prawidłowy
      } else {
          // adres email jest nieprawidłowy; wyświetl powody
          foreach ($validator->getMessages() as $message) {
              echo "$message\n";
          }
      }


Sprawdzi to adres email *$email* i w przypadku niepowodzenia wypełni *$validator->getMessages()* użytecznymi
informacjami informującymi o błędach.

**Części adresu email**

*Zend\Validate\EmailAddress* dopasuje każdy prawidłowy adres email zgodny ze specyfikacją RFC2822. Na przykład,
poprawnymi adresami będą *bob@domain.com*, *bob+jones@domain.us*, *"bob@jones"@domain.com* oraz *"bob
jones"@domain.com*

Niektóre przestarzałe formaty adresów email nie są obecnie weryfikowane (np. zawierające znak powrotu karetki,
albo znak "\\" w adresie email).

**Weryfikacja dla różnych typów adresów serwerów**

Część adresu email zawierająca adres serwera jest weryfikowana za pomocą :ref:`Zend\Validate\Hostname
<zend.validator.set.hostname>`. Domyślnie akceptowane są jedynie adresy DNS w stylu *domain.com*, ale jeśli
chcesz, to możesz włączyć akceptowanie także adresów IP oraz adresów lokalnych.

Aby to zrobić, musisz utworzyć instancję *Zend\Validate\EmailAddress* przekazując parametr określający typ
adresów jakie chcesz akceptować. Więcej szczegółów znajdziesz w *Zend\Validate\Hostname*, jednak poniżej
możesz zobaczyć przykład akceptowania zarówno adresów DNS jak i adresów lokalnych:

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\EmailAddress(Zend\Validate\Hostname::ALLOW_DNS | Zend\Validate\Hostname::ALLOW_LOCAL);
      if ($validator->isValid($email)) {
          // adres email wygląda na prawidłowy
      } else {
          // adres email jest nieprawidłowy; wyświetl powody
          foreach ($validator->getMessages() as $message) {
              echo "$message\n";
          }
      }




**Checking if the hostname actually accepts email**

Just because an email address is in the correct format, it doesn't necessarily mean that email address actually
exists. To help solve this problem, you can use MX validation to check whether an MX (email) entry exists in the
DNS record for the email's hostname. This tells you that the hostname accepts email, but doesn't tell you the exact
email address itself is valid.

MX checking is not enabled by default and at this time is only supported by UNIX platforms. To enable MX checking
you can pass a second parameter to the *Zend\Validate\EmailAddress* constructor.

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\EmailAddress(Zend\Validate\Hostname::ALLOW_DNS, true);


Alternatively you can either pass *true* or *false* to *$validator->setValidateMx()* to enable or disable MX
validation.

By enabling this setting network functions will be used to check for the presence of an MX record on the hostname
of the email address you wish to validate. Please be aware this will likely slow your script down.

**Validating International Domains Names**

*Zend\Validate\EmailAddress* will also match international characters that exist in some domains. This is known as
International Domain Name (IDN) support. This is enabled by default, though you can disable this by changing the
setting via the internal *Zend\Validate\Hostname* object that exists within *Zend\Validate\EmailAddress*.

   .. code-block:: php
      :linenos:

      $validator->hostnameValidator->setValidateIdn(false);


Więcej informacji na temat użycia metody *setValidateIdn()* znajduje się w dokumentacji
*Zend\Validate\Hostname*.

Please note IDNs are only validated if you allow DNS hostnames to be validated.

**Validating Top Level Domains**

By default a hostname will be checked against a list of known TLDs. This is enabled by default, though you can
disable this by changing the setting via the internal *Zend\Validate\Hostname* object that exists within
*Zend\Validate\EmailAddress*.

   .. code-block:: php
      :linenos:

      $validator->hostnameValidator->setValidateTld(false);


Więcej informacji na temat użycia metody *setValidateTld()* znajduje się w dokumentacji Zend\Validate\Hostname.

Please note TLDs are only validated if you allow DNS hostnames to be validated.


