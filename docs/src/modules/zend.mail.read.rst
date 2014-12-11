.. _zend.mail.read:

Reading Mail Messages
=====================

``Zend\Mail`` can read mail messages from several local or remote mail storages. All of them have the same basic
*API* to count and fetch messages and some of them implement additional interfaces for not so common features. For
a feature overview of the implemented storages, see the following table.

.. _zend.mail.read.table-1:

.. table:: Mail Read Feature Overview

   +---------------------+--------+--------+--------+--------+
   |Feature              |Mbox    |Maildir |Pop3    |IMAP    |
   +=====================+========+========+========+========+
   |Storage type         |local   |local   |remote  |remote  |
   +---------------------+--------+--------+--------+--------+
   |Fetch message        |Yes     |Yes     |Yes     |Yes     |
   +---------------------+--------+--------+--------+--------+
   |Fetch MIME-part      |emulated|emulated|emulated|emulated|
   +---------------------+--------+--------+--------+--------+
   |Folders              |Yes     |Yes     |No      |Yes     |
   +---------------------+--------+--------+--------+--------+
   |Create message/folder|No      |todo    |No      |todo    |
   +---------------------+--------+--------+--------+--------+
   |Flags                |No      |Yes     |No      |Yes     |
   +---------------------+--------+--------+--------+--------+
   |Quota                |No      |Yes     |No      |No      |
   +---------------------+--------+--------+--------+--------+

.. _zend.mail.read-example:

Simple example using Pop3
-------------------------

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Storage\Pop3(array('host'     => 'localhost',
                                            'user'     => 'test',
                                            'password' => 'test'));

   echo $mail->countMessages() . " messages found\n";
   foreach ($mail as $message) {
       echo "Mail from '{$message->from}': {$message->subject}\n";
   }

.. _zend.mail.read-open-local:

Opening a local storage
-----------------------

Mbox and Maildir are the two supported formats for local mail storages, both in their most simple formats.

If you want to read from a Mbox file you only need to give the filename to the constructor of
``Zend\Mail\Storage\Mbox``:

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Storage\Mbox(array('filename' =>
                                                '/home/test/mail/inbox'));

Maildir is very similar but needs a dirname:

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Storage\Maildir(array('dirname' =>
                                                   '/home/test/mail/'));

Both constructors throw a ``Zend\Mail\Exception`` if the storage can't be read.

.. _zend.mail.read-open-remote:

Opening a remote storage
------------------------

For remote storages the two most popular protocols are supported: Pop3 and Imap. Both need at least a host and a
user to connect and login. The default password is an empty string, the default port as given in the protocol
*RFC*.

.. code-block:: php
   :linenos:

   // connecting with Pop3
   $mail = new Zend\Mail\Storage\Pop3(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test'));

   // connecting with Imap
   $mail = new Zend\Mail\Storage\Imap(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test'));

   // example for a none standard port
   $mail = new Zend\Mail\Storage\Pop3(array('host'     => 'example.com',
                                            'port'     => 1120
                                            'user'     => 'test',
                                            'password' => 'test'));

For both storages *SSL* and TLS are supported. If you use *SSL* the default port changes as given in the *RFC*.

.. code-block:: php
   :linenos:

   // examples for Zend\Mail\Storage\Pop3, same works for Zend\Mail\Storage\Imap

   // use SSL on different port (default is 995 for Pop3 and 993 for Imap)
   $mail = new Zend\Mail\Storage\Pop3(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test',
                                            'ssl'      => 'SSL'));

   // use TLS
   $mail = new Zend\Mail\Storage\Pop3(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test',
                                            'ssl'      => 'TLS'));

Both constructors can throw ``Zend\Mail\Exception`` or ``Zend\Mail\Protocol\Exception`` (extends
``Zend\Mail\Exception``), depending on the type of error.

.. _zend.mail.read-fetching:

Fetching messages and simple methods
------------------------------------

Messages can be fetched after you've opened the storage . You need the message number, which is a counter starting
with 1 for the first message. To fetch the message, you use the method ``getMessage()``:

.. code-block:: php
   :linenos:

   $message = $mail->getMessage($messageNum);

Array access is also supported, but this access method won't supported any additional parameters that could be
added to ``getMessage()``. As long as you don't mind, and can live with the default values, you may use:

.. code-block:: php
   :linenos:

   $message = $mail[$messageNum];

