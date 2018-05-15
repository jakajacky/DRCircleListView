//
//  ViewController.m
//  CircleListViewDemo
//
//  Created by 张小强 on 2018/5/15.
//  Copyright © 2018年 张小强. All rights reserved.
//

#import "ViewController.h"
#import "DRCircleListView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DRCircleListView *cir = [[DRCircleListView alloc] initWithFrame:CGRectMake(0, 0, 1450, 1450)];
    cir.center = CGPointMake(375/2.0, 725-120+667);
    [self.view addSubview:cir];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
