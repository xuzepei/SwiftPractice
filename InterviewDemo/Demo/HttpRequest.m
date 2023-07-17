

#import "HttpRequest.h"


@implementation HttpRequest

+ (HttpRequest*)sharedInstance
{
    static HttpRequest* sharedInstance = nil;
    if(nil == sharedInstance)
    {
        @synchronized([HttpRequest class])
        {
            if (nil == sharedInstance)
            {
                sharedInstance = [[HttpRequest alloc] init];
            }
        }
    }
    
    return sharedInstance;
}

- (id)init
{
	if(self = [super init])
	{
		_receivedData = [[NSMutableData alloc] init];
		_isConnecting = NO;
		_contentType = 0;
		_requestType = 0;
		_expectedContentLength = 0;
		_currentLength = 0;
	}
	
	return self;
}

- (void)dealloc
{
    if (_timeOutTimer) {
        [_timeOutTimer invalidate];
        _timeOutTimer = nil;
    }
    
	self.isConnecting = NO;
    self.receivedData = nil;
    self.requestingURL = nil;
    self.token = nil;
	self.urlConnection = nil;
    
    self.dataTask = nil;
    self.uploadTask = nil;
    self.resultBlock = nil;
	
    //[super dealloc];
}

- (void)cancel
{
    if (_timeOutTimer) {
        [_timeOutTimer invalidate];
        _timeOutTimer = nil;
    }
    
    if(_urlConnection)
    {
        [_urlConnection cancel];
    }
    
    _isConnecting = NO;
    self.receivedData = nil;
	self.urlConnection = nil;
}

- (BOOL)request:(NSString*)urlString delegate:(id)delegate resultSelector:(SEL)resultSelector token:(id)token
{
    if(0 == [urlString length] || _isConnecting)
        return NO;
    
    self.resultSelector = resultSelector;
	self.delegate = delegate;
	self.token = token;
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	self.requestingURL = urlString;
	//urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	[request setURL:[NSURL URLWithString: urlString]];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setTimeoutInterval: 5];
	[request setHTTPShouldHandleCookies:FALSE];
	[request setHTTPMethod:@"GET"];
    
    NSLog(@"request:%@",_requestingURL);
	
    BOOL isSuccess = YES;
    
    NSURLConnection * urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
	if (urlConnection)
	{
        self.urlConnection = urlConnection;
        
		_isConnecting = YES;
		[_receivedData setLength: 0];
		//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
        //		if([_delegate respondsToSelector: @selector(willStartHttpRequest:)])
        //			[_delegate willStartHttpRequest:nil];
	}
    else
    {
        isSuccess = NO;
    }
    
    return isSuccess;
}

- (NSDictionary*)parseToDictionary:(NSData*)data
{
    if(nil == data)
        return nil;
    
    NSError* error = nil;
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if(error)
    {
        NSLog(@"parse errror:%@",[error localizedDescription]);
        return nil;
    }
    
    if([json isKindOfClass:[NSDictionary class]])
    {
        return (NSDictionary *)json;
    }
    
    return nil;
}

- (BOOL)post:(NSString*)urlString token:(NSDictionary*)token withCompletionBlock:(ResultBlock)block
{
    if(0 == [urlString length] || _isConnecting)
        return NO;
    
    self.resultBlock = block;
	self.token = token;
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	self.requestingURL = urlString;
	urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters: NSCharacterSet.URLQueryAllowedCharacterSet];
	[request setURL:[NSURL URLWithString: urlString]];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	//[request setTimeoutInterval: 20];
	[request setHTTPShouldHandleCookies:FALSE];
	[request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    self.token = [NSString stringWithFormat:@"client_id=ro.client&client_secret=secret&grant_type=password&scope=openid profile offline_access api.resource.full&username=%@&password=%@",[self.token objectForKey:@"username"],[self.token objectForKey:@"password"]];
    NSString* body = (NSString*)_token;
    if([body length])
    {
        [request setHTTPBody: [body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSLog(@"post:%@",_requestingURL);
	
    BOOL isSuccess = YES;
    self.isConnecting = YES;

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        self.isConnecting = NO;
        
        if (error) {
            NSLog(@"Error performing request: %@", error.localizedDescription);
        }
        
        [self connectionDidFinish:data response:response error:error];
        
    }];
    [task resume];
    
    return isSuccess;
}


- (void)connectionDidFinish:(NSData*)data response:(NSURLResponse*)response error:(NSError*)error
{
    long statusCode = 0;
    if(response)
    {
        statusCode = (long)[(NSHTTPURLResponse*)response statusCode];
    }
    
    NSDictionary* dict = nil;
    if(200 == statusCode)
    {
        dict = [self parseToDictionary: data];
        //NSLog(@"dict: %@",dict);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(self.resultBlock)
        {
            self.resultBlock(dict);
        }
        
    });
}

