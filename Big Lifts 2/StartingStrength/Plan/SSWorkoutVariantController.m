#import <MRCEnumerable/NSArray+Enumerable.h>
#import <MRCEnumerable/NSDictionary+Enumerable.h>
#import "SSWorkoutVariantController.h"
#import "SSWorkoutStore.h"
#import "NSDictionaryMutator.h"
#import "SSVariantStore.h"
#import "SSVariant.h"
#import "IAPAdapter.h"
#import "PurchaseOverlay.h"
#import "Purchaser.h"

int const SS_WORKOUT_VARIANT_SECTION = 1;

@interface SSWorkoutVariantController ()
@property(nonatomic, strong) NSDictionary *variantMapping;
@property(nonatomic, strong) NSDictionary *iapCells;
@end

@implementation SSWorkoutVariantController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.variantMapping = @{@0 : @"Standard", @1 : @"Novice", @2 : @"Onus-Wunsler", @3 : @"Practical Programming"};
    self.iapCells = @{IAP_SS_ONUS_WUNSLER : self.onusWunslerCell,
            IAP_SS_PRACTICAL_PROGRAMMING : self.practicalProgrammingCell,
            IAP_SS_WARMUP : self.warmupCell};
    [self checkSelectedVariant];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enableOrDisableIapCells)
                                                 name:IAP_PURCHASED_NOTIFICATION
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self enableOrDisableIapCells];
    [self.warmupToggle setOn:[[[SSVariantStore instance] first] warmupEnabled]];
}

- (void)enableOrDisableIapCells {
    [[self.iapCells allKeys] each:^(NSString *purchaseId) {
        if (!([[IAPAdapter instance] hasPurchased:purchaseId])) {
            [self disable:purchaseId view:self.iapCells[purchaseId]];
        }
        else {
            [self enable:self.iapCells[purchaseId]];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell viewWithTag:kPurchaseOverlayTag]) {
        NSString *purchaseId = [self.iapCells detect:^BOOL(id key, id obj) {
            return cell == obj;
        }];
        [[Purchaser new] purchase:purchaseId];
    }
    else {
        if ([indexPath section] == 1) {
            NSString *variantName = [self.variantMapping objectForKey:[NSNumber numberWithInteger:[indexPath row]]];
            [[SSWorkoutStore instance] setupVariant:variantName];
            [self checkSelectedVariant];
        }
    }
}

- (void)checkSelectedVariant {
    SSVariant *variant = [[SSVariantStore instance] first];
    [self uncheckAllRows];

    int index = [[[NSDictionaryMutator new] invert:self.variantMapping][variant.name] intValue];
    UITableViewCell *cell = [self tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:SS_WORKOUT_VARIANT_SECTION]];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)uncheckAllRows {
    for (int i = 0; i < [self tableView:nil numberOfRowsInSection:SS_WORKOUT_VARIANT_SECTION]; i++) {
        UITableViewCell *cell = [self tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:SS_WORKOUT_VARIANT_SECTION]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}

- (IBAction)toggleWarmup:(id)sender {
    BOOL warmupOn = [self.warmupToggle isOn];
    [[[SSVariantStore instance] first] setWarmupEnabled:warmupOn];

    [[SSWorkoutStore instance] removeWarmup];
    if (warmupOn) {
        [[SSWorkoutStore instance] addWarmup];
    }
}

@end