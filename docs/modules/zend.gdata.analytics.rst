
Using Google Analytics
======================

The Google Analytics *API* allows client applications to request data, saved in the analytics accounts.

See `http://code.google.com/apis/analytics/docs/gdata/v2/gdataOverview.html`_ for more information about the Google Analytics *API* .

.. _zend.gdata.analytics.accounts:

Retrieving account data
-----------------------

Using the account feed, you are able to retrieve a list of all the accounts available to a specified user.

.. code-block:: php
    :linenos:
    
    $service = Zend\GData\Analytics::AUTH_SERVICE_NAME;
    $client = Zend\GData\ClientLogin::getHttpClient($email, $password, $service);
    $analytics = new Zend\GData\Analytics($client);  
    $accounts = $analytics->getAccountFeed();
    
    foreach ($accounts as $account) {  
      echo "\n{$account->title}\n";
    }
    

The ``$analytics->getAccountFeed()`` call, results in a ``Zend\GData\Analytics\AccountFeed`` object that contains ``Zend\GData\Analytics\AccountEntry`` objects. Each of this objects represent a google analytics account.

.. _zend.gdata.analytics.reports:

Retrieving report data
----------------------

Besides the account feed, google offers a data feed, to retrieve report data using the Google Analytics *API* . To easily request for these reports, Zend\\GData\\Analytics offers a simple query construction interface. You can use all the `metrics and dimensions`_ specified by the API. Additionaly you can apply some `filters`_ to retrieve some `common data`_ or even complex results.

.. code-block:: php
    :linenos:
    
    $query = $service->newDataQuery()->setProfileId($profileId)  
      ->addMetric(Zend\GData\Analytics\DataQuery::METRIC_BOUNCES)
      ->addMetric(Zend\GData\Analytics\DataQuery::METRIC_VISITS)
      ->addDimension(Zend\GData\Analytics\DataQuery::DIMENSION_MEDIUM)
      ->addDimension(Zend\GData\Analytics\DataQuery::DIMENSION_SOURCE)
      ->addFilter("ga:browser==Firefox")  
      ->setStartDate('2011-05-01')   
      ->setEndDate('2011-05-31')   
      ->addSort(Zend\GData\Analytics\DataQuery::METRIC_VISITS, true)
      ->addSort(Zend\GData\Analytics\DataQuery::METRIC_BOUNCES, false)
      ->setMaxResults(50); 
      
    $result = $analytics->getDataFeed($query);
    foreach($result as $row){  
      echo $row->getMetric('ga:visits')."\t";  
      echo $row->getValue('ga:bounces')."\n";  
    }
    


.. _`http://code.google.com/apis/analytics/docs/gdata/v2/gdataOverview.html`: http://code.google.com/apis/analytics/docs/gdata/v2/gdataOverview.html
.. _`metrics and dimensions`: http://code.google.com/intl/de-CH/apis/analytics/docs/gdata/dimsmets/dimsmets.html
.. _`filters`: http://code.google.com/intl/de-CH/apis/analytics/docs/gdata/v2/gdataReferenceDataFeed.html#filters
.. _`common data`: http://code.google.com/intl/de-CH/apis/analytics/docs/gdata/gdataCommonQueries.html