For iterating over all messages the Iterator interface is implemented:

.. code-block:: php
   :linenos:

   foreach ($mail as $messageNum => $message) {
       // do stuff ...
   }

To count the messages in the storage, you can either use the method ``countMessages()`` or use array access:

.. code-block:: php
   :linenos:

   // method
   $maxMessage = $mail->countMessages();

   // array access
   $maxMessage = count($mail);

To remove a mail, you use the method ``removeMessage()`` or again array access:

.. code-block:: php
   :linenos:

   // method
   $mail->removeMessage($messageNum);

   // array access
   unset($mail[$messageNum]);

.. _zend.mail.read-message:

Working with messages
---------------------

After you fetch the messages with ``getMessage()`` you want to fetch headers, the content or single parts of a
multipart message. All headers can be accessed via properties or the method ``getHeader()`` if you want more
control or have unusual header names. The header names are lower-cased internally, thus the case of the header name
in the mail message doesn't matter. Also headers with a dash can be written in camel-case. If no header is found
for both notations an exception is thrown. To encounter this the method ``headerExists()`` can be used to check the
existence of a header.

.. code-block:: php
   :linenos:

   // get the message object
   $message = $mail->getMessage(1);

   // output subject of message
   echo $message->subject . "\n";

   // get content-type header
   $type = $message->contentType;

   // check if CC isset:
   if (isset($message->cc)) { // or $message->headerExists('cc');
       $cc = $message->cc;
   }

If you have multiple headers with the same name- i.e. the Received headers- you might want an array instead of a
string. In this case, use the ``getHeader()`` method.

.. code-block:: php
   :linenos:

   // get header as property - the result is always a string,
   // with new lines between the single occurrences in the message
   $received = $message->received;

   // the same via getHeader() method
   $received = $message->getHeader('received', 'string');

   // better an array with a single entry for every occurrences
   $received = $message->getHeader('received', 'array');
   foreach ($received as $line) {
       // do stuff
   }

   // if you don't define a format you'll get the internal representation
   // (string for single headers, array for multiple)
   $received = $message->getHeader('received');
   if (is_string($received)) {
       // only one received header found in message
   }

The method ``getHeaders()`` returns all headers as array with the lower-cased name as key and the value as and
array for multiple headers or as string for single headers.

.. code-block:: php
   :linenos:

   // dump all headers
   foreach ($message->getHeaders() as $name => $value) {
       if (is_string($value)) {
           echo "$name: $value\n";
           continue;
       }
       foreach ($value as $entry) {
           echo "$name: $entry\n";
       }
   }

If you don't have a multipart message, fetching the content is easily done via ``getContent()``. Unlike the
headers, the content is only fetched when needed (aka late-fetch).

.. code-block:: php
   :linenos:

   // output message content for HTML
   echo '<pre>';
   echo $message->getContent();
   echo '</pre>';

Checking for multipart messages is done with the method ``isMultipart()``. If you have multipart message you can
get an instance of ``Zend\Mail\Part`` with the method ``getPart()``. ``Zend\Mail\Part`` is the base class of
``Zend\Mail\Message``, so you have the same methods: ``getHeader()``, ``getHeaders()``, ``getContent()``,
``getPart()``, ``isMultipart()`` and the properties for headers.

.. code-block:: php
   :linenos:

   // get the first none multipart part
   $part = $message;
   while ($part->isMultipart()) {
       $part = $message->getPart(1);
   }
   echo 'Type of this part is ' . strtok($part->contentType, ';') . "\n";
   echo "Content:\n";
   echo $part->getContent();

``Zend\Mail\Part`` also implements ``RecursiveIterator``, which makes it easy to scan through all parts. And for
easy output, it also implements the magic method ``__toString()``, which returns the content.

.. code-block:: php
   :linenos:

   // output first text/plain part
   $foundPart = null;
   foreach (new RecursiveIteratorIterator($mail->getMessage(1)) as $part) {
       try {
           if (strtok($part->contentType, ';') == 'text/plain') {
               $foundPart = $part;
               break;
           }
       } catch (Zend\Mail\Exception $e) {
           // ignore
       }
   }
   if (!$foundPart) {
       echo 'no plain text part found';
   } else {
       echo "plain text part: \n" . $foundPart;
   }

.. _zend.mail.read-flags:

Checking for flags
------------------

