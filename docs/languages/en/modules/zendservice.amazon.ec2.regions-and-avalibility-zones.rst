.. _zendservice.amazon.ec2.zones:

ZendService\Amazon\Ec2: Regions and Availability Zones
=======================================================

Amazon EC2 provides the ability to place instances in different regions and Availability Zones. Regions are
dispersed in separate geographic areas or countries. Availability Zones are located within regions and are
engineered to be insulated from failures in other Availability Zones and provide inexpensive low latency network
connectivity to other Availability Zones in the same region. By launching instances in separate Availability Zones,
you can protect your applications from the failure of a single Availability Zone.

.. _zendservice.amazon.ec2.zones.regions:

Amazon EC2 Regions
------------------

Amazon EC2 provides multiple regions so you can launch Amazon EC2 instances in locations that meet your
requirements. For example, you might want to launch instances in Europe to be closer to your European customers or
to meet legal requirements.

Each Amazon EC2 region is designed to be completely isolated from the other Amazon EC2 regions. This achieves the
greatest possible failure independence and stability, and it makes the locality of each EC2 resource unambiguous.

.. _zendservice.amazon.ec2.zones.regions.example:

.. rubric:: Viewing the available regions

*describe* is used to find out which regions your account has access to.

*describe* will return an array containing information about which regions are available. Each array will contain
regionName and regionUrl.

.. code-block:: php
   :linenos:

   $ec2_region = new ZendService\Amazon\Ec2\Region('aws_key','aws_secret_key');
   $regions = $ec2_region->describe();

   foreach ($regions as $region) {
       print $region['regionName'] . ' -- ' . $region['regionUrl'] . '<br />';
   }

.. _zendservice.amazon.ec2.zones.availability:

Amazon EC2 Availability Zones
-----------------------------

When you launch an instance, you can optionally specify an Availability Zone. If you do not specify an Availability
Zone, Amazon EC2 selects one for you in the region that you are using. When launching your initial instances, we
recommend accepting the default Availability Zone, which allows Amazon EC2 to select the best Availability Zone for
you based on system health and available capacity. Even if you have other instances running, you might consider not
specifying an Availability Zone if your new instances do not need to be close to, or separated from, your existing
instances.

.. _zendservice.amazon.ec2.zones.availability.example:

.. rubric:: Viewing the available zones

*describe* is used to find out which what the status is of each availability zone.

*describe* will return an array containing information about which zones are available. Each array will contain
zoneName and zoneState.

.. code-block:: php
   :linenos:

   $ec2_zones = new ZendService\Amazon\Ec2\Availabilityzones('aws_key',
                                                              'aws_secret_key');
   $zones = $ec2_zones->describe();

   foreach ($zones as $zone) {
       print $zone['zoneName'] . ' -- ' . $zone['zoneState'] . '<br />';
   }


