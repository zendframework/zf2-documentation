.. EN-Revision: none
.. _zend.service.twitter:

Zend\Service\Twitter
====================

.. _zend.service.twitter.introduction:

Introduction
------------

``Zend\Service\Twitter`` fournit un client pour `l'APIREST de Twitter`_. ``Zend\Service\Twitter`` vous permet
d'interroger les fils (timeline) publics. En fournissant un nom d'utilisateur et un mot de passe pour Twitter, il
vous permettra également de récupérer et mettre à jour votre statut, de répondre à des amis, de leur envoyer
des messages directs, de marquer des tweets comme favoris et beaucoup d'autres choses.

``Zend\Service\Twitter`` implémente un service *REST*, et toutes ses méthodes retournes une instance de
``Zend\Rest\Client\Result``.

``Zend\Service\Twitter`` et subdivisé en sections, ainsi vous pouvez facilement identifier le type d'appel qui est
demandé.

- *account* s'assure que vos données de compte sont valides, vérifie votre taux limite pour l'*API* et termine la
  session courante pour l'utilisateur authentifié.

- *status* retourne les fils publics et ceux de l'utilisateur et montre, met à jour, détruit et retourne des
  réponses pour l'utilisateur authentifié.

- *user* récupère les amis et 'followers' de l'utilisateur authentifié et retourne de plus amples informations
  sur l'utilisateur passé en paramètre.

- *directMessage* récupère les messages directs reçus par l'utilisateur authentifié, supprime les messages
  directs et permet également d'envoyer des messages directs.

- *friendship* crée et supprime des amitiés pour l'utilisateur authentifié.

- *favorite* liste, crée et détruit des tweets favoris.

- *block* bloque et débloque des utilisateurs qui vous suivent.

.. _zend.service.twitter.authentication:

Authentification
----------------

A l'exception de la récupération du fil public, ``Zend\Service\Twitter`` nécessite une authentification pour
fonctionner. Twitter utilise l'`Authentification HTTP basique`_. Vous pouvez lui passer votre nom d'utilisateur ou
votre email utilisé pour l'enregistrement de votre compte ainsi que votre mot de passe pour vous connecter à
Twitter.

.. _zend.service.twitter.authentication.example:

.. rubric:: Créer la classe Twitter

L'exemple de code suivant décrit comment créer le service Twitter, lui passer vos nom d'utilisateur et mot de
passe et vérifier qu'ils sont corrects.

.. code-block:: php
   :linenos:

   $twitter = new Zend\Service\Twitter('myusername', 'mysecretpassword');
   // vérifie vos données de connexion avec Twitter
   $response = $twitter->account->verifyCredentials();

Vous pouvez également passer un tableau qui contient le nom d'utilisateur et le mot de passe en tant que premier
argument

.. code-block:: php
   :linenos:

   $userInfo   = array('username' => 'foo', 'password' => 'bar');
   $twitter    = new Zend\Service\Twitter($userInfo);
   // vérifie vos données de connexion avec Twitter
   $response = $twitter->account->verifyCredentials();

.. _zend.service.twitter.account:

Account Methods
---------------

- ``verifyCredentials()`` tests if supplied user credentials are valid with minimal overhead.

  .. _zend.service.twitter.account.verifycredentails:

  .. rubric:: Verifying credentials

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->account->verifyCredentials();

- ``endSession()`` signs users out of client-facing applications.

  .. _zend.service.twitter.account.endsession:

  .. rubric:: Sessions ending

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->account->endSession();

- ``rateLimitStatus()`` returns the remaining number of *API* requests available to the authenticating user before
  the *API* limit is reached for the current hour.

  .. _zend.service.twitter.account.ratelimitstatus:

  .. rubric:: Rating limit status

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->account->rateLimitStatus();

.. _zend.service.twitter.status:

Status Methods
--------------

- ``publicTimeline()`` returns the 20 most recent statuses from non-protected users with a custom user icon. The
  public timeline is cached by Twitter for 60 seconds.

  .. _zend.service.twitter.status.publictimeline:

  .. rubric:: Retrieving public timeline

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->status->publicTimeline();

- ``friendsTimeline()`` returns the 20 most recent statuses posted by the authenticating user and that user's
  friends.

  .. _zend.service.twitter.status.friendstimeline:

  .. rubric:: Retrieving friends timeline

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->status->friendsTimeline();

  The ``friendsTimeline()`` method accepts an array of optional parameters to modify the query.

  - *since* narrows the returned results to just those statuses created after the specified date/time (up to 24
    hours old).

  - *page* specifies which page you want to return.

