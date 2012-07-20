.. _zend.cache.theory:

Teoria buforowania
==================

Są trzy kluczowe składniki w ``Zend_Cache``. Pierwszym jest unikalny identyfikator (łańcuch znakow) który jest
używany do identyfikowania rekordów bufora. Drugim jest dyrektywa **'lifetime'** jaką pokazano w przykładach;
definiuje ona jak długo buforowany zasób jest uznawany za 'świeży'. Trzecim kluczowym składnikiem jest
warunkowe wykonanie więc część twojego kodu może być ominięta, co powoduje wzrost wydajności. Główna
funkcja frontendu (np. ``Zend_Cache_Core::get()``) jest zawsze zaprojektowana tak, aby zwracała wartość false
gdy bufor jest nieaktualny, jeśli jest to sensowne dla danego frontendu. To pozwala użytkownikom na ominięcie
bloków kodu, które chcą buforować, zawierając je w wyrażenie **if(){ ... }** gdzie warunkiem jest metoda
``Zend_Cache``. Na końcu takich bloków musisz zapisać to co wygenerowałeś (np. za pomocą metody
``Zend_Cache_Core::save()``).

.. note::

   Warunkowe uruchamianie twojego kodu nie jest konieczne w niektórych frontendach (na przykład **Function**),
   gdzie cała logika jest zaimplementowana we frontendzie.

.. note::

   'bufor istnieje' jest wyrażeniem określającym sytuację, w której rekord bufora został znaleziony, jest
   poprawny i jest 'świeży' 'fresh' (innymi słowy jeszcze nie wygasł). 'Bufor nie istnieje' jest wszystkim
   innym. Kiedy zdarzy się, że bufor nie istnieje musisz wygenerować swoje dane (tak jak robisz to normalnie) i
   zapisać je w buforze. Z drugiej strony, gdy bufor istnieje, backend automatycznie pobierze rekord z bufora.

.. _zend.cache.factory:

Metoda fabryki Zend_Cache
-------------------------

Dobrym sposobem utworzenia użytecznej instancji frontendu ``Zend_Cache`` jest ten pokazany w poniższym
przykładzie:

.. code-block:: php
   :linenos:

   // Wybieramy backend (na przykład 'File' lub 'Sqlite'...)
   $backendName = '[...]';

   // Wybieramy frontend (na przykład 'Core', 'Output', 'Page'...)
   $frontendName = '[...]';

   // Ustawiamy tablicę opcji dla wybranego frontendu
   $frontendOptions = array([...]);

   // Ustawiamy tablicę opcji dla wybranego backendu
   $backendOptions = array([...]);

   // Tworzymy instancję klasy Zend_Cache
   // (oczywiście dwa ostatnie argumenty są opcjonalne)
   $cache = Zend_Cache::factory($frontendName,
                                $backendName,
                                $frontendOptions,
                                $backendOptions);

W poniższych przykładach założymy że zmienna ``$cache`` zawiera poprawną instancję frontendu i to, że
rozumiesz jak przekazać parametry do wybranego backendu.

.. note::

   Zawsze używaj metody ``Zend_Cache::factory()`` aby pobrać instancje frontendu. Tworzenie instancji frontendu
   czy backendu nie będzie przynosiło oczekiwanych rezultatów.

.. _zend.cache.tags:

Nadawanie etykiet rekordom
--------------------------

Etykiety są sposobem kategoryzowania rekordów bufora. Kiedy zapisujesz bufor za pomocą metody ``save()``,
możesz ustawić tablicę etykiet, które mają być przypisane danemu rekordowi. Wtedy będziesz miał
możliwość usuwania wszystkich rekordów bufora oznaczonych daną etykietą (lub etykietami):

.. code-block:: php
   :linenos:

   $cache->save($huge_data, 'myUniqueID', array('tagA', 'tagB', 'tagC'));

.. note::

   Zauważ, że metoda ``save()`` akceptuje opcjonalny czwarty argument: ``$specificLifetime`` (jeśli jego
   wartość jest inna od false, ustawiany jest określony czas ważności dla konkretnego rekordu bufora.

.. _zend.cache.clean:

Czyszczenie bufora
------------------

Aby usunąć/unieważnić rekord bufora o określonym id, możesz użyć metody ``remove()``:

.. code-block:: php
   :linenos:

   $cache->remove('idToRemove');

Aby usunąć/unieważnić wiele rekordów bufora za jednym razem, możesz użyć metody ``clean()``. Na przykład
aby usunąć wszystkie rekordy bufora:

.. code-block:: php
   :linenos:

   // czyszczenie wszystkich rekordów
   $cache->clean(Zend_Cache::CLEANING_MODE_ALL);

   // czyszczenie jedynie nieaktualnych rekordów
   $cache->clean(Zend_Cache::CLEANING_MODE_OLD);

Jeśli chcesz usunąć rekordy bufora oznaczone etykietami 'tagA' oraz 'tagC':

.. code-block:: php
   :linenos:

   $cache->clean(
       Zend_Cache::CLEANING_MODE_MATCHING_TAG,
       array('tagA', 'tagC')
   );

Jeśli chcesz usunąć rekordy bufora nieoznaczone etykietami 'tagA' oraz 'tagC':

.. code-block:: php
   :linenos:

   $cache->clean(
       Zend_Cache::CLEANING_MODE_NOT_MATCHING_TAG,
       array('tagA', 'tagC')
   );

Jeśli chcesz usunąć rekordy bufora oznaczone etykietami 'tagA' lub 'tagC':

.. code-block:: php
   :linenos:

   $cache->clean(
       Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
       array('tagA', 'tagC')
   );

Dostępne tryby czyszczenia bufora to: ``CLEANING_MODE_ALL``, ``CLEANING_MODE_OLD``,
``CLEANING_MODE_MATCHING_TAG``, ``CLEANING_MODE_NOT_MATCHING_TAG`` oraz ``CLEANING_MODE_MATCHING_ANY_TAG``. Trzy
ostatnie, jak nazwa wskazuje, mogą w operacji czyszczenia być użyte wraz z tablicą etykiet.


