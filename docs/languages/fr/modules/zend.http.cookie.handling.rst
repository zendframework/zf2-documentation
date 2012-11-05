.. EN-Revision: none
.. _zend.http.cookies:

Zend\Http\Cookie and Zend\Http\CookieJar
========================================

.. _zend.http.cookies.introduction:

Introduction
------------

``Zend\Http\Cookie``, comme son nom l'indique, est une classe qui représente un cookie *HTTP*. Elle propose des
méthodes d'analyse de la chaîne de réponse *HTTP*, de collection des cookies, et d'accès à leurs propriétés.
Il est aussi possible avec cette classe de vérifier si les paramètres d'un cookie correspondent à un scénario
précis, par exemple une *URL* spécifique, un certain temps d'expiration, la présence ou non de *HTTPS*, etc...

``Zend\Http\CookieJar`` est un objet utilisé en général avec ``Zend\Http\Client`` pour fournir une collection
d'objets ``Zend\Http\Cookie``. L'idée principale est d'attacher un objet ``Zend\Http\CookieJar`` à un objet
``Zend\Http\Client``, de manière à ce que toutes les requêtes de celui-ci utilisent les cookies présents dans
l'objet *CookieJar*. Ainsi, lorsque le client enverra une autre requête, il demandera à l'objet *CookieJar* tous
les cookies concernant cette requête. Ceci est très pratique dans des cas comme envoyer un cookie de session
entre plusieurs requêtes *HTTP* successives. De plus, l'objet ``Zend\Http\CookieJar`` peut être sérialisé et
mis en session.

.. _zend.http.cookies.cookie.instantiating:

Instancier des objets Zend\Http\Cookie
--------------------------------------

