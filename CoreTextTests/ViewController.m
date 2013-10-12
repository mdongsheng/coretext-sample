//
//  ViewController.m
//  CoreTextTests
//
//  Created by 东升 on 13-9-18.
//  Copyright (c) 2013年 东升. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CoreTextView *textView = [[CoreTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:textView];
    [textView initText];
    
    [textView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
