//
//  oLabelTextCell.h
//  P2PCamera
//
//  Created by Tsang on 13-1-15.
//
//

#import <UIKit/UIKit.h>

@interface oLabelTextCell : UITableViewCell
{
    IBOutlet UILabel *keyLable;
    IBOutlet UITextField *textField;

}
@property (nonatomic, retain) UILabel *keyLable;
@property (nonatomic, retain) UITextField *textField;
@end
