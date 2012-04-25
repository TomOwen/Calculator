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
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack=[program mutableCopy];
    }
    return [self descriptionOfTopOfStack:stack];
}
//check if an nsstring is an operation
+ (BOOL)isOperation:(NSString *)operation{
    BOOL result=0;
    NSSet *operationSet=[NSSet setWithObjects:@"+",@"-",@"*",@"/",@"sin",@"cos",@"sqrt", nil];
    if ([operationSet containsObject:operation] ) result= 1;
    return result;
}
//compare two operations' priority
+ (BOOL) compareOperationPriority:(NSString *)firstOperation vs:(NSString *)secondOperation{
    BOOL result=0;
    NSDictionary *operationPriority= [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"+",@"1",@"-",@"2",@"*",@"2",@"/",@"3",@"sin",@"3",@"cos",@"3",@"sqrt", nil];
    int firstOperationLevel=[[operationPriority objectForKey:firstOperation] intValue];
    int secondOperationLevel;
    if (secondOperation) {
        secondOperationLevel=[[operationPriority objectForKey:secondOperation] intValue];
        if (firstOperationLevel>secondOperationLevel)  result=1;
    }
    return result;
}
//get rid of unnecessary parienthese by comparing the last and the secondlast operation
+(NSString *) surpressParienthese:(NSString *)description{
    NSMutableArray *descriptionArray=[[description componentsSeparatedByString:@" "] mutableCopy];
    
    NSString *lastOperation,*secondLastOperation;
    for (int i=[descriptionArray count]-1; i>0 && !lastOperation; i--) {
        if([CalculatorBrain isOperation:[descriptionArray objectAtIndex:i]]){
            lastOperation=[descriptionArray objectAtIndex:i];//last operation found
            
            for (int j=i-1; j>0 && !secondLastOperation; j--) {
                if ([CalculatorBrain isOperation:[descriptionArray objectAtIndex:j]]) {
                    secondLastOperation=[descriptionArray objectAtIndex:j];
                    
                }
            }
            if (![CalculatorBrain compareOperationPriority:lastOperation vs:secondLastOperation]) {
                [descriptionArray removeObjectAtIndex:i-1];
                [descriptionArray removeObjectAtIndex:0];
            }
            
        }
    }
    
    description=[[descriptionArray valueForKey:@"description"] componentsJoinedByString:@" "];
    return description;
}

+ (NSString *) descriptionOfTopOfStack: (NSMutableArray *)stack{
    NSString *description = @"";
    
    id topOfStack=[stack lastObject];
    [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]]) description=[topOfStack stringValue];
    
    else if([topOfStack isKindOfClass:[NSString class]])
    {
        
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"twoOperandOperation"])
        {
            NSString *second=[CalculatorBrain descriptionOfTopOfStack:stack];
            NSString *first=[CalculatorBrain descriptionOfTopOfStack:stack];
            description=[NSString stringWithFormat:@"( %@ ) %@ %@",first,topOfStack,second];
            NSLog(@"2operand description = '%@'",description);
            description=[CalculatorBrain surpressParienthese: description];  //only two operand operation needs to surpress 
        }
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"singleOperandOperation"]) {
            description=[NSString stringWithFormat:@"%@ ( %@ )",topOfStack,[CalculatorBrain descriptionOfTopOfStack:stack]];
        }
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"noOperandOperation"]) {
            description=[NSString stringWithFormat:@"%@",topOfStack];
        }
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"variable"]) {
            description=topOfStack;
        }
    }
    //check if description has "null" in the case of user pressed operation withoud operand before
    NSRange nsrange=[description rangeOfString:@"null"];
    if (nsrange.location!=NSNotFound) {
        description=@"operand not entered";
    }
    return description;
}
//private method to determine a string's type
+ (NSString *) typeOfString:(NSString *)string{
    NSSet *twoOperandOperation=[NSSet setWithObjects:@"+",@"-",@"*",@"/", nil];
    NSSet *singleOperandOperation=[NSSet setWithObjects:@"sqrt",@"sin",@"cos", nil];
    NSSet *noOperandOperation=[NSSet setWithObjects:@"pi", nil];
    NSSet *variable=[NSSet setWithObjects:@"a",@"b",@"x", nil];
    if ([twoOperandOperation containsObject:string])return @"twoOperandOperation";
    else if ([singleOperandOperation containsObject:string])return @"singleOperandOperation";
    else if ([noOperandOperation containsObject:string])return @"noOperandOperation";
    else if ([variable containsObject:string]) return @"variable";
    else return nil;
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
