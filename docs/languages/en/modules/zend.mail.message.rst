.. _zend.mail.message:

Zend\\Mail\\Message
===================

.. _zend.mail.message.intro:

Overview
--------

The ``Message`` class encapsulates a single email message as described in RFCs `822`_ and `2822`_. It acts
basically as a value object for setting mail headers and content.

If desired, multi-part email messages may also be created. This is as trivial as creating the message body using
the :ref:`Zend\\Mime <zend.mime>` component, assigning it to the mail message body.

The ``Message`` class is simply a value object. It is not capable of sending or storing itself; for those purposes,
you will need to use, respectively, a :ref:`Transport adapter <zend.mail.transport>` or :ref:`Storage adapter
<zend.mail.read>`.

.. _zend.mail.message.quick-start:

Quick Start
-----------

Creating a ``Message`` is simple: simply instantiate it.

.. code-block:: php
   :linenos:

   use Zend\Mail\Message;

   $message = new Message();

Once you have your ``Message`` instance, you can start adding content or headers. Let's set who the mail is from,
who it's addressed to, a subject, and some content:

.. code-block:: php
   :linenos:

   $message->addFrom("matthew@zend.com", "Matthew Weier O'Phinney")
           ->addTo("foobar@example.com")
           ->setSubject("Sending an email from Zend\Mail!");
   $message->setBody("This is the message body.");

You can also add recipients to carbon-copy ("Cc:") or blind carbon-copy ("Bcc:").

.. code-block:: php
   :linenos:

   $message->addCc("ralph.schindler@zend.com")
           ->addBcc("enrico.z@zend.com");

If you want to specify an alternate address to which replies may be sent, that can be done, too.

.. code-block:: php
   :linenos:

   $message->addReplyTo("matthew@weierophinney.net", "Matthew");

Interestingly, RFC822 allows for multiple "From:" addresses. When you do this, the first one will be used as the
sender, **unless** you specify a "Sender:" header. The ``Message`` class allows for this.

.. code-block:: php
   :linenos:

   /*
    * Mail headers created:
    * From: Ralph Schindler <ralph.schindler@zend.com>, Enrico Zimuel <enrico.z@zend.com>
    * Sender: Matthew Weier O'Phinney <matthew@zend.com></matthew>
    */
   $message->addFrom("ralph.schindler@zend.com", "Ralph Schindler")
           ->addFrom("enrico.z@zend.com", "Enrico Zimuel")
           ->setSender("matthew@zend.com", "Matthew Weier O'Phinney");

By default, the ``Message`` class assumes ASCII encoding for your email. If you wish to use another encoding, you
can do so; setting this will ensure all headers and body content are properly encoded using quoted-printable
encoding.

.. code-block:: php
   :linenos:

   $message->setEncoding("UTF-8");

If you wish to set other headers, you can do that as well.

.. code-block:: php
   :linenos:

   /*
    * Mail headers created:
    * X-API-Key: FOO-BAR-BAZ-BAT
    */
   $message->getHeaders()->addHeaderLine('X-API-Key', 'FOO-BAR-BAZ-BAT');

Sometimes you may want to provide HTML content, or multi-part content. To do that, you'll first create a MIME
message object, and then set it as the body of your mail message object. When you do so, the ``Message`` class will
automatically set a "MIME-Version" header, as well as an appropriate "Content-Type" header.

.. code-block:: php
   :linenos:

   use Zend\Mail\Message;
   use Zend\Mime\Message as MimeMessage;
   use Zend\Mime\Part as MimePart;

   $text = new MimePart($textContent);
   $text->type = "text/plain";

   $html = new MimePart($htmlMarkup);
   $html->type = "text/html";

   $image = new MimePart(fopen($pathToImage, 'r'));
   $image->type = "image/jpeg";

   $body = new MimeMessage();
   $body->setParts(array($text, $html, $image));

   $message = new Message();
   $message->setBody($body);

If you want a string representation of your email, you can get that:

.. code-block:: php
   :linenos:

   echo $message->toString();

