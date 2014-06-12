//
//  PhotoCollectionCell.h
//  HandyFlickr
//
//  Created by Bobie Chen on 2014/3/4.
//  Copyright (c) 2014年 Bobie Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionCell : UICollectionViewCell

- (void)prepareThumbnailWithURL:(NSURL*)photoURL;
- (UIImage*)getCellImage;

@end
