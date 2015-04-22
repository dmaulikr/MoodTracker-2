#import "MoodsViewController.h"
#import "FetchedResultsControllerDataSource.h"
#import "MoodEntry.h"
#import <UIImageView+AFNetworking.h>
#import <BlocksKit.h>
#import <BlocksKit+UIKit.h>
#import "MoodEntryTableViewCell.h"

@interface MoodsViewController () <FetchedResultsControllerDataSourceDelegate>

@property (nonatomic, strong) FetchedResultsControllerDataSource* fetchedResultsControllerDataSource;
@property (nonatomic, strong) NSManagedObjectContext *moc;

@end

@implementation MoodsViewController

#pragma mark init

-(instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    self = [super init];
    
    if (self) {
        self.moc = managedObjectContext;
    }
    
    return self;
}

#pragma mark view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupFetchedResultsController];
    [self addRightBarButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fetchedResultsControllerDataSource.paused = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.fetchedResultsControllerDataSource.paused = YES;
}

#pragma mark add nav items

-(void)addRightBarButton{
    __weak typeof (self) weakSelf = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"New Entry" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}


#pragma mark fetched results controller setup

- (void)setupFetchedResultsController
{
    self.fetchedResultsControllerDataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.fetchedResultsControllerDataSource.fetchedResultsController = [self fetchedResultsController];
    self.fetchedResultsControllerDataSource.delegate = self;
    self.fetchedResultsControllerDataSource.reuseIdentifier = @"Cell";
}

- (NSFetchedResultsController*)fetchedResultsController
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[MoodEntry entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (NSManagedObjectContext*)managedObjectContext
{
    return self.moc;
}

#pragma mark Fetched Results Controller Delegate

- (void)configureCell:(id)cell withObject:(id)object
{
    MoodEntry* moodEntry = object;
    MoodEntryTableViewCell *newCell = (MoodEntryTableViewCell*)cell;
    newCell.moodEntry = moodEntry;
    [self setImageForCell:newCell withURLString:moodEntry.weatherIconURLString];
}

-(void)setImageForCell:(UITableViewCell*)cell withURLString:(NSString*)URLString{
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"]; //not a real image
    
    __weak UITableViewCell *weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.imageView.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
}

#pragma mark tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MoodEntryTableViewCell height];
}

@end