//
//  DetailViewController.m
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 9/16/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageDownloader.h"
#import "MainViewController.h"


@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) MainViewController *mainViewController;

@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *title = _currentImageDownloader.dict[@"title"];
    if ([[title substringToIndex:7] isEqualToString:@"Unknown"]) {
        self.title = @"No Title";
    } else {
        self.title = title;
    }
    [self displayBigImage];
}

// -----------------------------------------------------------------------------------------------------------------------

- (void)willMoveToParentViewController:(UINavigationController *)navController {
    if (navController) {
        self.mainViewController = [navController viewControllers][0];
    } else {
        self.currentImageDownloader.bigImage = self.imageView.image;
        _mainViewController.currentImageDownloader = _currentImageDownloader;
    }
}

// -----------------------------------------------------------------------------------------------------------------------

- (void)displayBigImage {
    
    ImageDownloaderCompletionBlock completion = ^(UIImage *image, NSError *error) {
        if (image) {
            self.imageView.image = image;
        } else {
            NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__,
                  [error localizedDescription]);
        }
    };
    
    UIImage *image = [_currentImageDownloader bigImage];
    
    if (image) {
        self.imageView.image = image;
    } else {
        NSURL *URL = [NSURL URLWithString:_currentImageDownloader.dict[@"url_m"]];
        [_currentImageDownloader downloadImageAtURL:URL completion:completion];
    }
}

@end