L'instanciation se fait de deux manières différentes :

   - Via son constructeur, de cette façon : *new Zend\Http\Cookie(string $name, string $value, string $domain,
     [int $expires, [string $path, [boolean $secure]]]);*

     - ``$name``: Nom du cookie (par ex. "PHPSESSID") (requis)

     - ``$value``: La valeur du cookie (requis)

     - ``$domain``: Le domaine de validité du cookie (par ex. ".example.com") (requis)

     - ``$expires``: Temps d'expiration du cookie, un timestamp UNIX (optionnel, défaut à ``NULL``). Si non
       fourni, le cookie sera considéré comme "cookie de session", avec pas de temps d'expiration.

     - ``$path``: Chemin de validité du cookie, par ex. "/foo/bar/" (optionnel, défaut : "/")

     - ``$secure``: Booléen, Si le cookie doit être transmis via connexion sécurisée (HTTPS) uniquement
       (optionnel, défaut à ``FALSE``)

   - En appelant la méthode statique ``fromString($cookieStr, [$refUri, [$encodeValue]])``, avec une chaîne de
     caractères représentant un cookie tel que défini dans les en-têtes *HTTP*"Set-Cookie" (réponse) ou
     "Cookie" (requête). Dans ce cas la valeur du cookie doit être encodée. Lorsque la chaîne de caractères
     représentant un cookie ne comporte pas de partie "domain", vous devez fournir alors un *URI* selon lequel le
     cookie cherchera son domaine et son chemin.

     La méthode *fromString* accepte les paramètres suivants :

     - ``$cookieStr``: a cookie string as represented in the 'Set-Cookie'*HTTP* response header or 'Cookie'*HTTP*
       request header (required)

     - ``$refUri``: a reference *URI* according to which the cookie's domain and path will be set. (optional,
       defaults to parsing the value from the $cookieStr)

     - ``$encodeValue``: If the value should be passed through urldecode. Also effects the cookie's behavior when
       being converted back to a cookie string. (optional, defaults to true)





      .. _zend.http.cookies.cookie.instantiating.example-1:

      .. rubric:: Créer un objet Zend\Http\Cookie

      .. code-block:: php
         :linenos:

         // D'abord, en utilisant son constructeur.
         // ce cookie expirera dans 2 heures
         $cookie = new Zend\Http\Cookie('foo',
                                        'bar',
                                        '.example.com',
                                        time() + 7200,
                                        '/path');

         // En prenant l'en-tête de réponse HTTP 'Set-Cookie'
         // Ce cookie n'expirera pas et ne sera envoyé que
         // sur des connexions sécurisées
         $cookie = Zend\Http\Cookie::fromString(
                         'foo=bar; domain=.example.com; path=/path; secure');

         // Si le domaine n'est pas présent, spécifiez le manuellement :
         $cookie = Zend\Http\Cookie::fromString(
                         'foo=bar; secure;', 'http://www.example.com/path');



   .. note::

      Lorsque vous utilisez la méthode statique ``Zend\Http\Cookie::fromString()``, veillez à fournir un cookie
      *URL* encodé (tel que c'est le cas dans les en-têtes *HTTP*). Avec le constructeur en revanche, il est
      nécessaire d'utiliser une valeur non encodée.



La manipulation inverse est possible. Grâce à la méthode ``__toString()``, vous pouvez récupérer une chaîne
représentant le cookie, à partir de l'objet ``Zend\Http\Cookie``. La chaîne alors retournée est la même que
celle utilisée dans l'en-tête HTTP "Cookie", à savoir une chaîne encodée, terminée par un point-virgule (;) :




      .. _zend.http.cookies.cookie.instantiating.example-2:

      .. rubric:: Passer de l'objet Zend\Http\Cookie à la chaîne

      .. code-block:: php
         :linenos:

         // Création d'un nouveau cookie
         $cookie = new Zend\Http\Cookie('foo',
                                        'two words',
                                        '.example.com',
                                        time() + 7200,
                                        '/path');

         // Va afficher 'foo=two+words;' :
         echo $cookie->__toString();

         // Ceci est la même chose
         echo (string) $cookie;

         // En PHP 5.2 et plus, ceci fonctionne aussi :
         echo $cookie;



.. _zend.http.cookies.cookie.accessors:

Zend\Http\Cookie méthodes getter
--------------------------------

Une fois l'objet ``Zend\Http\Cookie`` crée, il existe des méthodes 'getter' pour accéder aux différentes
propriétés du cookie :

   - *string getName()*: Retourne le nom du cookie

   - *string getValue()*: Retourne la valeur réelle (décodée), du cookie

   - *string getDomain()*: Retourne le domaine du cookie

   - *string getPath()*: Retourne le chemin du cookie, par défaut '/'

   - *int getExpiryTime()*: Retourne la date d'expiration, comme timestamp UNIX. Si pas de date, ``NULL`` sera
     retourné.



Voici encore quelques méthodes de vérifications booléennes :

   - *boolean isSecure()*: Regarde si le cookie est un cookie sécurisé. Si c'est le cas, les navigateurs ont pour
     instruction de ne les envoyer que sur des connexions sécurisées (HTTPS).

   - *boolean isExpired(int $time = null)*: Vérifie si le cookie est expirés. Si il n'y a pas de date
     d'expiration, cette méthode retournera toujours ``TRUE``. Si ``$time`` est fourni, alors la date du cookie
     sera comparée à ce ``$time``, et non plus au temps actuel.

   - *boolean isSessionCookie()*: Vérifie si le cookie est un cookie dit 'de session'. C'est un cookie sans date
     d'expiration, sensé être détruit à la fin de la session de travail actuelle (à la fermeture du
     navigateur).







      .. _zend.http.cookies.cookie.accessors.example-1:

      .. rubric:: Utilisation des méthodes getter de Zend\Http\Cookie

      .. code-block:: php
         :linenos:

         // Création d'un cookie
         $cookie =
             Zend\Http\Cookie::fromString('foo=two+words;'
                                        . ' domain=.example.com;'
                                        . ' path=/somedir;'
                                        . 'secure;'
                                        . 'expires=Wednesday, 28-Feb-05 20:41:22 UTC');

         echo $cookie->getName();   // Affiche 'foo'
         echo $cookie->getValue();  // Affiche 'two words'
         echo $cookie->getDomain(); // Affiche '.example.com'
         echo $cookie->getPath();   // Affiche '/'

         echo date('Y-m-d', $cookie->getExpiryTime());
         // Affiche '2005-02-28'

         echo ($cookie->isExpired() ? 'Yes' : 'No');
         // Affiche 'Yes'

         echo ($cookie->isExpired(strtotime('2005-01-01') ? 'Yes' : 'No');
         // Affiche 'No'

         echo ($cookie->isSessionCookie() ? 'Yes' : 'No');
         // Affiche 'No'



.. _zend.http.cookies.cookie.matching:

Zend\Http\Cookie: Correspondance de scénario
--------------------------------------------

La vraie valeur ajoutée d'un objet ``Zend\Http\Cookie`` est sa méthode match(). Celle-ci teste le cookie en
rapport avec un scénario *HTTP*, pour savoir ci celui-ci doit être attaché à la requête ou pas. La syntaxe est
la suivante : *boolean Zend\Http\Cookie->match(mixed $uri, [boolean $matchSessionCookies, [int $now]]);*

   - *mixed $uri*: un objet Zend\Uri\Http avec un domaine et un chemin à vérifier. Une chaîne représentant une
     *URL* peut aussi être utilisée. Le cookie sera déclaré bon si le schéma de l'URL (HTTP ou *HTTPS*)
     correspond, ainsi que le chemin (path).

   - *boolean $matchSessionCookies*: établit ou non une correspondance pour les cookies dits de session. Par
     défaut : ``TRUE``. Si mis à ``FALSE``, alors les cookies sans date d'expiration seront ignorés du
     processus.

   - *int $now*: timestamp UNIX passé pour vérifier l'expiration du cookie. Si non spécifié, alors le temps
     actuel sera pris en considération.





      .. _zend.http.cookies.cookie.matching.example-1:

      .. rubric:: Correspondance de cookies

      .. code-block:: php
         :linenos:

         // Création de l'objet cookie - d'abord un cookie sécurisé
         $cookie = Zend\Http\Cookie::fromString(
                     'foo=two+words; domain=.example.com; path=/somedir; secure;');

         $cookie->match('https://www.example.com/somedir/foo.php');
         // Retournera true

         $cookie->match('http://www.example.com/somedir/foo.php');
         // Retournera false, car la connexion n'est pas sécurisée

         $cookie->match('https://otherexample.com/somedir/foo.php');
         // Retournera false, le domaine est incorrect

         $cookie->match('https://example.com/foo.php');
         // Retournera false, le chemin est incorrect

         $cookie->match('https://www.example.com/somedir/foo.php', false);
         // Retournera false, car les cookies de session ne sont pas pris en compte

         $cookie->match('https://sub.domain.example.com/somedir/otherdir/foo.php');
         // Retournera true

         // Création d'un autre objet cookie - cette fois non sécurisé,
         // expire dans 2 heures
         $cookie = Zend\Http\Cookie::fromString(
                     'foo=two+words; domain=www.example.com; expires='
                   . date(DATE_COOKIE, time() + 7200));

         $cookie->match('http://www.example.com/');
         // Retournera true

         $cookie->match('https://www.example.com/');
         // Will return true - non secure cookies can go
         // over secure connexions as well!

         $cookie->match('http://subdomain.example.com/');
         // Retournera false, domaine incorrect

         $cookie->match('http://www.example.com/', true, time() + (3 * 3600));
         // Retournera false, car nous avons rajouter 3 heures au temps actuel



.. _zend.http.cookies.cookiejar:

Classe Zend\Http\CookieJar : Instanciation
------------------------------------------

Dans la plupart des cas, il ne sera pas nécessaire d'instancier soi-même un objet ``Zend\Http\CookieJar``. Si
vous voulez un conteneur de cookie (CookieJar) attaché à votre objet ``Zend\Http\Client``, appelez simplement
``Zend\Http\Client->setCookieJar()``, et un nouveau conteneur, vide, y sera attaché. Plus tard, vous pourrez
utiliser la méthode ``Zend\Http\Client->getCookieJar()``, pour récupérer ce conteneur.

Si vous voulez tout de même instancier manuellement un objet *CookieJar*, appelez son constructeur avec "*new
Zend\Http\CookieJar()*", sans paramètres. Sinon il est possible aussi de passer par la méthode statique
``Zend\Http\CookieJar::fromResponse()`` qui prend, elle, deux paramètres : un objet ``Zend\Http\Response`` et un
*URI* de référence (un objet ``Zend\Uri\Http`` ou une chaîne). Cette méthode retourne alors un objet
``Zend\Http\CookieJar`` qui contiendra les cookies de la réponse *HTTP* passée. L'URI de référence servira à
remplir les paramètres "domain" et "path" des cookies, si jamais ils n'ont pas été définis dans les en-têtes
"Set-Cookie".

.. _zend.http.cookies.cookiejar.adding_cookies:

Ajouter des cookies à un objet Zend\Http\CookieJar
--------------------------------------------------

En temps normal, c'est l'objet ``Zend\Http\Client`` qui ajoutera des cookies dans l'objet *CookieJar* que vous lui
aurez attaché. Vous pouvez en ajouter manuellement aussi :

   - ``Zend\Http\CookieJar->addCookie($cookie[, $ref_uri])``: Ajoute un cookie au conteneur (Jar). $cookie peut
     être soit un objet ``Zend\Http\Cookie``, soit une chaîne qui sera alors convertie de manière automatique en
     objet cookie. Si vous passez une chaîne, alors vous devriez aussi passer le paramètre $ref_uri qui
     représente l'URI de référence pour déterminer les paramètres "domain" et "path" du cookie.

   - ``Zend\Http\CookieJar->addCookiesFromResponse($response, $ref_uri)``: Ajoute tous les cookies présents dans
     une réponse *HTTP* au conteneur. La réponse *HTTP* doit être un objet ``Zend\Http\Response`` contenant au
     moins un en-tête "Set-Cookie". ``$ref_uri`` est un *URI* (un objet Zend\Uri\Http ou une chaîne), servant de
     référence pour remplir les paramètres du cookie "domain" et "path", si ceux-ci ne sont pas trouvés dans la
     réponse.



.. _zend.http.cookies.cookiejar.getting_cookies:

Récupérer les cookies présents dans un objet Zend\Http\CookieJar
----------------------------------------------------------------

Comme pour l'ajout de cookies, en théorie, vous n'aurez pas besoin de récupérer des cookies du conteneur, car
l'objet ``Zend\Http\Client`` se chargera de les gérer lui-même et de les envoyer dans les bonnes requêtes.
Cependant, il existe des méthodes pour récupérer des cookies depuis un conteneur (Jar) : ``getCookie()``,
``getAllCookies()``, et ``getMatchingCookies()``. De plus, itérer sur le CookieJar vous permettra d'en extraire
tous les objets ``Zend\Http\Cookie``.

Il est important de noter que chacune de ces trois méthodes, prend un paramètre spécial destiné à déterminer
le type que chaque méthode retournera. Ce paramètre peut avoir 3 valeurs:

   - ``Zend\Http\CookieJar::COOKIE_OBJECT``: Retourne un objet ``Zend\Http\Cookie``. Si plus d'un cookie devait
     être retourné, il s'agira alors d'un tableau d'objets cookie.

   - ``Zend\Http\CookieJar::COOKIE_STRING_ARRAY``: Retourne les cookies comme des chaînes de caractères dans un
     format "foo=bar", correspondant au format de l'en-tête de requête *HTTP*"Cookie". Si plus d'un cookie devait
     être retourné, il s'agira alors d'un tableau de chaînes.

   - ``Zend\Http\CookieJar::COOKIE_STRING_CONCAT``: Similaire à COOKIE_STRING_ARRAY, mais si plusieurs cookies
     devaient être retournés, alors il ne s'agira plus d'un tableau, mais d'une chaîne concaténant tous les
     cookies, séparés par des point-virgule (;). Ceci est très utile pour passer tous les cookies d'un coup,
     dans l'en-tête *HTTP*"Cookie".



Voici la structure des méthodes de récupération des cookies :

   - ``Zend\Http\CookieJar->getCookie($uri, $cookie_name[, $ret_as])``: Retourne un cookie depuis le conteneur,
     selon son *URI* (domain et path), et son nom. ``$uri`` est un objet ``Zend\Uri\Http`` ou une chaîne.
     $cookie_name est une chaîne identifiant le cookie en question. $ret_as spécifie le type de retour, comme vu
     plus haut (par défaut COOKIE_OBJECT).

   - ``Zend\Http\CookieJar->getAllCookies($ret_as)``: Retourne tous les cookies du conteneur. $ret_as spécifie le
     type de retour, comme vu plus haut (par défaut COOKIE_OBJECT).

   - ``Zend\Http\CookieJar->getMatchingCookies($uri[, $matchSessionCookies[, $ret_as[, $now]]])``: Retourne tous
     les cookies ayant une correspondance pour un scénario donné, à savoir un *URI* et une date d'expiration.

        - ``$uri`` est soit un objet Zend\Uri\Http soit une chaîne.

        - ``$matchSessionCookies`` est un booléen désignant si les cookies de session, c'est à dire sans date
          d'expiration, doivent être analysés aussi pour établir une correspondance. Par défaut : ``TRUE``.

        - ``$ret_as`` spécifie le type de retour, comme vu plus haut (par défaut COOKIE_OBJECT).

        - ``$now`` est un entier représentant un timestamp UNIX à considérer comme 'maintenant'. Ainsi tous les
          cookies expirant avant ce temps là, ne seront pas pris en compte. Si vous ne spécifiez pas ce
          paramètre, alors c'est le temps actuel qui sera pris comme référence.

     Vous pouvez en apprendre plus sur la correspondance des cookies ici : :ref:`
     <zend.http.cookies.cookie.matching>`.




