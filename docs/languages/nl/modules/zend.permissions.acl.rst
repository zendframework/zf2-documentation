.. _zend.permissions.acl.introduction:

Introductie
===========

Zend\Permissions\Acl levert een lichte en flexibele toegangscontrolelijst (ACL) functionaliteit en rechten beheer. In het
algemeen, een applicatie mag deze functionaliteit benutten om de toegang tot bepaalde beschermde objecten door
andere vragende objecten te controleren.

Binnen deze documentatie spreken we af,



   - Een **Bron** is een object waarvan de toegang wordt gecontroleerd.

   - Een **Rol** is een object dat toegang vraagt tot een bron.

Simpel gezegd, **Rollen vragen toegang tot bronnen**. Een voorbeeld, als een persoon toegang vraagt tot een auto,
dan is de vragende persoon een rol en de auto is de bron, want de toegang tot de auto wordt gecontroleerd.

Door de specificatie en het gebruiken van een toegangscontrolelijst (ACL), kan een applicatie controleren of
vragende objecten (Rollen) zijn toegestaan om beschermde objecten (Bronnen) te gebruiken.

.. _zend.permissions.acl.introduction.resources:

Over Bronnen
------------

In Zend\Permissions\Acl is het maken van een bron heel simpel. Zend\Permissions\Acl heeft een *Zend\Permissions\Acl\Resource\ResourceInterface* om het
ontwikkelaars makkelijk te maken bij het maken van Bronnen. Een klasse hoeft deze interface alleen maar te
implementeren, en bestaat uit een enkele methode, *getResourceId()*, om Zend\Permissions\Acl het object als een Bron te laten
beschouwen. Verder wordt *Zend\Permissions\Acl\Resource* gebruikt binnen Zend\Permissions\Acl als een standaard Bron implementatie voor
ontwikkelaars die uitgebreid kan worden waar wenselijk.

Zend\Permissions\Acl levert een boom structuur waaraan meerdere Bronnen ( of "gebieden onder toegangscontrole" ) aan toegevoegd
kunnen worden. Omdat Bronnen opgeslagen worden in zo'n boom structuur, kunnen ze algemeen ( tot aan de top van de
boom ) tot specifiek ( tot de blaadjes van de boom ) geregeld worden. Vragen aan een specifieke Bron zullen
automatisch de Bronnen hiërarchie doorzoeken naar regels verbonden met ouderlijke Bronnen, wat een simpele
overerving van regels mogelijk maakt. Als voorbeeld, als een standaard regel moet worden toegepast op ieder gebouw
binnen een stad, dan verbind je die regel met de stad, in plaats van aan ieder gebouw. Sommige gebouwen hebben
wellicht uitzonderingen op die regel en dit is vrij makkelijk te bereiken binnen Zend\Permissions\Acl door die
uitzonderingsregels te verbinden met ieder gebouw die een uitzondering heeft. Een Bron mag maar van een ouder Bron
erven, maar deze ouder Bron kan zijn eigen ouder Bron hebben, etc etc.

Zend\Permissions\Acl ondersteunt ook privileges op Bronnen (zoals, "maak", "lees", "update", "verwijder"), en de ontwikkelaar
kan regels toekennen die effect hebben op alle privileges of specifieke privileges op een Bron.

.. _zend.permissions.acl.introduction.roles:

Over Rollen
-----------

Net als bij Bronnen, is het aanmaken van een Rol ook heel simpel. Zend\Permissions\Acl levert *Zend\Permissions\Acl\Role\RoleInterface* om het
ontwikkelaars makkelijk te maken bij het maken van een Rol. Een klasse hoeft deze interface alleen maar te
implementeren, en bestaat uit een enkele methode, *getRoleId()*, om Zend\Permissions\Acl het object als een Rol te laten
beschouwen. Verder wordt *Zend\Permissions\Acl\Role* gebruikt binnen Zend\Permissions\Acl als een standaard Rol implementatie voor
ontwikkelaars die uitgebreid kan worden waar wenselijk.

In Zend\Permissions\Acl, mag een Rol erven van één of meer Rollen. Dit is om overerving van regels tussen Rollen mogelijk te
maken. Als voorbeeld, een gebruiker Rol, zoals "sally", kan behoren tot één of meer ouder Rollen, zoals
"redacteur" en "administrator". De ontwikkelaar kan apart regels toekennen aan "redacteur" en "administrator" en
"sally" erft deze regels van beide, zonder dat deze regels direct aan "sally" zijn toegekend.

Hoewel de mogelijkheid om te erven van meerdere Rollen heel makkelijk is, brengt meedere overervingen een zekere
mate van complexiteit met zich mee. Het volgende voorbeeld illustreert een tegenstrijdige bepaling en hoe Zend\Permissions\Acl
dit oplost.

.. _zend.permissions.acl.introduction.roles.example.multiple_inheritance:

.. rubric:: Meerdere overervingen tussen rollen

