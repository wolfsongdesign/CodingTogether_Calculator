//
//  CalculatorTests.m
//  CalculatorTests
//
//  Created by andy on 6/26/12.
//  Copyright (c) 2012 Wolfsong, LLC. All rights reserved.
//

#import "CalculatorTests.h"
#import "CalculatorBrain.h"

@implementation CalculatorTests

// FIXME 'static' ? 
static CalculatorBrain *brain;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    brain = [[CalculatorBrain alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

/*
- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in CalculatorTests");
}
*/


//
// Stack tests
//
- (void)testPopOnNewBrain
{
    double d = [brain popOperand];
    STAssertEqualsWithAccuracy(d, 0.0, 0.000001, @"pop on empty stack should be zero");
}

- (void)testPopOneOperand
{
    [brain pushOperand:99.99];
    double d = [brain popOperand];
    STAssertEqualsWithAccuracy(d, 99.99, 0.000001, @"pop after push should return pushed operand");
}


//
// Operation tests
//
- (void)testPerformValueAfterOperation
{
    [brain pushOperand:1.2];
    [brain pushOperand:3.4];
    double d = [brain performOperation:@"+"];
    STAssertEqualsWithAccuracy(d, 4.6, 0.000001, @"perform should return the correct value");
}

- (void)testPopValueAfterOperation
{
    [brain pushOperand:1.2];
    [brain pushOperand:3.4];
    [brain performOperation:@"+"];
    double d = [brain popOperand];
    STAssertEqualsWithAccuracy(d, 4.6, 0.000001, @"pop after perform should return correct value");
}

- (void)testSimpleAdditionOperation
{
    [brain pushOperand:1.2];
    [brain pushOperand:3.4];
    [brain performOperation:@"+"];
    double d = [brain popOperand];
    STAssertEqualsWithAccuracy(d, 4.6, 0.000001, @"Simple addition 1.2 3.4 + = 4.6");
}

- (void)testSimpleSubtractionOperation
{
    [brain pushOperand:1.2];
    [brain pushOperand:3.4];
    [brain performOperation:@"-"];
    double d = [brain popOperand];
    STAssertEqualsWithAccuracy(d, -2.2, 0.01, @"Simple subtraction: 1.2 3.4 - = -2.2");
}

- (void)testSimpleMultiplicationOperation
{
    [brain pushOperand:1.2];
    [brain pushOperand:3.4];
    [brain performOperation:@"*"];
    double d = [brain popOperand];
    STAssertEqualsWithAccuracy(d, 4.08, 0.000001, @"Simple multiplication: 1.2 3.4 * = 4.08");
}

- (void)testSimpleDivisionOperation
{
    [brain pushOperand:4.2];
    [brain pushOperand:2];
    [brain performOperation:@"/"];
    double d = [brain popOperand];
    STAssertEqualsWithAccuracy(d, 2.1, 0.000001, @"Simple division: 1.2 3.4 / = 0.352941");
}

- (void)testSimplePiOperation
{
    [brain pushOperand:1.2];
    [brain performOperation:@"π"];
    double d = [brain popOperand];
    STAssertEqualsWithAccuracy(d, 3.141592, 0.000001, @"Pi constant = 3.141592");
}

- (void)testPerformPiExample
{
    double d = [brain performOperation:@"π"];
    [brain pushOperand:1.8];
    [brain pushOperand:1.8];
    d = [brain performOperation:@"*"];
    d = [brain performOperation:@"*"];
    d = [brain performOperation:@"sqrt"];
    STAssertEqualsWithAccuracy(d, 3.19042, 0.00001, @"perform should return the correct value");
}

- (void)testClearOperation
{
    [brain pushOperand:1.2];
    [brain pushOperand:3.4];
    [brain performOperation:@"CLEAR"];
    double d = [brain popOperand];
    STAssertEqualsWithAccuracy(d, 0.0, 0.000001, @"Simple test of Clear");
}


@end
