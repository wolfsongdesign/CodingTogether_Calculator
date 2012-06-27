//
//  CalculatorBrain.m
//  Calculator
//
//  Created by andy on 6/26/12.
//  Copyright (c) 2012 Wolfsong, LLC. All rights reserved.
//

#import "CalculatorBrain.h"

// operandStack should be private
@interface CalculatorBrain()
@property (strong, nonatomic) NSMutableArray *operandStack;
@end


@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

// Lazy instantiation of operandStack 
- (NSMutableArray *)operandStack {
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

//
// setOperandStack
//
- (void)setOperandStack:(NSMutableArray *)anArray {
    _operandStack = anArray;
}

//
// pushOperand
//
- (void)pushOperand:(double)operand {
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

//
// popOperand
//
- (double)popOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) {
        [self.operandStack removeLastObject];
    }
    return [operandObject doubleValue];
}

//
// performOperation
//
- (double)performOperation:(NSString *)operation {
    double result = 0;
    
    // Addition
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    // Multiplication
    } else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    // Subtraction
    } else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    // Division
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    // sin
    } else if ([operation isEqualToString:@"sin"]) {
        double num = [self popOperand];
        result = sin(num);
    // cos
    } else if ([operation isEqualToString:@"cos"]) {
        double num = [self popOperand];
        result = cos(num);
    // sqrt
    } else if ([operation isEqualToString:@"sqrt"]) {
        double num = [self popOperand];
        result = sqrt(num);
    } 
    
    // Push result on to stack
    [self pushOperand:result];
    
    return result;
}

@end
