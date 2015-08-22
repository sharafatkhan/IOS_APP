//
//  IAPHelper.h
//  app
//
//  Created by Hushain on 3/2/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol IAPHelperDelegate <NSObject>

@optional

- (void)didReceivePurchaseResponce:(SKProductsResponse *)response;
- (void)startPayment:(SKPaymentTransaction *)transaction;
- (void)completePayment:(SKPaymentTransaction *)transaction;
- (void)restoredPayment:(SKPaymentTransaction *)transactions;
- (void)failedPayment:(SKPaymentTransaction *)transaction;

@end

@interface IAPHelper : NSObject<SKPaymentTransactionObserver,SKProductsRequestDelegate>
{
    __weak id<IAPHelperDelegate> delegate;
}
@property (nonatomic, weak) id<IAPHelperDelegate> delegate;
@property (nonatomic,retain) SKProductsRequest *productRequest;
@property (nonatomic,retain) SKProduct *productPurchase;
-(void)purchaseLessionWithLessonProduct:(NSString *)productID;
- (void)restorePurchases;

@end
