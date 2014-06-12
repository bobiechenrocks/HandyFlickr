//
//  FlickrManager.m
//  HandyFlickr
//
//  Created by Bobie Chen on 2014/3/4.
//  Copyright (c) 2014年 Bobie Chen. All rights reserved.
//

#import "FlickrManager.h"

static FlickrManager* m_flickrManager;

@implementation FlickrManager

+ (FlickrManager*)sharedFlickrManager
{
    if (!m_flickrManager)
    {
        m_flickrManager = [[FlickrManager alloc] init];
    }
    
    return m_flickrManager;
}

- (void)fetchNearByWithKeyword:(NSString*)strKeyword completion:(void (^)(NSError* error, NSArray* arrayResult))completionHandler
{
    
}

@end
