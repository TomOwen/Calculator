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
    NSNumber *programStackEntered = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:programStackEntered];
}
- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject:variable];
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
+ (double) popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    if ([topOfStack isKindOfClass: [NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass: [NSString class]]) {
        NSString *operation = topOfStack;
        if  ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double pop1 = [self popOperandOffProgramStack:stack];
            double pop2 = [self popOperandOffProgramStack:stack];
            result = pop2 - pop1;
        } else if ([operation isEqualToString:@"/"]) {
            double operand1 = [self popOperandOffProgramStack:stack];
            double operand2 = [self popOperandOffProgramStack:stack];
            if (operand1) {
                result = operand2/operand1;
            }
        } else if ([operation isEqualToString:@"π"]) {
            result = 3.14159;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
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
    return [self popOperandOffProgramStack:stack];
}
+(double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) stack = [program mutableCopy];
    //loop to replace variables with conrisponding values in dictionary
    for (int i=0; i<[stack count]; i++) {
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"a"]){
            //convert NSString object to NSNumber object
            NSString *myString=[variableValues valueForKey:@"a"];
            NSNumber *myNumber=[NSNumber numberWithDouble:[myString doubleValue]];
            //replace "a" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber]; 
        } 
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"b"]){
            //convert NSString object to NSNumber object
            NSString *myString=[variableValues valueForKey:@"b"];
            NSNumber *myNumber=[NSNumber numberWithDouble:[myString doubleValue]];
            //replace "b" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber]; 
        } 
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"x"]){
            //convert NSString object to NSNumber object
            NSString *myString=[variableValues valueForKey:@"x"];
            NSNumber *myNumber=[NSNumber numberWithDouble:[myString doubleValue]];
            //replace "x" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber]; 
        } 
    }
    return [self popOperandOffProgramStack:stack];
}
+ (NSSet *)variablesUsedInProgram:(id)program{
    //check if program contains variables
    NSSet *variablesSetUsedInProgram;
    if (!variablesSetUsedInProgram) variablesSetUsedInProgram =[[NSSet alloc]init];
    if ([program containsObject:@"a"]) variablesSetUsedInProgram=[variablesSetUsedInProgram setByAddingObject:@"a"];
    if ([program containsObject:@"b"]) variablesSetUsedInProgram=[variablesSetUsedInProgram setByAddingObject:@"b"];
    if ([program containsObject:@"x"]) variablesSetUsedInProgram=[variablesSetUsedInProgram setByAddingObject:@"x"];
    if ([variablesSetUsedInProgram count] ==0) variablesSetUsedInProgram =nil;
    return variablesSetUsedInProgram;
}
@end
