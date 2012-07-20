.. _zend.view.helpers.initial.headmeta:

Helper HeadMeta
===============

Element HTML *<meta>* używany jest do definiowania informacji meta o dokumencie HTML -- zazwyczaj są to słowa
kluczowe, informacje o zestawie znaków, informacje o sposobie buforowania itp. Są dwa rodzaje znaczników meta,
'http-equiv' oraz 'name', oba muszą zawierać także atrybut 'content', a mogą dodatkowo zawierać jeszcze
atrybuty 'lang' oraz 'scheme'.

Helper *HeadMeta* udostępnia następujące metody do ustawiania i dodawania znaczników meta:

- *appendName($keyValue, $content, $conditionalName)*

- *offsetSetName($index, $keyValue, $content, $conditionalName)*

- *prependName($keyValue, $content, $conditionalName)*

- *setName($keyValue, $content, $modifiers)*

- *appendHttpEquiv($keyValue, $content, $conditionalHttpEquiv)*

- *offsetSetHttpEquiv($index, $keyValue, $content, $conditionalHttpEquiv)*

- *prependHttpEquiv($keyValue, $content, $conditionalHttpEquiv)*

- *setHttpEquiv($keyValue, $content, $modifiers)*

Zmienna *$keyValue* jest używana do definiowania wartości atrybutów 'name' oraz 'http-equiv'; Zmienna *$content*
definiuje wartość atrybutu 'content', a zmienna *$modifiers* jest opcjonalną asocjacyjną tablicą, która może
zawierać klucze dla atrybutów 'lang' oraz 'scheme'.

Możesz także ustawić znaczniki meta używając metody *headMeta()* helpera, która posiada następującą
sygnaturę: *headMeta($content, $keyValue, $keyType = 'name', $modifiers = array(), $placement = 'APPEND')*.
Parametr *$keyValue* jest zawartością dla klucza określonego w parametrze *$keyType*, którego wartością
zawsze powinno być 'name' lub 'http-equiv'. Parametr *$placement* może mieć wartość 'SET' (nadpisuje wszystkie
wcześniej ustawione wartości), 'APPEND' (dodaje na spód stosu), lub 'PREPEND' (dodaje na wierzchołek stosu).

Helper *HeadMeta* nadpisuje każdą z metod *append()*, *offsetSet()*, *prepend()*, oraz *set()* aby wymusić
użycie specjalnych metod opisanych powyżej. Wewnętrznie klasa przechowuje każdy element jako obiekt klasy
*stdClass*, który jest potem serializowany za pomocą metody *itemToString()*. Pozwala to na sprawdzenie
elementów znajdujących się na stosie, a także na zmianę wartości poprzez modyfikację zwróconego obiektu.

Helper *HeadMeta* jest implementacją :ref:`helpera Placeholder <zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.headmeta.basicusage:

.. rubric:: Podstawowe użycie helpera HeadMeta

Możesz określić nowy znacznik meta w dowolnej chwili. Najczęściej będziesz określał zasady buforowania po
stronie klienta oraz dane SEO.

Przykładowo, jeśli chcesz określić słowa kluczowe SEO, powinieneś utworzyć znacznik meta o nazwie
'keywords', a jego zawartością powinny być słowa kluczowe, które chcesz połączyć z daną stroną:

.. code-block::
   :linenos:

   // ustawienie słów kluczowych
   $this->headMeta()->appendName('keywords', 'framework php productivity');


Jeśli chcesz ustalić zasady buforowania po stronie klienta, powinieneś ustawić znaczniki http-equiv:

.. code-block::
   :linenos:

   // zablokowanie buforowania po stronie klienta
   $this->headMeta()->appendHttpEquiv('expires',
                                      'Wed, 26 Feb 1997 08:21:57 GMT')
                    ->appendHttpEquiv('pragma', 'no-cache')
                    ->appendHttpEquiv('Cache-Control', 'no-cache');


Innym popularnym przykładem użycia znaczników meta jest ustawienie typu zawartości, zestawu znaków oraz
języka:

.. code-block::
   :linenos:

   // ustawienie typu zawartości i zestawu znaków
   $this->headMeta()->appendHttpEquiv('Content-Type',
                                      'text/html; charset=UTF-8')
                    ->appendHttpEquiv('Content-Language', 'en-US');


Ostatnim przykład pokazuje jak można w łatwy sposób wyświetlić komunikat bezpośrednio przez przekierowaniem
używając znacznika "meta refresh":

.. code-block::
   :linenos:

   // ustawienie czasu odświeżenia strony na 3 sekundy z nowym adresem URL:
   $this->headMeta()->appendHttpEquiv('Refresh',
                                      '3;URL=http://www.some.org/some.html');


Jeśli jesteś gotowy na wyświetlenie znaczników meta w layoucie, po prostu wyświetl helper:

.. code-block::
   :linenos:

   <?= $this->headMeta() ?>



