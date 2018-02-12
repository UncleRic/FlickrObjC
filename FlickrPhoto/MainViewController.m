//  MainViewController.m
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 9/14/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------------------------

#import "MainViewController.h"
#import "SimpleFlickrAPI.h"
#import "ImageDownloader.h"
#import "DetailViewController.h"
#import "PhotoCollectionView.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet PhotoCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *downloaders;

@end

@implementation MainViewController

NSString *searchText = @"Shark";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self initiateRefreshData];
    [self fetchFlickrPhotoWithSearchString:searchText tag:@"[shark, ocean"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Flickr Viewer";
    if (_currentImageDownloader) {
        [_downloaders replaceObjectAtIndex:_selectedItemIndex withObject:_currentImageDownloader];
    }
}

- (void)initiateRefreshData {
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh Data"];
    refreshControl.tintColor = UIColor.redColor;
    refreshControl.backgroundColor = UIColor.whiteColor;
    UIImage *hook = [UIImage imageNamed:@"Hook"];
    UIImageView *hookImageView = [[UIImageView alloc] initWithImage:hook];
    UIImage *fish = [UIImage imageNamed:@"Fish"];
    UIImageView *fishImageView = [[UIImageView alloc] initWithImage:fish];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[hookImageView ,fishImageView]];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 10.0;
    [refreshControl addSubview:stackView];
    
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UILayoutGuide *container = [refreshControl layoutMarginsGuide];
    [stackView.leadingAnchor constraintEqualToAnchor:container.leadingAnchor].active = YES;
    [stackView.topAnchor constraintEqualToAnchor:container.topAnchor].active = YES;
    
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.collectionView.refreshControl = refreshControl;
}

- (void)handleRefresh:(NSObject *)sender {
    
    
    
    //    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh now"];
    //    // ... update datasource
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Updated %@", [NSDate date]]];
    //        [self.refreshControl endRefreshing];
    //        [self.collectionView reloadData];
    //    });
    NSLog(@"do something");
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark -

- (void)fetchFlickrPhotoWithSearchString:(NSString *)searchString tag: (NSString *)tags {
    
    SimpleFlickrAPI *flickr = [SimpleFlickrAPI new];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[flickr getURLForString: searchString tags:tags]
                                 completionHandler:^(NSData *data,
                                                     NSURLResponse *response,
                                                     NSError *error) {
                                     if (!error) {
                                         NSString *string = [flickr stringByRemovingFlickrJavaScript:data];
                                         NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
                                         NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                                  options:NSJSONReadingAllowFragments
                                                                                                    error:&error];
                                         
                                         NSArray *photoInfos = [[jsonDict objectForKey:@"photos"] objectForKey:@"photo"];
                                         
                                         NSMutableArray *downloaders = [[NSMutableArray alloc] initWithCapacity:[photoInfos count]];
                                         for (NSInteger index = 0; index < [photoInfos count]; index++) {
                                             ImageDownloader *downloader = [[ImageDownloader alloc] initWithDict:photoInfos[index]];
                                             [downloaders addObject:downloader];
                                         }
                                         self.downloaders = downloaders; // ...link local array with instance array 'downloaders' (Note: same object!).
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [self.collectionView reloadData];
                                         });
                                     } else {
                                         NSLog(@"*** {SessionDataError}: %@",error);
                                         // ...Handle Error.
                                     }
                                 }] resume];
    
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - UICollectionViewDelegate methods
// ...to be implemented later.

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.downloaders count];
}

// -----------------------------------------------------------------------------------------------------------------------

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:1];
    
    // •(1) Each cell displays an image of the photo from Flickr.
    //    However, the image must be downloaded first.
    //    The completion block for the ImageDownloader object is defined.
    //    The completion block sets the image property for cell’s photoImageView to the image passed in to the block.•
    //    ImageDownloader(completion) --> ViewController(completion)
    
    
    ImageDownloaderCompletionBlock completion = ^(UIImage *image, NSError *error) {                                  // 1
        if (image) {
            photoImageView.image = image;
        } else {
            NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__,
                  [error localizedDescription]);
        }
    };
    
    
    self.selectedItemIndex = [indexPath item];   // ...NSIndexPath (UICollectionViewAdditions)
    
    self.currentImageDownloader = [_downloaders objectAtIndex:_selectedItemIndex];
    
    // (2) If the image was previously downloaded, the cell’s image is set right away.
    // There is no reason to download it again.
    
    UIImage *image = [_currentImageDownloader image];                                 // 2
    
    if (image) {
        photoImageView.image = image;
    } else {
        NSURL *url = [NSURL URLWithString:[_downloaders[_selectedItemIndex] dict][@"url_sq"]];
        [_currentImageDownloader downloadImageAtURL:url completion:completion];
    }
    
    return cell;
}


// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Segue Handler

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UICollectionViewCell *)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathsForSelectedItems][0];
        DetailViewController *detailViewController = [segue destinationViewController];
        _selectedItemIndex = [selectedIndexPath item];
        detailViewController.currentImageDownloader = [_downloaders objectAtIndex:_selectedItemIndex];
    }
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Action methods

- (IBAction)exitAction:(id)sender {
    exit(0);
}

@end
