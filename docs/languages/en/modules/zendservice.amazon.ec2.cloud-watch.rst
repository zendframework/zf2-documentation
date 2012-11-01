.. _zendservice.amazon.ec2.cloudwatch:

ZendService\Amazon\Ec2: CloudWatch Monitoring
=============================================

Amazon CloudWatch is an easy-to-use web service that provides comprehensive monitoring for Amazon Elastic Compute
Cloud (Amazon *EC2*) and Elastic Load Balancing. For more details information check out the `Amazon CloudWatch
Developers Guide`_

.. _zendservice.amazon.ec2.cloudwatch.usage:

CloudWatch Usage
----------------

.. _zendservice.amazon.ec2.cloudwatch.usage.list:

.. rubric:: Listing Aviable Metrics

``listMetrics()`` returns a list of up to 500 valid metrics for which there is recorded data available to a you and
a NextToken string that can be used to query for the next set of results.

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\CloudWatch('aws_key','aws_secret_key');
   $return = $ec2_ebs->listMetrics();

.. _zendservice.amazon.ec2.cloudwatch.usage.getmetricstatistics:

.. rubric:: Return Statistics for a given metric

``getMetricStatistics()`` Returns data for one or more statistics of given a metric.

.. note::

   The maximum number of datapoints that the Amazon CloudWatch service will return in a single GetMetricStatistics
   request is 1,440. If a request is made that would generate more datapoints than this amount, Amazon CloudWatch
   will return an error. You can alter your request by narrowing the time range (StartTime, EndTime) or increasing
   the Period in your single request. You may also get all of the data at the granularity you originally asked for
   by making multiple requests with adjacent time ranges.

``getMetricStatistics()`` only requires two parameters but it also has four additional parameters that are
optional.

- **Required:**

- **MeasureName** The measure name that corresponds to the measure for the gathered metric. Valid *EC2* Values are
  *CPU*\ Utilization, NetworkIn, NetworkOut, DiskWriteOps DiskReadBytes, DiskReadOps, DiskWriteBytes. Valid Elastic
  Load Balancing Metrics are Latency, RequestCount, HealthyHostCount UnHealthyHostCount. `For more information
  click here`_

- **Statistics** The statistics to be returned for the given metric. Valid values are Average, Maximum, Minimum,
  Samples, Sum. You can specify this as a string or as an array of values. If you don't specify one it will default
  to Average instead of failing out. If you specify an incorrect option it will just skip it. `For more information
  click here`_

- **Optional:**

- **Dimensions** Amazon CloudWatch allows you to specify one Dimension to further filter metric data on. If you
  don't specify a dimension, the service returns the aggregate of all the measures with the given measure name and
  time range.

- **Unit** The standard unit of Measurement for a given Measure. Valid Values: Seconds, Percent, Bytes, Bits,
  Count, Bytes/Second, Bits/Second, Count/Second, and None. Constraints: When using count/second as the unit, you
  should use Sum as the statistic instead of Average. Otherwise, the sample returns as equal to the number of
  requests instead of the number of 60-second intervals. This will cause the Average to always equals one when the
  unit is count/second.

- **StartTime** The timestamp of the first datapoint to return, inclusive. For example, 2008-02-26T19:00:00+00:00.
  We round your value down to the nearest minute. You can set your start time for more than two weeks in the past.
  However, you will only get data for the past two weeks. (in *ISO* 8601 format). Constraints: Must be before
  EndTime.

- **EndTime** The timestamp to use for determining the last datapoint to return. This is the last datapoint to
  fetch, exclusive. For example, 2008-02-26T20:00:00+00:00 (in *ISO* 8601 format).

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\CloudWatch('aws_key','aws_secret_key');
   $return = $ec2_ebs->getMetricStatistics(
                                        array('MeasureName' => 'NetworkIn',
                                              'Statistics' => array('Average')));



.. _`Amazon CloudWatch Developers Guide`: http://docs.amazonwebservices.com/AmazonCloudWatch/latest/DeveloperGuide/Welcome.html
.. _`For more information click here`: http://docs.amazonwebservices.com/AmazonCloudWatch/latest/DeveloperGuide/US_GetStatistics.html
