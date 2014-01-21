//
//  MoviesViewController.m
//  tomatoes
//
//  Created by Utkarsh Sengar on 1/17/14.
//  Copyright (c) 2014 area42. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieDetailViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "UIImageView+AFNetworking.h"
#import "Reachability.h"
#import "SVProgressHUD.h"

@interface MoviesViewController ()
{
    Reachability *internetReachableFoo;
}

@property (nonatomic, strong) NSMutableArray *movies;
- (void) reload;
@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self reload];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testInternetConnection];
    self.title = @"Movies";
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [self reload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    Movie *movie = self.movies[indexPath.row];
    cell.movieTitleLabel.text = movie.title;
    cell.movieSynopsisLabel.text = movie.synopsis;
    cell.movieCastLabel.text = movie.cast;
    
    NSURL *url = [[NSURL alloc] initWithString:movie.image];
    [cell.movieImage setImageWithURL:url];
    
    return cell;
}


- (void) reload{
    [self showWithStatus];
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //NSLog(@"%@", object);
        
        NSMutableArray *movies = [[NSMutableArray alloc] init];
        for(NSDictionary *movie in [object objectForKey:@"movies"]){
            NSMutableDictionary *movie_holder = [[NSMutableDictionary alloc] init];
            for(NSDictionary *c in movie[@"abridged_cast"]){
                if([movie_holder objectForKey:@"cast"]){
                    NSMutableArray *cast = [movie_holder objectForKey:@"cast"];
                    [cast addObject:c[@"name"]];
                    [movie_holder setObject:cast forKey:@"cast"];
                } else {
                    NSMutableArray *cast = [[NSMutableArray alloc] init];
                    [cast addObject:c[@"name"]];
                    [movie_holder setObject:cast forKey:@"cast"];
                }

            }
            [movie_holder setObject:movie[@"title"] forKey:@"title"];
            [movie_holder setObject:movie[@"synopsis"] forKey:@"synopsis"];
            [movie_holder setObject:movie[@"posters"][@"original"] forKey:@"image"];
            Movie *movie_obj = [[Movie alloc] initWithDictionary:movie_holder];
            [movies addObject:movie_obj];
        }
        
        self.movies = movies;
        [self.tableView reloadData];
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *selectedCell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
    Movie *movie = self.movies[indexPath.row];
    
    MovieDetailViewController *movieDetailViewController = (MovieDetailViewController *)segue.destinationViewController;
    movieDetailViewController.movie = movie;
}

- (void)stopRefresh {
    [self.refreshControl endRefreshing];
}

// Checks if we have an internet connection or not
- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Important" message: @"You are not connected to the internet.  Please try again." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        });
    };
    
    [internetReachableFoo startNotifier];
}

#pragma mark -
#pragma mark Show Methods Sample

- (void)showWithStatus {
    [SVProgressHUD showWithStatus:@"Doing Stuff" ];
}

static float progress = 0.0f;

- (IBAction)showWithProgress:(id)sender {
    progress = 0.0f;
    [SVProgressHUD showProgress:0 status:@"Loading"];
    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3];
}

- (void)increaseProgress {
    progress+=0.1f;
    [SVProgressHUD showProgress:progress status:@"Loading"];
    
    if(progress < 1.0f)
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3];
    else
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.4f];
}


#pragma mark -
#pragma mark Dismiss Methods Sample

- (void)dismiss {
    [SVProgressHUD dismiss];
}

- (void)dismissSuccess {
    [SVProgressHUD showSuccessWithStatus:@"Great Success!"];
}

- (void)dismissError {
    [SVProgressHUD showErrorWithStatus:@"Failed with Error"];
}

@end
