//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Tom Owen on 4/18/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)enterPressed;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
- (IBAction)clearBrain;
@property (weak, nonatomic) IBOutlet UILabel *variablesDisplay;

@end
