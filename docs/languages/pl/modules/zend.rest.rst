.. _zend.rest.introduction:

Wprowadzenie
============

Webserwisy REST używają formatów XML specyficznych dla każdego z webserwisów. Te w locie definiowane standardy
oznaczają, że sposób dostępu do każdego z webserwisów REST może być inny. Webserwisy REST zazwyczaj
używają parametrów URL (danych GET) lub nazw ścieżek do wskazywania danych do pobrania i danych POST do
przesyłania danych.

Zend Framework daje możliwość użycia zarówno funkcjonaności klienta jak i serwera, które razem użyte
pozwalają na otrzymanie bardziej "lokalnego" interfejsu za pośrednictwem wirtualnego dostępu do obiektów.
Komponent serwera umożliwia automatyczne udostępnianie funkcji i klas za pomocą prostego formatu XML. Kiedy
uzyskujemy dostęp do tych webserwisów za pomocą klienta, możliwe jest łatwe pobranie i zwrócenie danych
otrzymanych po wywołaniu. Jeśli chcesz użyć klienta z serwerem webserwisów nie opartym na klasie
Zend_Rest_Server, dostęp wciąż będzie łatwy.


