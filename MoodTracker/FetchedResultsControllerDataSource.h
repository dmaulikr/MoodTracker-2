#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class NSFetchedResultsController;

@protocol FetchedResultsControllerDataSourceDelegate

- (void)configureCell:(UITableViewCell*)cell withObject:(id)object;

@optional

- (void)deleteObject:(id)object;

@end



@interface FetchedResultsControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, weak) id<FetchedResultsControllerDataSourceDelegate> delegate;
@property (nonatomic, copy) NSString* reuseIdentifier;
@property (nonatomic) BOOL paused;

- (id)initWithTableView:(UITableView*)tableView;

@end