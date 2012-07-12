
Zend_Service_Twitter
====================

.. _zend.service.twitter.introduction:

Introduction
------------

``Zend_Service_Twitter`` provides a client for the `Twitter RESTAPI`_ . ``Zend_Service_Twitter`` allows you to query the public timeline. If you provide a username and OAuth details for Twitter, it will allow you to get and update your status, reply to friends, direct message friends, mark tweets as favorite, and much more.

``Zend_Service_Twitter`` implements a *REST* service, and all methods return an instance of ``Zend_Rest_Client_Result`` .

``Zend_Service_Twitter`` is broken up into subsections so you can easily identify which type of call is being requested.

    - account makes sure that your account credentials are valid, checks
    - your API rate limit, and ends the current session for the
    - authenticated user.
    - status retrieves the public and user timelines and
    - shows, updates, destroys, and retrieves replies for the authenticated user.
    - user retrieves friends and followers for the authenticated user
    - and returns extended information about a passed user.
    - directMessage retrieves the authenticated user's received direct
    - messages, deletes direct messages, and sends new direct messages.
    - friendship creates and removes friendships for the
    - authenticated user.
    - favorite lists, creates, and removes favorite tweets.
    - block blocks and unblocks users from following you.


.. _zend.service.twitter.authentication:

Authentication
--------------

With the exception of fetching the public timeline, ``Zend_Service_Twitter`` requires authentication as a valid user. This is achieved using the OAuth authentication protocol. OAuth is the only supported authentication mode for Twitter as of August 2010. The OAuth implementation used by ``Zend_Service_Twitter`` is ``Zend_Oauth`` .

.. _zend.service.twitter.authentication.example:

Creating the Twitter Class
--------------------------

``Zend_Service_Twitter`` must authorize itself, on behalf of a user, before use with the Twitter API (except for public timeline). This must be accomplished using OAuth since Twitter has disabled it's basic HTTP authentication as of August 2010.

There are two options to establishing authorization. The first is to implement the workflow of ``Zend_Oauth`` via ``Zend_Service_Twitter`` which proxies to an internal ``Zend_Oauth_Consumer`` object. Please refer to the ``Zend_Oauth`` documentation for a full example of this workflow - you can call all documented ``Zend_Oauth_Consumer`` methods on ``Zend_Service_Twitter`` including constructor options. You may also use ``Zend_Oauth`` directly and only pass the resulting access token into ``Zend_Service_Twitter`` . This is the normal workflow once you have established a reusable access token for a particular Twitter user. The resulting OAuth access token should be stored to a database for future use (otherwise you will need to authorize for every new instance of ``Zend_Service_Twitter`` ). Bear in mind that authorization via OAuth results in your user being redirected to Twitter to give their consent to the requested authorization (this is not repeated for stored access tokens). This will require additional work (i.e. redirecting users and hosting a callback URL) over the previous HTTP authentication mechanism where a user just needed to allow applications to store their username and password.

The following example demonstrates setting up ``Zend_Service_Twitter`` which is given an already established OAuth access token. Please refer to the ``Zend_Oauth`` documentation to understand the workflow involved. The access token is a serializable object, so you may store the serialized object to a database, and unserialize it at retrieval time before passing the objects into ``Zend_Service_Twitter`` . The ``Zend_Oauth`` documentation demonstrates the workflow and objects involved.

.. code-block:: php
    :linenos:
    
    /**
     * We assume $serializedToken is the serialized token retrieved from a database
     * or even $_SESSION (if following the simple Zend_Oauth documented example)
     */
    $token = unserialize($serializedToken);
    
    $twitter = new Zend_Service_Twitter(array(
        'username' => 'johndoe',
        'accessToken' => $token
    ));
    
    // verify user's credentials with Twitter
    $response = $twitter->account->verifyCredentials();
    

.. note::
    ****

    In order to authenticate with Twitter, ALL applications MUST be registered with Twitter in order to receive a Consumer Key and Consumer Secret to be used when authenticating with OAuth. This can not be reused across multiple applications - you must register each new application separately. Twitter access tokens have no expiry date, so storing them to a database is advised (they can, of course, be refreshed simply be repeating the OAuth authorization process). This can only be done while interacting with the user associated with that access token.

    The previous pre-OAuth version of ``Zend_Service_Twitter`` allowed passing in a username as the first parameter rather than within an array. This is no longer supported.

