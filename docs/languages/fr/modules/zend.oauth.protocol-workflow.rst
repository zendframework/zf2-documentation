.. _zend.oauth.introduction.protocol-workflow:

Protocol Workflow
=================

Before implementing OAuth it makes sense to understand how the protocol operates. To do so we'll take the example
of Twitter which currently implements OAuth based on the OAuth Core 1.0 Revision A Specification. This example
looks at the protocol from the perspectives of the User (who will approve access), the Consumer (who is seeking
access) and the Provider (who holds the User's private data). Access may be read-only or read and write.

By chance, our User has decided that they want to utilise a new service called TweetExpress which claims to be
capable of reposting your blog posts to Twitter in a manner of seconds. TweetExpress is a registered application on
Twitter meaning that it has access to a Consumer Key and a Consumer Secret (all OAuth applications must have these
from the Provider they will be accessing) which identify its requests to Twitter and that ensure all requests can
be signed using the Consumer Secret to verify their origin.

To use TweetExpress you are asked to register for a new account, and after your registration is confirmed you are
informed that TweetExpress will seek to associate your Twitter account with the service.

In the meantime TweetExpress has been busy. Before gaining your approval from Twitter, it has sent a *HTTP* request
to Twitter's service asking for a new unauthorized Request Token. This token is not User specific from Twitter's
perspective, but TweetExpress may use it specifically for the current User and should associate it with their
account and store it for future use. TweetExpress now redirects the User to Twitter so they can approve
TweetExpress' access. The URL for this redirect will be signed using TweetExpress' Consumer Secret and it will
contain the unauthorized Request Token as a parameter.

At this point the User may be asked to log into Twitter and will now be faced with a Twitter screen asking if they
approve this request by TweetExpress to access Twitter's *API* on the User's behalf. Twitter will record the
response which we'll assume was positive. Based on the User's approval, Twitter will record the current
unauthorized Request Token as having been approved by the User (thus making it User specific) and will generate a
new value in the form of a verification code. The User is now redirected back to a specific callback URL used by
TweetExpress (this callback URL may be registered with Twitter or dynamically set using an oauth_callback parameter
in requests). The redirect URL will contain the newly generated verification code.

TweetExpress' callback URL will trigger an examination of the response to determine whether the User has granted
their approval to Twitter. Assuming so, it may now exchange it's unauthorized Request Token for a fully authorized
Access Token by sending a request back to Twitter including the Request Token and the received verification code.
Twitter should now send back a response containing this Access Token which must be used in all requests used to
access Twitter's *API* on behalf of the User. Twitter will only do this once they have confirmed the attached
Request Token has not already been used to retrieve another Access Token. At this point, TweetExpress may confirm
the receipt of the approval to the User and delete the original Request Token which is no longer needed.

From this point forward, TweetExpress may use Twitter's *API* to post new tweets on the User's behalf simply by
accessing the *API* endpoints with a request that has been digitally signed (via HMAC-SHA1) with a combination of
TweetExpress' Consumer Secret and the Access Key being used.

Although Twitter do not currently expire Access Tokens, the User is free to deauthorize TweetExpress from their
Twitter account settings. Once deauthorized, TweetExpress' access will be cut off and their Access Token rendered
invalid.


