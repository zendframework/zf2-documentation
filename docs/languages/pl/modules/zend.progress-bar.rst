.. EN-Revision: none
.. _zend.progressbar.introduction:

Zend_ProgressBar
================

.. _zend.progressbar.whatisit:

Wprowadzenie
------------

``Zend_ProgressBar`` to komponent służący do tworzenia i aktualizacji pasków postępu (progressbar) w różnych
środowiskach. Składa się na niego pojedynczy element backendu, który sygnalizuje postęp poprzez jeden z wielu
dostępnych adapterów. Podczas każdej aktualizacji brana jest wartość absolutna i opcjonalna wiadomość o
stanie postępu a następnie skonfigurowany adapter jest wywoływany z obliczonymi danymi takimi jak procent
postępu oraz czas, jaki został do końca wykonywanej akcji.

.. _zend.progressbar.basic:

Podstawowe użycie Zend_Progressbar
----------------------------------

``Zend_ProgressBar`` jest komponentem łatwym w użyciu. Należy, po prostu, utworzyć nową instancję klasy
``Zend_Progressbar``, definiując wartość minimalną i maksymalną oraz wybrać adapter służący prezentacji
danych o postępie działań. W przypadku operacji na pliku, użycie może wyglądać następująco:

.. code-block:: php
   :linenos:

   $progressBar = new Zend\ProgressBar\ProgressBar($adapter, 0, $fileSize);

   while (!feof($fp)) {
       // Wykonanie operacji

       $progressBar->update($currentByteCount);
   }

   $progressBar->finish();

W pierwszym kroku tworzona jest instancja ``Zend_ProgressBar`` ze zdefiniowanym adapterem, wartością minimalną:
0, oraz maksymalną równą rozmiarowi pliku. Po tym następuje seria operacji na pliku w pętli. Podczas każdej
iteracji pętli, pasek postępu jest aktualizowany danymi o ilości "przerobionych" bajtów pliku.

Metodę ``update()`` klasy ``Zend_ProgressBar`` można również wywoływać bez argumentów. Powoduje to
przeliczenie czasu do końca wykonywanej akcji i wysłanie go do adaptera. Ten sposób może być przydatny gdy nie
ma konkretnych danych do wysłania adapterowi ale niezbędna jest aktualizacja paska postępu.

.. _zend.progressbar.persistent:

Postęp utrwalony (persistent progress)
--------------------------------------

Jeśli zajdzie potrzeba utrzymania paska postępu przez wiele żądań, można w tym celu podać łańcuch znaków
z przestrzenią nazw sesji jako czwarty argument konstruktora. W tym przypadku pasek postępu nie uaktualni
adaptera w momencie konstruowania - niezbędne będzie wywołanie metody ``update()`` lub ``finish()``. Obecna
wartość, tekst stanu postępu oraz czas rozpoczęcia działania (wymagany przy obliczaniu czasu pozostałego do
końca) będą pobrane podczas następnego żądania i uruchomienia skryptu.

.. _zend.progressbar.adapters:

Standardowe adaptery
--------------------

Standardowo ``Zend_ProgressBar`` ma do dyspozycji następujące adaptery:

   - :ref:` <zend.progressbar.adapter.console>`

   - :ref:` <zend.progressbar.adapter.jspush>`

   - :ref:` <zend.progressbar.adapter.jspull>`



.. include:: zend.progress-bar.adapter.console.rst
.. include:: zend.progress-bar.adapter.js-push.rst
.. include:: zend.progress-bar.adapter.js-pull.rst

