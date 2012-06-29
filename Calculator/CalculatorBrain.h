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
- (double)popOperand;
- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;

@end

