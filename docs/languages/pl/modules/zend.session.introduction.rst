.. EN-Revision: none
.. _zend.session.introduction:

Wprowadzenie
============

Zespół Zend Framework Auth bardzo docenia twój wkład w naszą listę email: `fw-auth@lists.zend.com`_

W aplikacjach web używających PHP, a **sesja** reprezentuje logiczne połączenie jeden-do-jednego pomiędzy
danymi o stanie użytkownika znajdującymi się na serwerze, a konkretną aplikacją użytkownika (np.
przeglądarka stron internetowych). *Zend_Session* pomaga w zarządzaniu i zabezpieczaniu danych sesji, które są
logicznym dopełnieniem danych w ciasteczku, pomiędzy wieloma żądaniami do serwisu przez tego samego klienta. W
przeciwieństwie do danych z ciasteczka, dane sesji nie są przechowywane po stronie klienta i są one dostępne
dla klienta tylko wtedy, gdy kod po stronie serwera dobrowolnie udostępni dane w odpowiedzi na żądanie klienta.
Dla celów tego komponentu oraz dokumentacji, określenie "dane sesji" odnoszą się do danych przechowywanych po
stronie serwera w tablicy `$_SESSION`_, zarządzanych przez *Zend_Session*, oraz indywidualnie manipulowanych przez
obiekty dostępowe *Zend\Session\Namespace*. **Przestrzenie nazw sesji** zapewniają dostęp do danych sesji
używając klasycznych `przestrzeni nazw`_ implementowanych logicznie jako nazwane grupy asocjacyjnych tablic, o
kluczach będących łańcuchami znaków. (analogicznie jak tablice PHP).

Instancje *Zend\Session\Namespace* są obiektami dostępowymi dla przestrzeni nazw będących wycinkami tablicy
*$_SESSION*. Komponent *Zend_Session* rozszerza istniejącą funkcjonalność PHP ext/session dodając interfejs
umożliwiający administrację i zarządzanie, a także zapewniając API dla przestrzeni nazw
*Zend\Session\Namespace*. *Zend\Session\Namespace* zapewnia ustandaryzowany zorientowany obiektowo interfejs do
pracy z przestrzeniami nazw istniejącymi wewnątrz standardowego mechanizmu sesji PHP. Wspierane są zarówno
przestrzenie nazw dla anonimowych użytkowników, jak i dla uwierzytelnionych (np. zalogowanych). *Zend_Auth*,
komponent autentykacji w Zend Framework używa *Zend\Session\Namespace* do przechowywania informacji związanych z
autentykowanymi użytkownikami w przestrzeni nazw "Zend_Auth". Z tego względu, że *Zend_Session* używa
normalnych wewnętrznych funkcji modułu sesji, oraz umożliwia użycie wszystkich znanych opcji konfiguracyjnych i
ustawień (zobacz `http://www.php.net/session`_), a dodatkowo umożliwia dostęp za pomocą zorientowanego
obiektowo interfejsu, to użycie tego modułu jest przykładem dobrej praktyki programowania, a także gładko
integruje się z Zend Framework. Zatem standardowy identyfikator sesji PHP przechowywany albo w ciasteczku klienta,
albo dołączony do adresów URL, umożliwia połączenie klienta oraz danych stanu sesji.

Domyślna `obsługa zapisu sesji`_ nie rozwiązuje problemu zarządzania tym powiązaniem dla klastrów serwerów,
ponieważ dane sesji przechowywane są w systemie plików serwera, który odpowiada na żądanie. Jeśli żądanie
może byc przetworzone przez inny serwer niż ten, na którym zapisane są dane sesji, to przetwarzający serwer
nie ma dostępu do danych sesji (jeśli nie są dostępne w systemie plików połączonym siecią). Dodatkowe
odpowiednie możliwości obsługi zapisu będą zapewnione, gdy będzie to możliwe. Namawiamy członków
społeczności aby wysyłali propozycje możliwości obsługi zapisu na listę `fw-auth@lists.zend.com`_. Obsługa
zapisu kompatybilna z Zend_Db została opisana na liście.



.. _`fw-auth@lists.zend.com`: mailto:fw-auth@lists.zend.com
.. _`$_SESSION`: http://www.php.net/manual/en/reserved.variables.php#reserved.variables.session
.. _`przestrzeni nazw`: http://en.wikipedia.org/wiki/Namespace_%28computer_science%29
.. _`http://www.php.net/session`: http://www.php.net/session
.. _`obsługa zapisu sesji`: http://www.php.net/manual/en/function.session-set-save-handler.php
