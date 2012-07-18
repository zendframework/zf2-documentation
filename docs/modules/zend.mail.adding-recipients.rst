.. _zend.mail.adding-recipients:

Adding Recipients
=================

Recipients can be added in three ways:

- ``addTo()``: Adds a recipient to the mail with a "To" header

- ``addCc()``: Adds a recipient to the mail with a "Cc" header

- ``addBcc()``: Adds a recipient to the mail not visible in the header

``getRecipients()`` serves list of the recipients. ``clearRecipients()`` clears the list.

.. note::

   **Additional parameter**

   ``addTo()`` and ``addCc()`` accept a second optional parameter that is used as a human-readable name of the
   recipient for the header. Double quotation is changed to single quotation and angle brackets to square brackets
   in the parameter.

.. note::

   **Optional Usage**

   All three of these methods can also accept an array of email addresses to add instead of one at a time. In the
   case of ``addTo()`` and ``addCc()``, they can be associative arrays where the key is the human readable name for
   the recipient.


