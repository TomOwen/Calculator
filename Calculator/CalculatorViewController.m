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
@property (nonatomic, strong) NSDictionary *testVariableValues;
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
// lazy instantiation with setter
- (NSDictionary *) testVariableValues {
    if (!_testVariableValues) _testVariableValues = [[NSDictionary alloc]init];
    return _testVariableValues;
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
- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    [self.brain pushVariable:sender.currentTitle];
    self.display.text = sender.currentTitle;
    
}
- (IBAction)testPressed:(UIButton *)sender {
    //the next line is to test if NSSet variablesSetUsedInProgram works
    //NSLog(@"NSSet is: %@",[CalculatorBrain variablesUsedInProgram:self.brain.program]);
    
    //set testVariableValues to some preset testing values
    if ([sender.currentTitle isEqualToString:@"Test 1"]) {
        self.testVariableValues=[NSDictionary dictionaryWithObjectsAndKeys:@"3",@"a",@"4",@"b",@"10",@"x", nil];
    }
    if ([sender.currentTitle isEqualToString:@"Test 2"]) {
        self.testVariableValues=[NSDictionary dictionaryWithObjectsAndKeys:@"-3",@"a",@"-4",@"b",@"-10",@"x", nil];
    }
    if ([sender.currentTitle isEqualToString:@"Test 3"]) {
        self.testVariableValues=nil;
    }
    //run program
    double result=[[self.brain class] runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g",result];
}
@end
