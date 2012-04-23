//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Tom Owen on 4/18/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *) programStack
{
    if (!_programStack ){
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void) pushOperand:(double)operand 
{
    NSNumber *programStack = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:programStack];
}
- (double) performOperation:(NSString *)operation 
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}
// only implement getter for program (readonly)
- (id)program
{
    return [self.programStack copy];
}
+ (NSString *) descriptionOfProgram:(id)program
{
    return @"implement this in assignment 2";
}
+ (double) popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    if ([topOfStack isKindOfClass: [NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass: [NSString class]]) {
        NSString *operation = topOfStack;
        if  ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double pop1 = [self popOperandOffStack:stack];
            double pop2 = [self popOperandOffStack:stack];
            result = pop2 - pop1;
        } else if ([operation isEqualToString:@"/"]) {
            double operand1 = [self popOperandOffStack:stack];
            double operand2 = [self popOperandOffStack:stack];
            if (operand1) {
                result = operand2/operand1;
            }
        } else if ([operation isEqualToString:@"π"]) {
            result = 3.14159;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        }
    }
    
    return result;
}
+ (double) runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}
@end
