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
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userEnteredADecimal;
@property (strong, nonatomic) CalculatorBrain *brain;
@property (weak, nonatomic) IBOutlet UILabel *program;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userEnteredADecimal = _userEnteredADecimal;
@synthesize brain = _brain;
@synthesize program = _program;

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
    self.program.text = @"0";
    // Clear stack
    [self.brain performOperation: @"CLEAR"];
}

//
// enter Key Pressed
//
- (IBAction)enterPressed {    
    NSString *displayString = self.display.text;
    NSString *programString = self.program.text;
    
    // Catch corner case if user presses "." then Enter
    if ([displayString isEqualToString:@"."]) return;
    
    // Set program label
    // Test to remove starting '0'
    if ([programString isEqualToString:@"0"]) {
        self.program.text = displayString;
    } else {
        self.program.text = [programString stringByAppendingFormat:@" %@", displayString];
    }
    // Set BOOLs
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userEnteredADecimal = NO;

    // Push operand on stack
    [self.brain pushOperand:[displayString doubleValue]];
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
    
    // Set program label
    // Test to remove starting '0'
    NSString *programString = self.program.text;
    if ([programString isEqualToString:@"0"]) {
        self.program.text = operation;
    } else {
        self.program.text = [programString stringByAppendingFormat:@" %@", operation];
    }
    //
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (void)viewDidUnload {
    [self setProgram:nil];
    [super viewDidUnload];
}
@end

