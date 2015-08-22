    //
//  StartViewController.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StartViewController.h"
#import "obj_common.h"



@implementation StartViewController

@synthesize versionLabel;
@synthesize imgView;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate
{
    
	return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    
	return UIInterfaceOrientationMaskPortrait;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];
    NSString *strVersion = [NSString stringWithFormat:@"Ver %s", STR_VERSION_NO];    
    versionLabel.text = strVersion;
    CGRect mainScreen=[[UIScreen mainScreen]bounds];
    CGRect lFrame=versionLabel.frame;
    imgView.frame=CGRectMake(0,0,mainScreen.size.width,mainScreen.size.height);
    versionLabel.frame=CGRectMake((mainScreen.size.width-lFrame.size.width)/2, (mainScreen.size.height-lFrame.size.height)-50, lFrame.size.width, lFrame.size.height);
    versionLabel.hidden=YES;
   
}
-(void)viewWillAppear:(BOOL)animated{
   
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [versionLabel release];
    [imgView release];
    [super dealloc];
}


@end
