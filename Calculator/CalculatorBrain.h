//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Tom Owen on 4/18/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
- (void) pushOperand: (double)operand;
- (double) performOperation: (NSString *)operation;
- (void)pushVariable:(NSString *)variable;
- (void) clearTopOfProgramStack;
@property (readonly) id program;
+ (double) runProgram:(id)program;
// new version for the intelligent calculator with variables
+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
// special one off to display variables and values in the test case
+ (NSSet *) variablesUsedInProgram:(id)program;
+ (NSString *) descriptionOfProgram:(id)program;

@end
