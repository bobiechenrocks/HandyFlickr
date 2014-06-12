//
//  PhotoCollectionCell.m
//  HandyFlickr
//
//  Created by Bobie Chen on 2014/3/4.
//  Copyright (c) 2014年 Bobie Chen. All rights reserved.
//

#import "PhotoCollectionCell.h"

@interface PhotoCollectionCell ()

@property (strong) UIImageView* imageThumbnail;

@end

@implementation PhotoCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)prepareThumbnailWithURL:(NSURL*)photoURL
{
    if (!self.imageThumbnail)
    {
        self.imageThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.imageThumbnail];
    }
    
    [self _fetchImage:photoURL];
}

- (void)_fetchImage:(NSURL*)photoURL
{
    NSURLRequest* request = [NSURLRequest requestWithURL:photoURL];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        if (error)
        {
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* image = [[UIImage alloc] initWithData:data];
                self.imageThumbnail.image = image;
            });
        }
    }];
}

- (UIImage*)getCellImage
{
    return self.imageThumbnail.image;
}

@end
