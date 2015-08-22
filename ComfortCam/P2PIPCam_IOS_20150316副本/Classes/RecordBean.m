//
//  RecordBean.m
//  P2PCamera
//
//  Created by Tsang on 14-5-19.
//
//

#import "RecordBean.h"

@implementation RecordBean
@synthesize path;
@synthesize size;
@synthesize img;
@synthesize indexpath;
@synthesize isLoaded;
@synthesize number;
-(void)dealloc{
    path=nil;
    size=nil;
    img=nil;
    indexpath=nil;
    [super dealloc];
}
@end
