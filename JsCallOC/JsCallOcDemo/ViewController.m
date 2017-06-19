//
//  ViewController.m
//  JsCallOcDemo
//
//  Created by zhang on 2017/6/15.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>

@interface ViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,weak)UIWebView *webView ;

@property (nonatomic,weak)IBOutlet UILabel *showTop;
@property (nonatomic,weak)IBOutlet UILabel *showCenter;
@property (nonatomic,weak)IBOutlet UILabel *showBottom;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //创建webView
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    webView.delegate = self;
    webView.scrollView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    
    //html    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Test" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    //加载HTML
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"scheme = %@",request.URL.scheme);
    NSLog(@"absoluteString = %@",request.URL.absoluteString);
//    NSString
    NSArray *array = [request.URL.absoluteString componentsSeparatedByString:@"?"];
    NSLog(@"array = %@",array);
    //判断连接是否存在
    if ([request.URL.scheme isEqualToString:@"clickp"]) {
        //说明没有参数
        if (array.count==1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
            SEL sel = NSSelectorFromString(request.URL.scheme);
            [self performSelector:sel withObject:nil withObject:nil];
#pragma clang diagnostic pop
        }else if(array.count == 2){//说明有1个参数
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:",request.URL.scheme]);
            [self performSelector:sel withObject:[array lastObject] withObject:nil];
#pragma clang diagnostic pop

        }else if (array.count == 3){//说明有2个参数
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:message:",request.URL.scheme]);
            [self performSelector:sel withObject:array[1] withObject:[array lastObject]];
#pragma clang diagnostic pop
        }

    }
    
    return YES;
}

- (void)clickp{
    self.showTop.text = @"点击了第一个p标签";
}


- (void)clickp:(NSString *)message{
   NSString *new =  [message stringByRemovingPercentEncoding];
   self.showCenter.text = new;
}

- (void)clickp:(NSString *)firstMessage message:(NSString *)lastMessage{
    NSString *firstParam = [firstMessage stringByRemovingPercentEncoding];
    NSString *lastParam = [lastMessage stringByRemovingPercentEncoding];
    self.showBottom.text = [NSString stringWithFormat:@"%@ %@",firstParam,lastParam];
}


- (IBAction)clickClear:(id)sender{
    self.showTop.text = nil;
    self.showCenter.text = nil;
    self.showBottom.text = nil;
}


@end
