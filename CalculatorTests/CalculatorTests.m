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


- (void)testPopOnNewBrain
{
    double d = [brain popOperand];
    STAssertEqualsWithAccuracy(d, 0.0, 0.000001, @"pop on empty stack should be zero");
}
*/

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

@end
