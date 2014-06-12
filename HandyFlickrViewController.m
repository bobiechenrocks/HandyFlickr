//
//  HandyFlickrViewController.m
//  HandyFlickr
//
//  Created by Bobie Chen on 2014/3/4.
//  Copyright (c) 2014年 Bobie Chen. All rights reserved.
//

#import "HandyFlickrViewController.h"
#import "UICommonUtility.h"
#import "FlickrManager.h"
#import "FlickrKit.h"
#import "FKAuthViewController.h"
#import "PhotoCollectionCell.h"

@interface HandyFlickrViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

/* UI elements */
@property (strong) UICollectionView* mainGridCollectionView;
@property (strong) UIActivityIndicatorView* loadingIndicator;
@property (strong) UIView* flickrPhotoView;
@property (strong) UIActivityIndicatorView* mediumPhotoLoadingIndicator;

/* controls */
@property (strong) FKDUNetworkOperation *checkAuthOp;
@property (strong) FKDUNetworkOperation *completeAuthOp;
@property (strong) NSMutableArray* arrayPhotoURL;
@property (strong) NSMutableArray* arrayMediumPhotoURL;
@property (strong) UIImage* mediumPhotoImage;

@end

@implementation HandyFlickrViewController

const CGFloat kfNavbarHeight = 44.0f;
const CGFloat kfStatusbarHeight = 22.0f;
NSString* kstrAPIKey = @"4a38b54e4faf0c771fc8df00297705f8";
NSString* kstrAPISecret = @"5cdce9bf3e026d33";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self prepareMainView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareMainView
{
    /* 
     1. prepare basic blank background view
     2. show a loading activity indicator
     3. (async) use Flickr API to fetch data
     4. when the async request returns, show data on the collection-view
     */
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    self.navigationItem.title = @"HandyFlickr";
    
    CGSize screenSize = [UICommonUtility getScreenSize];
    if (!self.mainGridCollectionView)
    {
        CGFloat fGridHeight = screenSize.height - kfNavbarHeight - kfStatusbarHeight;
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        self.mainGridCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, fGridHeight) collectionViewLayout:layout];
        [self.view addSubview:self.mainGridCollectionView];
        
        [self.mainGridCollectionView setDataSource:self];
        [self.mainGridCollectionView setDelegate:self];
        
        [self.mainGridCollectionView registerClass:[PhotoCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [self.mainGridCollectionView setBackgroundColor:[UIColor clearColor]];
    }
    
    if (!self.loadingIndicator)
    {
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:self.loadingIndicator];
        CGRect frame = self.loadingIndicator.frame;
        frame.origin.x = (self.view.frame.size.width - frame.size.width)/2;
        frame.origin.y = (self.view.frame.size.height - frame.size.height)/2;
        self.loadingIndicator.frame = frame;
    }
    
    [self.loadingIndicator startAnimating];
    
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:kstrAPIKey sharedSecret:kstrAPISecret];
    
    self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (!error) {
                /* do nothing */
				//[self userLoggedIn:userName userID:userId];
			} else {
                
//				[self doSilentLogin];
                [self doSilentFetch];
                
			}
        });
	}];
}

- (void)doSilentLogin
{
    /* maybe there is no need to log in? */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticateCallback:) name:@"UserAuthCallbackNotification" object:nil];
    
    FKAuthViewController *authView = [[FKAuthViewController alloc] init];
    [self.navigationController pushViewController:authView animated:YES];
}

- (void) userAuthenticateCallback:(NSNotification *)notification {
	NSURL *callbackURL = notification.object;
    self.completeAuthOp = [[FlickrKit sharedFlickrKit] completeAuthWithURL:callbackURL completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (!error) {
				//[self userLoggedIn:userName userID:userId];
			} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];
			}
//			[self.navigationController popToRootViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
		});
	}];
}