- (BOOL)refreshImage:(NSString*)urlString withCompletionBlock:(ResultBlock)block
{
    if(0 == [urlString length] || _isConnecting)
        return NO;
    
    self.resultBlock = block;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    self.requestingURL = urlString;
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters: NSCharacterSet.URLQueryAllowedCharacterSet];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 20];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters = [NSUserDefaults.standardUserDefaults objectForKey:@"access_token"];
    NSString* accessToken = [parameters objectForKey:@"access_token"];
    NSString* token_type = [parameters objectForKey:@"token_type"];
    NSString* temp = [NSString stringWithFormat:@"%@ %@",token_type,accessToken];
    [request setValue:temp forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"request:%@",_requestingURL);
    
    self.isConnecting = YES;

    NSURLSession *session = [NSURLSession sharedSession];
    self.dataTask = [session dataTaskWithRequest:request
                               completionHandler:
                     ^(NSData *data, NSURLResponse *response, NSError *error) {
                         
                         self.dataTask = nil;
                         self.isConnecting = NO;
        
        if(error)
        {
            NSLog(@"error: %@",[error localizedDescription]);
        }
                         
        long statusCode = 0;
        if(response)
        {
            statusCode = (long)[(NSHTTPURLResponse*)response statusCode];
        }
        
        NSDictionary* dict = nil;
        if(200 == statusCode)
        {
            if(data)
            {

                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; // Convert NSData to NSString
                
                if(str == nil || 0 == str.length)
                {
                    NSString* path = [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), @"/video.mp4"];
                    dict = @{@"result":@"1", @"path":path};
                    [data writeToFile:path atomically:YES];
                } else {
                    NSLog(@"%@", str); // Output: "hello"
                    dict = @{@"result":@"0"};
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.resultBlock)
            {
                self.resultBlock(dict);
            }
            
        });
                     }];
    
    [self.dataTask resume];
    
    return YES;
}

- (BOOL)get:(NSString*)urlString withCompletionBlock:(ResultBlock)block
{
    if(0 == [urlString length] || _isConnecting)
        return NO;
    
    self.resultBlock = block;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    self.requestingURL = urlString;
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters: NSCharacterSet.URLQueryAllowedCharacterSet];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 20];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters = [NSUserDefaults.standardUserDefaults objectForKey:@"access_token"];
    NSString* accessToken = [parameters objectForKey:@"access_token"];
    NSString* token_type = [parameters objectForKey:@"token_type"];
    NSString* temp = [NSString stringWithFormat:@"%@ %@",token_type,accessToken];
    [request setValue:temp forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"request:%@",_requestingURL);
    
    self.isConnecting = YES;

    NSURLSession *session = [NSURLSession sharedSession];
    self.dataTask = [session dataTaskWithRequest:request
                               completionHandler:
                     ^(NSData *data, NSURLResponse *response, NSError *error) {
                         
                         self.dataTask = nil;
                         self.isConnecting = NO;
                         
                         [self connectionDidFinish:data response:response error:error];
                     }];
    
    [self.dataTask resume];
    
    return YES;
}


@end
