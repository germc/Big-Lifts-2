extern NSString * const FTO_ASSISTANCE_NONE;
extern NSString * const FTO_ASSISTANCE_BORING_BUT_BIG;
extern NSString * const FTO_ASSISTANCE_TRIUMVIRATE;
extern NSString * const FTO_ASSISTANCE_SST;

@interface FTOAssistance : NSManagedObject
@property(nonatomic) NSString *name;
@end