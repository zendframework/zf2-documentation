.. EN-Revision: none
.. _zend.progressbar.adapter.jspush:

Zend\ProgressBar_Adapter\JsPush
===============================

``Zend\ProgressBar_Adapter\JsPush`` to adapter pozwalający na aktualizację paska postępu w przeglądarce poprzez
JavaScript Push. To oznacza, że nie jest potrzebne nowe połączenie na potrzeby przesyłu danych o postępie
operacji. Proces pracujący po stronie serwera komunikuje się bezpośrednio z przeglądarką użytkownika.

Opcje adaptera można ustawiać za pomocą metod *set** albo przez podanie tablicy asocjacyjnej lub obiektu
``Zend_Config`` w pierwszym parametrze konstruktora. Dostępne opcje to:

- *updateMethodName*: Metoda JavaScript, która zostanie wywołana przy każdej aktualizacji paska postępu.
  Domyślnie jest to ``Zend\ProgressBar\Update``.

- *finishMethodName*: Metoda JavaScript, która zostanie wywołana po zakończeniu prowadzonej operacji. Domyślna
  wartość to ``NULL``, co oznacza brak reakcji.

Użycie tego adaptera jest dość proste. Na początku należy utworzyć pasek postępu w przeglądarce za pomocą
poleceń JavaScript lub *HTML*. Następnie należy zdefiniować metodę JavaScript wywoływaną przy aktualizacji
oraz (opcjonalnie) po skończeniu działania. Obie powinny przyjmować pojedynczy argument - obiekt *JSON*. Aby
otworzyć połączenie należy wywołać długo trwającą akcję w ukrytym obiekcie *iframe* lub *object*. Podczas
wykonywania tego procesu przy każdej aktualizacji adapter będzie wywoływał odpowiednią metodę przekazując do
niej obiekt *JSON* o następujących parametrach:

- *current*: Obecna wartość absolutna

- *max*: Maksymalna wartość absolutna

- *percent*: Obliczony procent postępu

- *timeTaken*: Czas trwania procesu (do obecnej chwili)

- *timeRemaining*: Oszacowanie czasu pozostałego do końca

- *text*: Opcjonalna wiadomość dotycząca stanu postępu

.. _zend.progressbar-adapter.jspush.example:

.. rubric:: Podstawowy przykład kodu po stronie klienta

Ten przykład ilustruje prosty kod *HTML*, *CSS* oraz JavaScript do użytku z adapterem JsPush

.. code-block:: html
   :linenos:

   <div id="zend-progressbar-container">
       <div id="zend-progressbar-done"></div>
   </div>

   <iframe src="long-running-process.php" id="long-running-process"></iframe>

.. code-block:: css
   :linenos:

   #long-running-process {
       position: absolute;
       left: -100px;
       top: -100px;

       width: 1px;
       height: 1px;
   }

   #zend-progressbar-container {
       width: 100px;
       height: 30px;

       border: 1px solid #000000;
       background-color: #ffffff;
   }

   #zend-progressbar-done {
       width: 0;
       height: 30px;

       background-color: #000000;
   }

.. code-block:: javascript
   :linenos:

   function Zend\ProgressBar\Update(data)
   {
       document.getElementById('zend-progressbar-done').style.width = data.percent + '%';
   }

Powyższy kod tworzy prosty pojemnik z czarną granicą oraz blok wskazujący zaawansowanie procesu. Należy
pamiętać by nie ukrywać elementów *iframe* lub *object* poprzez *display: none;* ponieważ w takiej sytuacji
niektóre przeglądarki jak Safari 2 w ogóle nie pobiorą tych elementów.

Zamiast własnoręcznie tworzyć pasek postępu, można skorzystać z jednej z wielu dostępnych bibliotek
JavaScript, takich jak Dojo czy jQuery. Np.:

- Dojo: `http://dojotoolkit.org/book/dojo-book-0-9/part-2-dijit/user-assistance-and-feedback/progress-bar`_

- jQuery: `http://t.wits.sg/2008/06/20/jquery-progress-bar-11/`_

- MooTools: `http://davidwalsh.name/dw-content/progress-bar.php`_

- Prototype: `http://livepipe.net/control/progressbar`_

.. note::

   **Odstęp czasowy pomiędzy aktualizacjami**

   Należy upewnić się, że nie jest tworzona zbyt duża ilość aktualizacji. Każda z nich powinna przesyłać
   dane o wielkości co najmniej 1kB. Dla przeglądarki Safari jest to niezbędny warunek do wykonania polecenia
   wywołania funkcji. Internet Explorer ma podobne ograniczenie - w jego przypadku jest to 256 Bajtów.



.. _`http://dojotoolkit.org/book/dojo-book-0-9/part-2-dijit/user-assistance-and-feedback/progress-bar`: http://dojotoolkit.org/book/dojo-book-0-9/part-2-dijit/user-assistance-and-feedback/progress-bar
.. _`http://t.wits.sg/2008/06/20/jquery-progress-bar-11/`: http://t.wits.sg/2008/06/20/jquery-progress-bar-11/
.. _`http://davidwalsh.name/dw-content/progress-bar.php`: http://davidwalsh.name/dw-content/progress-bar.php
.. _`http://livepipe.net/control/progressbar`: http://livepipe.net/control/progressbar
