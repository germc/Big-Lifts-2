#import <MRCEnumerable/NSDictionary+Enumerable.h>
#import "StoreViewController.h"
#import "SKProductStore.h"

@interface StoreViewController ()

@property(nonatomic, strong) NSDictionary *purchaseIdToStoreInfo;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.purchaseIdToStoreInfo = @{
            @"barLoading" : @{
                    @"buyButton" : self.barLoadingBuyButton,
                    @"purchasedButton" : self.barLoadingPurchasedButton,
                    @"buyMessage" : @"Bar loading is now available throughout the app."
            },
            @"ssOnusWunsler" : @{
                    @"buyButton" : self.onusWunslerBuyButton,
                    @"purchasedButton" : self.onusWunslerPurchasedButton,
                    @"buyMessage" : @"Onus Wunsler is now available in Starting Strength."
            }
    };
    [self setProductPrice:[[SKProductStore instance] productById:@"barLoading"]];
    [self setProductPrice:[[SKProductStore instance] productById:@"ssOnusWunsler"]];
}

- (void)setProductPrice:(SKProduct *)product {
    if (product) {
        UIButton *button = self.purchaseIdToStoreInfo[product.productIdentifier][@"buyButton"];
        [button setTitle:[self priceOf:product] forState:UIControlStateNormal];
        [button setUserInteractionEnabled:YES];
    }
}

- (NSString *)priceOf:(SKProduct *)product {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    return [numberFormatter stringFromNumber:product.price];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideShowBuyButtons];
}

- (void)hideShowBuyButtons {
    [self.purchaseIdToStoreInfo each:^(NSString *purchaseId, NSDictionary *purchaseInfo) {
        BOOL barLoadingPurchased = [[IAPAdapter instance] hasPurchased:purchaseId];

        [purchaseInfo[@"buyButton"] setHidden:barLoadingPurchased];
        [purchaseInfo[@"purchasedButton"] setHidden:!barLoadingPurchased];
    }];
}

- (IBAction)buyButtonTapped:(id)sender {
    NSString *purchaseId = [self purchaseIdForButton:sender];
#if (TARGET_IPHONE_SIMULATOR)
    [[IAPAdapter instance] addPurchase: purchaseId];
    [self successfulPurchase: purchaseId];
    #else
    [[IAPAdapter instance] purchaseProductForId:purchaseId completion:^(NSObject *_) {
        [self successfulPurchase:purchaseId];
    }                                     error:^(NSError *err) {
        [self erroredPurchase:err];
    }];
#endif
}

- (NSString *)purchaseIdForButton:(id)sender {
    return [self.purchaseIdToStoreInfo detect:^BOOL(id key, NSDictionary *purchaseInfo) {
        return purchaseInfo[@"buyButton"] == sender;
    }];
}

- (void)erroredPurchase:(NSError *)err {
    NSLog(@"%@", [err localizedDescription]);
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Could not purchase..."
                                                    message:@"Something went wrong trying to connect to the store. Please try again later."
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [error performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

- (void)successfulPurchase:(NSString *)purchaseId {
    UIAlertView *thanks = [[UIAlertView alloc] initWithTitle:@"Purchased!"
                                                     message:self.purchaseIdToStoreInfo[purchaseId][@"buyMessage"]
                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [thanks performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [self hideShowBuyButtons];
}
@end