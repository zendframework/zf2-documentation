.. _zendgdata.calendar:

Using Google Calendar
=====================

You can use the ``ZendGData\Calendar`` class to view, create, update, and delete events in the online Google
Calendar service.

See http://code.google.com/apis/calendar/overview.html for more information about the Google Calendar *API*.

.. _zendgdata.calendar.connecting:

Connecting To The Calendar Service
----------------------------------

The Google Calendar *API*, like all GData *API*\ s, is based off of the Atom Publishing Protocol (APP), an *XML*
based format for managing web-based resources. Traffic between a client and the Google Calendar servers occurs over
*HTTP* and allows for both authenticated and unauthenticated connections.

Before any transactions can occur, this connection needs to be made. Creating a connection to the calendar servers
involves two steps: creating an *HTTP* client and binding a ``ZendGData\Calendar`` service instance to that
client.

.. _zendgdata.calendar.connecting.authentication:

Authentication
^^^^^^^^^^^^^^

The Google Calendar *API* allows access to both public and private calendar feeds. Public feeds do not require
authentication, but are read-only and offer reduced functionality. Private feeds offers the most complete
functionality but requires an authenticated connection to the calendar servers. There are three authentication
schemes that are supported by Google Calendar:

- **ClientAuth** provides direct username/password authentication to the calendar servers. Since this scheme
  requires that users provide your application with their password, this authentication is only recommended when
  other authentication schemes are insufficient.

- **AuthSub** allows authentication to the calendar servers via a Google proxy server. This provides the same level
  of convenience as ClientAuth but without the security risk, making this an ideal choice for web-based
  applications.

- **MagicCookie** allows authentication based on a semi-random *URL* available from within the Google Calendar
  interface. This is the simplest authentication scheme to implement, but requires that users manually retrieve
  their secure *URL* before they can authenticate, doesn't provide access to calendar lists, and is limited to
  read-only access.

The ``ZendGData`` library provides support for all three authentication schemes. The rest of this chapter will
assume that you are familiar the authentication schemes available and how to create an appropriate authenticated
connection. For more information, please see section the :ref:`Authentication section
<zendgdata.introduction.authentication>` of this manual or the `Authentication Overview in the Google Data API
Developer's Guide`_.

.. _zendgdata.calendar.connecting.service:

Creating A Service Instance
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to interact with Google Calendar, this library provides the ``ZendGData\Calendar`` service class. This
class provides a common interface to the Google Data and Atom Publishing Protocol models and assists in marshaling
requests to and from the calendar servers.

Once deciding on an authentication scheme, the next step is to create an instance of ``ZendGData\Calendar``. The
class constructor takes an instance of ``Zend\Http\Client`` as a single argument. This provides an interface for
AuthSub and ClientAuth authentication, as both of these require creation of a special authenticated *HTTP* client.
If no arguments are provided, an unauthenticated instance of ``Zend\Http\Client`` will be automatically created.

The example below shows how to create a Calendar service class using ClientAuth authentication:

.. code-block:: php
   :linenos:

   // Parameters for ClientAuth authentication
   $service = ZendGData\Calendar::AUTH_SERVICE_NAME;
   $user = "sample.user@gmail.com";
   $pass = "pa$$w0rd";

   // Create an authenticated HTTP client
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);

   // Create an instance of the Calendar service
   $service = new ZendGData\Calendar($client);

A Calendar service using AuthSub can be created in a similar, though slightly more lengthy fashion:

