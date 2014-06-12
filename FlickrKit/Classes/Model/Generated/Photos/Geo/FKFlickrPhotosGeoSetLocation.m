//
//  FKFlickrPhotosGeoSetLocation.m
//  FlickrKit
//
//  Generated by FKAPIBuilder on 12 Jun, 2013 at 17:19.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrPhotosGeoSetLocation.h" 

@implementation FKFlickrPhotosGeoSetLocation

- (BOOL) needsLogin {
    return YES;
}

- (BOOL) needsSigning {
    return YES;
}

- (FKPermission) requiredPerms {
    return 1;
}

- (NSString *) name {
    return @"flickr.photos.geo.setLocation";
}

- (BOOL) isValid:(NSError **)error {
    BOOL valid = YES;
	NSMutableString *errorDescription = [[NSMutableString alloc] initWithString:@"You are missing required params: "];
	if(!self.photo_id) {
		valid = NO;
		[errorDescription appendString:@"'photo_id', "];
	}
	if(!self.lat) {
		valid = NO;
		[errorDescription appendString:@"'lat', "];
	}
	if(!self.lon) {
		valid = NO;
		[errorDescription appendString:@"'lon', "];
	}

	if(error != NULL) {
		if(!valid) {	
			NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorDescription};
			*error = [NSError errorWithDomain:FKFlickrKitErrorDomain code:FKErrorInvalidArgs userInfo:userInfo];
		}
	}
    return valid;
}

- (NSDictionary *) args {
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
	if(self.photo_id) {
		[args setValue:self.photo_id forKey:@"photo_id"];
	}
	if(self.lat) {
		[args setValue:self.lat forKey:@"lat"];
	}
	if(self.lon) {
		[args setValue:self.lon forKey:@"lon"];
	}
	if(self.accuracy) {
		[args setValue:self.accuracy forKey:@"accuracy"];
	}
	if(self.context) {
		[args setValue:self.context forKey:@"context"];
	}
	if(self.bookmark_id) {
		[args setValue:self.bookmark_id forKey:@"bookmark_id"];
	}
	if(self.is_public) {
		[args setValue:self.is_public forKey:@"is_public"];
	}
	if(self.is_contact) {
		[args setValue:self.is_contact forKey:@"is_contact"];
	}
	if(self.is_friend) {
		[args setValue:self.is_friend forKey:@"is_friend"];
	}
	if(self.is_family) {
		[args setValue:self.is_family forKey:@"is_family"];
	}
	if(self.foursquare_id) {
		[args setValue:self.foursquare_id forKey:@"foursquare_id"];
	}
	if(self.woeid) {
		[args setValue:self.woeid forKey:@"woeid"];
	}

    return [args copy];
}

- (NSString *) descriptionForError:(NSInteger)error {
    switch(error) {
		case FKFlickrPhotosGeoSetLocationError_PhotoNotFound:
			return @"Photo not found";
		case FKFlickrPhotosGeoSetLocationError_RequiredArgumentsMissing:
			return @"Required arguments missing.";
		case FKFlickrPhotosGeoSetLocationError_NotAValidLatitude:
			return @"Not a valid latitude.";
		case FKFlickrPhotosGeoSetLocationError_NotAValidLongitude:
			return @"Not a valid longitude.";
		case FKFlickrPhotosGeoSetLocationError_NotAValidAccuracy:
			return @"Not a valid accuracy.";
		case FKFlickrPhotosGeoSetLocationError_ServerError:
			return @"Server error.";
		case FKFlickrPhotosGeoSetLocationError_UserHasNotConfiguredDefaultViewingSettingsForLocationData:
			return @"User has not configured default viewing settings for location data.";
		case FKFlickrPhotosGeoSetLocationError_InvalidSignature:
			return @"Invalid signature";
		case FKFlickrPhotosGeoSetLocationError_MissingSignature:
			return @"Missing signature";
		case FKFlickrPhotosGeoSetLocationError_LoginFailedOrInvalidAuthToken:
			return @"Login failed / Invalid auth token";
		case FKFlickrPhotosGeoSetLocationError_UserNotLoggedInOrInsufficientPermissions:
			return @"User not logged in / Insufficient permissions";
		case FKFlickrPhotosGeoSetLocationError_InvalidAPIKey:
			return @"Invalid API Key";
		case FKFlickrPhotosGeoSetLocationError_ServiceCurrentlyUnavailable:
			return @"Service currently unavailable";
		case FKFlickrPhotosGeoSetLocationError_FormatXXXNotFound:
			return @"Format \"xxx\" not found";
		case FKFlickrPhotosGeoSetLocationError_MethodXXXNotFound:
			return @"Method \"xxx\" not found";
		case FKFlickrPhotosGeoSetLocationError_InvalidSOAPEnvelope:
			return @"Invalid SOAP envelope";
		case FKFlickrPhotosGeoSetLocationError_InvalidXMLRPCMethodCall:
			return @"Invalid XML-RPC Method Call";
		case FKFlickrPhotosGeoSetLocationError_BadURLFound:
			return @"Bad URL found";
  
		default:
			return @"Unknown error code";
    }
}

@end