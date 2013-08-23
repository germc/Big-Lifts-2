#import "FTOEditViewController.h"
#import "FTOLiftStore.h"
#import "FTOLift.h"
#import "LiftFormCell.h"
#import "FTOEditLiftCell.h"
#import "RowTextField.h"
#import "TextFieldWithCell.h"
#import "TextViewInputAccessoryBuilder.h"

@implementation FTOEditViewController

- (void)viewDidLoad {
    UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)handleSingleTap:(id)handleSingleTap {
    [self.view endEditing:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self emptyView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[FTOLiftStore instance] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FTOLift *lift = ([[FTOLiftStore instance] findAll])[(NSUInteger) indexPath.row];
    if ([indexPath section] == 0) {
        FTOEditLiftCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(FTOEditLiftCell.class)];
        if (cell == nil) {
            cell = [FTOEditLiftCell create];
        }

        [cell setLift:lift];
        [[cell max] setIndexPath:indexPath];
        [[cell max] setDelegate:self];
        return cell;
    }
    else {
        return [self liftFormCellFor:self.tableView lift:lift];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 1 ? @"Increment" : @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"FTOEditMaxesHeader" owner:self options:nil][0];
        CGRect bounds = [view bounds];
        [view setBounds:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width,
                [self tableView:nil heightForHeaderInSection:section])];
        return view;
    }

    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    RowTextField *rowTextField = (RowTextField *) textField;
    NSIndexPath *indexPath = [rowTextField indexPath];

    NSString *weightText = [textField text];

    if ([weightText isEqualToString:@""]) {
        [self.tableView reloadData];
        return;
    }

    NSDecimalNumber *weight = [NSDecimalNumber decimalNumberWithString:weightText];
    Lift *lift = [self liftAtIndex:[indexPath row]];
    if ([indexPath section] == 0) {
        [lift setWeight:weight];
        [self.tableView reloadData];
    }
    else {
        [lift setIncrement:weight];
    }
}

- (UITableViewCell *)liftFormCellFor:(UITableView *)tableView lift:(Lift *)lift {
    LiftFormCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(LiftFormCell.class)];
    if (cell == nil) {
        cell = [LiftFormCell create];
    }
    [[cell liftLabel] setText:lift.name];
    [[cell textField] setText:[lift.increment stringValue]];
    [[TextViewInputAccessoryBuilder new] doneButtonAccessory:[cell textField]];
    return cell;
}

- (Lift *)liftAtIndex:(int)index {
    return [[FTOLiftStore instance] atIndex:index];
}

@end