.. code-block:: php
   :linenos:

   /*
    * Retrieve the current URL so that the AuthSub server knows where to
    * redirect the user after authentication is complete.
    */
   function getCurrentUrl()
   {
       global $_SERVER;

       // Filter php_self to avoid a security vulnerability.
       $php_request_uri =
           htmlentities(substr($_SERVER['REQUEST_URI'],
                               0,
                               strcspn($_SERVER['REQUEST_URI'], "\n\r")),
                               ENT_QUOTES);

       if (isset($_SERVER['HTTPS']) &&
           strtolower($_SERVER['HTTPS']) == 'on') {
           $protocol = 'https://';
       } else {
           $protocol = 'http://';
       }
       $host = $_SERVER['HTTP_HOST'];
       if ($_SERVER['HTTP_PORT'] != '' &&
           (($protocol == 'http://' && $_SERVER['HTTP_PORT'] != '80') ||
           ($protocol == 'https://' && $_SERVER['HTTP_PORT'] != '443'))) {
           $port = ':' . $_SERVER['HTTP_PORT'];
       } else {
           $port = '';
       }
       return $protocol . $host . $port . $php_request_uri;
   }

   /**
    * Obtain an AuthSub authenticated HTTP client, redirecting the user
    * to the AuthSub server to login if necessary.
    */
   function getAuthSubHttpClient()
   {
       global $_SESSION, $_GET;

       // if there is no AuthSub session or one-time token waiting for us,
       // redirect the user to the AuthSub server to get one.
       if (!isset($_SESSION['sessionToken']) && !isset($_GET['token'])) {
           // Parameters to give to AuthSub server
           $next = getCurrentUrl();
           $scope = "http://www.google.com/calendar/feeds/";
           $secure = false;
           $session = true;

           // Redirect the user to the AuthSub server to sign in

           $authSubUrl = ZendGData\AuthSub::getAuthSubTokenUri($next,
                                                                $scope,
                                                                $secure,
                                                                $session);
            header("HTTP/1.0 307 Temporary redirect");

            header("Location: " . $authSubUrl);

            exit();
       }

       // Convert an AuthSub one-time token into a session token if needed
       if (!isset($_SESSION['sessionToken']) && isset($_GET['token'])) {
           $_SESSION['sessionToken'] =
               ZendGData\AuthSub::getAuthSubSessionToken($_GET['token']);
       }

       // At this point we are authenticated via AuthSub and can obtain an
       // authenticated HTTP client instance

       // Create an authenticated HTTP client
       $client = ZendGData\AuthSub::getHttpClient($_SESSION['sessionToken']);
       return $client;
   }

   // -> Script execution begins here <-

   // Make sure that the user has a valid session, so we can record the
   // AuthSub session token once it is available.
   session_start();

   // Create an instance of the Calendar service, redirecting the user
   // to the AuthSub server if necessary.
   $service = new ZendGData\Calendar(getAuthSubHttpClient());

Finally, an unauthenticated server can be created for use with either public feeds or MagicCookie authentication:

.. code-block:: php
   :linenos:

   // Create an instance of the Calendar service using an unauthenticated
   // HTTP client

   $service = new ZendGData\Calendar();

Note that MagicCookie authentication is not supplied with the *HTTP* connection, but is instead specified along
with the desired visibility when submitting queries. See the section on retrieving events below for an example.

.. _zendgdata.calendar_retrieval:

Retrieving A Calendar List
--------------------------

The calendar service supports retrieving a list of calendars for the authenticated user. This is the same list of
calendars which are displayed in the Google Calendar UI, except those marked as "**hidden**" are also available.

The calendar list is always private and must be accessed over an authenticated connection. It is not possible to
retrieve another user's calendar list and it cannot be accessed using MagicCookie authentication. Attempting to
access a calendar list without holding appropriate credentials will fail and result in a 401 (Authentication
Required) status code.