Finally, you can fully introspect the message -- including getting all addresses of recipients and senders, all
headers, and the message body.

.. code-block:: php
   :linenos:

   // Headers
   // Note: this will also grab all headers for which accessors/mutators exist in
   // the Message object itself.
   foreach ($message->getHeaders() as $header) {
       echo $header->toString();
       // or grab values: $header->getFieldName(), $header->getFieldValue()
   }

   // The logic below also works for the methods cc(), bcc(), to(), and replyTo()
   foreach ($message->from() as $address) {
       printf("%s: %s\n", $address->getEmail(), $address->getName());
   }

   // Sender
   $address = $message->getSender();
   printf("%s: %s\n", $address->getEmail(), $address->getName());

   // Subject
   echo "Subject: ", $message->getSubject(), "\n";

   // Encoding
   echo "Encoding: ", $message->getEncoding(), "\n";

   // Message body:
   echo $message->getBody();     // raw body, or MIME object
   echo $message->getBodyText(); // body as it will be sent

Once your message is shaped to your liking, pass it to a :ref:`mail transport <zend.mail.transport>` in order to
send it!

.. code-block:: php
   :linenos:

   $transport->send($message);

.. _zend.mail.message.options:

Configuration Options
---------------------

The ``Message`` class has no configuration options, and is instead a value object.

.. _zend.mail.message.methods:

Available Methods
-----------------

.. _zend.mail.message.methods.is-valid:

**isValid**
   ``isValid()``

   Is the message valid?

   If we don't have any From addresses, we're invalid, according to RFC2822.

   Returns bool

.. _zend.mail.message.methods.set-encoding:

**setEncoding**
   ``setEncoding(string $encoding)``

   Set the message encoding.

   Implements a fluent interface.

.. _zend.mail.message.methods.get-encoding:

**getEncoding**
   ``getEncoding()``

   Get the message encoding.

   Returns string.

.. _zend.mail.message.methods.set-headers:

**setHeaders**
   ``setHeaders(Zend\Mail\Headers $headers)``

   Compose headers.

   Implements a fluent interface.

.. _zend.mail.message.methods.get-headers:

**getHeaders**
   ``getHeaders()``

   Access headers collection.

   Lazy-loads a Zend\\Mail\\Headers instance if none is already attached.

   Returns a Zend\\Mail\\Headers instance.

.. _zend.mail.message.methods.set-from:

**setFrom**
   ``setFrom(string|AddressDescription|array|Zend\Mail\AddressList|Traversable $emailOrAddressList, string|null $name)``

   Set (overwrite) From addresses.

   Implements a fluent interface.

.. _zend.mail.message.methods.add-from:

**addFrom**
   ``addFrom(string|Zend\Mail\Address|array|Zend\Mail\AddressList|Traversable $emailOrAddressOrList, string|null $name)``

   Add a "From" address.

   Implements a fluent interface.

.. _zend.mail.message.methods.from:

**from**
   ``from()``

   Retrieve list of From senders

   Returns Zend\\Mail\\AddressList instance.

.. _zend.mail.message.methods.set-to:

**setTo**
   ``setTo(string|AddressDescription|array|Zend\Mail\AddressList|Traversable $emailOrAddressList, null|string $name)``

   Overwrite the address list in the To recipients.

   Implements a fluent interface.

.. _zend.mail.message.methods.add-to:

**addTo**
   ``addTo(string|AddressDescription|array|Zend\Mail\AddressList|Traversable $emailOrAddressOrList, null|string $name)``

   Add one or more addresses to the To recipients.

   Appends to the list.

   Implements a fluent interface.

.. _zend.mail.message.methods.to:

**to**
   ``to()``

   Access the address list of the To header.

   Lazy-loads a Zend\\Mail\\AddressList and populates the To header if not previously done.

   Returns a Zend\\Mail\\AddressList instance.

.. _zend.mail.message.methods.set-cc:

