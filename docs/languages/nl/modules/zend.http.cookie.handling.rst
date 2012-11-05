.. EN-Revision: none
.. _zend.http.cookies:

Zend\Http\Cookie and Zend\Http\CookieJar
========================================

.. _zend.http.cookies.introduction:

Inleiding
---------

Zend\Http\Cookie is, zoals verwacht, een klasse die een HTTP cookie voorstelt. Ze verstrekt methodes voor het
inlezen van HTTP response strings, cookies verzamelen en gemakkelijk hun eigenschappen aanspreken. Het laat ook toe
na te gaan of een cookie een bepaald scenario volgt, bv: een verzoek URL, verlooptijd, secure verbinding, enz.

Zend\Http\CookieJar is een object dat gewoonlijk door Zend\Http\Client word gebruikt om een set van
Zend\Http\Cookie objecten te bewaren. Het idee is dat indien een Zend\Http\CookieJar object aan een
Zend\Http\Client objekt is verbonden alle cookies die van en naar de klant gaan via HTTP verzoeken in het
Zend\Http\CookieJar zullen worden opgeslaan. Als de klant dan een nieuw verzoek maakt zal het eerst het
Zend\Http\CookieJar object aanspreken om alle cookies die aan het verzoek voldoen te verkrijgen. Deze zullen dan
automatisch aan de verzoek headers worden toegevoegd. Dit is zeer handig in gevallen waar je een gebruikers sessie
over opeenvolgende HTTP verzoeken moet bewaren : het stuurt automatisch de session ID cookies waar nodig. Bovendien
kan het Zend\Http\CookieJar object worden geserialiseerd en opgeslaan worden in $_SESSION waar nodig.

.. _zend.http.cookies.cookie.instantiating:

Instantiating Zend\Http\Cookie Objects
--------------------------------------

Instantiating a Cookie object can be done in two ways:

   - Through the constructor, using the following syntax: *new Zend\Http\Cookie(string $name, string $value, string
     $domain, [int $expires, [string $path, [boolean $secure]]]);*

     - *$name*: The name of the cookie (eg. 'PHPSESSID') (required)

     - *$value*: The value of the cookie (required)

     - *$domain*: The cookie's domain (eg. '.example.com') (required)

     - *$expires*: Cookie expiration time, as UNIX time stamp (optional, defaults to null). If not set, cookie will
       be treated as a 'session cookie' with no expiration time.

     - *$path*: Cookie path, eg. '/foo/bar/' (optional, defaults to '/')

     - *$secure*: Boolean, Whether the cookie is to be sent over secure (HTTPS) connections only (optional,
       defaults to boolean FALSE)

   - By calling the fromString() static method, with a cookie string as represented in the 'Set-Cookie' HTTP
     response header or 'Cookie' HTTP request header. In this case, the cookie value must already be encoded. When
     the cookie string does not contain a 'domain' part, you must provide a reference URI according to which the
     cookie's domain and path will be set.



   .. rubric:: Instantiating a Zend\Http\Cookie object

   .. code-block:: php
      :linenos:

      <?php
      // First, using the constructor. This cookie will expire in 2 hours
      $cookie = new Zend\Http\Cookie('foo', 'bar', '.example.com', time() + 7200, '/path');

      // You can also take the HTTP response Set-Cookie header and use it.
      // This cookie is similar to the previous one, only it will not expire, and
      // will only be sent over secure connections
      $cookie = Zend\Http\Cookie::fromString('foo=bar; domain=.example.com; path=/path; secure');

      // If the cookie's domain is not set, you have to manually specify it
      $cookie = Zend\Http\Cookie::fromString('foo=bar; secure;', 'http://www.example.com/path');
      ?>


   .. note::

      When instantiating a cookie object using the Zend\Http\Cookie::fromString() method, the cookie value is
      expected to be URL encoded, as cookie strings should be. However, when using the constructor, the cookie
      value string is expected to be the real, decoded value.



A cookie object can be transferred back into a string, using the \__toString() magic method. This method will
produce a HTTP request "Cookie" header string, showing the cookie's name and value, and terminated by a semicolon
(';'). The value will be URL encoded, as expected in a Cookie header:

   .. rubric:: Stringifying a Zend\Http\Cookie object

   .. code-block:: php
      :linenos:

      <?php
      // Create a new cookie
      $cookie = new Zend\Http\Cookie('foo', 'two words', '.example.com', time() + 7200, '/path');

      // Will print out 'foo=two+words;' :
      echo $cookie->__toString();

      // This is actually the same:
      echo (string) $cookie;

      // In PHP 5.2 and higher, this also works:
      echo $cookie;
      ?>


.. _zend.http.cookies.cookie.accessors:

Zend\Http\Cookie getter methods
-------------------------------

