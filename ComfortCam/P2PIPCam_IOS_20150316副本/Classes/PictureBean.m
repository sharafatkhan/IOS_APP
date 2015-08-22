//
//  PictureBean.m
//  P2PCamera
//
//  Created by Tsang on 14-5-20.
//
//

#import "PictureBean.h"

@implementation PictureBean
@synthesize path;
@synthesize img;
@synthesize indexpath;
@synthesize isLoaded;
@synthesize number;
-(void)dealloc{
    path=nil;
    img=nil;
    indexpath=nil;
    [super dealloc];
}
@end
