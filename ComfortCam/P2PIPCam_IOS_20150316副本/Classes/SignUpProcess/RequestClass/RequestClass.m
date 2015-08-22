//
//  RequestClass.m
//  P2PCamera
//
//  Created by MonuRathor on 11/01/15.
//
//

#import "RequestClass.h"

#define SERVER_URL @"http://ccadmin.comfortcam.com/webservices.php?"

@interface RequestClass ()
{
    NSOperationQueue *queue;
}

@end

@implementation RequestClass
@synthesize delegate;

- (void)makePostRequestFromDictionary:(NSDictionary *)param
{
    
    IpCameraClientAppDelegate *appDelegate = (IpCameraClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showLoadingView];

    
    NSString *parameterString = @"";
    for (NSString *aKey in [param allKeys])
    {
        parameterString = [parameterString stringByAppendingFormat:@"&%@=%@",aKey,[param valueForKey:aKey]];
    }
    NSData *postData = [parameterString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",SERVER_URL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [self startConnection:request];
}

- (void)startConnection:(NSURLRequest *)request
{
    if (!queue)
    {
        queue = [[NSOperationQueue alloc] init];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (!connectionError)
        {
            [self performSelectorOnMainThread:@selector(connectionSuccess:) withObject:data waitUntilDone:NO];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(connectionError:) withObject:connectionError waitUntilDone:NO];
        }
    }];
}

- (void)connectionSuccess:(id)result
{
    IpCameraClientAppDelegate *appDelegate = (IpCameraClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideLoadingView];

    
    NSError *error = nil;
    NSDictionary *dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
    if (error == nil)
    {
        if([[dictResult valueForKey:@"code"] integerValue] == 200)
        {
            [self connectionError:error withDictionary:dictResult];
        }
        else
        {
//            NSInteger errCode = [[dictResult valueForKey:@"code"] integerValue];
//            error = [NSError errorWithDomain:@"comfortcam" code:errCode userInfo:dictResult];
//            [self connectionError:error withDictionary:dictResult];
            
            if ([[dictResult valueForKey:@"status"] isEqualToString:@"ERROR"])
            {
                NSMutableDictionary *errDict = [NSMutableDictionary dictionary];
                [errDict setValue:[dictResult valueForKey:@"response"] forKey:NSLocalizedDescriptionKey];
                NSError *err = [NSError errorWithDomain:[dictResult valueForKey:@"code"] code:[[dictResult valueForKey:@"code"] intValue] userInfo:errDict];
                [self connectionError:err];
            }
        }
    }
    else if([[dictResult valueForKey:@"code"] integerValue] == 200)
    {
        if ([self.delegate respondsToSelector:@selector(connectionSuccess:andError:)])
        {
            [self.delegate connectionSuccess:result andError:nil];
        }
    }
    else
    {
        NSMutableDictionary *errDict = [NSMutableDictionary dictionary];
        NSString *disc = @"";
        NSString *errCode = @"";
        if (dictResult != nil)
        {
            disc = [dictResult valueForKey:@"response"];
            errCode = [dictResult valueForKey:@"code"];
        }
        
        if (disc.length == 0)
        {
            disc = @"Request time out";
            errCode = @"408";
        }
        
        if (dictResult != nil) {
            NSError *err = [NSError errorWithDomain:[dictResult valueForKey:@"code"] code:[[dictResult valueForKey:@"code"] intValue] userInfo:errDict];
            [self connectionError:err];
        }else
        {
            [self connectionError:nil];
        }
    }
    
}

- (void)connectionError:(NSError *)error
{
    
    IpCameraClientAppDelegate *appDelegate = (IpCameraClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideLoadingView];
    
    if ([self.delegate respondsToSelector:@selector(connectionSuccess:andError:)]) {
        [self.delegate connectionSuccess:nil andError:error];
    }
}


- (void)connectionError:(NSError *)error withDictionary:(NSDictionary *) paramDictionary
{
    if ([self.delegate respondsToSelector:@selector(connectionSuccess:andError:)])
    {
        [self.delegate connectionSuccess:paramDictionary andError:error];
    }
}

- (void)stopConnection{
    queue = nil;
}

@end
