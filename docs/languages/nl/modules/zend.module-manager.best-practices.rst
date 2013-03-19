.. EN-Revision: 10f4d4b6ffd10466d9bba6a9cba567b032766520
.. _zend.module-manager.best-practices:

Aanbevelingen bij het ontwikkelen van modules
=============================================

Er zijn enkele aanbevelingen waar je rekening mee dient te houden als je een ZF2 module ontwikkelt:

- **Hou de ``init()`` en ``onBootstrap()`` methoden eenvoudig.** Wees conservatief met de acties die je uitvoert
  in de ``init()`` en ``onBootstrap()`` methoden van je ``Module`` class. Deze methoden worden uitgevoerd voor **elke**
  paginarequest en kunnen beter geen zware acties uitvoeren. Als vuistregel kan je stellen dat het registreren van
  event listeners een geschikte taak is die uitgevoerd kan worden in deze twee methoden. Zulke lichtgewicht taken
  hebben over het algemeen nauwelijks invloed op de prestaties van je applicatie, zelfs wanneer er veel modules
  geladen worden. Het wordt beschouwd als een slechte gewoonte wanneer je deze twee methoden gebruikt om instanties
  van apllicatieresources aan te maken of te configureren zoals databaseconnecties, een applicatielogger of een
  mailer. Zulke taken zijn beter geschikt voor de ``ServiceManager`` van Zend Framework 2.
  
- **Schrijf nooit iets weg binnen een module.** Je code mag **nooit** iets wegschrijven onder de module directory.
  Na de installatie moeten de bestanden van een module altijd blijven overeenkomen met de originele distributie. Alle
  gebruiker-specifieke configuratiegegevens dienen aangemaakt te worden via overrides in de Application module
  of via configuratiebestanden op het niveau van de Application module. Alle andere bestandswijzigingen dienen
  te gebeuren in een beschrijfbaar pad buiten de module directory.
  
  Er zijn twee grote voordelen aan het volgen van deze regel. Ten eerste zullen alle modules die gegevens wegschrijven
  onder de module directory niet compatibel zijn met phar packaging. Ten tweede zal het veel makkelijker zijn om de module
  up to date te houden met de upstream distributie met behulp van mechanismen zoals Git. De Application module vormt
  uiteraard een uitzondering op deze regel, aangezien er normaal gezien geen upstream distributie bestaat van deze module,
  en het onwaarschijnlijk is dat je deze module zou willen gebruiken vanuit een phar archief.
  
- **Gebruik een vendor prefix voor namen van modules.** Om conflicten te vermijden wordt aangeraden de namespace van je
  module te voorzien van een vendor prefix. De (nog onvolledige) developer tools module die door Zend wordt verdeeld
  heet bijvoorbeeld "ZendDeveloperTools" in plaats van "DeveloperTools".
  
- **Gebruik een module prefix voor namen van services.** Als je services definieert in de top-level Service Manager,
  dan is het aangeraden om de namen van deze services te voorzien van een prefix met de naam van je module om
  conflicten te vermijden met services van andere modules. Bijvoorbeeld: de database adapter van MyModule kan
  beter "MyModule\DbAdapter" genoemd worden dan "DbAdapter". Als je een service wenst te delen met een andere module,
  onthou dan dat de Service Manager "alias" feature kan gebruikt worden om in een samengevoegde configuratie
  factories te definiëren van individuele modules. In een ideale wereld definiëren modules hun eigen service dependencies,
  maar aliases kunnen gedefinieerd worden op applicatie niveau zodat je zeker kan zijn dat gemeenschappelijke services
  in aparte modules refereren naar dezelfde instantie.

