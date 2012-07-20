.. _zend.progressbar.adapter.jspull:

Zend_ProgressBar_Adapter_JsPull
===============================

Adapter ``Zend_ProgressBar_Adapter_JsPull`` jest przeciwieństwem jsPush. W jego przypadku niezbędne jest
"wyciągnięcie" aktualizacji zamiast "wypchnięcia" z przeglądarki. Generalnie zaleca się użycie tego adaptera
z opcją utrwalania postępu ``Zend_ProgressBar``. Jego działanie polega na wysłaniu do przeglądarki łańcucha
znaków (w formacie *JSON*), który wygląda tak jak string *JSON* wysyłany przez adapter jsPush. Jedyną
różnicą pomiędzy nimi jest dodatkowy parametr (w stringu wysyłanym przez adapter jsPull) o nazwie *finished*.
Zawiera on wartość ``FALSE`` kiedy uruchamiana jest metoda ``update()`` lub ``TRUE`` w przypadku wywoływania
metody ``finish()``.

Opcje adaptera można ustawiać za pomocą metod *set** albo przez podanie tablicy asocjacyjnej lub obiektu
``Zend_Config`` w pierwszym parametrze konstruktora. Dostępne opcje to:

- *exitAfterSend*: Flaga oznaczająca czy bieżące żądanie ma zostać zakończone po wysłaniu danych do
  przeglądarki. Domyślnie przyjmuje wartość ``TRUE``.


