//
//  KavenZoomImageView.m
//  IOSDemo
//
//  Created by Tsang on 14-5-2.
//  Copyright (c) 2014年 Tsang. All rights reserved.
//

#import "KavenZoomImageView.h"
#define kZoomStep 2
@implementation KavenZoomImageView
@synthesize imageView;
@synthesize mdelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)dealloc{
    mdelegate=nil;
    if (imageView!=nil) {
        [imageView release];
        imageView=nil;
    }
    [super dealloc];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupView];
}
- (void)setupView {
    self.delegate=self;
    self.imageView=nil;
    self.showsVerticalScrollIndicator=NO;
    self.showsHorizontalScrollIndicator=NO;
    self.bouncesZoom=YES;
    self.decelerationRate=UIScrollViewDecelerationRateFast;
    UITapGestureRecognizer *scrollViewDoubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleScrollViewDoubleTap:)];
    scrollViewDoubleTap.numberOfTapsRequired=2;
    [self addGestureRecognizer:scrollViewDoubleTap];
    [scrollViewDoubleTap release];
    UITapGestureRecognizer *scrollViewTwoFingerTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleScrollViewTwoFingerTap:)];
    scrollViewTwoFingerTap.numberOfTouchesRequired=2;
    [self addGestureRecognizer:scrollViewTwoFingerTap];
    [scrollViewTwoFingerTap release];
    UITapGestureRecognizer *scrollViewSingleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleScrollViewSingleTap:)];
    [self addGestureRecognizer:scrollViewSingleTap];
    [scrollViewSingleTap release];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize boundsSize=self.bounds.size;
    CGRect frameToCenter=self.imageView.frame;
    if (frameToCenter.size.width<boundsSize.width) {
        frameToCenter.origin.x=(boundsSize.width-frameToCenter.size.width)/2;
    }else{
        frameToCenter.origin.x=0;
    }
    if (frameToCenter.size.height<boundsSize.height) {
        frameToCenter.origin.y=(boundsSize.height-frameToCenter.size.height)/2;
    }else{
        frameToCenter.origin.y=0;
    }
    self.imageView.frame=frameToCenter;
    
    CGPoint contentOffset=self.contentOffset;
    if (frameToCenter.origin.x!=0.0) {
        contentOffset.x=0.0;
    }
    if (frameToCenter.origin.y!=0.0) {
        contentOffset.y=0.0;
    }
    self.contentOffset=contentOffset;
    self.contentInset=UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}
