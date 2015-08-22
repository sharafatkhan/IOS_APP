//
//  RequestClass.h
//  P2PCamera
//
//  Created by MonuRathor on 11/01/15.
//
//

#import <Foundation/Foundation.h>

@protocol RequestClassDelegate <NSObject>

- (void)connectionSuccess:(id)result andError:(NSError *)error;

@end

@interface RequestClass : NSObject
{
    __weak id<RequestClassDelegate> delegate;
}
@property (nonatomic, weak) id<RequestClassDelegate> delegate;
- (void)makePostRequestFromDictionary:(NSDictionary *)param;
- (void)stopConnection;
@end
