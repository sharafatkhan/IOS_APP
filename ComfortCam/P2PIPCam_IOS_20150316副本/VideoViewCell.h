//
//  VideoViewCell.h
//  P2PCamera
//
//  Created by Tsang on 14-5-17.
//
//

#import <UIKit/UIKit.h>
#import "VideoPicView.h"
@interface VideoViewCell : UITableViewCell
{
    VideoPicView *vidPicView1;
    VideoPicView *vidPicView2;
    VideoPicView *vidPicView3;
    VideoPicView *vidPicView4;
    VideoPicView *vidPicView5;
    VideoPicView *vidPicView6;
    VideoPicView *vidPicView7;
    VideoPicView *vidPicView8;
    
    
}

@property (nonatomic,retain)VideoPicView *vidPicView1;
@property (nonatomic,retain)VideoPicView *vidPicView2;
@property (nonatomic,retain)VideoPicView *vidPicView3;
@property (nonatomic,retain)VideoPicView *vidPicView4;
@property (nonatomic,retain)VideoPicView *vidPicView5;
@property (nonatomic,retain)VideoPicView *vidPicView6;
@property (nonatomic,retain)VideoPicView *vidPicView7;
@property (nonatomic,retain)VideoPicView *vidPicView8;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier mFrame:(CGRect)frame;
@end