.. _zend.service.twitter.account:

Account Methods
---------------

    - verifyCredentials() tests if supplied user
    - credentials are valid with minimal overhead.
    - Verifying credentials
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->account->verifyCredentials();
    - endSession() signs users out of
    - client-facing applications.
    - Sessions ending
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->account->endSession();
    - rateLimitStatus() returns the remaining number of
    - API requests available to the authenticating user
    - before the API limit is reached for the current hour.
    - Rating limit status
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->account->rateLimitStatus();


.. _zend.service.twitter.status:

Status Methods
--------------

    - publicTimeline() returns the 20 most recent statuses
    - from non-protected users with a custom user icon. The public timeline is cached
    - by Twitter for 60 seconds.
    - Retrieving public timeline
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->status->publicTimeline();
    - friendsTimeline() returns the 20 most recent statuses
    - posted by the authenticating user and that user's friends.
    - Retrieving friends timeline
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->status->friendsTimeline();
    - The friendsTimeline() method accepts an array of
    - optional parameters to modify the query.
    - since narrows the returned results to just those statuses
    - created after the specified date/time (up to 24 hours old).
    - page specifies which page you want to return.
    - userTimeline() returns the 20 most recent statuses
    - posted from the authenticating user.
    - Retrieving user timeline
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->status->userTimeline();
    - The userTimeline() method accepts an array of optional
    - parameters to modify the query.
    - id specifies the ID or screen name of the user for whom to
    - return the friends_timeline.
    - since narrows the returned results to just those statuses
    - created after the specified date/time (up to 24 hours old).
    - page specifies which page you want to return.
    - count specifies the number of statuses to retrieve.
    - May not be greater than 200.
    - show() returns a single status, specified by the
    - id parameter below. The status' author will be returned inline.
    - Showing user status
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->status->show(1234);
    - update() updates the authenticating user's status.
    - This method requires that you pass in the status update that you want to post
    - to Twitter.
    - Updating user status
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->status->update('My Great Tweet');
    - The update() method accepts a second additional
    - parameter.
    - in_reply_to_status_id specifies the ID of an existing
    - status that the status to be posted is in reply to.
    - replies() returns the 20 most recent @replies (status
    - updates prefixed with @username) for the authenticating user.
    - Showing user replies
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->status->replies();
    - The replies() method accepts an array of optional
    - parameters to modify the query.
    - since narrows the returned results to just those statuses
    - created after the specified date/time (up to 24 hours old).
    - page specifies which page you want to return.
    - since_id returns only statuses with an ID greater than
    - (that is, more recent than) the specified ID.
    - destroy() destroys the status specified by the
    - required id parameter.
    - Deleting user status
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->status->destroy(12345);


.. _zend.service.twitter.user:

User Methods
------------

    - friends()r eturns up to 100 of the authenticating
    - user's friends who have most recently updated, each with current status inline.
    - Retrieving user friends
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->user->friends();
    - The friends() method accepts an array of optional
    - parameters to modify the query.
    - id specifies the ID or screen name of the user for whom to
    - return a list of friends.
    - since narrows the returned results to just those statuses
    - created after the specified date/time (up to 24 hours old).
    - page specifies which page you want to return.
    - followers() returns the authenticating user's
    - followers, each with current status inline.
    - Retrieving user followers
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->user->followers();
    - The followers() method accepts an array of optional
    - parameters to modify the query.
    - id specifies the ID or screen name of the user for whom to
    - return a list of followers.
    - page specifies which page you want to return.
    - show() returns extended information of a given user,
    - specified by ID or screen name as per the required id
    - parameter below.
    - Showing user informations
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->user->show('myfriend');


.. _zend.service.twitter.directmessage:

Direct Message Methods
----------------------

    - messages() returns a list of the 20 most recent direct
    - messages sent to the authenticating user.
    - Retrieving recent direct messages received
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->directMessage->messages();
    - The message() method accepts an array of optional
    - parameters to modify the query.
    - since_id returns only direct messages with an ID greater
    - than (that is, more recent than) the specified ID.
    - since narrows the returned results to just those statuses
    - created after the specified date/time (up to 24 hours old).
    - page specifies which page you want to return.
    - sent() returns a list of the 20 most recent direct
    - messages sent by the authenticating user.
    - Retrieving recent direct messages sent
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->directMessage->sent();
    - The sent() method accepts an array of optional
    - parameters to modify the query.
    - since_id returns only direct messages with an ID greater
    - than (that is, more recent than) the specified ID.
    - since narrows the returned results to just those statuses
    - created after the specified date/time (up to 24 hours old).
    - page specifies which page you want to return.
    - new() sends a new direct message to the specified user
    - from the authenticating user. Requires both the user and text parameters below.
    - Sending direct message
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->directMessage->new('myfriend', 'mymessage');
    - destroy() destroys the direct message specified in the
    - required id parameter. The authenticating user must be the
    - recipient of the specified direct message.
    - Deleting direct message
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->directMessage->destroy(123548);


.. _zend.service.twitter.friendship:

Friendship Methods
------------------

    - create() befriends the user specified in the
    - id parameter with the authenticating user.
    - Creating friend
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->friendship->create('mynewfriend');
    - destroy() discontinues friendship with the user
    - specified in the id parameter and the authenticating user.
    - Deleting friend
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->friendship->destroy('myoldfriend');
    - exists() tests if a friendship exists between the
    - user specified in the id parameter and the authenticating user.
    - Checking friend existence
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->friendship->exists('myfriend');


.. _zend.service.twitter.favorite:

Favorite Methods
----------------

    - favorites() returns the 20 most recent favorite
    - statuses for the authenticating user or user specified by the
    - id parameter.
    - Retrieving favorites
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->favorite->favorites();
    - The favorites() method accepts an array of optional
    - parameters to modify the query.
    - id specifies the ID or screen name of the user for whom to
    - request a list of favorite statuses.
    - page specifies which page you want to return.
    - create() favorites the status specified in the
    - id parameter as the authenticating user.
    - Creating favorites
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->favorite->create(12351);
    - destroy() un-favorites the status specified in the
    - id parameter as the authenticating user.
    - Deleting favorites
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->favorite->destroy(12351);


.. _zend.service.twitter.block:

Block Methods
-------------

    - exists() checks if the authenticating user is blocking
    - a target user and can optionally return the blocked user's object if a
    - block does exists.
    - Checking if block exists
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - // returns true or false
    - $response = $twitter->block->exists('blockeduser');
    - // returns the blocked user's info if the user is blocked
    - $response2 = $twitter->block->exists('blockeduser', true);
    - The favorites() method accepts a second
    - optional parameter.
    - returnResult specifies whether or not return the user
    - object instead of just TRUE or
    - FALSE.
    - create() blocks the user specified in the
    - id parameter as the authenticating user and destroys a friendship
    - to the blocked user if one exists. Returns the blocked user in the requested
    - format when successful.
    - Blocking a user
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->block->create('usertoblock);
    - destroy() un-blocks the user specified in the
    - id parameter for the authenticating user. Returns the un-blocked
    - user in the requested format when successful.
    - Removing a block
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - $response   = $twitter->block->destroy('blockeduser');
    - blocking() returns an array of user objects that the
    - authenticating user is blocking.
    - Who are you blocking
    - $twitter = new Zend_Service_Twitter(array(
    - 'username' => 'johndoe',
    - 'accessToken' => $token
    - ));
    - // return the full user list from the first page
    - $response = $twitter->block->blocking();
    - // return an array of numeric user IDs from the second page
    - $response2 = $twitter->block->blocking(2, true);
    - The favorites() method accepts two optional parameters.
    - page specifies which page ou want to return. A single page
    - contains 20 IDs.
    - returnUserIds specifies whether to return an array of
    - numeric user IDs the authenticating user is blocking instead of an
    - array of user objects.


.. include:: zend.service.twitter.search.rst

.. _`Twitter RESTAPI`: http://apiwiki.twitter.com/Twitter-API-Documentation