- ``userTimeline()`` returns the 20 most recent statuses posted from the authenticating user.

  .. _zend.service.twitter.status.usertimeline:

  .. rubric:: Retrieving user timeline

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->status->userTimeline();

  The ``userTimeline()`` method accepts an array of optional parameters to modify the query.

  - *id* specifies the ID or screen name of the user for whom to return the friends_timeline.

  - *since* narrows the returned results to just those statuses created after the specified date/time (up to 24
    hours old).

  - *page* specifies which page you want to return.

  - *count* specifies the number of statuses to retrieve. May not be greater than 200.

- ``show()`` returns a single status, specified by the *id* parameter below. The status' author will be returned
  inline.

  .. _zend.service.twitter.status.show:

  .. rubric:: Showing user status

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->status->show(1234);

- ``update()`` updates the authenticating user's status. This method requires that you pass in the status update
  that you want to post to Twitter.

  .. _zend.service.twitter.status.update:

  .. rubric:: Updating user status

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->status->update('My Great Tweet');

  The ``update()`` method accepts a second additional parameter.

  - *in_reply_to_status_id* specifies the ID of an existing status that the status to be posted is in reply to.

- ``replies()`` returns the 20 most recent @replies (status updates prefixed with @username) for the authenticating
  user.

  .. _zend.service.twitter.status.replies:

  .. rubric:: Showing user replies

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->status->replies();

  The ``replies()`` method accepts an array of optional parameters to modify the query.

  - *since* narrows the returned results to just those statuses created after the specified date/time (up to 24
    hours old).

  - *page* specifies which page you want to return.

  - *since_id* returns only statuses with an ID greater than (that is, more recent than) the specified ID.

- ``destroy()`` destroys the status specified by the required *id* parameter.

  .. _zend.service.twitter.status.destroy:

  .. rubric:: Deleting user status

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->status->destroy(12345);

.. _zend.service.twitter.user:

User Methods
------------

- ``friends()``\ r eturns up to 100 of the authenticating user's friends who have most recently updated, each with
  current status inline.

  .. _zend.service.twitter.user.friends:

  .. rubric:: Retrieving user friends

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->user->friends();

  The ``friends()`` method accepts an array of optional parameters to modify the query.

  - *id* specifies the ID or screen name of the user for whom to return a list of friends.

  - *since* narrows the returned results to just those statuses created after the specified date/time (up to 24
    hours old).

  - *page* specifies which page you want to return.

- ``followers()`` returns the authenticating user's followers, each with current status inline.

  .. _zend.service.twitter.user.followers:

  .. rubric:: Retrieving user followers

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->user->followers();

  The ``followers()`` method accepts an array of optional parameters to modify the query.

  - *id* specifies the ID or screen name of the user for whom to return a list of followers.

  - *page* specifies which page you want to return.

- ``show()`` returns extended information of a given user, specified by ID or screen name as per the required *id*
  parameter below.

  .. _zend.service.twitter.user.show:

  .. rubric:: Showing user informations

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->user->show('myfriend');

.. _zend.service.twitter.directmessage:

Direct Message Methods
----------------------

- ``messages()`` returns a list of the 20 most recent direct messages sent to the authenticating user.

  .. _zend.service.twitter.directmessage.messages:

  .. rubric:: Retrieving recent direct messages received

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->directMessage->messages();

  The ``message()`` method accepts an array of optional parameters to modify the query.

  - *since_id* returns only direct messages with an ID greater than (that is, more recent than) the specified ID.

  - *since* narrows the returned results to just those statuses created after the specified date/time (up to 24
    hours old).

  - *page* specifies which page you want to return.

- ``sent()`` returns a list of the 20 most recent direct messages sent by the authenticating user.

  .. _zend.service.twitter.directmessage.sent:

  .. rubric:: Retrieving recent direct messages sent

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->directMessage->sent();

  The ``sent()`` method accepts an array of optional parameters to modify the query.

  - *since_id* returns only direct messages with an ID greater than (that is, more recent than) the specified ID.

  - *since* narrows the returned results to just those statuses created after the specified date/time (up to 24
    hours old).

  - *page* specifies which page you want to return.