De volgende code defineerd 3 basis Rollen - "*gast*", "*lid*", en "*admin*" - waarvan andere Rollen kunnen erven.
Vervolgens, wordt er een Rol, met de identiteit "*eenGebruiker*" aangemaakt die van alle drie de Rollen erft. De
volgorde waarin deze rollen staan in de *$ouders* array is van belang. Als het nodig is, zoekt Zend\Permissions\Acl niet alleen
naar toegangsregels voor de geraadpleegde Rol ( in dit voorbeeld "*eenGebruiker*"), maar ook in de Rollen waar de
geraadpleegde Rol van erft (in dit voorbeeld "*gast*", "*lid*", en "*admin*"):

.. code-block:: php
   :linenos:

   <?php
   $acl = new Zend\Permissions\Acl\Acl();

   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('gast'))
       ->addRole(new Zend\Permissions\Acl\Role\GenericRole('lid'))
       ->addRole(new Zend\Permissions\Acl\Role\GenericRole('admin'));

   $ouders = array('gast', 'lid', 'admin');
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('eenGebruiker'), $ouders);

   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('eenBron'));

   $acl->deny('gast', 'eenBron');
   $acl->allow('lid', 'eenBron');

   echo $acl->isAllowed('eenGebruiker', 'eenBron') ? 'toegestaan' : 'weigeren';

Omdat er geen regel is gespecificeerd voor de "*eenGebruiker*" Rol en "*eenBron*", gaat Zend\Permissions\Acl opzoek naar regels
die mogelijk gedefineerd zijn voor Rollen waar "*eenGebruiker*" van erft. Als eerste wordt de "*admin*" Rol
geraadpleegd, hiervoor is geen toegang regel gedefineerd. Daarna wordt de "*lid*" Rol geraadpleegd, en Zend\Permissions\Acl
vindt hier een regel dat "*lid*" toegestaan is om "*eenBron*" te gebruiken.

Als Zend\Permissions\Acl door zou gaan met raadplegen van regels gedefineerd voor andere ouder Rollen, dan zou hij vinden dat
"*gast*" geen toegang heeft om "*eenBron*" te gebruiken. Dit feit introduceert een tegenstrijdigheid want nu is
"*eenGebruiker*" zowel toegestaan als geweigerd om "*eenBron*" te gebruiken, veroorzaakt door het erven van
conflicterende regels van verschillende ouder Rollen.

Zend\Permissions\Acl lost deze tegenstrijdigheid op door de raadpleging te beëindigen zodra de eerste regel gevonden wordt die
direct toepasbaar is op de vraag. In dit geval, omdat de "*lid*" Rol eerder geraadpleegd wordt dan "*gast*", zal de
voorbeeld code "toegestaan" weergeven.

.. note::

   Wanneer je meerdere ouders specificeerd voor een Rol, hou dan in gedachten dat de laatste ouder in de lijst als
   eerste doorzocht wordt op regels die toepasbaar zijn op de autorisatie vraag.

.. _zend.permissions.acl.introduction.creating:

Maken van de toegangscontrolelijst (ACL)
----------------------------------------

Een ACL kan iedere groep van fysieke en virtuele objecten bevatten die je wenst. Als demonstratie creëren we een
basis Content Management Systeem ACL die verschillende niveaus van groepen bevat. Voor het maken van een ACL
object, moeten we de ACL instantiëren zonder parameters:

.. code-block:: php
   :linenos:

   <?php

   $acl = new Zend\Permissions\Acl\Acl();

.. note::

   Totdat een ontwikkelaar een toestaan regel specificeerd, zal Zend\Permissions\Acl toegang tot iedere privilege van iedere
   Bron verbieden voor elke Rol.

.. _zend.permissions.acl.introduction.role_registry:

Registeren van Rollen
---------------------

Content Management Systemen zullen bijna altijd een hiërarchie van rechten nodig hebben om de rechten van zijn
gebruikers te bepalen. Er is bijvoorbeeld een 'gast' groep om gelimiteerde toegang voor demonstraties toe te staan,
een 'medewerker' groep voor het meerendeel van de CMS gebruikers die de dagelijkse acties uitvoeren, een
'redacteur' groep voor diegene die verantwoordelijke zijn voor herzien, acrhieveren en verwijderen van content en
een 'administrator' groep die alles van de andere groepen mag en onderhoud mag plegen aan gevoelige informatie,
gebruikersbeheer, configuraties aanpassen en gegevens backuppen/ exporteren. Deze rechten worden verzameld in een
Rol lijst, waarin elke groep privileges mag erven van 'ouder' groepen en enkele privileges voor hun unieke groep
kunnen hebben. De rechten kunnen als volgt worden weergegeven:

.. _zend.permissions.acl.introduction.role_registry.table.example_cms_access_controls:

.. table:: Toegang controle voor een voorbeeld CMS

   +-------------+-----------------------------------+----------------+
   |Naam         |Unieke rechten                     |Erft rechten van|
   +=============+===================================+================+
   |Gast         |Bekijk                             |N/A             |
   +-------------+-----------------------------------+----------------+
   |Medewerker   |Wijzig, Verzenden, Herzien         |Gast            |
   +-------------+-----------------------------------+----------------+
   |Redacteur    |Publiceren, Archiveren, Verwijderen|Medewerker      |
   +-------------+-----------------------------------+----------------+
   |Administrator|Heeft alle rechten                 |N/A             |
   +-------------+-----------------------------------+----------------+

