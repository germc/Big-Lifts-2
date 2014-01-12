#import "FTOCustomAssistanceEditSetViewController.h"
#import "JFTOCustomAssistanceLiftStore.h"
#import "JSet.h"
#import "FTOCustomAssistanceEditLiftViewController.h"
#import "TextViewInputAccessoryBuilder.h"
#import "PaddingTextField.h"
#import "JFTOCustomAssistanceLift.h"
#import "JFTOLiftStore.h"

@implementation FTOCustomAssistanceEditSetViewController

- (void)viewDidLoad {
    [[TextViewInputAccessoryBuilder new] doneButtonAccessory:(id) self.liftTextField];
    [[TextViewInputAccessoryBuilder new] doneButtonAccessory:(id) self.percentageTextField];
    [[TextViewInputAccessoryBuilder new] doneButtonAccessory:(id) self.repsTextField];
    [self.liftTextField setDelegate:self];
    [self.percentageTextField setDelegate:self];
    [self.repsTextField setDelegate:self];

    self.liftsPicker = [UIPickerView new];
    [self.liftsPicker setDataSource:self];
    [self.liftsPicker setDelegate:self];
    self.liftTextField.inputView = self.liftsPicker;
}

- (void)viewWillAppear:(BOOL)animated {
    [self determineIfUsingBigLift];
    [self setupLiftSelector];
    [self.percentageTextField setText:[self.set.percentage stringValue]];
    [self.repsTextField setText:[self.set.reps stringValue]];
}

- (void)determineIfUsingBigLift {
    if (!self.set.lift) {
        self.usingBigLift = NO;
    }
    else {
        self.usingBigLift = ![[[JFTOCustomAssistanceLiftStore instance] findAll] containsObject:self.set.lift];
    }
    [self.useBigLiftSwitch setOn:self.usingBigLift];
}

- (void)setupLiftSelector {
    if (!self.usingBigLift) {
        BOOL hasLifts = [[JFTOCustomAssistanceLiftStore instance] count] > 0;
        [self.addLiftButton setHidden:hasLifts];
        [self.liftTextField setHidden:!hasLifts];
    }
    else {
        [self.addLiftButton setHidden:YES];
        [self.liftTextField setHidden:NO];
    }

    if (self.set.lift) {
        [self.liftTextField setText:self.set.lift.name];
        [self.liftsPicker selectRow:[[[self liftStore] findAll] indexOfObject:self.set.lift] inComponent:0 animated:NO];
    }

    [self.liftsPicker reloadAllComponents];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateSet];
}

- (void)updateSet {
    self.set.lift = [[self liftStore] atIndex:[self.liftsPicker selectedRowInComponent:0]];
    self.set.percentage = [NSDecimalNumber decimalNumberWithString:[self.percentageTextField text]];
    self.set.reps = [NSNumber numberWithInt:[[self.repsTextField text] intValue]];
    [self.liftTextField setText:self.set.lift.name];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ftoCustomAsstEditSetAddLift"]) {
        self.set.lift = [[JFTOCustomAssistanceLiftStore instance] create];
        FTOCustomAssistanceEditLiftViewController *controller = [segue destinationViewController];
        controller.lift = (id) self.set.lift;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self liftStore] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    JFTOCustomAssistanceLift *lift = [[self liftStore] atIndex:row];
    return lift.name;
}

- (BLJStore *)liftStore {
    return self.usingBigLift ? [JFTOLiftStore instance] : [JFTOCustomAssistanceLiftStore instance];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self updateSet];
}

- (IBAction)useBigLiftChanged:(id)sender {
    self.set.lift = nil;
    [self.liftTextField setText:@"No lift"];
    self.usingBigLift = [sender isOn];
    [self setupLiftSelector];
}

@end