- ``new()`` sends a new direct message to the specified user from the authenticating user. Requires both the user
  and text parameters below.

  .. _zend.service.twitter.directmessage.new:

  .. rubric:: Sending direct message

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->directMessage->new('myfriend', 'mymessage');

- ``destroy()`` destroys the direct message specified in the required *id* parameter. The authenticating user must
  be the recipient of the specified direct message.

  .. _zend.service.twitter.directmessage.destroy:

  .. rubric:: Deleting direct message

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->directMessage->destroy(123548);

.. _zend.service.twitter.friendship:

Friendship Methods
------------------

- ``create()`` befriends the user specified in the *id* parameter with the authenticating user.

  .. _zend.service.twitter.friendship.create:

  .. rubric:: Creating friend

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->friendship->create('mynewfriend');

- ``destroy()`` discontinues friendship with the user specified in the *id* parameter and the authenticating user.

  .. _zend.service.twitter.friendship.destroy:

  .. rubric:: Deleting friend

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->friendship->destroy('myoldfriend');

- ``exists()`` tests if a friendship exists between the user specified in the *id* parameter and the authenticating
  user.

  .. _zend.service.twitter.friendship.exists:

  .. rubric:: Checking friend existence

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->friendship->exists('myfriend');

.. _zend.service.twitter.favorite:

Favorite Methods
----------------

- ``favorites()`` returns the 20 most recent favorite statuses for the authenticating user or user specified by the
  *id* parameter.

  .. _zend.service.twitter.favorite.favorites:

  .. rubric:: Retrieving favorites

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->favorite->favorites();

  The ``favorites()`` method accepts an array of optional parameters to modify the query.

  - *id* specifies the ID or screen name of the user for whom to request a list of favorite statuses.

  - *page* specifies which page you want to return.

- ``create()`` favorites the status specified in the *id* parameter as the authenticating user.

  .. _zend.service.twitter.favorite.create:

  .. rubric:: Creating favorites

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->favorite->create(12351);

- ``destroy()`` un-favorites the status specified in the *id* parameter as the authenticating user.

  .. _zend.service.twitter.favorite.destroy:

  .. rubric:: Deleting favorites

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->favorite->destroy(12351);

.. _zend.service.twitter.block:

Block Methods
-------------

- ``exists()`` checks if the authenticating user is blocking a target user and can optionally return the blocked
  user's object if a block does exists.

  .. _zend.service.twitter.block.exists:

  .. rubric:: Checking if block exists

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     // returns true or false
     $response = $twitter->block->exists('blockeduser');
     // returns the blocked user's info if the user is blocked
     $response2 = $twitter->block->exists('blockeduser', true);

  The ``favorites()`` method accepts a second optional parameter.

  - *returnResult* specifies whether or not return the user object instead of just ``TRUE`` or ``FALSE``.

- ``create()`` blocks the user specified in the *id* parameter as the authenticating user and destroys a friendship
  to the blocked user if one exists. Returns the blocked user in the requested format when successful.

  .. _zend.service.twitter.block.create:

  .. rubric:: Blocking a user

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->block->create('usertoblock);

- ``destroy()`` un-blocks the user specified in the *id* parameter for the authenticating user. Returns the
  un-blocked user in the requested format when successful.

  .. _zend.service.twitter.block.destroy:

  .. rubric:: Removing a block

  .. code-block:: php
     :linenos:

     $twitter    = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     $response   = $twitter->block->destroy('blockeduser');

- ``blocking()`` returns an array of user objects that the authenticating user is blocking.

  .. _zend.service.twitter.block.blocking:

  .. rubric:: Who are you blocking

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter('myusername', 'mysecretpassword');
     // return the full user list from the first page
     $response = $twitter->block->blocking();
     // return an array of numeric user IDs from the second page
     $response2 = $twitter->block->blocking(2, true);

  The ``favorites()`` method accepts two optional parameters.

  - *page* specifies which page ou want to return. A single page contains 20 IDs.

  - *returnUserIds* specifies whether to return an array of numeric user IDs the authenticating user is blocking
    instead of an array of user objects.

.. include:: zend.service.twitter.search.rst


.. _`l'APIREST de Twitter`: http://apiwiki.twitter.com/Twitter-API-Documentation
.. _`Authentification HTTP basique`: http://en.wikipedia.org/wiki/Basic_authentication_scheme
