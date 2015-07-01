//
//  ViewController.m
//  GETCache
//
//  Created by mac on 15/7/1.
//  Copyright (c) 2015年 CC. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
// 响应的 etag
@property (nonatomic, copy) NSString *etag;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

/**
 1. 请求是可变的，缓存策略要每次都从服务器加载
 2. 每次得到响应后，需要记录住 etag
 3. 下次发送请求的同时，将etag一起发送给服务器（由服务器比较内容是否发生变化）
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSURL *url = [NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/w%3D400/sign=da7c596d8501a18bf0eb134fae2e0761/21a4462309f79052c98a987f0ef3d7ca7acbd5de.jpg"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    
    // 发送 etag
    if (self.etag.length > 0) {
        [request setValue:self.etag forHTTPHeaderField:@"If-None-Match"];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"%@ %tu", response, data.length);
        // 类型转换（如果将父类设置给子类，需要强制转换）
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        // 判断响应的状态码是否是 304 Not Modified
        if (httpResponse.statusCode == 304) {
            NSLog(@"加载本地缓存图片");
            // 如果是，使用本地缓存
            // 根据请求获取到`被缓存的响应`！
            NSCachedURLResponse *cacheResponse =  [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
            // 拿到缓存的数据
            data = cacheResponse.data;
        }
        
        // 获取并且纪录 etag，区分大小写
        self.etag = httpResponse.allHeaderFields[@"Etag"];
        
        NSLog(@"%@", self.etag);
        
        self.iconView.image = [UIImage imageWithData:data];
    }];
}

@end
