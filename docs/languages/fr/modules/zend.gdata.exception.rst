.. EN-Revision: none
.. _zend.gdata.exception:

Attraper les exceptions Gdata
=============================

La classe ``ZendGData\App\Exception`` est la classe de base de toutes les exceptions envoyées par les composants
Gdata.

.. code-block:: php
   :linenos:

   try {
       $client =
           ZendGData\ClientLogin::getHttpClient($username, $password);
   } catch(ZendGData\App\Exception $ex) {
       // Affiche l'exception à l'utilisateur
       die($ex->getMessage());
   }

Voici les sous classes exception utilisées dans ``ZendGData``:

   - ``ZendGData\App\AuthException`` indique que les identifiants du compte utilisateur sont erronés.

   - ``ZendGData\App\BadMethodCallException`` est levée lorsque vous tentez d'utiliser une méthode sur un
     service qui ne l'implémente pas. Par exemple, le service CodeSearch ne supporte pas la méthode ``post()``.

   - ``ZendGData\App\HttpException`` indique un échec de requête *HTTP*. Cette exception vous donne le moyen de
     récupérer la réponse ``Zend\Http\Response`` entière pour déterminer la cause exacte de l'erreur, alors
     que *$e->getMessage()* ne montre pas autant de détails.

   - ``ZendGData\App\InvalidArgumentException`` est envoyée lorsque l'application envoie une valeur non attendue.
     Par exemple spécifier la visibilité d'un calendrier à "banane", ou récupérer le flux d'un blog Blogger
     sans spécifier le nom du blog en question.

   - ``ZendGData\App\CaptchaRequiredException`` est envoyée lorsqu'une tentative de ClientLogin reçoit un
     challenge CAPTCHA(tm) depuis le service d'authentification. Cette exception contient un jeton ID et une *URL*
     vers une image CAPTCHA(tm). Cette image est un puzzle visuel qui devrait être retournée à l'utilisateur du
     service. Après récupération de la réponse de l'utilisateur, celle-ci peut être incluse lors du
     ClientLogin suivant. L'utilisateur peut aussi alternativement être redirigé vers ce site :
     `https://www.google.com/accounts/DisplayUnlockCaptcha`_. De plus amples informations peuvent être trouvées
     dans :ref:`la documentation du ClientLogin <zend.gdata.clientlogin>`.



Vous pouvez ainsi utiliser ces sous-classes d'exceptions pour les gérer chacune différemment. Référez vous à
l'API pour savoir quel composant ``ZendGData`` envoie quel type d'exception.

.. code-block:: php
   :linenos:

   try {
       $client =
           ZendGData\ClientLogin::getHttpClient($username,
                                                 $password,
                                                 $service);
   } catch(ZendGData\App\AuthException $authEx) {
       // identifiants fournis incorrects
       // Vous pourriez par exemple offrir une
       // seconde chance à l'utilisateur ici
       ...
   } catch(ZendGData\App\HttpException $httpEx) {
       // les serveurs Google Data sont injoignables
       die($httpEx->getMessage);
   }



.. _`https://www.google.com/accounts/DisplayUnlockCaptcha`: https://www.google.com/accounts/DisplayUnlockCaptcha
