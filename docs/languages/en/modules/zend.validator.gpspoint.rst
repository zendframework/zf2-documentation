.. _zend.validator.set.gpspoint

GpsPoint
============

``Zend\Validator\GpsPoint`` allows you to validate GPS Coordinates. The formats
Degrees Minutes Second (DMS, for example 38° 53\ 23" N, 77° 00' 32" W) and Latitude/Longitude (for example 38.8897°, -77.0089°)
are allowed.

.. _zend.validator.set.gpspoint.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\GpsPoint();
   if ($validator->isValid('38.8897°, -77.0089°')) {
       // GpsPoint appears to be valid
   } else {
       // GpsPoint is invalid; print the reasons
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

This will match the GpsPoint ``'38.8897°, -77.0089°'`` and on failure populate ``getMessages()`` with usefull error messages.

Whatever type are used to validate, the values always have to be separated by a comma.
Otherwise the validation will be fail with a ``GpsPoint::INCOMPLETE_COORDINATE`` error.

.. _zend.validator.set.gpspoint.errors

Possible Errors
-----------

- **CONVERT_ERROR**: While converting the DMS values into lat/long values, an error occurred.
- **OUT_OF_BOUNDS**: The Coordinate exceed the maximal Values of -90 and 90 for Latitude and -180 and 180 for Longitude.
- **INCOMPLETE_COORDINATE**: This error is raised, when an incomplete Coordinate is passed, like the first or second value is missing
