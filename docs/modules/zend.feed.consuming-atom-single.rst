
Consuming a Single Atom Entry
=============================

Single Atom ``<entry>`` elements are also valid by themselves. Usually the *URL* for an entry is the feed's *URL* followed by ``/<entryId>`` , such as ``http://atom.example.com/feed/1`` , using the example *URL* we used above.

If you read a single entry, you will still have a ``Zend_Feed_Atom`` object, but it will automatically create an "anonymous" feed to contain the entry.

Alternatively, you could instantiate the entry object directly if you know you are accessing an ``<entry>`` -only document:


