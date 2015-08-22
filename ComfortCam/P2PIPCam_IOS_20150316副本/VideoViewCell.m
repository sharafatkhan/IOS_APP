//
//  VideoViewCell.m
//  P2PCamera
//
//  Created by Tsang on 14-5-17.
//
//

#import "VideoViewCell.h"

@implementation VideoViewCell
@synthesize vidPicView1;
@synthesize vidPicView2;
@synthesize vidPicView3;
@synthesize vidPicView4;
@synthesize vidPicView5;
@synthesize vidPicView6;
@synthesize vidPicView7;
@synthesize vidPicView8;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier mFrame:(CGRect)frame
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        int top=5;
        self.backgroundColor=[UIColor clearColor];
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            vidPicView1=[[VideoPicView alloc]initWithFrame:CGRectMake(8, top, 70, frame.size.height)];
            [self.contentView addSubview:vidPicView1];
            vidPicView1.hidden=YES;
            vidPicView1.userInteractionEnabled=NO;
            vidPicView2=[[VideoPicView alloc]initWithFrame:CGRectMake(8+CGRectGetMaxX(vidPicView1.frame), top, 70, frame.size.height)];
            vidPicView2.hidden=YES;
            vidPicView2.userInteractionEnabled=NO;
            [self.contentView addSubview:vidPicView2];
            
            vidPicView3=[[VideoPicView alloc]initWithFrame:CGRectMake(8+CGRectGetMaxX(vidPicView2.frame), top, 70, frame.size.height)];
            vidPicView3.hidden=YES;
            vidPicView3.userInteractionEnabled=NO;
            [self.contentView addSubview:vidPicView3];
            
            vidPicView4=[[VideoPicView alloc]initWithFrame:CGRectMake(8+CGRectGetMaxX(vidPicView3.frame),top, 70, frame.size.height)];
            vidPicView4.hidden=YES;
            vidPicView4.userInteractionEnabled=NO;
            [self.contentView addSubview:vidPicView4];
            
        }else{
            vidPicView1=[[VideoPicView alloc]initWithFrame:CGRectMake(8, top, 86, frame.size.height)];
            vidPicView1.hidden=YES;
            vidPicView1.userInteractionEnabled=NO;
            [self.contentView addSubview:vidPicView1];
            
            vidPicView2=[[VideoPicView alloc]initWithFrame:CGRectMake(8+CGRectGetMaxX(vidPicView1.frame), top, 86, frame.size.height)];
            vidPicView2.hidden=YES;
            vidPicView2.userInteractionEnabled=NO;
            [self.contentView addSubview:vidPicView2];
            
            vidPicView3=[[VideoPicView alloc]initWithFrame:CGRectMake(8+CGRectGetMaxX(vidPicView2.frame), top, 86, frame.size.height)];
            vidPicView3.hidden=YES;
            vidPicView3.userInteractionEnabled=NO;
            [self.contentView addSubview:vidPicView3];
            
            vidPicView4=[[VideoPicView alloc]initWithFrame:CGRectMake(8+CGRectGetMaxX(vidPicView3.frame), top, 86, frame.size.height)];
            vidPicView4.hidden=YES;
            vidPicView4.userInteractionEnabled=NO;
            [self.contentView addSubview:vidPicView4];
           
            vidPicView5=[[VideoPicView alloc]initWithFrame:CGRectMake(8+CGRectGetMaxX(vidPicView4.frame), top, 86, frame.size.height)];
            vidPicView5.hidden=YES;
            vidPicView5.userInteractionEnabled=NO;
            [self.contentView addSubview:vidPicView5];
            
            vidPicView6=[[VideoPicView alloc]initWithFrame:CGRectMake(8+CGRectGetMaxX(vidPicView5.frame), top, 86, frame.size.height)];
            vidPicView6.hidden=YES;
            vidPicView6.userInteractionEnabled=NO;
            [self.contentView addSubview:vidPicView6];
            
            vidPicView7=[[VideoPicView alloc]initWithFrame:CGRectMake(8+CGRectGetMaxX(vidPicView6.frame), top, 86, frame.size.height)];
            vidPicView7.hidden=YES;
            vidPicView7.userInteractionEnabled=NO;
            [self.contentView addSubview:vidPicView7];
            
            vidPicView8=[[VideoPicView alloc]initWithFrame:CGRectMake(8+CGRectGetMaxX(vidPicView7.frame), top, 86, frame.size.height)];
            vidPicView8.hidden=YES;
            vidPicView8.userInteractionEnabled=NO;
            [self.contentView addSubview:vidPicView8];
        }
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
