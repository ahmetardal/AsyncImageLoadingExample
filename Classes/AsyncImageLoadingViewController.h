//
//  AsyncImageLoadingViewController.h
//  AsyncImageLoading
//
//  Created by Ahmet Ardal on 2/7/11.
//  Copyright 2011 LiveGO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncImageLoadingViewController: UIViewController<UITableViewDelegate,
                                                                UITableViewDataSource,
                                                                UITextFieldDelegate>
{
    UITableView *imagesTableView;
    UIButton *button;

    /*!
     stores urls of the images to be loaded
     */
    NSMutableArray *imageQueue;
    
    /*!
     stores all downloaded UIImage objects
     */
    NSMutableArray *loadedImages;
    
    /*!
     operation queue for downloading images in background
     */
    NSOperationQueue *imageLoaderOpQueue;
}

@property (nonatomic, retain) IBOutlet UITableView *imagesTableView;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) NSMutableArray *imageQueue;
@property (nonatomic, retain) NSMutableArray *loadedImages;
@property (nonatomic, retain) NSOperationQueue *imageLoaderOpQueue;

- (IBAction) loadMoreButtonPressed:(id)sender;

@end
