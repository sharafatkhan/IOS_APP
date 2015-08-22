//
//  oLabelTextCell.m
//  P2PCamera
//
//  Created by Tsang on 13-1-15.
//
//

#import "oLabelTextCell.h"

@implementation oLabelTextCell
@synthesize keyLable;
@synthesize textField;
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
    self.keyLable=nil;
    self.textField=nil;
    [super dealloc];
}
@end
