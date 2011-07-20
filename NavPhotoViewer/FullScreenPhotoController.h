//
//  FullScreenPhotoController.h
//  NavPhotoViewer
//
//  Created by Jordan Gurrieri on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNavigationBarFadeDelay 5.5

@interface FullScreenPhotoController : UIViewController {
    UIImageView *imageView;
    UILabel *caption;
    UIImage *image;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *caption;
@property (nonatomic, retain) UIImage *image;

@end