Maildir and IMAP support storing flags. The class ``Zend\Mail\Storage`` has constants for all known maildir and
IMAP system flags, named ``Zend\Mail\Storage::FLAG_<flagname>``. To check for flags ``Zend\Mail\Message`` has a
method called ``hasFlag()``. With ``getFlags()`` you'll get all set flags.

.. code-block:: php
   :linenos:

   // find unread messages
   echo "Unread mails:\n";
   foreach ($mail as $message) {
       if ($message->hasFlag(Zend\Mail\Storage::FLAG_SEEN)) {
           continue;
       }
       // mark recent/new mails
       if ($message->hasFlag(Zend\Mail\Storage::FLAG_RECENT)) {
           echo '! ';
       } else {
           echo '  ';
       }
       echo $message->subject . "\n";
   }

   // check for known flags
   $flags = $message->getFlags();
   echo "Message is flagged as: ";
   foreach ($flags as $flag) {
       switch ($flag) {
           case Zend\Mail\Storage::FLAG_ANSWERED:
               echo 'Answered ';
               break;
           case Zend\Mail\Storage::FLAG_FLAGGED:
               echo 'Flagged ';
               break;

           // ...
           // check for other flags
           // ...

           default:
               echo $flag . '(unknown flag) ';
       }
   }

As IMAP allows user or client defined flags, you could get flags that don't have a constant in
``Zend\Mail\Storage``. Instead, they are returned as strings and can be checked the same way with ``hasFlag()``.

.. code-block:: php
   :linenos:

   // check message for client defined flags $IsSpam, $SpamTested
   if (!$message->hasFlag('$SpamTested')) {
       echo 'message has not been tested for spam';
   } else if ($message->hasFlag('$IsSpam')) {
       echo 'this message is spam';
   } else {
       echo 'this message is ham';
   }

.. _zend.mail.read-folders:

Using folders
-------------

All storages, except Pop3, support folders, also called mailboxes. The interface implemented by all storages
supporting folders is called ``Zend\Mail\Storage\Folder\Interface``. Also all of these classes have an additional
optional parameter called ``folder``, which is the folder selected after login, in the constructor.

For the local storages you need to use separate classes called ``Zend\Mail\Storage\Folder\Mbox`` or
``Zend\Mail\Storage\Folder\Maildir``. Both need one parameter called ``dirname`` with the name of the base dir. The
format for maildir is as defined in maildir++ (with a dot as default delimiter), Mbox is a directory hierarchy with
Mbox files. If you don't have a Mbox file called INBOX in your Mbox base dir you need to set another folder in the
constructor.

``Zend\Mail\Storage\Imap`` already supports folders by default. Examples for opening these storages:

