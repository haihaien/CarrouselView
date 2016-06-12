//
//  ViewController.m
//  ZYCarousel
//
//  Created by LeMo-test on 16/6/12.
//  Copyright © 2016年 LeMo-test. All rights reserved.
//

#import "ViewController.h"
#import "ZYCarouselView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZYCarouselView *biew = [[ZYCarouselView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 300) WithPageControlModel:0];
    biew.delegat=self;
    biew.ImageArrys=[@[[UIImage imageNamed:@"kk.jpg"],[UIImage imageNamed:@"ll.jpg"],[UIImage imageNamed:@"pp.jpg"],[UIImage imageNamed:@"aa.jpg"]]mutableCopy];
    [self.view addSubview:biew];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)ZYCarouseView:(ZYCarouselView *)View WithSelectedItemInfo:(id)info
{

    NSLog(@"%@",info);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
