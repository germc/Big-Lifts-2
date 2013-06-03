#import "WeightsTableDataSourceTests.h"
#import "BLStoreManager.h"
#import "WeightsTableDataSource.h"
#import "WeightTableCell.h"
#import "BarWeightCell.h"
#import "StepperWithCell.h"
#import "PlateStore.h"
#import "Plate.h"
#import "TextFieldWithCell.h"
#import "BarStore.h"
#import "Bar.h"

@implementation WeightsTableDataSourceTests
@synthesize dataSource;

- (void)setUp {
    [[BLStoreManager instance] resetAllStores];
    dataSource = [WeightsTableDataSource new];
}

- (void)testReturnsPlateCount {
    STAssertTrue([dataSource tableView:nil numberOfRowsInSection:1] > 0, @"");
}

- (void)testWiresCellsWithData {
    WeightTableCell *cell = (WeightTableCell *) [dataSource tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    STAssertTrue([[[cell weightLabel] text] isEqualToString:@"45.0"], @"");
    STAssertTrue([[[cell unitsLabel] text] isEqualToString:@"lbs"], @"");
}

- (void)testPlateCountChangeAdjustsPlateCount {
    WeightTableCell *cell = (WeightTableCell *) [dataSource tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell.stepper setValue:1];
    [dataSource plateCountChanged:cell.stepper];
    Plate *p = [[PlateStore instance] atIndex:0];
    STAssertEquals([p.count intValue], 7, @"");
}

- (void)testPlateCountDoesNotGoNegative {
    WeightTableCell *cell = (WeightTableCell *) [dataSource tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell.stepper setValue:-2];
    Plate *p = [[PlateStore instance] atIndex:0];
    p.count = [NSNumber numberWithInt:1];
    [dataSource plateCountChanged:cell.stepper];
    STAssertEquals([p.count intValue], 0, @"");
}

- (void)testBarWeightCellIsSetOnLoad {
    BarWeightCell *cell = (BarWeightCell *) [dataSource tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *barText = [[cell textField] text];

    STAssertFalse([barText isEqualToString:@""], @"");
}

- (void)testBarWeightCanBeChanged {
    UITextField *textField = [UITextField new];
    [textField setText:@"33"];
    [dataSource textFieldDidEndEditing:textField];

    Bar *bar = [[BarStore instance] first];
    STAssertEquals( [bar.weight doubleValue], 33.0, @"");
}

@end