//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by ChenHao on 15/9/22.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRDetailViewController.h"

@interface BNRItemsViewController () 

@property(nonatomic,strong) IBOutlet UIView *headerView;

@end

@implementation BNRItemsViewController

-(IBAction)addNewItem:(id)sender {
    //创建新的BNRItem对象并将其加入BNRItemStore对象
    
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    //获取新的对象在allItems数组中的索引
    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    //将新行插入tableview对象
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

-(IBAction)toggleEditingMode:(id)sender {
    //如果当前的视图控制对象已经处在编辑模式
    if (self.isEditing) {
        //修改按钮文字，提示用户当前的表格状态
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        //关闭编辑模式
        [self setEditing:NO animated:YES];
    } else {
        //修改按钮文字，提示用户当前的表格状态
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

//-(UIView *)headerView {
//    //如果还没有载入headerView
//    //这里使用延迟实例化的设计模式(lazy instantiation)：只会在真正需要使用某个对象时再创建它，在某些情况下，这种设计模式可以显著减少内存占用。
//    if (!_headerView) {
//        //载入headerView.xib文件,已经在xib文件中做了关联了，所以不必再进行赋值
//      [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//    return _headerView;
//}

//-(void)viewDidAppear:(BOOL)animated {
//    [self.tableView setFrame:CGRectMake(0, 64, self.tableView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
//}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell类型
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *header = self.headerView;
    
    [self.tableView setTableHeaderView:header];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"publish_menu_background"]];
    self.tableView.backgroundView = bgView;
}

-(instancetype)init {
    //调用父类的指定初始化方法
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
//        for (int i = 0; i < 5; i++) {
//            [[BNRItemStore sharedStore] createItem];
//        }
        self.navigationItem.title = @"Homepwner";
        
        //创建新的UIBarButtonItem对象
        //将其目标对象设置为当前对象，将其动作方法设置为addNewItem
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[BNRItemStore sharedStore] allItems].count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    //获取allItems的第n个BNRItem对象
    
    //然后将该BNRItem对象的描述信息赋值给UITableViewCell对象的textLabel
    
    //这里的n是该cell对象所对应的表格行索引
    
    if (indexPath.row == [BNRItemStore sharedStore].allItems.count) {
        cell.textLabel.text = @"No More Items!";
    } else {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        
        BNRItem *item = items[indexPath.row];
        
        cell.textLabel.text = item.description;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果tableview对象请求确认的是删除操作...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [BNRItemStore sharedStore].allItems;
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        //还有删除表格视图中的响应表格行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [BNRItemStore sharedStore].allItems.count) {
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (destinationIndexPath.row < [BNRItemStore sharedStore].allItems.count) {
        [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.row >= [BNRItemStore sharedStore].allItems.count) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [BNRItemStore sharedStore].allItems.count) {
        return NO;
    }
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [[BNRItemStore sharedStore] allItems].count) {
        return;
    }
    BNRDetailViewController *ctrler = [[BNRDetailViewController alloc] init];
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];
    ctrler.item = item;
    [self.navigationController pushViewController:ctrler animated:YES];
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle f orRowAtIndexPath:(NSIndexPath *)indexPath {
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
