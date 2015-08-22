//
//  PicListIpadCell.m
//  P2PCamera
//
//  Created by Tsang on 13-6-18.
//
//

#import "PicListIpadCell.h"

@implementation PicListIpadCell
@synthesize imageView1;
@synthesize imageView2;
@synthesize imageView3;
@synthesize imageView4;
@synthesize imageView5;
@synthesize imageView6;
@synthesize imageView7;
@synthesize imageView8;
@synthesize imageView9;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier mFrame:(CGRect)mframe
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        imageView1=[[UIImageView alloc]init];
        imageView1.frame=CGRectMake(9, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView1];
        
        imageView2=[[UIImageView alloc]init];
        imageView2.frame=CGRectMake(imageView1.frame.origin.x+imageView1.frame.size.width+ 9, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView2];
        
        imageView3=[[UIImageView alloc]init];
        imageView3.frame=CGRectMake(imageView2.frame.origin.x+imageView2.frame.size.width+ 9, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView3];
        
        imageView4=[[UIImageView alloc]init];
        imageView4.frame=CGRectMake(imageView3.frame.origin.x+imageView3.frame.size.width+ 9, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView4];
        
        imageView5=[[UIImageView alloc]init];
        imageView5.frame=CGRectMake(imageView4.frame.origin.x+imageView4.frame.size.width+ 9, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView5];
        
        imageView6=[[UIImageView alloc]init];
        imageView6.frame=CGRectMake(imageView5.frame.origin.x+imageView5.frame.size.width+ 9, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView6];
        
        imageView7=[[UIImageView alloc]init];
        imageView7.frame=CGRectMake(imageView6.frame.origin.x+imageView6.frame.size.width+ 9, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView7];
        
        imageView8=[[UIImageView alloc]init];
        imageView8.frame=CGRectMake(imageView7.frame.origin.x+imageView7.frame.size.width+ 9, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView8];
        
        imageView9=[[UIImageView alloc]init];
        imageView9.frame=CGRectMake(imageView8.frame.origin.x+imageView8.frame.size.width+ 9, (mframe.size.height-75)/2, 75, 75);
        [self.contentView addSubview:imageView9];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
