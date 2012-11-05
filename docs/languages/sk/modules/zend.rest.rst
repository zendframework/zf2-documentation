.. EN-Revision: none
.. _zend.rest.introduction:

Introduction
============

Webové služby typu REST používajú vlastné špecifické XML formáty. Tieto ad-hoc štandardy spôsobujú to,
že prístup k REST webovej službe je rôzny pre každú REST webovú službu. REST webové služby typicky
používajú parametre v URL (GET dáta) alebo cestu v URL pre získavanie údajov a POST dáta pre posielanie
údajov.

Zend Framework poskytuje možnosti pre vytvorenia klienta, alebo služby, ktoré keď sa používajú spoločne
umožnia vytvoriť skoro "lokálne" prepojenie pomocou prístupu k virtuálnym vlastnostiam. Komponent pre
vytvorenie služby (serveru) umožňuje automatické sprístupnenie tried a funkcií pomocou výrečného a
jednoduchého XML formátu. Pri prístupe týmto službám je možné jednoducho získať návratovú hodnotu z
volania vzdialenej funkcie. Ak si želáte použiť klienta pre prístup k inej ako na Zend\Rest\Server založenej
službe, stále budete mať jednoduchý prístup u údajom.


