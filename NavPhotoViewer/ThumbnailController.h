//
//  ThumbnailController.h
//  NavPhotoViewer
//
//  Created by Jordan Gurrieri on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kThumbnailPortraitWidth 150
#define kThumbnailPortraitHeight 200
#define kThumbnailLandscapeWidth 266
#define kThumbnailLandscapeHeight 200

@class FullScreenPhotoController;

@interface ThumbnailController : UIViewController 
        <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
            FullScreenPhotoController *fullScreenPhotoController;
            UIImageView *imageView;
            UIButton *clearImageButton;
            UIButton *takePictureButton;
            UILabel *caption;
            UIImage *image;
            CGRect imageFrame;
}
@property (nonatomic, retain) FullScreenPhotoController *fullScreenPhotoController;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *clearImageButton;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UILabel *caption;
@property (nonatomic, retain) UIImage *image;

- (IBAction)shootPicture:(id)sender;
- (IBAction)selectExistingPicture:(id)sender;


@end