.. code-block:: php
   :linenos:

   $service = ZendGData\Calendar::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Calendar($client);

   try {
       $listFeed= $service->getCalendarListFeed();
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

Calling ``getCalendarListFeed()`` creates a new instance of ``ZendGData\Calendar\ListFeed`` containing each
available calendar as an instance of ``ZendGData\Calendar\ListEntry``. After retrieving the feed, you can use the
iterator and accessors contained within the feed to inspect the enclosed calendars.

.. code-block:: php
   :linenos:

   echo "<h1>Calendar List Feed</h1>";
   echo "<ul>";
   foreach ($listFeed as $calendar) {
       echo "<li>" . $calendar->title .
            " (Event Feed: " . $calendar->id . ")</li>";
   }
   echo "</ul>";

.. _zendgdata.event_retrieval:

Retrieving Events
-----------------

Like the list of calendars, events are also retrieved using the ``ZendGData\Calendar`` service class. The event
list returned is of type ``ZendGData\Calendar\EventFeed`` and contains each event as an instance of
``ZendGData\Calendar\EventEntry``. As before, the iterator and accessors contained within the event feed instance
allow inspection of individual events.

.. _zendgdata.event_retrieval.queries:

Queries
^^^^^^^

When retrieving events using the Calendar *API*, specially constructed query *URL*\ s are used to describe what
events should be returned. The ``ZendGData\Calendar\EventQuery`` class simplifies this task by automatically
constructing a query *URL* based on provided parameters. A full list of these parameters is available at the
`Queries section of the Google Data APIs Protocol Reference`_. However, there are three parameters that are worth
special attention:

- **User** is used to specify the user whose calendar is being searched for, and is specified as an email address.
  If no user is provided, "default" will be used instead to indicate the currently authenticated user (if
  authenticated).

- **Visibility** specifies whether a users public or private calendar should be searched. If using an
  unauthenticated session and no MagicCookie is available, only the public feed will be available.

- **Projection** specifies how much data should be returned by the server and in what format. In most cases you
  will want to use the "full" projection. Also available is the "basic" projection, which places most meta-data
  into each event's content field as human readable text, and the "composite" projection which includes complete
  text for any comments alongside each event. The "composite" view is often much larger than the "full" view.

.. _zendgdata.event_retrieval.start_time:

Retrieving Events In Order Of Start Time
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The example below illustrates the use of the ``ZendGData\Query`` class and specifies the private visibility feed,
which requires that an authenticated connection is available to the calendar servers. If a MagicCookie is being
used for authentication, the visibility should be instead set to "**private-magicCookieValue**", where
magicCookieValue is the random string obtained when viewing the private *XML* address in the Google Calendar UI.
Events are requested chronologically by start time and only events occurring in the future are returned.

.. code-block:: php
   :linenos:

   $query = $service->newEventQuery();
   $query->setUser('default');
   // Set to $query->setVisibility('private-magicCookieValue') if using
   // MagicCookie auth
   $query->setVisibility('private');
   $query->setProjection('full');
   $query->setOrderby('starttime');
   $query->setFutureevents('true');

   // Retrieve the event list from the calendar server
   try {
       $eventFeed = $service->getCalendarEventFeed($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

   // Iterate through the list of events, outputting them as an HTML list
   echo "<ul>";
   foreach ($eventFeed as $event) {
       echo "<li>" . $event->title . " (Event ID: " . $event->id . ")</li>";
   }
   echo "</ul>";

Additional properties such as ID, author, when, event status, visibility, web content, and content, among others
are available within ``ZendGData\Calendar\EventEntry``. Refer to the `Zend Framework API Documentation`_ and the
`Calendar Protocol Reference`_ for a complete list.

.. _zendgdata.event_retrieval.date_range:

Retrieving Events In A Specified Date Range
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To print out all events within a certain range, for example from December 1, 2006 through December 15, 2007, add
the following two lines to the previous sample. Take care to remove "``$query->setFutureevents('true')``", since
``futureevents`` will override ``startMin`` and ``startMax``.

.. code-block:: php
   :linenos:

   $query->setStartMin('2006-12-01');
   $query->setStartMax('2006-12-16');

Note that ``startMin`` is inclusive whereas ``startMax`` is exclusive. As a result, only events through 2006-12-15
23:59:59 will be returned.

.. _zendgdata.event_retrieval.fulltext:

Retrieving Events By Fulltext Query
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To print out all events which contain a specific word, for example "dogfood", use the ``setQuery()`` method when
creating the query.

.. code-block:: php
   :linenos:

   $query->setQuery("dogfood");

.. _zendgdata.event_retrieval.individual:

Retrieving Individual Events
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Individual events can be retrieved by specifying their event ID as part of the query. Instead of calling
``getCalendarEventFeed()``, ``getCalendarEventEntry()`` should be called instead.

.. code-block:: php
   :linenos:

   $query = $service->newEventQuery();
   $query->setUser('default');
   $query->setVisibility('private');
   $query->setProjection('full');
   $query->setEvent($eventId);

   try {
       $event = $service->getCalendarEventEntry($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

In a similar fashion, if the event *URL* is known, it can be passed directly into ``getCalendarEntry()`` to
retrieve a specific event. In this case, no query object is required since the event *URL* contains all the
necessary information to retrieve the event.

.. code-block:: php
   :linenos:

   $eventURL = "http://www.google.com/calendar/feeds/default/private"
             . "/full/g829on5sq4ag12se91d10uumko";

   try {
       $event = $service->getCalendarEventEntry($eventURL);
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zendgdata.calendar.creating_events:

Creating Events
---------------

.. _zendgdata.calendar.creating_events.single:

Creating Single-Occurrence Events
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Events are added to a calendar by creating an instance of ``ZendGData\EventEntry`` and populating it with the
appropriate data. The calendar service instance (``ZendGData\Calendar``) is then used to used to transparently
covert the event into *XML* and POST it to the calendar server. Creating events requires either an AuthSub or
ClientAuth authenticated connection to the calendar server.

At a minimum, the following attributes should be set:

- **Title** provides the headline that will appear above the event within the Google Calendar UI.

- **When** indicates the duration of the event and, optionally, any reminders that are associated with it. See the
  next section for more information on this attribute.

Other useful attributes that may optionally set include:

- **Author** provides information about the user who created the event.

- **Content** provides additional information about the event which appears when the event details are requested
  from within Google Calendar.

- **EventStatus** indicates whether the event is confirmed, tentative, or canceled.

- **Hidden** removes the event from the Google Calendar UI.

- **Transparency** indicates whether the event should be consume time on the user's free/busy list.

- **WebContent** allows links to external content to be provided within an event.

- **Where** indicates the location of the event.

- **Visibility** allows the event to be hidden from the public event lists.

For a complete list of event attributes, refer to the `Zend Framework API Documentation`_ and the `Calendar
Protocol Reference`_. Attributes that can contain multiple values, such as where, are implemented as arrays and
need to be created accordingly. Be aware that all of these attributes require objects as parameters. Trying instead
to populate them using strings or primitives will result in errors during conversion to *XML*.

Once the event has been populated, it can be uploaded to the calendar server by passing it as an argument to the
calendar service's ``insertEvent()`` function.

.. code-block:: php
   :linenos:

   // Create a new entry using the calendar service's magic factory method
   $event= $service->newEventEntry();

   // Populate the event with the desired information
   // Note that each attribute is crated as an instance of a matching class
   $event->title = $service->newTitle("My Event");
   $event->where = array($service->newWhere("Mountain View, California"));
   $event->content =
       $service->newContent(" This is my awesome event. RSVP required.");

   // Set the date using RFC 3339 format.
   $startDate = "2008-01-20";
   $startTime = "14:00";
   $endDate = "2008-01-20";
   $endTime = "16:00";
   $tzOffset = "-08";

   $when = $service->newWhen();
   $when->startTime = "{$startDate}T{$startTime}:00.000{$tzOffset}:00";
   $when->endTime = "{$endDate}T{$endTime}:00.000{$tzOffset}:00";
   $event->when = array($when);

   // Upload the event to the calendar server
   // A copy of the event as it is recorded on the server is returned
   $newEvent = $service->insertEvent($event);

.. _zendgdata.calendar.creating_events.schedulers_reminders:

Event Schedules and Reminders
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An event's starting time and duration are determined by the value of its ``when`` property, which contains the
properties ``startTime``, ``endTime``, and ``valueString``. **StartTime** and **EndTime** control the duration of
the event, while the ``valueString`` property is currently unused.

All-day events can be scheduled by specifying only the date omitting the time when setting ``startTime`` and
``endTime``. Likewise, zero-duration events can be specified by omitting the ``endTime``. In all cases, date and
time values should be provided in `RFC3339`_ format.

.. code-block:: php
   :linenos:

   // Schedule the event to occur on December 05, 2007 at 2 PM PST (UTC-8)
   // with a duration of one hour.
   $when = $service->newWhen();
   $when->startTime = "2007-12-05T14:00:00-08:00";
   $when->endTime="2007-12-05T15:00:00:00-08:00";

   // Apply the when property to an event
   $event->when = array($when);

The ``when`` attribute also controls when reminders are sent to a user. Reminders are stored in an array and each
event may have up to find reminders associated with it.

For a **reminder** to be valid, it needs to have two attributes set: ``method`` and a time. **Method** can accept
one of the following strings: "alert", "email", or "sms". The time should be entered as an integer and can be set
with either the property ``minutes``, ``hours``, ``days``, or ``absoluteTime``. However, a valid request may only
have one of these attributes set. If a mixed time is desired, convert to the most precise unit available. For
example, 1 hour and 30 minutes should be entered as 90 minutes.

.. code-block:: php
   :linenos:

   // Create a new reminder object. It should be set to send an email
   // to the user 10 minutes beforehand.
   $reminder = $service->newReminder();
   $reminder->method = "email";
   $reminder->minutes = "10";

   // Apply the reminder to an existing event's when property
   $when = $event->when[0];
   $when->reminders = array($reminder);

.. _zendgdata.calendar.creating_events.recurring:

Creating Recurring Events
^^^^^^^^^^^^^^^^^^^^^^^^^

Recurring events are created the same way as single-occurrence events, except a recurrence attribute should be
provided instead of a where attribute. The recurrence attribute should hold a string describing the event's
recurrence pattern using properties defined in the iCalendar standard (`RFC 2445`_).

Exceptions to the recurrence pattern will usually be specified by a distinct ``recurrenceException`` attribute.
However, the iCalendar standard provides a secondary format for defining recurrences, and the possibility that
either may be used must be accounted for.

Due to the complexity of parsing recurrence patterns, further information on this them is outside the scope of this
document. However, more information can be found in the `Common Elements section of the Google Data APIs Developer
Guide`_, as well as in *RFC* 2445.

.. code-block:: php
   :linenos:

    // Create a new entry using the calendar service's magic factory method
   $event= $service->newEventEntry();

   // Populate the event with the desired information
   // Note that each attribute is crated as an instance of a matching class
   $event->title = $service->newTitle("My Recurring Event");
   $event->where = array($service->newWhere("Palo Alto, California"));
   $event->content =
       $service->newContent(' This is my other awesome event, ' .
                            ' occurring all-day every Tuesday from ' .
                            '2007-05-01 until 207-09-04. No RSVP required.');

   // Set the duration and frequency by specifying a recurrence pattern.

   $recurrence = "DTSTART;VALUE=DATE:20070501\r\n" .
           "DTEND;VALUE=DATE:20070502\r\n" .
           "RRULE:FREQ=WEEKLY;BYDAY=Tu;UNTIL=20070904\r\n";

   $event->recurrence = $service->newRecurrence($recurrence);

   // Upload the event to the calendar server
   // A copy of the event as it is recorded on the server is returned
   $newEvent = $service->insertEvent($event);

.. _zendgdata.calendar.creating_events.quickadd:

Using QuickAdd
^^^^^^^^^^^^^^

QuickAdd is a feature which allows events to be created using free-form text entry. For example, the string "Dinner
at Joe's Diner on Thursday" would create an event with the title "Dinner", location "Joe's Diner", and date
"Thursday". To take advantage of QuickAdd, create a new ``QuickAdd`` property set to ``TRUE`` and store the
freeform text as a ``content`` property.

.. code-block:: php
   :linenos:

   // Create a new entry using the calendar service's magic factory method
   $event= $service->newEventEntry();

   // Populate the event with the desired information
   $event->content= $service->newContent("Dinner at Joe's Diner on Thursday");
   $event->quickAdd = $service->newQuickAdd("true");

   // Upload the event to the calendar server
   // A copy of the event as it is recorded on the server is returned
   $newEvent = $service->insertEvent($event);

.. _zendgdata.calendar.modifying_events:

Modifying Events
----------------

Once an instance of an event has been obtained, the event's attributes can be locally modified in the same way as
when creating an event. Once all modifications are complete, calling the event's ``save()`` method will upload the
changes to the calendar server and return a copy of the event as it was created on the server.

In the event another user has modified the event since the local copy was retrieved, ``save()`` will fail and the
server will return a 409 (Conflict) status code. To resolve this a fresh copy of the event must be retrieved from
the server before attempting to resubmit any modifications.

.. code-block:: php
   :linenos:

   // Get the first event in the user's event list
   $event = $eventFeed[0];

   // Change the title to a new value
   $event->title = $service->newTitle("Woof!");

   // Upload the changes to the server
   try {
       $event->save();
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zendgdata.calendar.deleting_events:

Deleting Events
---------------

Calendar events can be deleted either by calling the calendar service's ``delete()`` method and providing the edit
*URL* of an event or by calling an existing event's own ``delete()`` method.

In either case, the deleted event will still show up on a user's private event feed if an ``updateMin`` query
parameter is provided. Deleted events can be distinguished from regular events because they will have their
``eventStatus`` property set to "http://schemas.google.com/g/2005#event.canceled".

.. code-block:: php
   :linenos:

   // Option 1: Events can be deleted directly
   $event->delete();

.. code-block:: php
   :linenos:

   // Option 2: Events can be deleted supplying the edit URL of the event
   // to the calendar service, if known
   $service->delete($event->getEditLink()->href);

.. _zendgdata.calendar.comments:

Accessing Event Comments
------------------------

When using the full event view, comments are not directly stored within an entry. Instead, each event contains a
*URL* to its associated comment feed which must be manually requested.

Working with comments is fundamentally similar to working with events, with the only significant difference being
that a different feed and event class should be used and that the additional meta-data for events such as where and
when does not exist for comments. Specifically, the comment's author is stored in the ``author`` property, and the
comment text is stored in the ``content`` property.

.. code-block:: php
   :linenos:

   // Extract the comment URL from the first event in a user's feed list
   $event = $eventFeed[0];
   $commentUrl = $event->comments->feedLink->url;

   // Retrieve the comment list for the event
   try {
   $commentFeed = $service->getFeed($commentUrl);
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

   // Output each comment as an HTML list
   echo "<ul>";
   foreach ($commentFeed as $comment) {
       echo "<li><em>Comment By: " . $comment->author->name "</em><br/>" .
            $comment->content . "</li>";
   }
   echo "</ul>";



.. _`Authentication Overview in the Google Data API Developer's Guide`: http://code.google.com/apis/gdata/auth.html
.. _`Queries section of the Google Data APIs Protocol Reference`: http://code.google.com/apis/gdata/reference.html#Queries
.. _`Zend Framework API Documentation`: http://framework.zend.com/apidoc/core/
.. _`Calendar Protocol Reference`: http://code.google.com/apis/gdata/reference.html
.. _`RFC3339`: http://www.ietf.org/rfc/rfc3339.txt
.. _`RFC 2445`: http://www.ietf.org/rfc/rfc2445.txt
.. _`Common Elements section of the Google Data APIs Developer Guide`: http://code.google.com/apis/gdata/elements.html#gdRecurrence
