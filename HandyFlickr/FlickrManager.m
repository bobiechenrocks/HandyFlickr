//
//  FlickrManager.m
//  HandyFlickr
//
//  Created by Bobie Chen on 2014/3/4.
//  Copyright (c) 2014年 Bobie Chen. All rights reserved.
//

#import "FlickrManager.h"

static FlickrManager* m_flickrManager;

static NSString* s_strAPIKey = @"4a38b54e4faf0c771fc8df00297705f8";
static NSString* s_strAPISecret = @"5cdce9bf3e026d33";

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
    if ([strKeyword isEqualToString:@""]) {
        return;
    }
    
    NSString* strAPIBase = @"https://api.flickr.com/services/rest";
    NSString* strAPIPhotoSearch = @"flickr.photos.search";
    NSString* strAPIRequest = [NSString stringWithFormat:@"%@?method=%@&api_key=%@&tags=%@&per_page=50&format=json&nojsoncallback=1", strAPIBase, strAPIPhotoSearch, s_strAPIKey, strKeyword];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:strAPIRequest]];
    NSOperationQueue* q = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:q completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSError* r;
        NSDictionary* dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&r];
        NSDictionary* dictPhotos = [dictResponse objectForKey:@"photos"];
        if (dictPhotos)
        {
            NSArray* arrayPhotos = [dictPhotos objectForKey:@"photo"];
            if (completionHandler)
                completionHandler(nil, arrayPhotos);
        }
        
    }];
}

@end
