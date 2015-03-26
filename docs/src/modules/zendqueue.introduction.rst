.. _zendqueue.introduction:

Introduction
============

``ZendQueue`` provides a factory function to create specific queue client objects.

A message queue is a method for distributed processing. For example, a Job Broker application may accept multiple
applications for jobs from a variety of sources.

You could create a queue "``/queue/applications``" that would have a sender and a receiver. The sender would be any
available source that could connect to your message service or indirectly to an application (web) that could
connect to the message service.

The sender sends a message to the queue:

.. code-block:: xml
   :linenos:

   <resume>
       <name>John Smith</name>
       <location>
           <city>San Francisco</city>
           <state>California</state>
           <zip>00001</zip>
       </location>
       <skills>
           <programming>PHP</programming>
           <programming>Perl</programming>
       </skills>
   </resume>

The recipient or consumer of the queue would pick up the message and process the resume.

There are many messaging patterns that can be applied to queues to abstract the flow of control from the code and
provide metrics, transformations, and monitoring of messages queues. A good book on messaging patterns is
`Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions (Addison-Wesley Signature
Series)`_ (ISBN-10 0321127420; ISBN-13 978-0321127426).



.. _`Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions (Addison-Wesley Signature Series)`: http://www.amazon.com/Enterprise-Integration-Patterns-Designing-Addison-Wesley/dp/0321200683
