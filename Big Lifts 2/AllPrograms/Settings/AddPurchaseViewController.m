#import <FlurrySDK/Flurry.h>
#import "AddPurchaseViewController.h"
#import "Purchaser.h"
#import "SKProductStore.h"

@implementation AddPurchaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Flurry logEvent:@"AddPurchaseDebug"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionStyle == UITableViewCellSelectionStyleNone) {
        return;
    }
    [self.tableView endEditing:YES];

    NSString *purchaseId = [self.purchaseIdField text];
    if ([[SKProductStore instance].allPurchaseIds containsObject:purchaseId]) {
        [[Purchaser new] savePurchase:purchaseId];
        UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Unlocked"
                                                      message:@"Purchase unlocked"
                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [msg performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else if ([purchaseId isEqualToString:@"allPurchases"]) {
        for (NSString *productId in [SKProductStore instance].allPurchaseIds) {
            [[Purchaser new] savePurchase:productId];
        }
        UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Unlocked"
                                                      message:@"All current purchases unlocked"
                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [msg performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else {
        UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"I don't recognize that purchase ID."
                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [msg performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
}

@end