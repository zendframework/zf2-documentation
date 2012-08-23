.. EN-Revision: none
.. _learning.autoloading.intro:

Wprowadzenie
============

Autoloader to mechanizm, który eliminuje potrzebę ręcznego dołączania plików w kodzie *PHP*. Według
`dokumentacji autoloadera PHP`_ po skonfigurowaniu autoloadera, będzie on uruchomiony automatycznie w sytuacji, w
której zajdzie próba użycia niezdefiniowanej klasy bądź interfejsu.

Dzięki autoloaderowi nie trzeba się zastanawiać **gdzie** znajduje się plik z definicją danej klasy. Dobrze
zdefiniowany autoloader uwalnia od potrzeby brania pod uwagę lokalizacji pliku z klasą w stosunku do bieżącego
pliku. Dzięki temu można po prostu użyć klasy a autoloader zajmie się znalezieniem odpowiedniego pliku.

Dodatkowo, dzięki temu procesowi, poprzez odłożenie operacji ładowania pliku do ostatniej możliwej chwili,
można mieć pewność, że operacja wyszukania pliku zajdzie dokładnie jeden raz. To może stanowić znakomite
zwiększenie wydajności - w szczególności jeśli wywołania do funkcji ``require_once()`` zostaną usunięte.

Zend Framework propaguje użycie autoloadera i udostępnia szereg narzędzi służących do automatycznego
dołączania bibliotek jak i kodu samej aplikacji. Niniejszy tutorial opisuje te narzędzia jak i sposób ich
efektywnego użycia.



.. _`dokumentacji autoloadera PHP`: http://php.net/autoload
