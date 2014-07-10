:orphan:

.. _zendoauth.introduction.security-architecture:

Security Architecture
=====================

OAuth was designed specifically to operate over an insecure *HTTP* connection and so the use of *HTTPS* is not
required though obviously it would be desireable if available. Should a *HTTPS* connection be feasible, OAuth
offers a signature method implementation called PLAINTEXT which may be utilised. Over a typical unsecured *HTTP*
connection, the use of PLAINTEXT must be avoided and an alternate scheme using. The OAuth specification defines two
such signature methods: HMAC-SHA1 and RSA-SHA1. Both are fully supported by ``ZendOAuth``.

These signature methods are quite easy to understand. As you can imagine, a PLAINTEXT signature method does nothing
that bears mentioning since it relies on *HTTPS*. If you were to use PLAINTEXT over *HTTP*, you are left with a
significant problem: there's no way to be sure that the content of any OAuth enabled request (which would include
the OAuth Access Token) was altered en route. This is because unsecured *HTTP* requests are always at risk of
eavesdropping, Man In The Middle (MITM) attacks, or other risks whereby a request can be retooled so to speak to
perform tasks on behalf of the attacker by masquerading as the origin application without being noticed by the
service provider.

HMAC-SHA1 and RSA-SHA1 alleviate this risk by digitally signing all OAuth requests with the original application's
registered Consumer Secret. Assuming only the Consumer and the Provider know what this secret is, a middle-man can
alter requests all they wish - but they will not be able to validly sign them and unsigned or invalidly signed
requests would be discarded by both parties. Digital signatures therefore offer a guarantee that validly signed
requests do come from the expected party and have not been altered en route. This is the core of why OAuth can
operate over an unsecured connection.

How these digital signatures operate depends on the method used, i.e. HMAC-SHA1, RSA-SHA1 or perhaps another method
defined by the service provider. HMAC-SHA1 is a simple mechanism which generates a Message Authentication Code
(MAC) using a cryptographic hash function (i.e. SHA1) in combination with a secret key known only to the message
sender and receiver (i.e. the OAuth Consumer Secret and the authorized Access Key combined). This hashing mechanism
is applied to the parameters and content of any OAuth requests which are concatenated into a "base signature
string" as defined by the OAuth specification.

RSA-SHA1 operates on similar principles except that the shared secret is, as you would expect, each parties' RSA
private key. Both sides would have the other's public key with which to verify digital signatures. This does pose a
level of risk compared to HMAC-SHA1 since the RSA method does not use the Access Key as part of the shared secret.
This means that if the RSA private key of any Consumer is compromised, then all Access Tokens assigned to that
Consumer are also. RSA imposes an all or nothing scheme. In general, the majority of service providers offering
OAuth authorization have therefore tended to use HMAC-SHA1 by default, and those who offer RSA-SHA1 may offer
fallback support to HMAC-SHA1.

While digital signatures add to OAuth's security they are still vulnerable to other forms of attack, such as replay
attacks which copy earlier requests which were intercepted and validly signed at that time. An attacker can now
resend the exact same request to a Provider at will at any time and intercept its results. This poses a significant
risk but it is quiet simple to defend against - add a unique string (i.e. a nonce) to all requests which changes
per request (thus continually changing the signature string) but which can never be reused because Providers
actively track used nonces within the a certain window defined by the timestamp also attached to a request. You
might first suspect that once you stop tracking a particular nonce, the replay could work but this ignore the
timestamp which can be used to determine a request's age at the time it was validly signed. One can assume that a
week old request used in an attempted replay should be summarily discarded!

As a final point, this is not an exhaustive look at the security architecture in OAuth. For example, what if *HTTP*
requests which contain both the Access Token and the Consumer Secret are eavesdropped? The system relies on at one
in the clear transmission of each unless *HTTPS* is active, so the obvious conclusion is that where feasible
*HTTPS* is to be preferred leaving unsecured *HTTP* in place only where it is not possible or affordable to do so.


