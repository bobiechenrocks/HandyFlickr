//
//  FlickrManager.h
//  HandyFlickr
//
//  Created by Bobie Chen on 2014/3/4.
//  Copyright (c) 2014年 Bobie Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrManager : NSObject

+ (FlickrManager*)sharedFlickrManager;
- (void)fetchNearByWithKeyword:(NSString*)strKeyword completion:(void (^)(NSError* error, NSArray* arrayResult))completionHandler;

@end
