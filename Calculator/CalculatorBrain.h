//
//  CalculatorBrain.h
//  Calculator
//
//  Created by andy on 6/26/12.
//  Copyright (c) 2012 Wolfsong, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

// Public API

// FIXME Three different 'push' methods? Why not one...?
- (void)pushVariable:(NSString *)variable;
- (void)pushOperand:(double)operand;
// Add for automation and testing
- (void)pushOperation:(NSString *)operation;

- (double)performOperation:(NSString *)operation;
- (id)popOffStack;

// Program methods
@property (readonly) id program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end

