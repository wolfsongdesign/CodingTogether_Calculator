//
//  CalculatorViewController.m
//  Calculator
//
//  Created by andy on 6/26/12.
//  Copyright (c) 2012 Wolfsong, LLC. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *programDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *variableValueLabel;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userEnteredADecimal;
@property (strong, nonatomic) CalculatorBrain *brain;
@end


@implementation CalculatorViewController

@synthesize display = _display;
@synthesize programDescriptionLabel = _programDescriptionLabel;
@synthesize variableValueLabel = _variableValueLabel;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userEnteredADecimal = _userEnteredADecimal;
@synthesize brain = _brain;

//
// Lazy instantiation of Array 
//
- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

//
// digit Key Pressed
//
- (IBAction)digitPressed:(UIButton *)sender {
    // FIXME using currentTitle of button instead of using localization
    NSString *digit = sender.currentTitle;
    
    // Add digits to display string
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingFormat:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

//
// clear Key Pressed
//
- (IBAction)clearPressed {
    // Reset BOOLs
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userEnteredADecimal = NO;
    // Clear display(s)
    self.display.text = @"0"; 
    self.programDescriptionLabel.text = @" ";
    // Clear stack
    [self.brain performOperation: @"CLEAR"];
}

//
// enter Key Pressed
//
- (IBAction)enterPressed {    
    NSString *displayString = self.display.text;
    
    // Catch corner case if user presses "." then Enter
    if ([displayString isEqualToString:@"."]) return;
    
    // Set BOOLs
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userEnteredADecimal = NO;

    // Push operand on stack
    [self.brain pushOperand:[displayString doubleValue]];
    // FIXME
    // Set label
//    self.programDescriptionLabel.text = [[CalculatorBrain class] descriptionOfProgram:self.brain.program];
}

//
// plus/minus Key Pressed
//
- (IBAction)plusMinusPressed {
    NSString *displayString = self.display.text;
    
    // Add or remove leading "-" from string 
    if ( [displayString compare:@"-" options:0 range:NSMakeRange(0, 1)] == NSOrderedSame)
    {
        // Return substring after the "-" 
        self.display.text = [displayString substringFromIndex:(1)];
    } else {
        // Prepend "-" to displayString 
        self.display.text = [NSString stringWithFormat:@"-%@", displayString];
    }
}

//
// decimal Key Pressed
//
- (IBAction)decimalPressed {
    // Check if decimal has already been pressed
    if (self.userEnteredADecimal) return;
    // Add decimal to display string
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingFormat:@"."];
    } else {
        self.display.text = @".";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    // Set userEnteredADecimal
    self.userEnteredADecimal = YES;
}

//
// backspace Key Pressed
//
- (IBAction)backspacePressed {
    NSString *displayString = self.display.text;
    NSUInteger lengthOfString = displayString.length;
    
    // Return if display is already 0
    if ([displayString isEqualToString:@"0"]) {
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.userEnteredADecimal = NO;
        return;
    }
    // FIXME
    // Probably too verbose due to corner cases
    if (lengthOfString > 1) {
        // Check display for length == 2 
        // Set to '0' if display is a minus sign with number/decimal
        if (lengthOfString == 2) {
            if ( [displayString compare:@"-" options:0 range:NSMakeRange(0, 1)] == NSOrderedSame) {
                // Display = "0"
                self.display.text = @"0";
                self.userIsInTheMiddleOfEnteringANumber = NO;
                self.userEnteredADecimal = NO;
            } else {
                self.display.text = [displayString substringToIndex:(lengthOfString -1)];
            }
        } else {
            // Check to see if removing a decimal
            if ([displayString compare:@"." options:0 range:NSMakeRange(lengthOfString-1, 1)] == NSOrderedSame) {
                // If removed a decimal, set BOOL to NO
                self.userEnteredADecimal = NO;
            }
            // Remove one trailing character from string
            self.display.text = [displayString substringToIndex:(lengthOfString -1)];
        }
    } else {
        // lengthOfString == 0 or 1, set display to '0'
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.userEnteredADecimal = NO;
    }
}

//
// variable Key Pressed
//
- (IBAction)variablePressed:(UIButton *)sender {
    NSString *variable = sender.currentTitle;
    
    // Press Enter for the user
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    [self.brain pushVariable:variable];
    self.display.text = variable;
}

