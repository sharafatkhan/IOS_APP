//
//  VideoPicView.h
//  P2PCamera
//
//  Created by Tsang on 14-5-17.
//
//

#import <UIKit/UIKit.h>
@protocol VideoPicViewDelegate<NSObject>
-(void)videoPicViewPressed:(int)index;
@end
@interface VideoPicView : UIView
{
    UIImageView *imageView;
    UIImageView *flagImgView;
    UIImageView *hookImgView;
    UILabel *line;
    UILabel *labelTime;
    UILabel *labelSize;
    id<VideoPicViewDelegate>delegate;
}
@property (nonatomic,assign)id<VideoPicViewDelegate>delegate;
@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,retain)UIImageView *flagImgView;
@property (nonatomic,retain)UIImageView *hookImgView;
@property (nonatomic,retain)UILabel *line;
@property (nonatomic,retain)UILabel *labelTime;
@property (nonatomic,retain)UILabel *labelSize;

@end
