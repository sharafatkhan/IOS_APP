//
//  MySegmentControl.h
//  P2PCamera
//
//  Created by Tsang on 14-4-10.
//
//

#import <UIKit/UIKit.h>
@protocol MySegmentControlDelegate<NSObject>
-(void)segmentSelectedIndex:(int)index;
@end
@interface MySegmentControl : UIView
{
    NSMutableArray *btnArr;
    id<MySegmentControlDelegate>delegate;
}
@property (nonatomic,retain)id<MySegmentControlDelegate>delegate;
- (id)initWithFrame:(CGRect)frame segmentNumber:(int)num;
-(void)setSegmentImage:(UIImage *)img ForStatus:(UIControlState)status Index:(int)index;
-(void)setSegmentTitle:(NSString *)title Index:(int)index;
-(void)setSegmentBackgroundColor:(UIColor *)color Index:(int)index;
-(void)setSegmentSelected:(BOOL)flag Index:(int)index;
-(void)setSegmentTitleColor:(UIColor *)color ForStatus:(UIControlState)status Index:(int)index;
-(void)setSegmentBackgroundImageWithColor:(UIColor*)color ForState:(UIControlState)state Index:(int)index;
@end
