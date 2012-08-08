.. EN-Revision: none
.. _zend.view.helpers.initial.inlinescript:

Helper InlineScript
===================

Znacznik HTML *<script>* używany jest zarówno do wstawiania kodu skryptów wykonujących się po stronie klienta
do treści dokumentu jak i do załączania zewnętrznych plików zawierających taki skrypty. Helper *InlineScript*
pozwala ci na obsłużenie obu sposobów. Wywodzi się on z :ref:`helpera HeadScript
<zend.view.helpers.initial.headscript>` więc dostępne są wszystkie jego metody; z tą różnicą, że tu używaj
metody *inlineScript()* zamiast metody *headScript()*.

.. note::

   **Używaj helpera InlineScript dla skryptów w sekcji HTML Body**

   Helpera *InlineScript* powinieneś użyć gdy chcesz dołączyć skrypty wewnątrz sekcji HTML *body*.
   Umieszczanie skryptów na końcu dokumentu jest dobrą praktyką powodującą przyspieszenie ładowania strony,
   szczególnie gdy używasz skryptów statystyk pochodzących od zewnętrznych firm.

   Niektóre biblioteki JS muszą być dołączone w sekcji HTML *head*; użyj :ref:`helpera HeadScript
   <zend.view.helpers.initial.headscript>` dla tych skryptów.


