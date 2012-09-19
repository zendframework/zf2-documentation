.. _zend.form.intro:

Introduction to Zend\\Form
==========================

``Zend\Form`` is intended primarily as a bridge between your domain models and the View Layer. It composes a thin
layer of objects representing form elements, an :ref:`InputFilter <zend.input-filter>`, and a small number of
methods for binding data to and from the form and attached objects.

The ``Zend\Form`` component consists of the following objects:

- ``Elements``, which simply consist of a name and attributes.

- ``Fieldsets``, which extend from ``Elements``, but allow composing other fieldsets and elements.

- ``Forms``, which extend from ``Fieldsets`` (and thus ``Elements``). They provide data and object binding, and compose
  :ref:`InputFilters <zend.input-filter.intro>`. Data binding is done via :ref:`Zend\Stdlib\Hydrator <zend.stdlib.hydrator>`.

To facilitate usage with the view layer, the ``Zend\Form`` component also aggregates a number of form-specific view
helpers. These accept elements, fieldsets, and/or forms, and use the attributes they compose to render markup.

A small number of specialized elements are provided for accomplishing application-centric tasks. These include the
``Csrf`` element, used to prevent Cross Site Request Forgery attacks, and the ``Captcha`` element, used to display
and validate :ref:`CAPTCHAs <zend.captcha>`.

A ``Factory`` is provided to facilitate creation of elements, fieldsets, forms, and the related input filter. The
default ``Form`` implementation is backed by a factory to facilitate extension and ease the process of form
creation.

The code related to forms can often spread between a variety of concerns: a form definition, an input filter
definition, a domain model class, and one or more hydrator implementations. As such, finding the various bits of
code and how they relate can become tedious. To simplify the situation, you can also annotate your domain model
class, detailing the various input filter definitions, attributes, and hydrators that should all be used together.
``Zend\Form\Annotation\AnnotationBuilder`` can then be used to build the various objects you need.


