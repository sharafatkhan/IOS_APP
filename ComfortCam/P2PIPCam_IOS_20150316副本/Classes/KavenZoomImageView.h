//
//  KavenZoomImageView.h
//  IOSDemo
//
//  Created by Tsang on 14-5-2.
//  Copyright (c) 2014年 Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KavenZoomImageViewDelegate<NSObject>
@optional

- (void)photoViewDidSingleTap:(int)index;

@end
@interface KavenZoomImageView : UIScrollView<UIScrollViewDelegate>
{
    UIImageView *imageView;
    CGPoint  pointToCenterAfterResize;
    CGFloat  scaleToRestoreAfterResize;
    id<KavenZoomImageViewDelegate>mdelegate;
}
@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,retain)id<KavenZoomImageViewDelegate>mdelegate;
- (void)prepareForReuse;
- (void)displayImage:(UIImage *)image Frame:(CGRect)mframe;
- (void)updateZoomScale:(CGFloat)newScale;
- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center;
@end