**setCc**
   ``setCc(string|AddressDescription|array|Zend\Mail\AddressList|Traversable $emailOrAddressList, string|null $name)``

   Set (overwrite) CC addresses.

   Implements a fluent interface.

.. _zend.mail.message.methods.add-cc:

**addCc**
   ``addCc(string|Zend\Mail\Address|array|Zend\Mail\AddressList|Traversable $emailOrAddressOrList, string|null $name)``

   Add a "Cc" address.

   Implements a fluent interface.

.. _zend.mail.message.methods.cc:

**cc**
   ``cc()``

   Retrieve list of CC recipients

   Lazy-loads a Zend\\Mail\\AddressList and populates the Cc header if not previously done.

   Returns a Zend\\Mail\\AddressList instance.

.. _zend.mail.message.methods.set-bcc:

**setBcc**
   ``setBcc(string|AddressDescription|array|Zend\Mail\AddressList|Traversable $emailOrAddressList, string|null $name)``

   Set (overwrite) BCC addresses.

   Implements a fluent interface.

.. _zend.mail.message.methods.add-bcc:

**addBcc**
   ``addBcc(string|Zend\Mail\Address|array|Zend\Mail\AddressList|Traversable $emailOrAddressOrList, string|null $name)``

   Add a "Bcc" address.

   Implements a fluent interface.

.. _zend.mail.message.methods.bcc:

**bcc**
   ``bcc()``

   Retrieve list of BCC recipients.

   Lazy-loads a Zend\\Mail\\AddressList and populates the Bcc header if not previously done.

   Returns a Zend\\Mail\\AddressList instance.

.. _zend.mail.message.methods.set-reply-to:

**setReplyTo**
   ``setReplyTo(string|AddressDescription|array|Zend\Mail\AddressList|Traversable $emailOrAddressList, null|string $name)``

   Overwrite the address list in the Reply-To recipients.

   Implements a fluent interface.

.. _zend.mail.message.methods.add-reply-to:

**addReplyTo**
   ``addReplyTo(string|AddressDescription|array|Zend\Mail\AddressList|Traversable $emailOrAddressOrList, null|string $name)``

   Add one or more addresses to the Reply-To recipients.

   Implements a fluent interface.

.. _zend.mail.message.methods.reply-to:

**replyTo**
   ``replyTo()``

   Access the address list of the Reply-To header

   Lazy-loads a Zend\\Mail\\AddressList and populates the Reply-To header if not previously done.

   Returns a Zend\\Mail\\AddressList instance.

.. _zend.mail.message.methods.set-sender:

**setSender**
   ``setSender(mixed $emailOrAddress, mixed $name)``

   Set the message envelope Sender header.

   Implements a fluent interface.

.. _zend.mail.message.methods.get-sender:

**getSender**
   ``getSender()``

   Retrieve the sender address, if any.

   Returns null or a Zend\\Mail\\AddressDescription instance.

.. _zend.mail.message.methods.set-subject:

**setSubject**
   ``setSubject(string $subject)``

   Set the message subject header value.

   Implements a fluent interface.

.. _zend.mail.message.methods.get-subject:

**getSubject**
   ``getSubject()``

   Get the message subject header value.

   Returns null or a string.

.. _zend.mail.message.methods.set-body:

**setBody**
   ``setBody(null|string|Zend\Mime\Message|object $body)``

   Set the message body.

   Implements a fluent interface.

.. _zend.mail.message.methods.get-body:

**getBody**
   ``getBody()``

   Return the currently set message body.

   Returns null, a string, or an object.

.. _zend.mail.message.methods.get-body-text:

**getBodyText**
   ``getBodyText()``

   Get the string-serialized message body text.

   Returns null or a string.

.. _zend.mail.message.methods.to-string:

**toString**
   ``toString()``

   Serialize to string.

   Returns string.

.. _zend.mail.message.examples:

Examples
--------

Please :ref:`see the Quick Start section <zend.mail.message.quick-start>`.



.. _`822`: http://www.w3.org/Protocols/rfc822/
.. _`2822`: http://www.ietf.org/rfc/rfc2822.txt
