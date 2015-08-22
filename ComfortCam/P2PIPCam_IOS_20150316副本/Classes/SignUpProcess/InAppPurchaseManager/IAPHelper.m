//
//  IAPHelper.m
//  app
//
//  Created by Hushain on 3/2/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import "IAPHelper.h"

//Method for alert view
inline static void showAlertScreen(NSString *title,NSString* alertMessage){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle: NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil)
                                              otherButtonTitles:nil];
    [alertView show];
}

@implementation IAPHelper
{
    NSArray *arrProductForSell;
}
@synthesize productPurchase;
@synthesize productRequest;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
       // arrProductForSell = [[NSArray alloc]initWithObjects:kPRODUCT_ID,nil];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

-(void)purchaseLessionWithLessonProduct:(NSString *)productID
{
    if ([SKPaymentQueue canMakePayments]) {
        
        //The list of product identifiers for the products you wish to retrieve descriptions of.
        NSSet *productIdentifier =[NSSet setWithObject:productID];
        
        if (self.productRequest) {
            self.productRequest = nil;
        }
        
        //nitializes the request with the set of product identifiers.
        self.productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:productIdentifier];
        self.productRequest.delegate = self;
        
        //Sends the request to the Apple App Store.
        [self.productRequest start];
        
    }
    else
    {
        showAlertScreen(NSLocalizedStringFromTable(@"Error2", @STR_LOCALIZED_FILE_NAME, nil), NSLocalizedStringFromTable(@"not_support_inApp", @STR_LOCALIZED_FILE_NAME, nil));
        if ([self.delegate respondsToSelector:@selector(failedPayment:)]) {
            [self.delegate failedPayment:nil];
        }
        
    }
}

#pragma mark - Make Payment -

//Method for make payment
-(void)makePaymentForProduct
{
    SKPayment *payment = [SKPayment paymentWithProduct:self.productPurchase];
    [[SKPaymentQueue defaultQueue]addPayment:payment];
}

- (void)dealloc
{
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [super dealloc];
}

- (void)restorePurchases {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - SKProductsRequestDelegate -
/*
 Called when the Apple App Store responds to the product request.
 Parameters:-
 request: The product request sent to the Apple App Store.
 response: Detailed information about the list of products.
 products: A list of products, one product for each valid product identifier provided in the        original request.
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    if ([self.delegate respondsToSelector:@selector(didReceivePurchaseResponce:)]) {
        [self.delegate didReceivePurchaseResponce:response];
    }
    //The array consists of a list of SKProduct objects.
    NSArray *products = response.products;
    
    self.productPurchase = [products count] >= 1 ? [products firstObject]: nil;
    if (self.productPurchase) {
        
        NSLog(@"Product title: %@", self.productPurchase.localizedTitle);
        NSLog(@"Product description: %@", self.productPurchase.localizedDescription);
        NSLog(@"Product price: %@", self.productPurchase.price);
        NSLog(@"Product id: %@", self.productPurchase.productIdentifier);
        
        //-- Make payment
        [self performSelectorOnMainThread:@selector(makePaymentForProduct) withObject:nil waitUntilDone:NO];
    }
    else
    {
        showAlertScreen(NSLocalizedStringFromTable(@"Error2", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"In_App_error", @STR_LOCALIZED_FILE_NAME, nil) );
        if ([self.delegate respondsToSelector:@selector(failedPayment:)]) {
            [self.delegate failedPayment:nil];
        }
        
    }
    
}


#pragma mark - SKPaymentTransactionObserver methods -

// Called when the transaction status is updated
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
        for (SKPaymentTransaction *transaction in transactions) {
            switch (transaction.transactionState)
            {
                case SKPaymentTransactionStatePurchasing:
                    [self transactionStart:transaction];
                    break;
                    
                case SKPaymentTransactionStatePurchased:
                    [self transactionComplete:transaction];
                    [[SKPaymentQueue defaultQueue]
                     finishTransaction:transaction];
                    break;
                    
                case SKPaymentTransactionStateFailed:
                    [self transactionFailed:transaction];
                    [[SKPaymentQueue defaultQueue]
                     finishTransaction:transaction];
                    break;
                case SKPaymentTransactionStateRestored:
                {
                    [self transactionRestored:transaction];
                    [[SKPaymentQueue defaultQueue]
                     finishTransaction:transaction];
                    break;
                }
                default:
                    break;
            }
        }
    
}

#pragma mark - Local method for mange transactions -

-(void)transactionStart:(SKPaymentTransaction *)transaction
{
    if([self.delegate respondsToSelector:@selector(startPayment:)]){
        [self.delegate startPayment:transaction];
    }
}

-(void)transactionComplete:(SKPaymentTransaction *)transaction
{
    if([self.delegate respondsToSelector:@selector(completePayment:)]){
        [self.delegate completePayment:transaction];
    }
    
}

-(void)transactionFailed:(SKPaymentTransaction *)transaction
{
    if ([self.delegate respondsToSelector:@selector(failedPayment:)]) {
        [self.delegate failedPayment:nil];
    }
    
}

-(void)transactionRestored:(SKPaymentTransaction *)transaction
{
    if([self.delegate respondsToSelector:@selector(restoredPayment:)]){
        [self.delegate restoredPayment:transaction];
    }
}

@end
