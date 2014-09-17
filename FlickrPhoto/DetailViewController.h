//  DetailViewController.h
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 9/16/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

@interface DetailViewController : UIViewController
@property (nonatomic, strong) ImageDownloader *currentImageDownloader;
@property (nonatomic, strong) UIImage *image;

@end
