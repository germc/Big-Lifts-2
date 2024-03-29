@class JFTOLift;

@interface FTORepsToBeatCalculator : NSObject

- (int)repsToBeat:(JFTOLift *)lift atWeight:(NSDecimalNumber *)weight;

- (NSDecimalNumber *)findLogMax:(JFTOLift *)lift;

- (NSArray *)logsForLift:(JFTOLift *)lift;

- (int)findRepsToBeat:(NSDecimalNumber *)number withWeight:(NSDecimalNumber *)weight;
@end