Once a Zend\Http\Cookie object is instantiated, it provides several getter methods to get the different properties
of the HTTP cookie:

   - *string getName()*: Get the name of the cookie

   - *string getValue()*: Get the real, decoded value of the cookie

   - *string getDomain()*: Get the cookie's domain

   - *string getPath()*: Get the cookie's path, which defaults to '/'

   - *int getExpiryTime()*: Get the cookie's expiration time, as UNIX time stamp. If the cookie has no expiration
     time set, will return NULL.



Additionally, several boolean tester methods are provided:

   - *boolean isSecure()*: Check whether the cookie is set to be sent over secure connections only. Generally
     speaking, if true the cookie should only be sent over HTTPS.

   - *boolean isExpired(int $time = null)*: Check whether the cookie is expired or not. If the cookie has no
     expiration time, will always return true. If $time is provided, it will override the current time stamp as the
     time to check the cookie against.

   - *boolean isSessionCookie()*: Check whether the cookie is a "session cookie" - that is a cookie with no
     expiration time, which is meant to expire when the session ends.





   .. rubric:: Using getter methods with Zend\Http\Cookie

   .. code-block:: php
      :linenos:

      <?php
      // First, create the cookie
      $cookie = Zend\Http\Client('foo=two+words; domain=.example.com; path=/somedir; secure; expires=Wednesday, 28-Feb-05 20:41:22 UTC');

      echo $cookie->getName();   // Will echo 'foo'
      echo $cookie->getValue();  // will echo 'two words'
      echo $cookie->getDomain(); // Will echo '.example.com'
      echo $cookie->getPath();   // Will echo '/'

      echo date('Y-m-d', $cookie->getExpiryTime());
      // Will echo '2005-02-28'

      echo ($cookie->isExpired() ? 'Yes' : 'No');
      // Will echo 'Yes'

      echo ($cookie->isExpired(strtotime('2005-01-01') ? 'Yes' : 'No');
      // Will echo 'No'

      echo ($cookie->isSessionCookie() ? 'Yes' : 'No');
      // Will echo 'No'
      ?>


.. _zend.http.cookies.cookie.matching:

Zend\Http\Cookie: Matching against a scenario
---------------------------------------------

The only real logic contained in a Zend\Http\Cookie object, is in the match() method. This method is used to test a
cookie against a given HTTP request scenario, in order to tell whether the cookie should be sent in this request or
not. The method has the following syntax and parameters: *boolean Zend\Http\Cookie->match(mixed $uri, [boolean
$matchSessionCookies, [int $now]]);*

   - *mixed $uri*: A Zend\Uri\Http object with a domain name and path to be checked. Optionally, a string
     representing a valid HTTP URL can be passed instead. The cookie will match if the URL's scheme (HTTP or
     HTTPS), domain and path all match.

   - *boolean $matchSessionCookies*: Whether session cookies should be matched or not. Defaults to true. If set to
     false, cookies with no expiration time will never match.

   - *int $now*: Time (represented as UNIX time stamp) to check a cookie against for expiration. If not specified,
     will default to the current time.



   .. rubric:: Matching cookies

   .. code-block:: php
      :linenos:

      <?php
      // Create the cookie object - first, a secure session cookie
      $cookie = Zend\Http\Client('foo=two+words; domain=.example.com; path=/somedir; secure;');

      $cookie->match('https://www.example.com/somedir/foo.php');
      // Will return true

      $cookie->match('http://www.example.com/somedir/foo.php');
      // Will return false, because the connection is not secure

      $cookie->match('https://otherexample.com/somedir/foo.php');
      // Will return false, because the domain is wrong

      $cookie->match('https://example.com/foo.php');
      // Will return false, because the path is wrong

      $cookie->match('https://www.example.com/somedir/foo.php', false);
      // Will return false, because session cookies are not matched

      $cookie->match('https://sub.domain.example.com/somedir/otherdir/foo.php');
      // Will return true

      // Create another cookie object - now, not secure, with expiration time in two hours
      $cookie = Zend\Http\Client('foo=two+words; domain=www.example.com; expires=' . date(DATE_COOKIE, time() + 7200);

      $cookie->match('http://www.example.com/');
      // Will return true

      $cookie->match('https://www.example.com/');
      // Will return true - non secure cookies can go over secure connections as well!

      $cookie->match('http://subdomain.example.com/');
      // Will return false, because the domain is wrong

      $cookie->match('http://www.example.com/', true, time() + (3 * 3600));
      // Will return false, because we added a time offset of +3 hours to current time
      ?>


.. _zend.http.cookies.cookiejar:

The Zend\Http\CookieJar Class: Instantiation
--------------------------------------------

In most cases, there is no need to directly instantiate a Zend\Http\CookieJar object. If you want to attach a new
cookie jar to your Zend\Http\Client object, just call the Zend\Http\Client->setCookieJar() method, and a new, empty
cookie jar will be attached to your client. You could later get this cookie jar using
Zend\Http\Client->getCookieJar().

If you still wish to manually instantiate a CookieJar object, you can do so by calling "new Zend\Http\CookieJar()"
directly - the constructor method does not take any parameters. Another way to instantiate a CookieJar object is to
use the static Zend\Http\CookieJar::fromResponse() method. This method takes two parameters: a Zend\Http\Response
object, and a reference URI, as either a string or a Zend\Uri\Http object. This method will return a new
Zend\Http\CookieJar object, already containing the cookies set by the passed HTTP response. The reference URI will
be used to set the cookie's domain and path, if they are not defined in the Set-Cookie headers.

.. _zend.http.cookies.cookiejar.adding_cookies:

Adding Cookies to a Zend\Http\CookieJar object
----------------------------------------------

Usually, the Zend\Http\Client object you attached your CookieJar object to will automatically add cookies set by
HTTP responses to your jar. If you wish to manually add cookies to your jar, this can be done by using two methods:


   - *Zend\Http\CookieJar->addCookie($cookie[, $ref_uri])*: Add a single cookie to the jar. $cookie can be either a
     Zend\Http\Cookie object or a string, which will be converted automatically into a Cookie object. If a string
     is provided, you should also provide $ref_uri - which is a reference URI either as a string or Zend\Uri\Http
     object, to use as the cookie's default domain and path.

   - *Zend\Http\CookieJar->addCookiesFromResponse($response, $ref_uri)*: Add all cookies set in a single HTTP
     response to the jar. $response is expected to be a Zend\Http\Response object with Set-Cookie headers. $ref_uri
     is the request URI, either as a string or a Zend\Uri\Http object, according to which the cookies' default
     domain and path will be set.



.. _zend.http.cookies.cookiejar.getting_cookies:

Retrieving Cookies From a Zend\Http\CookieJar object
----------------------------------------------------

Just like with adding cookies, there is usually no need to manually fetch cookies from a CookieJar object. Your
Zend\Http\Client object will automatically fetch the cookies required for an HTTP request for you. However, you can
still use 3 provided methods to fetch cookies from the jar object: *getCookie()*, *getAllCookies()*, and
*getMatchingCookies()*.

It is important to note that each one of these methods takes a special parameter, which sets the return type of the
method. This parameter can have 3 values:

   - *Zend\Http\CookieJar::COOKIE_OBJECT*: Return a Zend\Http\Cookie object. If the method returns more than one
     cookie, an array of objects will be returned.

   - *Zend\Http\CookieJar::COOKIE_STRING_ARRAY*: Return cookies as strings, in a "foo=bar" format, suitable for
     sending in a HTTP request "Cookie" header. If more than one cookie is returned, an array of strings is
     returned.

   - *Zend\Http\CookieJar::COOKIE_STRING_CONCAT*: Similar to COOKIE_STRING_ARRAY, but if more than one cookie is
     returned, this method will concatenate all cookies into a single, long string separated by semicolons (;), and
     return it. This is especially useful if you want to directly send all matching cookies in a single HTTP
     request "Cookie" header.



The structure of the different cookie-fetching methods is described below:

   - *Zend\Http\CookieJar->getCookie($uri, $cookie_name[, $ret_as])*: Get a single cookie from the jar, according
     to it's URI (domain and path) and name. $uri is either a string or a Zend\Uri\Http object representing the
     URI. $cookie_name is a string identifying the cookie name. $ret_as specifies the return type as described
     above. $ret_type is optional, and defaults to COOKIE_OBJECT.

   - *Zend\Http\CookieJar->getAllCookies($ret_as)*: Get all cookies from the jar. $ret_as specifies the return type
     as described above. If not specified, $ret_type defaults to COOKIE_OBJECT.

   - *Zend\Http\CookieJar->getMatchingCookies($uri[, $matchSessionCookies[, $ret_as[, $now]]])*: Get all cookies
     from the jar that match a specified scenario, that is a URI and expiration time.

        - *$uri* is either a Zend\Uri\Http object or a string specifying the connection type (secure or
          non-secure), domain and path to match against.

        - *$matchSessionCookies* is a boolean telling whether to match session cookies or not. Session cookies are
          cookies that have no specified expiration time. Defaults to true.

        - *$ret_as* specifies the return type as described above. If not specified, defaults to COOKIE_OBJECT.

        - *$now* is an integer representing the UNIX time stamp to consider as "now" - that is any cookies who are
          set to expire before this time will not be matched. If not specified, defaults to the current time.

     You can read more about cookie matching here: :ref:` <zend.http.cookies.cookie.matching>`.