-(void)setFrame:(CGRect)frame{
    BOOL sizeChanging=!CGSizeEqualToSize(frame.size, self.frame.size);
    if (sizeChanging) {
        [self prepareToResize];
    }
    [super setFrame:frame];
    if (sizeChanging) {
        [self recoverFromResizing];
    }
}
- (void)prepareToResize {
    CGPoint boundsCenter=CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    pointToCenterAfterResize=[self convertPoint:boundsCenter toView:self.imageView];
    scaleToRestoreAfterResize=self.zoomScale;
    if (scaleToRestoreAfterResize<=self.minimumZoomScale+FLT_EPSILON) {
        scaleToRestoreAfterResize=0;
    }
}
- (void)recoverFromResizing {
    [self setMaxMinZoomScalesForCurrentBounds];
    CGFloat maxZoomScale=MAX(self.minimumZoomScale, scaleToRestoreAfterResize);
    self.zoomScale=MIN(self.maximumZoomScale, maxZoomScale);
    CGPoint boundsCenter=[self convertPoint:pointToCenterAfterResize fromView:self.imageView];
    CGPoint offset=CGPointMake(boundsCenter.x-self.bounds.size.width/2.0, boundsCenter.y-self.bounds.size.height/2.0);
    CGPoint maxOffset=[self maximumContentOffset];
    CGPoint minOffset=[self minimumContentOffset];
    CGFloat realMaxOffset=MIN(maxOffset.x, offset.x);
    offset.x=MAX(minOffset.x, realMaxOffset);
    realMaxOffset=MIN(maxOffset.y, offset.y);
    offset.y=MAX(minOffset.y, realMaxOffset);
    self.contentOffset=offset;
}
- (CGPoint)maximumContentOffset {
    CGSize contentSize=self.contentSize;
    CGSize boundsSize=self.bounds.size;
    return CGPointMake(contentSize.width-boundsSize.width, contentSize.height-boundsSize.height);
}
- (CGPoint)minimumContentOffset {
    return CGPointZero;
}
- (void)setMaxMinZoomScalesForCurrentBounds {
    CGSize boundsSize=self.bounds.size;
    CGFloat minScale=0.25;
    if (self.imageView.bounds.size.width>0.0&&self.imageView.bounds.size.height>0.0) {
        CGFloat xScale=boundsSize.width/self.imageView.bounds.size.width;
        CGFloat yScale=boundsSize.height/self.imageView.bounds.size.height;
        minScale=MIN(xScale, yScale);
        
    }
    CGFloat maxScale=minScale*(kZoomStep*2);
    self.maximumZoomScale=maxScale;
    self.minimumZoomScale=minScale;
}
#pragma mark--手势
-(void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (mdelegate!=nil) {
        [mdelegate photoViewDidSingleTap:self.tag];
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.zoomScale==self.maximumZoomScale) {
        [self updateZoomScaleWithGesture:gestureRecognizer newScale:self.minimumZoomScale];
    }else{
        CGFloat newScale=MIN(self.zoomScale*kZoomStep, self.maximumZoomScale);
        [self updateZoomScaleWithGesture:gestureRecognizer newScale:newScale];
    }
}
- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    CGFloat newScale=MAX([self zoomScale]/kZoomStep, self.minimumZoomScale);
    [self updateZoomScaleWithGesture:gestureRecognizer newScale:newScale];
    
    
}
- (void)handleDoubleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    
}
- (void)handleScrollViewDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.imageView.image==nil) {
        return;
    }
    CGPoint center=[self adjustPointIntoImageView:[gestureRecognizer locationInView:gestureRecognizer.view]];
    if (!CGPointEqualToPoint(center, CGPointZero)) {
        CGFloat newScale=MIN([self zoomScale]*kZoomStep, self.maximumZoomScale);
        [self updateZoomScale:newScale withCenter:center];
    }
}
- (void)handleScrollViewTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.imageView.image==nil) {
        return;
    }
    CGPoint center=[self adjustPointIntoImageView:[gestureRecognizer locationInView:gestureRecognizer.view]];
    if (!CGPointEqualToPoint(center, CGPointZero)) {
        CGFloat newScale=MAX([self zoomScale]/kZoomStep, self.minimumZoomScale);
        [self updateZoomScale:newScale withCenter:center];
    }
    
    
}
- (void)handleScrollViewSingleTap:(UIGestureRecognizer *)gestureRecognizer {
}
- (CGPoint)adjustPointIntoImageView:(CGPoint)center {
    BOOL contains=CGRectContainsPoint(self.imageView.frame, center);
    if (!contains) {
        center.x=center.x/self.zoomScale;
        center.y=center.y/self.zoomScale;
        
        CGRect imageViewBounds=self.imageView.bounds;
        
        center.x=MAX(center.x, imageViewBounds.origin.x);
        center.x=MIN(center.x, imageViewBounds.origin.x+imageViewBounds.size.height);
        
        center.y=MAX(center.y, imageViewBounds.origin.y);
        center.y=MIN(center.y, imageViewBounds.origin.y+imageViewBounds.size.width);
        
        return center;
    }
    return CGPointZero;
}
#pragma mark--Public
-(void)prepareForReuse{
    if (self.imageView!=nil) {
        for (UIGestureRecognizer *ges in self.imageView.gestureRecognizers) {
            [self.imageView removeGestureRecognizer:ges];
        }
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.imageView=nil;
}
-(void)displayImage:(UIImage *)image Frame:(CGRect)mframe{
    imageView=[[UIImageView alloc]initWithImage:image];
    imageView.contentMode=UIViewContentModeScaleToFill;
    imageView.frame=mframe;
    imageView.userInteractionEnabled=YES;
    [self addSubview:imageView];
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTwoFingerTap:)];
    UITapGestureRecognizer *doubleTwoFingerTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    [doubleTwoFingerTap setNumberOfTapsRequired:2];
    [doubleTwoFingerTap setNumberOfTouchesRequired:2];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [twoFingerTap requireGestureRecognizerToFail:doubleTwoFingerTap];
   
    [self.imageView addGestureRecognizer:singleTap];
    [self.imageView addGestureRecognizer:doubleTap];
    [self.imageView addGestureRecognizer:twoFingerTap];
    [self.imageView addGestureRecognizer:doubleTwoFingerTap];
    
    self.contentSize=self.imageView.frame.size;
    
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setZoomScale:self.minimumZoomScale animated:FALSE];
    
}

#pragma mark--Support 
- (void)updateZoomScale:(CGFloat)newScale {
    CGPoint center=CGPointMake(self.imageView.bounds.size.width/2.0, self.imageView.bounds.size.height/2.0);
    [self updateZoomScale:newScale withCenter:center];
}
- (void)updateZoomScaleWithGesture:(UIGestureRecognizer *)gestureRecognizer newScale:(CGFloat)newScale {
    CGPoint center=[gestureRecognizer locationInView:gestureRecognizer.view];
    [self updateZoomScale:newScale withCenter:center];
    
    
}
- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center {
    if (self.zoomScale!=newScale) {
        CGRect zoomRect=[self zoomRectForScale:newScale withCenter:center];
        [self zoomToRect:zoomRect animated:YES];
    }
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.width=self.frame.size.width/scale;
    zoomRect.size.height=self.frame.size.height/scale;
    zoomRect.origin.x=center.x-(zoomRect.size.width/2.0);
    zoomRect.origin.y=center.y-(zoomRect.size.height/2.0);
    return zoomRect;

}
#pragma  mark UIScrollViewDelegate
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
