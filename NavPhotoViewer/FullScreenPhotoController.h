//
//  FullScreenPhotoController.h
//  NavPhotoViewer
//
//  Created by Jordan Gurrieri on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FullScreenPhotoController : UIViewController {
    UIImageView *imageView;
    UILabel *caption;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *caption;

@end
