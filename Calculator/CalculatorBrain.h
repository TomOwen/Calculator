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

@end
