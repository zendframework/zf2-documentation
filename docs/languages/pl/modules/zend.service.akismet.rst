.. _zend.service.akismet:

Zend_Service_Akismet
====================

.. _zend.service.akismet.introduction:

Wprowadzenie
------------

Komponent *Zend_Service_Akismet* jest klientem dla `API serwisu Akismet`_. Serwis Akismet jest używany do
określenia czy nadesłane dane są potencjalnym spamem; udostępnia on także metody do nadsyłania danych, które
uznamy za spam, oraz danych, które niesłusznie zostały uznane za spam (czyli ham). Pierwotnie serwis Akismet
służył do kategoryzowania i identyfikowania spamu dla aplikacji Wordpress, ale obecnie może być użyty do
dowolnych danych.

Do użycia serwisu Akismet wymagane jest posiadanie klucza API. Możesz go otrzymać rejestrując konto w serwisie
`WordPress.com`_. Nie musisz aktywować bloga; samo założenie konta umożliwi ci otrzymanie klucza API.

Dodatkowo Akismet wymaga aby wszystkie żądania zawierały adres URL do zasobu, dla którego dane są filtrowane,
i z tego względu, że Akismet pochodzi z WordPress, ten zasób nazywany jest adresem bloga (blog url). Ta
wartość powinna być przekazana jako drugi argument do konstruktora, ale może być zresetowana w dowolnej chwili
za pomocą metody dostępowej *setBlogUrl()* lub nadpisana przez określenie klucza 'blog' w różnych wywołaniach
metod.

.. _zend.service.akismet.verifykey:

Weryfikowanie klucza API
------------------------

Metoda *Zend_Service_Akismet::verifyKey($key)* jest używana do weryfikowania poprawności klucza API Akismet. W
większości przypadków nie musisz tego sprawdzać, ale jeśli chcesz przeprowadzić test dla pewności lub
sprawdzić czy otrzymany klucz jest aktywny, możesz to zrobić za pomocą tej metody.

.. code-block::
   :linenos:

   // Tworzymy instancję podając klucz API
   // i adres URL używanej aplikacji
   $akismet = new Zend_Service_Akismet($apiKey,
                                       'http://framework.zend.com/wiki/');
   if ($akismet->verifyKey($apiKey) {
       echo "Key is valid.\n";
   } else {
       echo "Key is not valid\n";
   }


Jeśli metoda *verifyKey()* jest wywołana bez żadnych argumentów, to używany jest klucz API, który był podany
do konstruktora.

Metoda *verifyKey()* implementuje metodę REST *verify-key* serwisu Akismet.

.. _zend.service.akismet.isspam:

Sprawdzanie czy dane są spamem
------------------------------

Metoda *Zend_Service_Akismet::isSpam($data)* jest używana do sprawdzenia, czy przekazane dane są uznane przez
Akismet jako spam. Metoda przyjmuje tablicę asocjacyjną jako jedyny argument. Tablica ta wymaga zdefiniowania
poniższych kluczy:

- *user_ip*, adres IP użytkownika wysyłającego dane (nie twój adres IP, tylko użytkownika twojego serwisu)

- *user_agent*, nazwa klienta HTTP (przeglądarka oraz wersja) użytkownika wysyłającego dane.

Poniższe klucze są także rozpoznawane przez API:

- *blog*, pełny adres URL do zasobu lub aplikacji. Jeśli nie jest określony, zostanie użyty adres URL, który
  był podany do konstruktora.

- *referrer*, zawartość nagłówka HTTP_REFERER w trakcie wysyłania danych. (Zwróć uwagę na pisownię; nie
  jest ona taka sama jak nazwa nagłówka.)

- *permalink*, bezpośredni odnośnik do wpisu, dla którego dane są przesyłane.

- *comment_type*, typ przesyłanych danych. Możliwe wartości określone w API to 'comment', 'trackback',
  'pingback', oraz pusty łańcuch znaków (''), ale wartość może być dowolna.

- *comment_author*, nazwa osoby dodającej dane.

- *comment_author_email*, adres email osoby dodającej dane.

- *comment_author_url*, adres URL lub strona domowa osoby dodającej dane.

- *comment_content*, aktualnie wysłana zawartość komentarza.

Możesz także przesłać dowolne inne zmienne opisujące środowisko, ktore według ciebie mogą być pomocne w
zweryfikowaniu danych pod kątem spamu. Serwis Akismet sugeruje, aby była to cała zawartość tablicy $_SERVER.

Metoda *isSpam()* zwróci wartość logiczną true lub false, a w przypadku gdy klucz API jest nieprawidłowy,
wyrzuci wyjątek.

.. _zend.service.akismet.isspam.example-1:

.. rubric:: Użycie metody isSpam()

.. code-block::
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 (Windows; U; Windows NT' .
                                 '5.2; en-GB; rv:1.8.1) Gecko/20061010' .
                                 'Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => 'John Doe',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "I'm not a spammer, honest!"
   );
   if ($akismet->isSpam($data)) {
       echo "Sorry, but we think you're a spammer.";
   } else {
       echo "Welcome to our site!";
   }


Metoda *isSpam()* implementuje metodę *comment-check* API serwisu Akismet.

.. _zend.service.akismet.submitspam:

Wysyłanie informacji o spamie
-----------------------------

Czasem dane, które są spamem mogą przejść przez filtr. Jeśli będziesz przeglądał przychodzące dane i
znajdziesz dane, które według ciebie powinny być uznane za spam, możesz wysłać je do Akismet aby pomóc
ulepszyć filtr.

Metoda *Zend_Service_Akismet::submitSpam()* przyjmuje taką samą tablicę danych jak metoda *isSpam()*, ale nie
zwraca wartości. Jeśli klucz API jest nieprawidłowy, zostanie wyrzucony wyjątek.

.. _zend.service.akismet.submitspam.example-1:

.. rubric:: Użycie metody submitSpam()

.. code-block::
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 (Windows; U; Windows NT 5.2;' .
                                 'en-GB; rv:1.8.1) Gecko/20061010' .
                                 'Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => 'John Doe',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "I'm not a spammer, honest!"
   );
   $akismet->submitSpam($data));


