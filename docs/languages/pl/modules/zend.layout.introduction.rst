.. _zend.layout.introduction:

Wprowadzenie
============

Komponent *Zend_Layout* implementuje klasyczny wzorzec projektowy Dwuetapowych Widoków (Two Step View),
pozwalając programistom na wyświetleniu zawartości aplikacji wewnątrz innego widoku, najczęściej będącego
szablonem strony. Z tego powodu, że takie szablony są często w innych projektach nazywane **layoutami**, także
Zend Framework używa tego nazewnictwa w celu zachowania spójności.

Głównymi założeniami *Zend_Layout* są:

- Automatyczne wybieranie i renderowanie layoutów gdy są one używane wraz z komponentami MVC Zend Framework.

- Zapewnienie osobnej przestrzeni dla zmiennych i zawartości layoutu.

- Możliwość konfiguracji, włączając w to nazwę layoutu, sposób jej generowania, a także ścieżkę
  layoutu.

- Możliwość wyłączania layoutów, zmiany skryptów layoutów; możliwość przeprowadzania tych akcji zarówno
  wewnątrz kontrolerów jak i skryptów widoków.

- Te same zasady generowania nazw skryptów jak w klasie :ref:`ViewRenderer
  <zend.controller.actionhelpers.viewrenderer>`, ale z możliwością zdefiniowania innych zasad.

- Możliwość użycia komponentu bez komponentów MVC Zend Framework.


