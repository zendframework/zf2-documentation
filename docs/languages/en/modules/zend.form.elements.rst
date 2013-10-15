.. _zend.form.elements:

Form Elements
=============

.. _zend.form.elements.intro:

Introduction
------------

A set of specialized elements are provided for accomplishing application-centric tasks. These include several HTML5
input elements with matching server-side validators, the ``Csrf`` element (to prevent Cross Site Request Forgery
attacks), and the ``Captcha`` element (to display and validate :ref:`CAPTCHAs <zend.captcha>`).

A ``Factory`` is provided to facilitate creation of elements, fieldsets, forms, and the related input filter. See
the :ref:`Zend\\Form Quick Start <zend.form.quick-start.factory>` for more information.

.. include:: include/zend.form.element.rst

Standard Elements
-----------------

.. include:: include/zend.form.element.button.rst
.. include:: include/zend.form.element.captcha.rst
.. include:: include/zend.form.element.checkbox.rst
.. include:: include/zend.form.element.collection.rst
.. include:: include/zend.form.element.csrf.rst
.. include:: include/zend.form.element.file.rst
.. include:: include/zend.form.element.hidden.rst
.. include:: include/zend.form.element.image.rst
.. include:: include/zend.form.element.monthselect.rst
.. include:: include/zend.form.element.multicheckbox.rst
.. include:: include/zend.form.element.password.rst
.. include:: include/zend.form.element.radio.rst
.. include:: include/zend.form.element.select.rst
.. include:: include/zend.form.element.submit.rst
.. include:: include/zend.form.element.text.rst
.. include:: include/zend.form.element.textarea.rst

HTML5 Elements
--------------

.. include:: include/zend.form.element.color.rst
.. include:: include/zend.form.element.date.rst
.. include:: include/zend.form.element.date.time.rst
.. include:: include/zend.form.element.date.time.local.rst
.. include:: include/zend.form.element.email.rst
.. include:: include/zend.form.element.month.rst
.. include:: include/zend.form.element.number.rst
.. include:: include/zend.form.element.range.rst
.. include:: include/zend.form.element.time.rst
.. include:: include/zend.form.element.url.rst
.. include:: include/zend.form.element.week.rst
