//
//  DateTimeTwoLabelCell.m
//  P2PCamera
//
//  Created by Tsang on 13-8-14.
//
//

#import "DateTimeTwoLabelCell.h"

@implementation DateTimeTwoLabelCell
@synthesize labelname;
@synthesize labelvalue;
-(void)dealloc{
    labelvalue=nil;
    labelname=nil;
    [super dealloc];
}
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

@end