.. code-block:: php
   :linenos:

   // mbox with folders
   $mail = new Zend\Mail\Storage\Folder\Mbox(array('dirname' =>
                                                       '/home/test/mail/'));

   // mbox with a default folder not called INBOX, also works
   // with Zend\Mail\Storage\Folder\Maildir and Zend\Mail\Storage\Imap
   $mail = new Zend\Mail\Storage\Folder\Mbox(array('dirname' =>
                                                       '/home/test/mail/',
                                                   'folder'  =>
                                                       'Archive'));

   // maildir with folders
   $mail = new Zend\Mail\Storage\Folder\Maildir(array('dirname' =>
                                                          '/home/test/mail/'));

   // maildir with colon as delimiter, as suggested in Maildir++
   $mail = new Zend\Mail\Storage\Folder\Maildir(array('dirname' =>
                                                          '/home/test/mail/',
                                                      'delim'   => ':'));

   // imap is the same with and without folders
   $mail = new Zend\Mail\Storage\Imap(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test'));

With the method getFolders($root = null) you can get the folder hierarchy starting with the root folder or the
given folder. It's returned as an instance of ``Zend\Mail\Storage\Folder``, which implements ``RecursiveIterator``
and all children are also instances of ``Zend\Mail\Storage\Folder``. Each of these instances has a local and a
global name returned by the methods ``getLocalName()`` and ``getGlobalName()``. The global name is the absolute
name from the root folder (including delimiters), the local name is the name in the parent folder.

.. _zend.mail.read-folders.table-1:

.. table:: Mail Folder Names

   +---------------+----------+
   |Global Name    |Local Name|
   +===============+==========+
   |/INBOX         |INBOX     |
   +---------------+----------+
   |/Archive/2005  |2005      |
   +---------------+----------+
   |List.ZF.General|General   |
   +---------------+----------+

If you use the iterator, the key of the current element is the local name. The global name is also returned by the
magic method ``__toString()``. Some folders may not be selectable, which means they can't store messages and
selecting them results in an error. This can be checked with the method ``isSelectable()``. So it's very easy to
output the whole tree in a view:

.. code-block:: php
   :linenos:

   $folders = new RecursiveIteratorIterator($this->mail->getFolders(),
                                            RecursiveIteratorIterator::SELF_FIRST);
   echo '<select name="folder">';
   foreach ($folders as $localName => $folder) {
       $localName = str_pad('', $folders->getDepth(), '-', STR_PAD_LEFT) .
                    $localName;
       echo '<option';
       if (!$folder->isSelectable()) {
           echo ' disabled="disabled"';
       }
       echo ' value="' . htmlspecialchars($folder) . '">'
           . htmlspecialchars($localName) . '</option>';
   }
   echo '</select>';

The current selected folder is returned by the method ``getSelectedFolder()``. Changing the folder is done with the
method ``selectFolder()``, which needs the global name as parameter. If you want to avoid to write delimiters you
can also use the properties of a ``Zend\Mail\Storage\Folder`` instance:

.. code-block:: php
   :linenos:

   // depending on your mail storage and its settings $rootFolder->Archive->2005
   // is the same as:
   //   /Archive/2005
   //  Archive:2005
   //  INBOX.Archive.2005
   //  ...
   $folder = $mail->getFolders()->Archive->2005;
   echo 'Last folder was '
      . $mail->getSelectedFolder()
      . "new folder is $folder\n";
   $mail->selectFolder($folder);

.. _zend.mail.read-advanced:

Advanced Use
------------

.. _zend.mail.read-advanced.noop:

Using NOOP
^^^^^^^^^^

If you're using a remote storage and have some long tasks you might need to keep the connection alive via noop:

.. code-block:: php
   :linenos:

   foreach ($mail as $message) {

       // do some calculations ...

       $mail->noop(); // keep alive

       // do something else ...

       $mail->noop(); // keep alive
   }

.. _zend.mail.read-advanced.caching:

Caching instances
^^^^^^^^^^^^^^^^^

``Zend\Mail\Storage\Mbox``, ``Zend\Mail\Storage\Folder\Mbox``, ``Zend\Mail\Storage\Maildir`` and
``Zend\Mail\Storage\Folder\Maildir`` implement the magic methods ``__sleep()`` and ``__wakeup()``, which means they
are serializable. This avoids parsing the files or directory tree more than once. The disadvantage is that your
Mbox or Maildir storage should not change. Some easy checks may be done, like reparsing the current Mbox file if
the modification time changes, or reparsing the folder structure if a folder has vanished (which still results in
an error, but you can search for another folder afterwards). It's better if you have something like a signal file
for changes and check it before using the cached instance.

.. code-block:: php
   :linenos:

   // there's no specific cache handler/class used here,
   // change the code to match your cache handler
   $signal_file = '/home/test/.mail.last_change';
   $mbox_basedir = '/home/test/mail/';
   $cache_id = 'example mail cache ' . $mbox_basedir . $signal_file;

   $cache = new Your_Cache_Class();
   if (!$cache->isCached($cache_id) ||
       filemtime($signal_file) > $cache->getMTime($cache_id)) {
       $mail = new Zend\Mail\Storage\Folder\Pop3(array('dirname' =>
                                                           $mbox_basedir));
   } else {
       $mail = $cache->get($cache_id);
   }

   // do stuff ...

   $cache->set($cache_id, $mail);

.. _zend.mail.read-advanced.extending:

Extending Protocol Classes
^^^^^^^^^^^^^^^^^^^^^^^^^^

Remote storages use two classes: ``Zend\Mail\Storage\<Name>`` and ``Zend\Mail\Protocol\<Name>``. The protocol class
translates the protocol commands and responses from and to *PHP*, like methods for the commands or variables with
different structures for data. The other/main class implements the common interface.

If you need additional protocol features, you can extend the protocol class and use it in the constructor of the
main class. As an example, assume we need to knock different ports before we can connect to POP3.

.. code-block:: php
   :linenos:

   class Example_Mail_Exception extends Zend\Mail\Exception
   {
   }

   class Example_Mail_Protocol_Exception extends Zend\Mail\Protocol\Exception
   {
   }

   class Example_Mail_Protocol_Pop3_Knock extends Zend\Mail\Protocol\Pop3
   {
       private $host, $port;

       public function __construct($host, $port = null)
       {
           // no auto connect in this class
           $this->host = $host;
           $this->port = $port;
       }

       public function knock($port)
       {
           $sock = @fsockopen($this->host, $port);
           if ($sock) {
               fclose($sock);
           }
       }

       public function connect($host = null, $port = null, $ssl = false)
       {
           if ($host === null) {
               $host = $this->host;
           }
           if ($port === null) {
               $port = $this->port;
           }
           parent::connect($host, $port);
       }
   }

   class Example_Mail_Pop3_Knock extends Zend\Mail\Storage\Pop3
   {
       public function __construct(array $params)
       {
           // ... check $params here! ...
           $protocol = new Example_Mail_Protocol_Pop3_Knock($params['host']);

           // do our "special" thing
           foreach ((array) $params['knock_ports'] as $port) {
               $protocol->knock($port);
           }

           // get to correct state
           $protocol->connect($params['host'], $params['port']);
           $protocol->login($params['user'], $params['password']);

           // initialize parent
           parent::__construct($protocol);
       }
   }

   $mail = new Example_Mail_Pop3_Knock(array('host'        => 'localhost',
                                             'user'        => 'test',
                                             'password'    => 'test',
                                             'knock_ports' =>
                                                 array(1101, 1105, 1111)));

As you see, we always assume we're connected, logged in and, if supported, a folder is selected in the constructor
of the main class. Thus if you assign your own protocol class, you always need to make sure that's done or the next
method will fail if the server doesn't allow it in the current state.

.. _zend.mail.read-advanced.quota:

Using Quota (since 1.5)
^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Mail\Storage\Writable\Maildir`` has support for Maildir++ quotas. It's disabled by default, but it's
possible to use it manually, if the automatic checks are not desired (this means ``appendMessage()``,
``removeMessage()`` and ``copyMessage()`` do no checks and do not add entries to the maildirsize file). If enabled,
an exception is thrown if you try to write to the maildir and it's already over quota.

There are three methods used for quotas: ``getQuota()``, ``setQuota()`` and ``checkQuota()``:

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Storage\Writable\Maildir(array('dirname' =>
                                                      '/home/test/mail/'));
   $mail->setQuota(true); // true to enable, false to disable
   echo 'Quota check is now ', $mail->getQuota() ? 'enabled' : 'disabled', "\n";
   // check quota can be used even if quota checks are disabled
   echo 'You are ', $mail->checkQuota() ? 'over quota' : 'not over quota', "\n";

``checkQuota()`` can also return a more detailed response:

.. code-block:: php
   :linenos:

   $quota = $mail->checkQuota(true);
   echo 'You are ', $quota['over_quota'] ? 'over quota' : 'not over quota', "\n";
   echo 'You have ',
        $quota['count'],
        ' of ',
        $quota['quota']['count'],
        ' messages and use ';
   echo $quota['size'], ' of ', $quota['quota']['size'], ' octets';

If you want to specify your own quota instead of using the one specified in the maildirsize file you can do with
``setQuota()``:

.. code-block:: php
   :linenos:

   // message count and octet size supported, order does matter
   $quota = $mail->setQuota(array('size' => 10000, 'count' => 100));

To add your own quota checks use single letters as keys, and they will be preserved (but obviously not checked).
It's also possible to extend ``Zend\Mail\Storage\Writable\Maildir`` to define your own quota only if the
maildirsize file is missing (which can happen in Maildir++):

.. code-block:: php
   :linenos:

   class Example_Mail_Storage_Maildir extends Zend\Mail\Storage\Writable\Maildir {
       // getQuota is called with $fromStorage = true by quota checks
       public function getQuota($fromStorage = false) {
           try {
               return parent::getQuota($fromStorage);
           } catch (Zend\Mail\Storage\Exception $e) {
               if (!$fromStorage) {
                   // unknown error:
                   throw $e;
               }
               // maildirsize file must be missing

               list($count, $size) = get_quota_from_somewhere_else();
               return array('count' => $count, 'size' => $size);
           }
       }
   }


