.. _zendgdata.analytics:

Using Google Analytics
======================

The Google Analytics *API* allows client applications to request data, saved in the analytics accounts.

See http://code.google.com/apis/analytics/docs/gdata/v2/gdataOverview.html for more information about the Google
Analytics *API*.

.. _zendgdata.analytics.accounts:

Retrieving account data
-----------------------

Using the account feed, you are able to retrieve a list of all the accounts available to a specified user.

.. code-block:: php
   :linenos:

   $service = ZendGData\Analytics::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($email, $password, $service);
   $analytics = new ZendGData\Analytics($client);
   $accounts = $analytics->getAccountFeed();

   foreach ($accounts as $account) {
     echo "\n{$account->title}\n";
   }

The ``$analytics->getAccountFeed()`` call, results in a ``ZendGData\Analytics\AccountFeed`` object that contains
``ZendGData\Analytics\AccountEntry`` objects. Each of this objects represent a google analytics account.

.. _zendgdata.analytics.reports:

Retrieving report data
----------------------

Besides the account feed, google offers a data feed, to retrieve report data using the Google Analytics *API*. To
easily request for these reports, ZendGData\Analytics offers a simple query construction interface. You can use
all the `metrics and dimensions`_ specified by the API. Additionally you can apply some `filters`_ to retrieve some
`common data`_ or even complex results.

.. code-block:: php
   :linenos:

   $query = $service->newDataQuery()->setProfileId($profileId)
     ->addMetric(ZendGData\Analytics\DataQuery::METRIC_BOUNCES)
     ->addMetric(ZendGData\Analytics\DataQuery::METRIC_VISITS)
     ->addDimension(ZendGData\Analytics\DataQuery::DIMENSION_MEDIUM)
     ->addDimension(ZendGData\Analytics\DataQuery::DIMENSION_SOURCE)
     ->addFilter("ga:browser==Firefox")
     ->setStartDate('2011-05-01')
     ->setEndDate('2011-05-31')
     ->addSort(ZendGData\Analytics\DataQuery::METRIC_VISITS, true)
     ->addSort(ZendGData\Analytics\DataQuery::METRIC_BOUNCES, false)
     ->setMaxResults(50);

   $result = $analytics->getDataFeed($query);
   foreach ($result as $row) {
     echo $row->getMetric('ga:visits')."\t";
     echo $row->getValue('ga:bounces')."\n";
   }



.. _`metrics and dimensions`: http://code.google.com/intl/de-CH/apis/analytics/docs/gdata/dimsmets/dimsmets.html
.. _`filters`: http://code.google.com/intl/de-CH/apis/analytics/docs/gdata/v2/gdataReferenceDataFeed.html#filters
.. _`common data`: http://code.google.com/intl/de-CH/apis/analytics/docs/gdata/gdataCommonQueries.html