- (void)doSilentFetch
{
    FKFlickrPhotosSearch* search = [[FKFlickrPhotosSearch alloc] init];
    search.text = @"puppy";
	search.per_page = @"50";
    
    [[FlickrKit sharedFlickrKit] call:search completion:^(NSDictionary *response, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.loadingIndicator stopAnimating];
            
			if (response) {
                if (!self.arrayPhotoURL)
                {
                    self.arrayPhotoURL = [NSMutableArray arrayWithCapacity:0];
                }
                [self.arrayPhotoURL removeAllObjects];
                
                if (!self.arrayMediumPhotoURL)
                {
                    self.arrayMediumPhotoURL = [NSMutableArray arrayWithCapacity:0];
                }
                [self.arrayMediumPhotoURL removeAllObjects];
                
				for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
					NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeLargeSquare150 fromPhotoDictionary:photoDictionary];
                    NSURL *urlMedium = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeMedium800 fromPhotoDictionary:photoDictionary];
                    [self.arrayPhotoURL addObject:url];
                    [self.arrayMediumPhotoURL addObject:urlMedium];
				}
				
                [self doneFetch];
				
			} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];
			}
		});
	}];
}

- (void)doneFetch
{
    NSLog(@"done fetch");
    [self.mainGridCollectionView reloadData];
}

- (void)viewThisPhoto:(NSURL*)photoToViewURL
{
    CGSize screenSize = [UICommonUtility getScreenSize];
    self.flickrPhotoView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenSize.width, screenSize.height)];
    [self.flickrPhotoView setBackgroundColor:[UIColor blackColor]];
    
    if (!self.mediumPhotoLoadingIndicator)
    {
        self.mediumPhotoLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.flickrPhotoView addSubview:self.mediumPhotoLoadingIndicator];
        
        CGRect frame = self.mediumPhotoLoadingIndicator.frame;
        frame.origin.x = (self.flickrPhotoView.frame.size.width - frame.size.width)/2;
        frame.origin.y = (self.flickrPhotoView.frame.size.height - frame.size.height)/2;
        self.mediumPhotoLoadingIndicator.frame = frame;
    }
    
    [self.flickrPhotoView addSubview:self.mediumPhotoLoadingIndicator];
    [self.mediumPhotoLoadingIndicator startAnimating];
    
    [self.navigationController.view addSubview:self.flickrPhotoView];
    
    [self _fetchMediumPhoto:photoToViewURL];
    
    self.flickrPhotoView.alpha = 0.0f;
    [UIView animateWithDuration:0.25f animations:^{
        self.flickrPhotoView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissPostImageView)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [self.flickrPhotoView addGestureRecognizer:singleTap];
    }];
}

- (void)_fetchMediumPhoto:(NSURL*)photoURL
{
    NSURLRequest* request = [NSURLRequest requestWithURL:photoURL];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        
        [self.mediumPhotoLoadingIndicator stopAnimating];
        
        if (error)
        {
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* photoToView = [[UIImage alloc] initWithData:data];
                
                CGSize screenSize = [UICommonUtility getScreenSize];
                float fScreenWidthHeightRatio = screenSize.width / screenSize.height;
                float fPicWidthHeightRatio = photoToView.size.width / screenSize.height;
                
                if (fScreenWidthHeightRatio > fPicWidthHeightRatio)
                {
                    /* fit with screen height */
                    CGFloat fWidth = screenSize.height * photoToView.size.width / photoToView.size.height;
                    CGFloat fX = (screenSize.width - fWidth)/2;
                    UIImageView* imagePostPic = [[UIImageView alloc] initWithFrame:CGRectMake(fX, 0.0f, fWidth, screenSize.height)];
                    imagePostPic.image = photoToView;
                    [self.flickrPhotoView addSubview:imagePostPic];
                }
                else
                {
                    /* fit with screen width */
                    CGFloat fHeight = screenSize.width * photoToView.size.height / photoToView.size.width;
                    CGFloat fY = (screenSize.height - fHeight)/2;
                    UIImageView* imagePostPic = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, fY, screenSize.width, fHeight)];
                    imagePostPic.image = photoToView;
                    [self.flickrPhotoView addSubview:imagePostPic];
                }
            });
        }
    }];
}

- (void)_dismissPostImageView
{
    [UIView animateWithDuration:0.25f animations:^{
        self.flickrPhotoView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.flickrPhotoView removeFromSuperview];
    }];
}

#pragma mark - delegate & data-source for collection-view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arrayPhotoURL)
    {
        return [self.arrayPhotoURL count];
    }
    else
    {
        return 0;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell* cell = (PhotoCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[PhotoCollectionCell alloc] init];
    }
    
    [cell prepareThumbnailWithURL:[self.arrayPhotoURL objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell* cell = (PhotoCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell)
    {
        [self viewThisPhoto:[self.arrayMediumPhotoURL objectAtIndex:indexPath.row]];
    }
}

@end
