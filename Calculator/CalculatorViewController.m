//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Tom Owen on 4/18/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (strong, nonatomic) IBOutlet UILabel *testVariableValues;
@end

@implementation CalculatorViewController
@synthesize historyLabel = _historyLabel;
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;
// first commit .......
- (CalculatorBrain *) brain 
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    // only allow a single . to be entered
    if ([digit isEqualToString:@"."]) {
        // check display if more than one entered beep
        NSRange range = [self.display.text rangeOfString:@"."];
        if (range.length > 0) return;
    }
    if (userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text =digit;
        userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    // log to historylabel
    self.historyLabel.text = [self.historyLabel.text stringByAppendingFormat:@"%@ ",operation];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.historyLabel.text = [self.historyLabel.text stringByAppendingFormat:@"%@ ",self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
- (void)viewDidUnload {
    [self setHistoryLabel:nil];
    [self setTestVariableValues:nil];
    [super viewDidUnload];
}
- (IBAction)clearBrain {
    self.historyLabel.text = @"";
    self.display.text = @"";
    self.brain = Nil;
}
- (IBAction)testPressed:(UIButton *)sender {
}
- (IBAction)variablePressed:(UIButton *)sender {
}
@end
