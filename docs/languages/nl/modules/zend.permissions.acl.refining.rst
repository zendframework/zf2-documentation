.. _zend.permissions.acl.refining:

Verfijning van toegangscontrole
===============================

.. _zend.permissions.acl.refining.precise:

Precieze toegangscontrole
-------------------------

De basis ACL zoals gedefineerd in de :ref:`vorige sectie <zend.permissions.acl.introduction>` laat zien hoe verschillende
privileges kunnen worden toegestaan op de gehele ACL ( alle Bronnen ). Echter in de praktijk, neigen
toegangscontroles naar het hebben van uitzonderingen en gevarieerde niveaus van complexiteit. Zend\Permissions\Acl staat je toe
deze verfijningen in een duidelijke en flexibele manier te bereiken.

Voor het voorbeeld CMS, is vastgesteld dat terwijl de 'medewerker' groep de benodigheden voor het merendeel van de
gebruikers dekt, er een behoefte is aan een nieuwe 'marketing' groep die toegang nodig heeft tot de nieuwsbrieven
en het laatste nieuws in het CMS. De groep is vrij onafhankelijk en heeft de mogelijkheid om nieuwsbrieven en het
laatste nieuws te publiceren en te archiveren.

Verder, is er ook verzocht dat de 'medewerker' groep wordt toegestaan om nieuws berichten te zien, maar ze mogen
het laatste nieuws niet herzien. Als laatste, zou het voor iedereen (zelfs voor de administrators) onmogelijk
moeten zijn om nieuws aankondigingen te archiveren, omdat deze een levensduur hebben van 1-2 dagen.

Allereerst passen we de Rol lijst aan. We hebben ontdekt dat de 'marketing' groep de zelfde basis rechten heeft als
de 'medewerkers', dus we defineren 'marketing' zo dat het de rechten overerft van 'medewerker':

.. code-block::
   :linenos:
   <?php
   // De nieuwe marketing groep erft de rechten van medewerker
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('marketing'), 'medewerker');

Vervolgens, zien we dat de bovenstaande toegangscontrole refereerd naar specifieke Bronnen ( o.a., "nieuwsbrief",
"laatste nieuws", "Nieuws aankondigingen" ). Deze Bronnen gaan we nu toevoegen:

.. code-block::
   :linenos:
   <?php
   // Maken van de Bronnen voor de regels
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('nieuwsbrief'));            	// Nieuwsbrief
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('nieuws'));                 	// Nieuws
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('laatste_nieuws'), 'nieuws');   // Laatste nieuws
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('aankondiging'), 'nieuws'); 	// Nieuws aankondiging

Dan is het enkel nog een kwestie van het defineren van deze specifieke regels op de doel gebieden van de ACL:

.. code-block::
   :linenos:
   <?php
   // Marketing moet kunnen publiceren en archiveren van de nieuwsbrieven en het laatste nieuws
   $acl->allow('marketing', array('nieuwsbrief', 'laatste_nieuws'), array('publiceren', 'archiveren'));

   // Medewerkers ( en marketing door overerving ) worden geweigerd om het laatste nieuws te herzien
   $acl->deny('medewerker', 'laatste_nieuws', 'herzien');

   // Iedereen ( ook de administrators ) worden geweigerd om het nieuws aankondigingen te archiveren
   $acl->deny(null, 'aankondiging', 'archiveren');

We kunnen nu de ACL raadplegen met de nieuwste wijzigingen:

.. code-block::
   :linenos:
   <?php
   echo $acl->isAllowed('medewerker', 'nieuwsbrief', 'publiceren') ?
        "toegestaan" : "geweigerd"; // geweigerd

   echo $acl->isAllowed('marketing', 'nieuwsbrief', 'publiceren') ?
        "toegestaan" : "geweigerd"; // toegestaan

   echo $acl->isAllowed('medewerker', 'laatste_nieuws', 'publiceren') ?
        "toegestaan" : "geweigerd"; // geweigerd

   echo $acl->isAllowed('marketing', 'laatste_nieuws', 'publiceren') ?
        "toegestaan" : "geweigerd"; // toegestaan

   echo $acl->isAllowed('marketing', 'laatste_nieuws', 'archiveren') ?
        "toegestaan" : "geweigerd"; // toegestaan

   echo $acl->isAllowed('marketing', 'laatste_nieuws', 'herzien') ?
        "toegestaan" : "geweigerd"; // geweigerd

   echo $acl->isAllowed('redacteur', 'aankondiging', 'archiveren') ?
        "toegestaan" : "geweigerd"; // geweigerd

   echo $acl->isAllowed('administrator', 'aankondiging', 'archiveren') ?
        "toegestaan" : "geweigerd"; // geweigerd

.. _zend.permissions.acl.refining.removing:

Verwijderen van toegangscontrole
--------------------------------

Om één of meer toegangregels te verwijderen van de ACL, gebruiken we simpelweg de beschikbare *removeAllow()* of
*removeDeny()* methodes. Net als bij *allow()* en *deny()*, mag je een *null* waarde gebruiken om aan te geven dat
het voor alle Rollen, Bronnen en privileges geldt:

.. code-block::
   :linenos:
   <?php
   // Verwijder het weigeren van herzien van het laatste nieuws voor medewerkers ( en marketing via overerving )
   $acl->removeDeny('medewerker', 'laatste_nieuws', 'herzien');

   echo $acl->isAllowed('marketing', 'laatste_nieuws', 'herzien') ?
        "toegestaan" : "geweigerd"; // toegestaan

   // Verwijder het toegestaan van publiceren en archiveren van nieuwsbrieven aan marketing
   $acl->removeAllow('marketing', 'nieuwsbrief', array('publiceren', 'archiveren'));

   echo $acl->isAllowed('marketing', 'nieuwsbrief', 'publiceren') ?
        "toegestaan" : "geweigerd"; // geweigerd

   echo $acl->isAllowed('marketing', 'nieuwsbrief', 'archiveren') ?
        "toegestaan" : "geweigerd"; // geweigerd

Privileges kunnen oplopend worden aangepast zoals je hier boven zag, maar een *null* waarde voor de privileges
overschrijft zo'n oplopende wijziging:

.. code-block::
   :linenos:
   <?php
   // Sta marketing alles toe voor het laatste nieuws
   $acl->allow('marketing', 'laatste_nieuws');

   echo $acl->isAllowed('marketing', 'laatste_nieuws', 'publiceren') ?
        "toegestaan" : "geweigerd"; // toegestaan

   echo $acl->isAllowed('marketing', 'laatste_nieuws', 'archiveren') ?
        "toegestaan" : "geweigerd"; // toegestaan

   echo $acl->isAllowed('marketing', 'laatste_nieuws', 'iets') ?
        "toegestaan" : "geweigerd"; // toegestaan


