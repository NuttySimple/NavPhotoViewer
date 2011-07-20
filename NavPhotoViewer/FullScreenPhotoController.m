//
//  FullScreenPhotoController.m
//  NavPhotoViewer
//
//  Created by Jordan Gurrieri on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FullScreenPhotoController.h"

@interface FullScreenPhotoController () 
@property (nonatomic, retain) NSTimer *fadeTimer;
- (void) fadeBarController;
- (void) fadeBarAway:(NSTimer *)timer;
- (void) fadeBarIn;
@end


@implementation FullScreenPhotoController

@synthesize imageView;
@synthesize caption;
@synthesize image;
@synthesize fadeTimer;

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
    [imageView release];
    [caption release];
    [image release];
    [fadeTimer release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad
{
    [self fadeBarController];
    
    imageView.image = image;
    caption.text = caption.text;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.imageView = nil;
    self.caption = nil;
    [self.fadeTimer invalidate];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Fade In/Out code
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *) event {
    [super touchesEnded:touches withEvent:event];
    [self fadeBarController];
}

- (void)fadeBarController {
    if (self.navigationController.navigationBar.alpha == 0)
    {
        [self fadeBarIn];
    }
    
    if (self.fadeTimer != nil)
    {			
        [self.fadeTimer invalidate];
    }
    self.fadeTimer  = [NSTimer
                       scheduledTimerWithTimeInterval:kNavigationBarFadeDelay target:self
                       selector:@selector(fadeBarAway:) userInfo:nil repeats:NO];
}

- (void)fadeBarAway:(NSTimer*)timer {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    self.navigationController.navigationBar.alpha = 0.0;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [UIView commitAnimations];
}

- (void)fadeBarIn {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    self.navigationController.navigationBar.alpha = 1.0;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView commitAnimations];
}


@end
