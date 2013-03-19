.. EN-Revision: 65fdbc5b9b535359a7cfce4e76586c2b435a9ebd
.. _zend.module-manager.intro:

Inleiding tot modulesysteem
===========================

Zend Framework 2.0 introduceert een nieuwe en krachtige manier van werken met modules. Het nieuwe modulesysteem
is ontwikkeld met flexibiliteit, eenvoud en herbruikbaarheid in het achterhoofd. Een module kan zowat alles bevatten:
PHP code, MVC functionaliteit, library code, view scripts, publieke bestanden zoals images, CSS en JavaScript.
De mogelijkheden zijn eindeloos.

.. note::

   Het modulesysteem in ZF2 is ontwikkeld als generieke en krachtige basis van waaruit developers
   hun eigen module- of pluginsysteem kunnen ontwikkelen.
   
   Voor een beter inzicht in de event-driven concepten achter het ZF2 modulesysteem kan het nuttig zijn om de
   :ref:`EventManager documentatie <zend.event-manager.event-manager>` door te nemen.
   
Het modulesysteem bestaat uit:

- :ref:`De Module Autoloader <zend.loader.module-autoloader>` - ``Zend\Loader\ModuleAutoloader`` is een gespecialiseerde
  autoloader die verantwoordelijk is voor het localiseren en laden van de ``Module`` classes uit verschillende bronnen.
  
- :ref:`De Module Manager <zend.module-manager.module-manager>` - ``Zend\ModuleManager\ModuleManager`` accepteert een array
  van namen van modules en initieert een reeks van events voor elk van deze modules, waardoor het gedrag van het hele
  modulesysteem volledig gedefineerd kan worden door de listeners die aan de modulemanager zijn gekoppeld.

- **ModuleManager Listeners** - Er kunnen event listeners gekoppeld worden aan de verschillende events van de module manager.
  Deze listeners kunnen allerlei taken uitvoeren zoals het resolven en laden van modules tot het uitvoeren van gecompliceerde
  initialisatietaken en introspectie van de teruggegeven module objecten. 

.. note::

   De naam van een module in een typische Zend Framework 2 applicatie is gewoon een `PHP namespace`_ en moet bijgevolg
   alle regels volgen die gelden voor de namespace naamgeving.

De aanbevolen structuur voor een typische MVC-ge�rienteerde ZF2 module is:


::

   module_root/
       Module.php
       autoload_classmap.php
       autoload_function.php
       autoload_register.php
       config/
           module.config.php
       public/
           images/
           css/
           js/
       src/
           <module_namespace>/
               <code files>
       test/
           phpunit.xml
           bootstrap.php
           <module_namespace>/
               <test code files>
       view/
           <dir-named-after-module-namespace>/
               <dir-named-after-a-controller>/
                   <.phtml files>

.. _zend.module-manager.intro.the-autoload-files:

De autoload_*.php-bestanden
---------------------------

De drie ``autoload_*.php`` zijn optioneel, maar wel aanbevolen:

- ``autoload_classmap.php`` dient een classmap array terug te geven van classnaam/bestandsnaam paren (met de bestandsnamen
  gespecifieerd met behulp van de ``__DIR__`` magic constant).

- ``autoload_function.php`` dient een PHP callback terug te geven die kan doorgegeven worden aan ``spl_autoload_register()``.
  Over het algemeen gebruikt deze callback de map die teruggegeven wordt door ``autoload_classmap.php``.

- ``autoload_register.php`` dient een PHP callback te registreren met ``spl_autoload_register()``. Over het algemeen is dit
  de callback die wordt teruggegeven door de ``autoload_function.php``.
  
Het doel van deze drie bestanden is ervoor te zorgen dat er een standaardmechanisme bestaat voor het automatisch laden
van de classes in de module, zodat de module geen gebruik van de ``Zend\ModuleManager`` vereist (voor wanneer je
de module buiten een ZF2 applicatie wenst te gebruiken).




.. _`PHP namespace`: http://php.net/namespaces
