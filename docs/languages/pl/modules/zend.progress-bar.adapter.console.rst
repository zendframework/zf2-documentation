.. _zend.progressbar.adapter.console:

Zend_ProgressBar_Adapter_Console
================================

``Zend_ProgressBar_Adapter_Console`` to adapter tekstowy przeznaczony do użytku z terminalem (konsolą, wierszem
polecenia). Adapter potrafi automatycznie wykryć dostępną szerokość ale można również podać ją ręcznie.
Oprócz tego można definiować elementy, jakie mają zostać pokazane oraz ich kolejność jak również sam styl
wyświetlanego paska postępu.

.. note::

   **Automatyczne rozpoznawanie szerokości konsoli**

   W przypadku systemów \*nix niezbędny dla tej funkcjonalności jest *shell_exec*. Na maszynach Windows
   szerokość terminala jest stała (wynosi 80 znaków) więc automatyczne rozpoznawanie szerokości nie jest
   potrzebne.

Opcje adaptera można ustawiać za pomocą metod *set** albo przez podanie tablicy asocjacyjnej lub obiektu
``Zend_Config`` w pierwszym parametrze konstruktora. Dostępne opcje to:

- *outputStream*: Strumień do którego będzie kierowany wynik. Domyślnie to STDOUT. Może być dowolnym
  strumieniem, np.: *php://stderr* lub ścieżką do pliku.

- *width*: Liczba całkowita lub stała ``AUTO`` klasy ``Zend_Console_ProgressBar``.

- *elements*: Przyjmuje ``NULL`` dla domyślnej konfiguracji lub tablicę zawierającą co najmniej jedną z
  następujących wartości:

  - ``ELEMENT_PERCENT``: Obecna wartość wyrażona procentowo

  - ``ELEMENT_BAR``: Pasek pokazujący wartość procentową.

  - ``ELEMENT_ETA``: Automatycznie obliczany czas do zakończenia operacji. Ten element jest pokazywany pierwszy
    raz z opóźnieniem 5 sekund bo w krótszym czasie nie ma możliwości obliczenia wiarygodnych wyników.

  - ``ELEMENT_TEXT``: Opcjonalna wiadomość stanu postępu operacji.

- *textWidth*: Szerokość elementu ``ELEMENT_TEXT`` podana w znakach. Domyślnie to 20.

- *charset*: Kodowanie elementu ``ELEMENT_TEXT``. Domyślnie to utf-8.

- *barLeftChar*: Łańcuch znaków używany jako lewa krawędź paska postępu.

- *barRightChar*: Łańcuch znaków używany jako prawa krawędź paska postępu.

- *barIndicatorChar*: Łańcuch znaków używany jako wskaźnik paska postępu. Może zostać pusty.


