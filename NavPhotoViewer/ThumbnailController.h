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


@interface ThumbnailController : UIViewController 
        <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
            UIImageView *imageView;
            UIButton *takePictureButton;
            UIImage *image;
            CGRect imageFrame;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) UIImage *image;

- (IBAction)shootPicture:(id)sender;
- (IBAction)selectExistingPicture:(id)sender;


@end
