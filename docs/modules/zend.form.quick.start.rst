
Zend\\Form Quick Start
======================

Forms are relatively easy to create. At the bare minimum, each element or fieldset requires a name; typically, you'll also provide some attributes to hint to the view layer how it might render the item. The form itself will also typically compose an ``InputFilter`` -- which you can also conveniently create directly in the form via a factory. Individual elements can hint as to what defaults to use when generating a related input for the input filter.

Form validation is as easy as providing an array of data to the ``setData()`` method. If you want to simplify your work even more, you can bind an object to the form; on successful validation, it will be populated from the validated values.


