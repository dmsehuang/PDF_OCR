//
//  CharactersTVC.m
//  PDF_OCR
//
//  Created by huijinghuang on 4/22/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import "CharactersTVC.h"

@interface CharactersTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation CharactersTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"CellView" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)getData {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"RecognizedCharacter" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSError *err = nil;
    self.recognizedCharArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&err];
    if (err) {
        NSLog(@"Unable to execute fetch request");
        NSLog(@"%@", err);
    } else {
        NSLog(@"Successfully fetch recognized characters");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.recognizedCharArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    RecognizedCharacter *recognizedChar = [self.recognizedCharArr objectAtIndex:indexPath.row];
    cell.textLabel.text = recognizedChar.value;
    cell.imageView.image = [NSKeyedUnarchiver unarchiveObjectWithData:recognizedChar.image];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select row: %d", indexPath.row);
    RecognizedCharacter *recognizedChar = [self.recognizedCharArr objectAtIndex:indexPath.row];
    // alloc detail view and assign value to it
    CharacterDetailView *detailVC = [[CharacterDetailView alloc] init];
    detailVC.character = recognizedChar.value;
    detailVC.characterImage = [NSKeyedUnarchiver unarchiveObjectWithData:recognizedChar.image];
    detailVC.propVec = [NSKeyedUnarchiver unarchiveObjectWithData:recognizedChar.propVector];
    // push detail view to navigation stack
    [self.navi pushViewController:detailVC animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
