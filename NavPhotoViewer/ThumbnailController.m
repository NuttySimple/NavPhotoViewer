//
//  ThumbnailController.m
//  NavPhotoViewer
//
//  Created by Jordan Gurrieri on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThumbnailController.h"
#import "FullScreenPhotoController.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface ThumbnailController ()
static UIImage *shrinkImage(UIImage *original, CGSize size);
- (void)updateDisplay;
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;

@end

@implementation ThumbnailController

@synthesize fullScreenPhotoController;
@synthesize imageView;
@synthesize clearImageButton;
@synthesize takePictureButton;
@synthesize caption;
@synthesize image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [fullScreenPhotoController release];
    [imageView release];
    [takePictureButton release];
    [image release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)shootPicture:(id)sender {
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (void)shootPictureVoid:(id)sender {
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)selectExistingPicture:(id)sender {
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    self.title = @"#Thumbnail";
    
    imageView.hidden = YES;
    caption.hidden = YES;
    caption.text = @"Here be the caption, yarr!";
    
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera]) {
        takePictureButton.hidden = YES;
    }
    imageFrame = imageView.frame;
    
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                     target:self
                                     action:@selector(shootPictureVoid:)];
    self.navigationItem.rightBarButtonItem = cameraButton;
    [cameraButton release];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateDisplay];
}

- (void)viewDidUnload
{
    self.imageView = nil;
    self.takePictureButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CGSize chosenImageSize = chosenImage.size;
    CGSize newImageSize;
    CGRect cropRect;
    
    if (chosenImageSize.height > chosenImageSize.width) {
        // Create UIImage frame for image in portrait thumbnail
        imageView.frame = CGRectMake( imageView.frame.origin.x, imageView.frame.origin.y, kThumbnailPortraitWidth, kThumbnailPortraitHeight);
        clearImageButton.frame = CGRectMake( imageView.frame.origin.x, imageView.frame.origin.y, kThumbnailPortraitWidth, kThumbnailPortraitHeight);
        newImageSize = CGSizeMake(kThumbnailPortraitWidth, ((chosenImageSize.height*kThumbnailPortraitWidth)/chosenImageSize.width));
        cropRect = CGRectMake((newImageSize.width - (kThumbnailPortraitWidth))/2, (newImageSize.height - (kThumbnailPortraitHeight))/2, kThumbnailPortraitWidth, kThumbnailPortraitHeight);
    }
    else if (chosenImageSize.height < chosenImageSize.width) {
        // Create UIImage frame for image in landscape thumbnail
        imageView.frame = CGRectMake( imageView.frame.origin.x, imageView.frame.origin.y, kThumbnailLandscapeWidth, kThumbnailLandscapeHeight);
        clearImageButton.frame = CGRectMake( imageView.frame.origin.x, imageView.frame.origin.y, kThumbnailLandscapeWidth, kThumbnailLandscapeHeight);
        newImageSize = CGSizeMake(((chosenImageSize.width*kThumbnailLandscapeHeight)/chosenImageSize.height), kThumbnailLandscapeHeight);
        cropRect = CGRectMake((newImageSize.width - (kThumbnailLandscapeWidth))/2, (newImageSize.height - (kThumbnailLandscapeHeight))/2, kThumbnailLandscapeWidth, kThumbnailLandscapeHeight);
    }
    else {
        // Create UIImage frame for image in portrait thumbnail but maximize image scaling to fill height
        imageView.frame = CGRectMake( imageView.frame.origin.x, imageView.frame.origin.y, kThumbnailPortraitWidth, kThumbnailPortraitHeight);
        clearImageButton.frame = CGRectMake( imageView.frame.origin.x, imageView.frame.origin.y, kThumbnailPortraitWidth, kThumbnailPortraitHeight);
        newImageSize = CGSizeMake(kThumbnailPortraitHeight, kThumbnailPortraitHeight);
        cropRect = CGRectMake((newImageSize.width - (kThumbnailPortraitWidth))/2, (newImageSize.height - (kThumbnailPortraitHeight))/2, kThumbnailPortraitWidth, kThumbnailPortraitHeight);        
    }
    
    UIImage *shrunkenImage = shrinkImage(chosenImage, newImageSize);
    
    // Crop the new shrunken image to the fit the target frame size
    CGImageRef croppedShrunkenImage = CGImageCreateWithImageInRect([shrunkenImage CGImage], cropRect);
    
    self.image = [UIImage imageWithCGImage:croppedShrunkenImage];
    
    CGImageRelease(croppedShrunkenImage);
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}



#pragma mark -
static inline double radians (double degrees) {
    return degrees * M_PI/180;
}

#pragma mark -
static UIImage *shrinkImage(UIImage *original, CGSize size) {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGFloat targetWidth = size.width * scale;
    CGFloat targetHeight = size.height * scale;
    CGImageRef imageRef = [original CGImage];
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef context;
    
    //if (original.imageOrientation == UIImageOrientationUp || original.imageOrientation == UIImageOrientationDown) {
        context = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    //} else {
    //    context = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    //}       
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
	// and also the thumbnail point
    if (original.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(90));
        CGContextTranslateCTM (context, 0, -targetWidth);
        
    } else if (original.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(-90));
        CGContextTranslateCTM (context, -targetHeight, 0);
        
    } else if (original.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (original.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (context, targetWidth, targetHeight);
        CGContextRotateCTM (context, radians(-180));
    }
    
    if (original.imageOrientation == UIImageOrientationUp || original.imageOrientation == UIImageOrientationDown) {
        CGContextDrawImage(context, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    
    } else {
        CGContextDrawImage(context, CGRectMake(0, 0, targetHeight, targetWidth), imageRef);
    }
    
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    
    UIImage *shrunkenImage = [UIImage imageWithCGImage:shrunken scale:original.scale orientation:original.imageOrientation];
    //UIImage* shrunkenImage = [UIImage imageWithCGImage:shrunken];
    
    //CGSize shrunkenImageSize = shrunkenImage.size;
    
    CGContextRelease(context);
    CGImageRelease(shrunken);
    
    return shrunkenImage;
}


- (void)updateDisplay {
    imageView.image = image;
    imageView.hidden = NO;
    caption.hidden = NO;
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediaTypes = [UIImagePickerController
                           availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:
         sourceType] && [mediaTypes count] > 0) {
        NSArray *mediaTypes = [UIImagePickerController
							   availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error accessing media" 
                              message:@"Device doesn‚Äôt support that media source." 
                              delegate:nil 
                              cancelButtonTitle:@"Drat!" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


- (IBAction)didSelectImage:(id)sender {
    if (self.fullScreenPhotoController.view.superview == nil) {
        if (self.fullScreenPhotoController == nil) {
            FullScreenPhotoController *fullScreenController = [[FullScreenPhotoController alloc] initWithNibName:@"FullScreenPhotoController" bundle:nil];
            self.fullScreenPhotoController = fullScreenController;
            [fullScreenController release];
        }
        [self.navigationController pushViewController:fullScreenPhotoController animated:YES];
    }
}


@end