Metoda *submitSpam()* implementuje metodę *submit-spam* API serwisu Akismet.

.. _zend.service.akismet.submitham:

Wysyłanie informacji o fałszywym spamie (ham)
---------------------------------------------

Czasem dane zostaną przez Akismet błędnie uznane za spam. Z tego względu, powinieneś zapisywać dane uznane
przez Akismet za spam i regularnie je przeglądać. Jeśli znajdziesz takie przypadki, możesz wysłać takie dane
do Akismet jako "ham" czyli poprawne dane błędnie uznane za spam (ham jest dobry, spam nie jest).

Metoda *Zend_Service_Akismet::submitHam()* przyjmuje taką samą tablicę danych jak metody *isSpam()* oraz
*submitSpam()* i tak samo jak metoda *submitSpam()* nie zwraca wartości. Jeśli klucz API jest nieprawidłowy,
zostanie wyrzucony wyjątek.

.. _zend.service.akismet.submitham.example-1:

.. rubric:: Użycie metody submitHam()

.. code-block::
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 (Windows; U; Windows NT 5.2;' .
                                 'en-GB; rv:1.8.1) Gecko/20061010' .
                                 'Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => 'John Doe',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "I'm not a spammer, honest!"
   );
   $akismet->submitHam($data));


Metoda *submitHam()* implementuje metodę *submit-ham* API serwisu Akismet.

.. _zend.service.akismet.accessors:

Specyficzne metody dostępowe
----------------------------

O ile API serwisu Akismet określa jedynie cztery metody, komponent *Zend_Service_Akismet* posiada kilka
dodatkowych metod dostępowych, które mogą być użyte do modyfikowania wewnętrznych właściwości.

- Metody *getBlogUrl()* oraz *setBlogUrl()* pozwalają ci na odebranie oraz modyfikację adresu URL bloga
  używanego w żądaniach.

- Metody *getApiKey()* oraz *setApiKey()* pozwalają ci na odebranie oraz modyfikację klucza API używanego w
  żądaniach.

- Metody *getCharset()* oraz *setCharset()* pozwalają ci na odebranie oraz modyfikację zestawu znaków używanego
  w żądaniach.

- Metody *getPort()* oraz *setPort()* pozwalają ci na odebranie oraz modyfikację portu TCP używanego w
  żądaniach.

- Metody *getUserAgent()* oraz *setUserAgent()* pozwalają ci na pobranie oraz modyfikowanie informacji o kliencie
  HTTP używanym do przeprowadzenia żądania. Nota: nie jest to ta sama wartość co user_agent, która jest
  używana w danych wysyłanych do serwisu, ale raczej wartość, która będzie wysłana w nagłówku HTTP
  User-Agent podczas przeprowadzania żądania do serwisu.

  Wartość użyta do ustawienia nazwy klienta HTTP powinna być w formacie *nazwa klienta/wersja |
  Akismet/wersja*. Domyślna wartość to *Zend Framework/ZF-VERSION | Akismet/1.11*, gdzie *ZF-VERSION* jest
  numerem obecnej wersji ZF przechowywanym w stałej *Zend_Framework::VERSION*.



.. _`API serwisu Akismet`: http://akismet.com/development/api/
.. _`WordPress.com`: http://wordpress.com/
