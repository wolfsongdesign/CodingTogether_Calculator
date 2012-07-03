//
//  CalculatorBrain.m
//  Calculator
//
//  Created by andy on 6/26/12.
//  Copyright (c) 2012 Wolfsong, LLC. All rights reserved.
//
// ** Test to commit in github this change **

#import "CalculatorBrain.h"

// operandStack should be private
@interface CalculatorBrain()
@property (strong, nonatomic) NSMutableArray *programStack;
@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;

// Lazy instantiation of programStack 
- (NSMutableArray *)programStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

//
// setOperandStack
//
- (void)setOperandStack:(NSMutableArray *)anArray {
    _programStack = anArray;
}

//
// pushOperand
//
- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

//
// performOperation
//
- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

//
// program
//
- (id)program {
    return [self.programStack copy];
}

//
// descriptionOfProgram
//
+ (NSString *)descriptionOfProgram:(id)program {
    // Need to use recursion
    // Use NSSet 
    return @"Implement this in Assignment 2";
}

//
// popOperandOffStack
//
+ (double)popOperandOffStack:(NSMutableArray *)stack {
    // Only checking for NSString and NSNumber so it is important
    // that we are returning result=0 for all other cases
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result  = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        // Addition
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        // Multiplication
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        // Subtraction
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        // Division
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        // Pi
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;        
        // sin
        } else if ([operation isEqualToString:@"sin"]) {
            double num = [self popOperandOffStack:stack];
            result = sin(num);
        // cos
        } else if ([operation isEqualToString:@"cos"]) {
            double num = [self popOperandOffStack:stack];
            result = cos(num);
        // sqrt
        } else if ([operation isEqualToString:@"sqrt"]) {
            double num = [self popOperandOffStack:stack];
            result = sqrt(num);
        } else if ([operation isEqualToString:@"CLEAR"]) {
            [stack removeAllObjects];
        }
    }
    return result;
}

//
// runProgram
//
+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}



@end
