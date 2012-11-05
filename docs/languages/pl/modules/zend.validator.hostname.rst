.. EN-Revision: none
.. _zend.validator.set.hostname:

Hostname
========

Zend\Validate\Hostname pozwala ci na przeprowadzenie weryfikacji adresów serwerów w oparciu o zestaw znanych
specyfikacji. Możliwe jest sprawdzenie trzech różnych typów adresów serwerów: adresu DNS (np. domain.com),
adresu IP (np. 1.2.3.4), oraz adresu lokalnego (np. localhost). Domyślne będzie to sprawdzane jedynie w
kontekście adresów DNS.

**Podstawowe użycie**

Poniżej podstawowy przykład użycia:

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\Hostname();
      if ($validator->isValid($hostname)) {
          // nazwa serwera wygląda na prawidłową
      } else {
          // nazwa jest nieprawidłowa; wyświetl powody
          foreach ($validator->getMessages() as $message) {
              echo "$message\n";
          }
      }


Sprawdzi to nazwę serwera *$hostname* i w przypadku niepowodzenia wypełni *$validator->getMessages()*
użytecznymi informacjami informującymi o błędach.

**Weryfikacja różnych typów adresów serwerów**

Może się okazać, że chcesz zezwolić na użycie adresów IP, adresów lokalnych lub kombinacji dozwolonych
typów. Możesz to zrobić przekazując parametr do obiektu Zend\Validate\Hostname gdy tworzysz jego instancję.
Parametr powinien być liczbą całkowitą określającą, ktorego typu adresy są dozwolone. Zalecamy użycie
stałych klasy Zend\Validate\Hostname w tym celu.

Stałe klasy Zend\Validate\Hostname to: *ALLOW_DNS* aby zezwalać tylko na adresy DNS, *ALLOW_IP* aby zezwalać
tylko na adresy IP, *ALLOW_LOCAL* aby zezwalać tylko na adresy lokalne, oraz *ALLOW_ALL* aby zezwalać na
wszystkie typy. Aby tylko sprawdzić adres dla adresów IP możesz użyć poniższego przykładu:

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\Hostname(Zend\Validate\Hostname::ALLOW_IP);
      if ($validator->isValid($hostname)) {
          // nazwa serwera wygląda na prawidłową
      } else {
          // nazwa jest nieprawidłowa; wyświetl powody
          foreach ($validator->getMessages() as $message) {
              echo "$message\n";
          }
      }




Tak samo dobrze jak używając stałej *ALLOW_ALL* do określenia akceptacji adresów wszystkich typow, możesz
użyć dowolnej kombinacji tych typów. Na przykład aby akceptować adresy DNS oraz adresy lokalne, uwtórz
instancję obiektu Zend\Validate\Hostname w taki sposób:

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\Hostname(Zend\Validate\Hostname::ALLOW_DNS |
                                              Zend\Validate\Hostname::ALLOW_IP);




**Validating International Domains Names**

Some Country Code Top Level Domains (ccTLDs), such as 'de' (Germany), support international characters in domain
names. These are known as International Domain Names (IDN). These domains can be matched by Zend\Validate\Hostname
via extended characters that are used in the validation process.

At present the list of supported ccTLDs include:



   - at (Austria)

   - ch (Switzerland)

   - li (Liechtenstein)

   - de (Germany)

   - fi (Finland)

   - hu (Hungary)

   - no (Norway)

   - se (Sweden)



To match an IDN domain it's as simple as just using the standard Hostname validator since IDN matching is enabled
by default. If you wish to disable IDN validation this can be done by by either passing a parameter to the
Zend\Validate\Hostname constructor or via the *$validator->setValidateIdn()* method.

You can disable IDN validation by passing a second parameter to the Zend\Validate\Hostname constructor in the
following way.

   .. code-block:: php
      :linenos:

      $validator =
          new Zend\Validate\Hostname(Zend\Validate\Hostname::ALLOW_DNS, false);


Alternatively you can either pass TRUE or FALSE to *$validator->setValidateIdn()* to enable or disable IDN
validation. If you are trying to match an IDN hostname which isn't currently supported it is likely it will fail
validation if it has any international characters in it. Where a ccTLD file doesn't exist in Zend/Validate/Hostname
specifying the additional characters a normal hostname validation is performed.

Please note IDNs are only validated if you allow DNS hostnames to be validated.

**Validating Top Level Domains**

By default a hostname will be checked against a list of known TLDs. If this functionality is not required it can be
disabled in much the same way as disabling IDN support. You can disable TLD validation by passing a third parameter
to the Zend\Validate\Hostname constructor. In the example below we are supporting IDN validation via the second
parameter.

   .. code-block:: php
      :linenos:

      $validator =
          new Zend\Validate\Hostname(Zend\Validate\Hostname::ALLOW_DNS,
                                     true,
                                     false);


Alternatively you can either pass TRUE or FALSE to *$validator->setValidateTld()* to enable or disable TLD
validation.

Please note TLDs are only validated if you allow DNS hostnames to be validated.


