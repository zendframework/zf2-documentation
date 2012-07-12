
Character Sets
==============

``Zend_Mail`` does not check for the correct character set of the mail parts. When instantiating ``Zend_Mail`` , a charset for the e-mail itself may be given. It defaults toiso-8859-1. The application has to make sure that all parts added to that mail object have their content encoded in the correct character set. When creating a new mail part, a different charset can be given for each part.

.. note::
    **Only in text format**

    Character sets are only applicable for message parts in text format.


