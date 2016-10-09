//
//  TipViewController.m
//  Yanker1.0
//
//  Created by Guo Nice on 16/5/15.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:67/255.0 green:77/255.0 blue:105/255.0 alpha:1.0];
    [self.webView setScalesPageToFit:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://baike.baidu.com/link?url=-lEyRcu3u9jXoNGVMF_UeddJLlcfGUdApaDh-hhY2uzCn4V_1vfvdp6PPTPpsUl4068BvJll7AopRMCbb-vFFK"]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [webView stringByEvaluatingJavaScriptFromString:
     [NSString stringWithFormat:@"var script = document.createElement('script');"
      "script.type = 'text/javascript';"
      "script.text = \"function ResizeImages() { "
      "var myimg,oldwidth;"
      "var maxwidth = %f;" // UIWebView中显示的图片宽度
      "for(i=0;i <document.images.length;i++){"
      "myimg = document.images[i];"
      "if(myimg.width > maxwidth){"
      "oldwidth = myimg.width;"
      "myimg.width = maxwidth;"
      "}"
      "}"
      "}\";"
      "document.getElementsByTagName('head')[0].appendChild(script);",kWidth-15]];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}
@end
