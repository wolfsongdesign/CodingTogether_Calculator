//
//  CalculatorBrain.m
//  Calculator
//
//  Created by andy on 6/26/12.
//  Copyright (c) 2012 Wolfsong, LLC. All rights reserved.
//
// ** Test to commit in github this change **

#import "CalculatorBrain.h"

// programStack should be private
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
// pushOperation
//
- (void)pushOperation:(NSString *)operator {
    [self.programStack addObject:operator];
}

//
// pushVariable
//
- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject:variable];
}

//
// performOperation
//
- (double)performOperation:(NSString *)operation {
    [self pushOperation:operation];
    // call the class method
    // better to use [self class] than CalculatorBrain due to inheritance
    return [[self class] runProgram:self.program];
}

//
// program
//
- (id)program {
    return [self.programStack copy];
}

//
// isOperand
//
+ (BOOL)isOperand:(NSString *)operation {
    // Set of operands
    NSSet *set = [NSSet setWithObjects: @"+", @"*", @"-", @"/", @"π", @"sin", @"cos", @"sqrt", @"CLEAR", nil];
    
    return [set containsObject:operation];
}

//
// variablesUsedInProgram
//
+ (NSSet *)variablesUsedInProgram:(id)program {
    NSSet *variableSet;
    //
    if (!variableSet) {
        variableSet =[[NSSet alloc] init];
    }
    // Check if variables are used in program
    for (id obj in program) {
        // looking for variable (ie a NSString but not an operand)
        if ([obj isKindOfClass:[NSString class]] && ![self isOperand:obj]) {
            variableSet = [variableSet setByAddingObject:obj];
        }
    }
    // Assignment requires nil (not empty set) to be sent back
    if ([variableSet count] == 0) variableSet = nil;

    return variableSet;
}

//
// popDescriptionOffStack
//
+ (NSString *)popDescriptionOffStack:(NSMutableArray *)stack {
    NSString *description = @"";
    
    id topOfStack = [stack lastObject];
    // Remove last opbject off stack or return empty string
    if (topOfStack) [stack removeLastObject]; else return @"";
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        // If number, return as string
        description = [topOfStack stringValue]; 
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        // If string, need to process operation and add brackets
        NSString *operation = topOfStack;
        // Addition
        if ([operation isEqualToString:@"+"]) {
            NSString *second = [self popDescriptionOffStack:stack];
            NSString *first  = [self popDescriptionOffStack:stack];
            if (( [first compare:@"(" options:0 range:NSMakeRange(0, 1)] == NSOrderedSame) && 
                ( [second compare:@")" options:0 range:NSMakeRange(second.length-1, 1)] == NSOrderedSame)) {
                description = [NSString stringWithFormat:@"(%@ + %@)", first, second];
            } else {
                description = [NSString stringWithFormat:@"(%@ + %@)", first, second];
            }
        // Multiplication
        } else if ([operation isEqualToString:@"*"]) {
            NSString *second = [self popDescriptionOffStack:stack];
            NSString *first  = [self popDescriptionOffStack:stack];
            description = [NSString stringWithFormat:@"(%@ * %@)", first, second];
        // Subtraction
        } else if ([operation isEqualToString:@"-"]) {
            NSString *second = [self popDescriptionOffStack:stack];
            NSString *first  = [self popDescriptionOffStack:stack];
            description = [NSString stringWithFormat:@"(%@ - %@)", first, second];
        // Division
        } else if ([operation isEqualToString:@"/"]) {
            NSString *second = [self popDescriptionOffStack:stack];
            NSString *first  = [self popDescriptionOffStack:stack];
            description = [NSString stringWithFormat:@"(%@ / %@)", first, second];
        // Pi
        } else if ([operation isEqualToString:@"π"]) {
            description = @"π";        
        // sin
        } else if ([operation isEqualToString:@"sin"]) {
            NSString *first  = [self popDescriptionOffStack:stack];
            if (( [first compare:@"(" options:0 range:NSMakeRange(0, 1)] == NSOrderedSame) && 
                ( [first compare:@")" options:0 range:NSMakeRange(first.length-1, 1)] == NSOrderedSame)) {
                description = [NSString stringWithFormat:@"sin%@", first];
            } else {
                description = [NSString stringWithFormat:@"sin(%@)", first];
            }
        // cos
        } else if ([operation isEqualToString:@"cos"]) {
            NSString *first  = [self popDescriptionOffStack:stack];
            if (( [first compare:@"(" options:0 range:NSMakeRange(0, 1)] == NSOrderedSame) && 
                ( [first compare:@")" options:0 range:NSMakeRange(first.length-1, 1)] == NSOrderedSame)) {
                description = [NSString stringWithFormat:@"cos%@", first];
            } else {
                description = [NSString stringWithFormat:@"cos(%@)", first];
            }
        // sqrt
        } else if ([operation isEqualToString:@"sqrt"]) {
            NSString *first  = [self popDescriptionOffStack:stack];
            if (( [first compare:@"(" options:0 range:NSMakeRange(0, 1)] == NSOrderedSame) && 
                ( [first compare:@")" options:0 range:NSMakeRange(first.length-1, 1)] == NSOrderedSame)) {
                description = [NSString stringWithFormat:@"sqrt%@", first];
            } else {
                description = [NSString stringWithFormat:@"sqrt(%@)", first];
            }
        // CLEAR
        } else if ([operation isEqualToString:@"CLEAR"]) {
            [stack removeAllObjects];
        // Handle variables
        } else if ([operation isEqualToString:@"variable"]) {
            description = topOfStack;
        }
    }
        
    return description;
}

//
// descriptionOfProgram
//
// Use NSSet 
+ (NSString *)descriptionOfProgram:(id)program {
    // Main stack
    NSMutableArray *stack;
    NSMutableArray *expressionStack;
    
    // Check that program isKindOfClass: NSArray
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        if (!expressionStack) {
            expressionStack = [[NSMutableArray alloc] init];
        }
    } else {
        return @"Program not of Type NSArray!";
    }
    
    // Step through stack
    while (stack.count > 0) {
        // add objects to the beginning of the array so
        // program displays expressions in chronological order
        [expressionStack insertObject:[self popDescriptionOffStack:stack] atIndex:0];
    }
    
    // Seperate programs by comma 
    return [expressionStack componentsJoinedByString:@", "]; 
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
        // CLEAR
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
    // Call runProgram with a nil dictionary
    return [self runProgram:program usingVariableValues:nil];
}

+(double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    // iterate over each entry in stack (program)
    for (int i=0; i < [stack count]; i++) {
        id obj = [stack objectAtIndex:i]; 
        
        // looking for variable (ie a NSString but not an operand)
        if ([obj isKindOfClass:[NSString class]] && ![self isOperand:obj]) {  
            // found variable
            id value = [variableValues objectForKey:obj];         
            // If value is not NSNumber, set it to zero
            if (![value isKindOfClass:[NSNumber class]]) {
                value = [NSNumber numberWithInt:0];
            }        
            // Replace program variable with value.
            [stack replaceObjectAtIndex:i withObject:value];
        }     
    }  
    return [self popOperandOffStack:stack];
}


@end