Als voorbeeld wordt *Zend\Permissions\Acl\Role* gebruikt, maar ieder object dat *Zend\Permissions\Acl\Role\RoleInterface* implementeert kan
gebruikt worden. De groepen kunnen toegevoegd worden aan de Rol lijst op de volgende manier:

.. code-block:: php
   :linenos:

   <?php

   $acl = new Zend\Permissions\Acl\Acl();

   // Voeg groepen toe aan de Rol lijst van Zend\Permissions\Acl\Role

   // Gast erft geen oudelijke Rollen
   $rolGast = new Zend\Permissions\Acl\Role\GenericRole('gast');
   $acl->addRole($rolGast);

   // Medewerker erft van gast
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('medewerker'), $rolGast);

   /* Bovenstaande kan ook geschreven worden als:
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('medewerker'), 'gast');
   */

   // Redacteur erft van medewerker
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('redacteur'), 'medewerker');

   // Administrator erft geen ouder Rollen
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('administrator'));

.. _zend.permissions.acl.introduction.defining:

Defineren van de toegangscontrole
---------------------------------

Nu de ACL de relevante Rollen bevat, kunnen de regels worden opgesteld die defineren hoe Bronnen kunnen worden
gebruikt door Rollen. Het is je misschien opgevallen dat we geen Bronnen hebben gespecificeerd in dit voorbeeld,
wat erop neer komt dat de regels gelden voor alle Bronnen. Zend\Permissions\Acl levert een inplementatie waarbij regels enkel
te worden toegekend van algemeen tot specifiek, dit verkleint het aantal regels wat nodig is, want Bronnen en
Rollen erven regels die zijn gedefineerd voor hun ouders.

.. note::

   In het algemeen, staat Zend\Permissions\Acl een regel toe als een meer specifiekere regel niet bestaat.

We kunnen dus een redelijke complexe groep van regels defineren met een kleine hoeveelheid code. Om de basisregels
toe te passen zoals hierboven staan beschreven:

.. code-block:: php
   :linenos:

   <?php

   $acl = new Zend\Permissions\Acl\Acl();


   $rolGast = new Zend\Permissions\Acl\Role\GenericRole('gast');
   $acl->addRole($rolGast);
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('medewerker'), $rolGast);
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('redacteur'), 'medewerker');
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('administrator'));

   // Gast mag alleen content bekijken
   $acl->allow($rolGast, null, 'bekijk');

   /* Bovenstaande kan ook geschreven worden als:
   $acl->allow('gast', null, 'bekijk');
   */

   // Medewerker erft het bekijk privilege van gast, maar heeft extra privileges
   $acl->allow('medewerker', null, array('wijzig', 'verzend', 'herzien'));

   // Redacteur erft bekijk, wijzig, verzend en herzien privileges van medewerker
   // maar heeft extra prvileges
   $acl->allow('redacteur', null, array('publiceer', 'archiveer', 'verwijder'));

   // Administrator erft niets, maar is alle privileges toegestaan
   $acl->allow('administrator');

De *null* waarde in bovenstaande *allow()* aanroepen worden gebruikt om aan te geven dat de toestaan regels op alle
Bronnen van toepassing zijn.

.. _zend.permissions.acl.introduction.querying:

Raadplegen van de ACL
---------------------

We hebben nu een flexibele ACL die gebruikt kan worden om te bepalen of de aanvrager toestemming heeft om de actie
uit te voeren binnen de web applicatie. Raadplegen is vrij simpel met het gebruik van de *isAllowed()* methode:

.. code-block:: php
   :linenos:

   <?php
   echo $acl->isAllowed('gast', null, 'bekijk') ?
        "toegestaan" : "geweigerd"; // toegestaan

   echo $acl->isAllowed('medewerker', null, 'publiseer') ?
        "toegestaan" : "geweigerd"; // geweigerd

   echo $acl->isAllowed('medewerker', null, 'herzien') ?
        "toegestaan" : "geweigerd"; // toegestaan

   echo $acl->isAllowed('redacteur', null, 'bekijk') ?
        "toegestaan" : "geweigerd"; // toegestaan vanwege de overerving van gast

   echo $acl->isAllowed('redacteur', null, 'update') ?
        "toegestaan" : "geweigerd"; // geweigerd want er is geen toestaan regel voor 'update'

   echo $acl->isAllowed('administrator', null, 'bekijk') ?
        "toegestaan" : "geweigerd"; // toegestaan want administrator is alles toegestaan

   echo $acl->isAllowed('administrator') ?
        "toegestaan" : "geweigerd"; // toegestaan want administrator is alles toegestaan

   echo $acl->isAllowed('administrator', null, 'update') ?
        "toegestaan" : "geweigerd"; // toegestaan want administrator is alles toegestaan


