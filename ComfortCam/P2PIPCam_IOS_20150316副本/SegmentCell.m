//
//  SegmentCell.m
//  P2PCamera
//
//  Created by Tsang on 13-6-26.
//
//

#import "SegmentCell.h"

@implementation SegmentCell
@synthesize label;
@synthesize segment;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc{
    label=nil;
    segment=nil;
    [super dealloc];
}
@end
