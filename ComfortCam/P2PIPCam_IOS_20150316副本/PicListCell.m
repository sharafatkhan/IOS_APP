//
//  PicListCell.m
//  P2PCamera
//
//  Created by mac on 12-11-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PicListCell.h"

@implementation PicListCell

@synthesize imageView1;
@synthesize imageView2;
@synthesize imageView3;
@synthesize imageView4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier mFrame:(CGRect)mframe
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        imageView1=[[UIImageView alloc]init];
        imageView1.frame=CGRectMake(4, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView1];
        
        imageView2=[[UIImageView alloc]init];
        imageView2.frame=CGRectMake(imageView1.frame.origin.x+imageView1.frame.size.width+4, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView2];
        
        imageView3=[[UIImageView alloc]init];
        imageView3.frame=CGRectMake(imageView2.frame.origin.x+imageView2.frame.size.width+4, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView3];
        
        imageView4=[[UIImageView alloc]init];
        imageView4.frame=CGRectMake(imageView3.frame.origin.x+imageView3.frame.size.width+4, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView4];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc
{
    self.imageView1 = nil;
    self.imageView2 = nil;
    self.imageView3 = nil;
    self.imageView4 = nil;
    
    [super dealloc];
}

@end
