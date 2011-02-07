//
//  AsyncImageLoadingViewController.m
//  AsyncImageLoading
//
//  Created by Ahmet Ardal on 2/7/11.
//  Copyright 2011 LiveGO. All rights reserved.
//

#import "AsyncImageLoadingViewController.h"

@interface AsyncImageLoadingViewController(Private)
- (void) initialize;
- (void) loadImage:(id)arg;
- (void) updateTableView:(id)arg;
- (void) addImagesToQueue:(NSArray *)images;
@end


@implementation AsyncImageLoadingViewController

@synthesize imagesTableView, button, imageQueue, loadedImages, imageLoaderOpQueue;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return self;
    }
    
    [self initialize];
    return self;
}

- (void) awakeFromNib
{
    NSLog(@"AsyncImageLoadingViewController::awakeFromNib called");
    [super awakeFromNib];
    [self initialize];
}

- (void) viewDidLoad
{
    NSLog(@"AsyncImageLoadingViewController::viewDidLoad called");
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"AsyncImageLoadingViewController::viewDidAppear called");
    [super viewDidAppear:animated];

    //
    // add some images to the queue
    //
    NSArray *images = [NSArray arrayWithObjects:
                       @"http://dl.dropbox.com/u/9234555/avatars/ava01.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava02.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava03.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava04.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava05.gif", nil];
    [self addImagesToQueue:images];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    [self.imagesTableView release];
    [self.button release];
    [self.imageQueue release];
    [self.loadedImages release];
    [self.imageLoaderOpQueue release];
    [super dealloc];
}

- (IBAction) loadMoreButtonPressed:(id)sender
{
    NSLog(@"AsyncImageLoadingViewController::loadMoreButtonPressed called");

    //
    // add some more images to the queue
    //
    NSArray *images = [NSArray arrayWithObjects:
                       @"http://dl.dropbox.com/u/9234555/avatars/ava06.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava07.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava08.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava09.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava10.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava11.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava12.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava13.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava14.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava15.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava16.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava17.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava18.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava19.gif",
                       @"http://dl.dropbox.com/u/9234555/avatars/ava20.gif", nil];
    [self addImagesToQueue:images];
}


#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Images";
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.loadedImages count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ImageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"Image - %02d", (indexPath.row + 1)];
    cell.imageView.image = [self.loadedImages objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Private Methods

/*!
 @method     
 @abstract   initializes class variables
 */
- (void) initialize
{
    NSLog(@"AsyncImageLoadingViewController::initialize called");

    NSMutableArray *a = [[NSMutableArray alloc] init];
    self.imageQueue = a;
    [a release];
    
    a = [[NSMutableArray alloc] init];
    self.loadedImages = a;
    [a release];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    self.imageLoaderOpQueue = queue;
    [queue release];
}

/*!
 @method     
 @abstract   updates tableview for the newly downloaded image and scrolls the tableview to bottom
*/
- (void) updateTableView:(id)arg
{
    NSLog(@"AsyncImageLoadingViewController::updateTableView called");

    if ((arg == nil) || ([arg isKindOfClass:[UIImage class]] == NO)) {
        return;
    }

    // store the newly downloaded image
    [self.loadedImages addObject:arg];
    [arg release];

    // refresh tableview
    [self.imagesTableView reloadData];

    // scroll to the last cell of the tableview
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:([self.loadedImages count] - 1) inSection:0];
    [self.imagesTableView scrollToRowAtIndexPath:lastRow
                                atScrollPosition:UITableViewScrollPositionBottom
                                        animated:YES];
}

/*!
 @method     
 @abstract   downloads images, this is the method that dispatches tasks in the operation queue
 */
- (void) loadImage:(id)arg
{
    NSLog(@"AsyncImageLoadingViewController::loadImage called");
    
    if ((arg == nil) || ([arg isKindOfClass:[NSString class]] == NO)) {
        return;
    }

    // create a local autorelease pool since this code runs not on main thread
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    // fetch the image
    NSLog(@"AsyncImageLoadingViewController::loadImage - will download image: %@", arg);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:arg]];
    UIImage *image = [UIImage imageWithData:data];

    // update tableview with the downloaded image on main thread
    [self performSelectorOnMainThread:@selector(updateTableView:) withObject:[image retain] waitUntilDone:NO];

    [pool release];
}

/*!
 @method     
 @abstract   add images to the queue and starts the operation queue to download them
 */
- (void) addImagesToQueue:(NSArray *)images
{
    NSLog(@"AsyncImageLoadingViewController::addImagesToQueue called");

    [self.imageQueue addObjectsFromArray:images];

    // suspend the operation queue
    [self.imageLoaderOpQueue setSuspended:YES];

    // add tasks to the operation queue
    for (NSString *imageUrl in self.imageQueue) {
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:@selector(loadImage:)
                                                                           object:imageUrl];
        [self.imageLoaderOpQueue addOperation:op];
        [op release];
    }

    // clear items in the queue and resume the operation queue to start downloading images
    [self.imageQueue removeAllObjects];
    [self.imageLoaderOpQueue setSuspended:NO];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
