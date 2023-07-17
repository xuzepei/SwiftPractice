
#import <UIKit/UIKit.h>

@protocol HttpRequestDelegate <NSObject>
@optional
- (void) willStartHttpRequest: (id)token;
- (void) didFinishHttpRequest: (id)result token: (id)token;
- (void) didFailHttpRequest: (id)token;
- (void) updatePercentage: (float)percentage token: (id)token;
@end

typedef void (^ResultBlock)(NSDictionary* dict);
typedef void (^ResultImageBlock)(UIImage* image);

@interface HttpRequest : NSObject {

}

@property (nonatomic, strong)NSMutableData* receivedData;
@property (assign)BOOL isConnecting;
@property (nonatomic, weak)id delegate;
@property (assign)int statusCode;
@property (assign)int contentType;
@property (assign)int requestType;
@property (nonatomic, strong)NSString* requestingURL;
@property (nonatomic, strong)id token;
@property (assign)long long expectedContentLength;
@property (assign)long long currentLength;
@property (nonatomic, strong)NSURLConnection* urlConnection;
@property(assign)SEL resultSelector;
@property (nonatomic, strong)NSTimer* timeOutTimer;

@property (nonatomic, strong)NSURLSessionDataTask* dataTask;
@property (nonatomic, strong)NSURLSessionUploadTask* uploadTask;

@property (nonatomic, strong)ResultBlock resultBlock;
@property (nonatomic, strong)ResultImageBlock resultImageBlock;
@property (nonatomic, strong)NSString* jsonString;

+ (HttpRequest*)sharedInstance;
- (BOOL)request:(NSString*)urlString
	   delegate:(id)delegate
 resultSelector:(SEL)resultSelector //结果返回方法,仅限一个参数
		  token:(id)token;
- (BOOL)post:(NSString*)urlString token:(NSDictionary*)token withCompletionBlock:(ResultBlock)block;
- (void)cancel;
- (BOOL)get:(NSString*)urlString withCompletionBlock:(ResultBlock)block;
- (BOOL)refreshImage:(NSString*)urlString withCompletionBlock:(ResultBlock)block;


@end
