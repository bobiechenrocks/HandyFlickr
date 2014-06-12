//
//  FKFlickrPrefsGetPrivacy.h
//  FlickrKit
//
//  Generated by FKAPIBuilder on 12 Jun, 2013 at 17:19.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrAPIMethod.h"

typedef enum {
	FKFlickrPrefsGetPrivacyError_InvalidSignature = 96,		 /* The passed signature was invalid. */
	FKFlickrPrefsGetPrivacyError_MissingSignature = 97,		 /* The call required signing but no signature was sent. */
	FKFlickrPrefsGetPrivacyError_LoginFailedOrInvalidAuthToken = 98,		 /* The login details or auth token passed were invalid. */
	FKFlickrPrefsGetPrivacyError_UserNotLoggedInOrInsufficientPermissions = 99,		 /* The method requires user authentication but the user was not logged in, or the authenticated method call did not have the required permissions. */
	FKFlickrPrefsGetPrivacyError_InvalidAPIKey = 100,		 /* The API key passed was not valid or has expired. */
	FKFlickrPrefsGetPrivacyError_ServiceCurrentlyUnavailable = 105,		 /* The requested service is temporarily unavailable. */
	FKFlickrPrefsGetPrivacyError_FormatXXXNotFound = 111,		 /* The requested response format was not found. */
	FKFlickrPrefsGetPrivacyError_MethodXXXNotFound = 112,		 /* The requested method was not found. */
	FKFlickrPrefsGetPrivacyError_InvalidSOAPEnvelope = 114,		 /* The SOAP envelope send in the request could not be parsed. */
	FKFlickrPrefsGetPrivacyError_InvalidXMLRPCMethodCall = 115,		 /* The XML-RPC request document could not be parsed. */
	FKFlickrPrefsGetPrivacyError_BadURLFound = 116,		 /* One or more arguments contained a URL that has been used for abuse on Flickr. */

} FKFlickrPrefsGetPrivacyError;

/*

Returns the default privacy level preference for the user.

Possible values are:
<ul>
<li>1 : Public</li>
<li>2 : Friends only</li>
<li>3 : Family only</li>
<li>4 : Friends and Family</li>
<li>5 : Private</li>
</ul>


Response:

<rsp stat="ok">
<person nsid="12037949754@N01" privacy="1" />
</rsp>

*/
@interface FKFlickrPrefsGetPrivacy : NSObject <FKFlickrAPIMethod>


@end
