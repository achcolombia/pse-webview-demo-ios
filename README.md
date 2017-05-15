# DEMO invocación de PSE Móvil desde un WKWebview en iOS

Versión 1.0

El objetivo de esta aplicación es demostrar la integración de una aplicación iOS basada en WKWebview con la aplicación de pagos PSE móvil. Esta integración es equivalente para aquellas aplicaciones que utilicen UIWebView.

La única modificación que se realizó en este Demo, respecto de las configuraciones por omisión de un proyecto iOS, fue agregar la posibilidad de cargar URLs arbitrarias en **Info.plist**.

```
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
</dict>
```
