@interface WeightRounder : NSObject
- (NSDecimalNumber *)round:(NSDecimalNumber *)number;

- (NSDecimalNumber *)roundTo1:(NSDecimalNumber *)number withDirection:(const NSString *)direction;
@end