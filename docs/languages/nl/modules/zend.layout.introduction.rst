.. _zend.layout.introduction:

Introductie
===========

*Zend_Layout* implementeert het klassieke Two Step View design pattern, dat ontwikkelaars in staat stelt elke
output die een applicatie levert te voorzien van een omvattende, andere view. Dit wordt voornamelijk gebruikt om
elke pagina binnen een website van dezelfde layout te voorzien. Om deze reden wordt in veel andere projecten de
naam **layout** voor dit pattern gebruikt. Zend Framework gebruikt deze term om de vergelijkbaarheid te vergroten.

De belangrijkste doelen van *Zend_Layout* zijn:

- Automatische keuze en inbedding van standaard layouts bij gebruik van de MVC-componenten van Zend Framework.

- Een aparte omgeving bieden voor layout-gerelateerde variabelen en output.

- De ontwikkelaar in staat stellen om de layoutnaam, het pad naar het layout script en de inflectie van het layout
  script te wijzigen.

- De ontwikkelaar in staat stellen om vanuit de actiecontrollers en viewscripts de layout tijdelijk uit te
  schakelen en het layout script te veranderen.

- Dezelfde inflectieregels voor view script namen te volgen als :ref:`ViewRenderer
  <zend.controller.actionhelpers.viewrenderer>`, maar ook andere regels mogelijk maken.

- Ontwikkelaars die zonder de MVC-componenten werken ook in staat stellen *Zend_Layout* te gebruiken.