//
// operation Key Pressed
//
- (IBAction)operationPressed:(id)sender {    
    NSString *operation = [sender currentTitle];
    
    // If user presses a number then an operation, press Enter for the user
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    // Reset userEnteredADecimal
    self.userEnteredADecimal = NO;
    
    //
    double result = [self.brain performOperation:operation];
    
    // Set programDescription label
    self.programDescriptionLabel.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

//
// variablesDisplayStringFromVariablesUsedSet
//
- (NSString *)variablesDisplayStringFromVariablesUsedSet:(NSSet *)variablesUsedSet withDictionary:(NSDictionary *)dictionary {
    // Array of key value pairs
    NSMutableArray *variablesArray = [[NSMutableArray alloc] init];
    // Use enumerator to iterate over Set
    NSEnumerator *e = [variablesUsedSet objectEnumerator];
    id object;
    while (object = [e nextObject]) {
        NSString *val = [dictionary valueForKey:object];
        [variablesArray addObject:[NSString stringWithFormat:@"%@ = %@", object, val]];
    }
    return [variablesArray componentsJoinedByString:@", "];
}

//
//
//
- (IBAction)testOneKeyPressed:(id)sender {
    // run tests
    CalculatorBrain *testBrain = [self brain];
    
    // Setup the brain
    [testBrain pushVariable:@"x"];
    [testBrain pushVariable:@"x"];
    [testBrain pushOperation:@"*"];
    [testBrain pushVariable:@"y"];
    [testBrain pushVariable:@"y"];
    [testBrain pushOperation:@"*"];
    [testBrain pushOperation:@"+"];
    [testBrain pushOperation:@"sqrt"];  
    
    // Retrieve the program
    NSArray *program = testBrain.program;
    
    // Setup the dictionary
    NSDictionary *dictionary = 
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithDouble:3], @"x",
     [NSNumber numberWithDouble:4], @"y", nil];
    
    // Run the program with variables
    double result = [CalculatorBrain runProgram:program usingVariableValues:dictionary];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    // Display program description
    self.programDescriptionLabel.text = [[CalculatorBrain class] descriptionOfProgram:program];
    
    // Set of used variables
    NSSet *variablesUsedSet = [CalculatorBrain variablesUsedInProgram:program];
    // Display variables used
    self.variableValueLabel.text = [self variablesDisplayStringFromVariablesUsedSet:variablesUsedSet withDictionary:dictionary];
}

//
//
//
- (IBAction)testTwoKeyPressed:(id)sender {
    // run tests
    CalculatorBrain *testBrain = [self brain];
    
    // Setup the brain
    [testBrain pushOperand:3.25];
    [testBrain pushOperand:6];
    [testBrain pushOperation:@"+"];
    [testBrain pushOperand:14];
    [testBrain pushOperation:@"*"];
    [testBrain pushVariable:@"x"];
    [testBrain pushVariable:@"y"];
    [testBrain pushOperation:@"+"];  
    
    // Retrieve the program
    NSArray *program = testBrain.program;
    
    // Setup the dictionary
    NSDictionary *dictionary = 
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithDouble:-4], @"x",
     [NSNumber numberWithDouble:3], @"y", nil];
    
    // Run the program with variables
    double result = [CalculatorBrain runProgram:program usingVariableValues:dictionary];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    // Display program description
    self.programDescriptionLabel.text = [[CalculatorBrain class] descriptionOfProgram:program];
    
    // Set of used variables
    NSSet *variablesUsedSet = [CalculatorBrain variablesUsedInProgram:program];
    // Display variables used
    self.variableValueLabel.text = [self variablesDisplayStringFromVariablesUsedSet:variablesUsedSet withDictionary:dictionary];
}

//
//
//
- (IBAction)testThreeKeyPressed:(id)sender {
    // run tests
    CalculatorBrain *testBrain = [self brain];
    
    // Setup the brain
    [testBrain pushVariable:@"x"];
    [testBrain pushVariable:@"x"];
    [testBrain pushOperation:@"*"];
    [testBrain pushVariable:@"y"];
    [testBrain pushVariable:@"y"];
    [testBrain pushOperation:@"*"];
    [testBrain pushOperation:@"+"];
    [testBrain pushOperation:@"sqrt"];  
    
    // Retrieve the program
    NSArray *program = testBrain.program;
    
    // Setup the dictionary
    NSDictionary *dictionary = 
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithDouble:3], @"x",
     [NSNumber numberWithDouble:4], @"y", nil];
    
    // Run the program with variables
    double result = [CalculatorBrain runProgram:program usingVariableValues:dictionary];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    // Display program description
    self.programDescriptionLabel.text = [[CalculatorBrain class] descriptionOfProgram:program];
    
    // Set of used variables
    NSSet *variablesUsedSet = [CalculatorBrain variablesUsedInProgram:program];
    // Display variables used
    self.variableValueLabel.text = [self variablesDisplayStringFromVariablesUsedSet:variablesUsedSet withDictionary:dictionary];
}


- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setProgramDescriptionLabel:nil];
    [self setVariableValueLabel:nil];
    [super viewDidUnload];
}
@end

