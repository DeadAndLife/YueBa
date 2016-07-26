//
//  ViewController.m
//  PersonCard
//
//  Created by qingyun on 16/7/19.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import "Card.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *cardNo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)save:(id)sender {
    //使用entity初始化一个模型对象
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
//    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:app.managedObjectContext];
//    //设置模型对象的属性
//    [person setValue:self.name.text forKey:@"name"];
//    [person setValue:[NSNumber numberWithInt:self.age.text.intValue] forKey:@"age"];
//    
//    NSManagedObject *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:app.managedObjectContext];
//    [card setValue:self.cardNo.text forKey:@"no"];
//    
//    //将模型对象之间建立关系
//    [person setValue:card forKey:@"card"];
//    [card setValue:person forKey:@"person"];
    
    //得到一个实体
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:app.managedObjectContext];
//    //初始化模型对象
//    Person *person = [[Person alloc] initWithEntity:entity insertIntoManagedObjectContext:app.managedObjectContext];
//    person.name = self.name.text;
    
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:app.managedObjectContext];
    
    person.age = [NSNumber numberWithInt:self.age.text.intValue];
    
    NSEntityDescription *cardEntity = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:app.managedObjectContext];
    Card *card = [[Card alloc] initWithEntity:cardEntity insertIntoManagedObjectContext:app.managedObjectContext];
    
    card.no = self.cardNo.text;
    card.person = person;
    person.card = card;
    
    //将修改持久保存,保存后不能撤销
    [app saveContext];
    
    self.name.text = nil;
    self.age.text = nil;
    self.cardNo.text = nil;
    
    
}
- (IBAction)fetch:(id)sender {
    //从core data中查询出内容
    //构建一个查询对象
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    //设置排序条件,以age排序,升序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    //设置谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name != %@", @"zhangsan"];
    fetchRequest.predicate = predicate;
    
    //执行查询
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSArray *result = [app.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableString *string = [NSMutableString string];
    
    //查询的结果是模型对象数组,遍历模型对象
    for (Person *person in result) {
        [string appendFormat:@"name %@ age %@ cardNo %@\n", person.name, person.age.stringValue, person.card.no];
        
//        person.age = @110;
        [app.managedObjectContext deleteObject:person];
        
    }
    
    NSLog(@"%@", string);
    
    [app saveContext];
    
    
}

@end
