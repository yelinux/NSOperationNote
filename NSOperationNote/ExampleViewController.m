//
//  ExampleViewController.m
//  NSOperationNote
//
//  Created by chenyehong on 2021/4/15.
//

#import "ExampleViewController.h"
#import "MyOperation.h"
@interface ExampleViewController ()

@property (assign, nonatomic) double randomNum;
@property (assign, nonatomic) NSInteger ticketSurplusCount;
@property (strong, nonatomic) NSLock *lock;

@end

@implementation ExampleViewController

-(double)randomNum{
    return (arc4random() % 10) / 10.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"NSOperation笔记";
}

//使用子类 NSInvocationOperation
- (IBAction)click1:(id)sender {
    // 1.创建 NSInvocationOperation 对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(taskFun) object:nil];
    // 2.调用 start 方法开始执行操作
    [op start];
    
//    for - currentThread-0:<NSThread: 0x600000ddc180>{number = 1, name = main}
//    for - currentThread-1:<NSThread: 0x600000ddc180>{number = 1, name = main}
    
//    可以看到：在没有使用 NSOperationQueue、在主线程中单独使用使用子类 NSInvocationOperation 执行一个操作的情况下，操作是在当前线程执行的，并没有开启新线程。
}

//任务
- (void)taskFun {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:self.randomNum];
        NSLog(@"for - currentThread-%d:%@", i,  [NSThread currentThread]);
    }
}

//使用子类 NSBlockOperation
- (IBAction)click2:(id)sender {
    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum];
            NSLog(@"for - currentThread-%d:%@", i,  [NSThread currentThread]);
        }
    }];
    // 2.调用 start 方法开始执行操作
    [op start];
    
//    for - currentThread-0:<NSThread: 0x600000c40400>{number = 1, name = main}
//    for - currentThread-1:<NSThread: 0x600000c40400>{number = 1, name = main}
//    和上边 NSInvocationOperation 使用一样。因为代码是在主线程中调用的，所以打印结果为主线程。如果在其他线程中执行操作，则打印结果为其他线程。
}

//使用子类 NSBlockOperation-addExecutionBlock:
- (IBAction)click3:(id)sender {
    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"b - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 2.添加额外的操作
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"e1 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"e2 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"e3 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"e4 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"e5 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"e6 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"e7 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.调用 start 方法开始执行操作
    [op start];
    
//2021-04-15 10:12:46.227143+0800 NSOperationNote[86003:8486964] e4 - currentThread-0:<NSThread: 0x6000022f0940>{number = 4, name = (null)}
//2021-04-15 10:12:46.328191+0800 NSOperationNote[86003:8486875] b - currentThread-0:<NSThread: 0x6000022bca00>{number = 1, name = main}
//2021-04-15 10:12:46.328554+0800 NSOperationNote[86003:8486875] b - currentThread-1:<NSThread: 0x6000022bca00>{number = 1, name = main}
//2021-04-15 10:12:46.428084+0800 NSOperationNote[86003:8486968] e5 - currentThread-0:<NSThread: 0x6000022e59c0>{number = 6, name = (null)}
//2021-04-15 10:12:46.627348+0800 NSOperationNote[86003:8486963] e6 - currentThread-0:<NSThread: 0x6000022e8b00>{number = 7, name = (null)}
//2021-04-15 10:12:46.727468+0800 NSOperationNote[86003:8486965] e2 - currentThread-0:<NSThread: 0x6000022e92c0>{number = 8, name = (null)}
//2021-04-15 10:12:46.827232+0800 NSOperationNote[86003:8486967] e1 - currentThread-0:<NSThread: 0x600002282cc0>{number = 3, name = (null)}
//2021-04-15 10:12:46.829008+0800 NSOperationNote[86003:8486968] e5 - currentThread-1:<NSThread: 0x6000022e59c0>{number = 6, name = (null)}
//2021-04-15 10:12:46.928261+0800 NSOperationNote[86003:8486970] e7 - currentThread-0:<NSThread: 0x6000022d0140>{number = 9, name = (null)}
//2021-04-15 10:12:47.028247+0800 NSOperationNote[86003:8486962] e3 - currentThread-0:<NSThread: 0x6000022a5a80>{number = 5, name = (null)}
//2021-04-15 10:12:47.028996+0800 NSOperationNote[86003:8486965] e2 - currentThread-1:<NSThread: 0x6000022e92c0>{number = 8, name = (null)}
//2021-04-15 10:12:47.127659+0800 NSOperationNote[86003:8486964] e4 - currentThread-1:<NSThread: 0x6000022f0940>{number = 4, name = (null)}
//2021-04-15 10:12:47.228411+0800 NSOperationNote[86003:8486963] e6 - currentThread-1:<NSThread: 0x6000022e8b00>{number = 7, name = (null)}
//2021-04-15 10:12:47.329588+0800 NSOperationNote[86003:8486962] e3 - currentThread-1:<NSThread: 0x6000022a5a80>{number = 5, name = (null)}
//2021-04-15 10:12:47.528753+0800 NSOperationNote[86003:8486967] e1 - currentThread-1:<NSThread: 0x600002282cc0>{number = 3, name = (null)}
//2021-04-15 10:12:47.529429+0800 NSOperationNote[86003:8486970] e7 - currentThread-1:<NSThread: 0x6000022d0140>{number = 9, name = (null)}

//    NSBlockOperation 还提供了一个方法 addExecutionBlock:，通过 addExecutionBlock: 就可以为 NSBlockOperation 添加额外的操作。这些操作（包括 blockOperationWithBlock 中的操作）可以在不同的线程中同时（并发）执行。只有当所有相关的操作已经完成执行时，才视为完成。
//
//    如果添加的操作多的话，blockOperationWithBlock: 中的操作也可能会在其他线程（非当前线程）中执行，这是由系统决定的，并不是说添加到 blockOperationWithBlock: 中的操作一定会在当前线程中执行。（可以使用 addExecutionBlock: 多添加几个操作试试）。
}

//使用自定义子类MyOperation
- (IBAction)click4:(id)sender {
    MyOperation *op = [[MyOperation alloc] init];
    [op start];
    
//2021-04-15 10:17:05.663791+0800 NSOperationNote[86093:8491592] 1---<NSThread: 0x600002588000>{number = 1, name = main}
//2021-04-15 10:17:07.664410+0800 NSOperationNote[86093:8491592] 1---<NSThread: 0x600002588000>{number = 1, name = main}
//    在没有使用 NSOperationQueue、在主线程单独使用自定义继承自 NSOperation 的子类的情况下，是在主线程执行操作，并没有开启新线程。
}

/*
创建队列
NSOperationQueue 一共有两种队列：主队列、自定义队列。其中自定义队列同时包含了串行、并发功能。下边是主队列、自定义队列的基本创建方法和特点。
 
 主队列
 凡是添加到主队列中的操作，都会放到主线程中执行（注：不包括操作使用addExecutionBlock:添加的额外操作，额外操作可能在其他线程执行）。
 // 主队列获取方法
 NSOperationQueue *queue = [NSOperationQueue mainQueue];
 
 自定义队列（非主队列）
 添加到这种队列中的操作，就会自动放到子线程中执行。
 同时包含了：串行、并发功能。
 // 自定义队列创建方法
 NSOperationQueue *queue = [[NSOperationQueue alloc] init];

 */

//使用 addOperation: 将操作加入到操作队列中
- (IBAction)click5:(id)sender {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.创建操作
    // 使用 NSInvocationOperation 创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(taskFun1) object:nil];

    // 使用 NSInvocationOperation 创建操作2
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(taskFun2) object:nil];

    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"b - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"e - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
    [queue addOperation:op3]; // [op3 start]
    
//    2021-04-15 10:39:00.919600+0800 NSOperationNote[86325:8511007] b - currentThread-0:<NSThread: 0x600002b90500>{number = 5, name = (null)}
//    2021-04-15 10:39:01.020357+0800 NSOperationNote[86325:8511011] for - currentThread-0:<NSThread: 0x600002b98ac0>{number = 3, name = (null)}
//    2021-04-15 10:39:01.223044+0800 NSOperationNote[86325:8511011] for - currentThread-1:<NSThread: 0x600002b98ac0>{number = 3, name = (null)}
//    2021-04-15 10:39:01.223043+0800 NSOperationNote[86325:8511007] b - currentThread-1:<NSThread: 0x600002b90500>{number = 5, name = (null)}
//    2021-04-15 10:39:01.319340+0800 NSOperationNote[86325:8511008] for - currentThread-0:<NSThread: 0x600002b94fc0>{number = 6, name = (null)}
//    2021-04-15 10:39:01.420352+0800 NSOperationNote[86325:8511009] e - currentThread-0:<NSThread: 0x600002bd5f40>{number = 4, name = (null)}
//    2021-04-15 10:39:01.420845+0800 NSOperationNote[86325:8511008] for - currentThread-1:<NSThread: 0x600002b94fc0>{number = 6, name = (null)}
//    2021-04-15 10:39:01.421224+0800 NSOperationNote[86325:8511009] e - currentThread-1:<NSThread: 0x600002bd5f40>{number = 4, name = (null)}

//    使用 NSOperation 子类创建操作，并使用 addOperation: 将操作加入到操作队列后能够开启新线程，进行并发执行。
}

- (void)taskFun1 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:self.randomNum];
        NSLog(@"for - currentThread-%d:%@", i,  [NSThread currentThread]);
    }
}

- (void)taskFun2 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:self.randomNum];
        NSLog(@"for - currentThread-%d:%@", i,  [NSThread currentThread]);
    }
}

//使用 addOperationWithBlock: 将操作加入到操作队列中
- (IBAction)click6:(id)sender {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.使用 addOperationWithBlock: 添加操作到队列中
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum];// 模拟耗时操作
            NSLog(@"for 1 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum];// 模拟耗时操作
            NSLog(@"for 2 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum];// 模拟耗时操作
            NSLog(@"for 3 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    
//    2021-04-15 10:41:52.298321+0800 NSOperationNote[86382:8514756] for 3 - currentThread-0:<NSThread: 0x60000195c840>{number = 6, name = (null)}
//    2021-04-15 10:41:52.396995+0800 NSOperationNote[86382:8514755] for 2 - currentThread-0:<NSThread: 0x600001967680>{number = 7, name = (null)}
//    2021-04-15 10:41:52.499402+0800 NSOperationNote[86382:8514757] for 1 - currentThread-0:<NSThread: 0x600001973240>{number = 5, name = (null)}
//    2021-04-15 10:41:52.499845+0800 NSOperationNote[86382:8514757] for 1 - currentThread-1:<NSThread: 0x600001973240>{number = 5, name = (null)}
//    2021-04-15 10:41:53.203626+0800 NSOperationNote[86382:8514756] for 3 - currentThread-1:<NSThread: 0x60000195c840>{number = 6, name = (null)}
//    2021-04-15 10:41:53.297588+0800 NSOperationNote[86382:8514755] for 2 - currentThread-1:<NSThread: 0x600001967680>{number = 7, name = (null)}

//    使用 addOperationWithBlock: 将操作加入到操作队列后能够开启新线程，进行并发执行。
}

/*
 NSOperationQueue 创建的自定义队列同时具有串行、并发功能
 关键属性 maxConcurrentOperationCount，叫做最大并发操作数。用来控制一个特定队列中可以有多少个操作同时参与并发执行。
 注意：这里 maxConcurrentOperationCount 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数。而且一个操作也并非只能在一个线程中运行。
 最大并发操作数：maxConcurrentOperationCount
 maxConcurrentOperationCount 默认情况下为-1，表示不进行限制，可进行并发执行。
 maxConcurrentOperationCount 为1时，队列为串行队列。只能串行执行。
 maxConcurrentOperationCount 大于1时，队列为并发队列。操作并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整为 min{自己设定的值，系统设定的默认最大值}。
 */
//设置 MaxConcurrentOperationCount（最大并发操作数）
- (IBAction)click7:(id)sender {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.设置最大并发操作数
    queue.maxConcurrentOperationCount = 1; // 串行队列
    // queue.maxConcurrentOperationCount = 2; // 并发队列
    // queue.maxConcurrentOperationCount = 8; // 并发队列

    // 3.添加操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"for 1 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"for 2 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"for 3 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"for 4 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
}

/*
 NSOperation、NSOperationQueue 最吸引人的地方是它能添加操作之间的依赖关系。通过操作依赖，我们可以很方便的控制操作之间的执行先后顺序。NSOperation 提供了3个接口供我们管理和查看依赖。

 - (void)addDependency:(NSOperation *)op; 添加依赖，使当前操作依赖于操作 op 的完成。
 - (void)removeDependency:(NSOperation *)op; 移除依赖，取消当前操作对操作 op 的依赖。
 @property (readonly, copy) NSArray<NSOperation *> *dependencies; 在当前操作开始执行之前完成执行的所有操作对象数组。
 当然，我们经常用到的还是添加依赖操作。现在考虑这样的需求，比如说有 A、B 两个操作，其中 A 执行完操作，B 才能执行操作。

 如果使用依赖来处理的话，那么就需要让操作 B 依赖于操作 A。具体代码如下：
 */
//操作依赖，使用方法：addDependency:
- (IBAction)click8:(id)sender {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"for 1 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"for 2 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.添加依赖
    [op2 addDependency:op1]; // 让op2 依赖于 op1，则先执行op1，在执行op2

    // 4.添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    
//    2021-04-15 10:50:20.803443+0800 NSOperationNote[86538:8523480] for 1 - currentThread-0:<NSThread: 0x600001cf8f00>{number = 7, name = (null)}
//    2021-04-15 10:50:21.407097+0800 NSOperationNote[86538:8523480] for 1 - currentThread-1:<NSThread: 0x600001cf8f00>{number = 7, name = (null)}
//    2021-04-15 10:50:22.312737+0800 NSOperationNote[86538:8523478] for 2 - currentThread-0:<NSThread: 0x600001cf9240>{number = 6, name = (null)}
//    2021-04-15 10:50:22.716755+0800 NSOperationNote[86538:8523478] for 2 - currentThread-1:<NSThread: 0x600001cf9240>{number = 6, name = (null)}
//    通过添加操作依赖，无论运行几次，其结果都是 op1 先执行，op2 后执行。
}

/*
 NSOperation 优先级
 NSOperation 提供了queuePriority（优先级）属性，queuePriority属性适用于同一操作队列中的操作，不适用于不同操作队列中的操作。默认情况下，所有新创建的操作对象优先级都是NSOperationQueuePriorityNormal。但是我们可以通过setQueuePriority:方法来改变当前操作在同一队列中的执行优先级。
 // 优先级的取值
 typedef NS_ENUM(NSInteger, NSOperationQueuePriority) {
     NSOperationQueuePriorityVeryLow = -8L,
     NSOperationQueuePriorityLow = -4L,
     NSOperationQueuePriorityNormal = 0,
     NSOperationQueuePriorityHigh = 4,
     NSOperationQueuePriorityVeryHigh = 8
 };
 
 对于添加到队列中的操作，首先进入准备就绪的状态（就绪状态取决于操作之间的依赖关系），然后进入就绪状态的操作的开始执行顺序（非结束执行顺序）由操作之间相对的优先级决定（优先级是操作对象自身的属性）。

 那么，什么样的操作才是进入就绪状态的操作呢？

 当一个操作的所有依赖都已经完成时，操作对象通常会进入准备就绪状态，等待执行。
 举个例子，现在有4个优先级都是 NSOperationQueuePriorityNormal（默认级别）的操作：op1，op2，op3，op4。其中 op3 依赖于 op2，op2 依赖于 op1，即 op3 -> op2 -> op1。现在将这4个操作添加到队列中并发执行。

 因为 op1 和 op4 都没有需要依赖的操作，所以在 op1，op4 执行之前，就是处于准备就绪状态的操作。
 而 op3 和 op2 都有依赖的操作（op3 依赖于 op2，op2 依赖于 op1），所以 op3 和 op2 都不是准备就绪状态下的操作。
 理解了进入就绪状态的操作，那么我们就理解了queuePriority 属性的作用对象。

 queuePriority 属性决定了进入准备就绪状态下的操作之间的开始执行顺序。并且，优先级不能取代依赖关系。
 如果一个队列中既包含高优先级操作，又包含低优先级操作，并且两个操作都已经准备就绪，那么队列先执行高优先级操作。比如上例中，如果 op1 和 op4 是不同优先级的操作，那么就会先执行优先级高的操作。
 如果，一个队列中既包含了准备就绪状态的操作，又包含了未准备就绪的操作，未准备就绪的操作优先级比准备就绪的操作优先级高。那么，虽然准备就绪的操作优先级低，也会优先执行。优先级不能取代依赖关系。如果要控制操作间的启动顺序，则必须使用依赖关系。
 
 */

//NSOperation、NSOperationQueue 线程间的通信
- (IBAction)click9:(id)sender {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];

    // 2.添加操作
    [queue addOperationWithBlock:^{
        // 异步进行耗时操作
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
            NSLog(@"for 1 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
        }

        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 进行一些 UI 刷新等操作
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:self.randomNum]; // 模拟耗时操作
                NSLog(@"for 2 - currentThread-%d:%@", i,  [NSThread currentThread]); // 打印当前线程
            }
        }];
    }];
    
//    在 iOS 开发过程中，我们一般在主线程里边进行 UI 刷新，例如：点击、滚动、拖拽等事件。我们通常把一些耗时的操作放在其他线程，比如说图片下载、文件上传等耗时操作。而当我们有时候在其他线程完成了耗时操作时，需要回到主线程，那么就用到了线程之间的通讯。
    
//    2021-04-15 10:55:50.562850+0800 NSOperationNote[86637:8529059] for 1 - currentThread-0:<NSThread: 0x600000a84cc0>{number = 7, name = (null)}
//    2021-04-15 10:55:51.064808+0800 NSOperationNote[86637:8529059] for 1 - currentThread-1:<NSThread: 0x600000a84cc0>{number = 7, name = (null)}
//    2021-04-15 10:55:51.165620+0800 NSOperationNote[86637:8528973] for 2 - currentThread-0:<NSThread: 0x600000ac4340>{number = 1, name = main}
//    2021-04-15 10:55:51.165970+0800 NSOperationNote[86637:8528973] for 2 - currentThread-1:<NSThread: 0x600000ac4340>{number = 1, name = main}
//    通过线程间的通信，先在其他线程中执行操作，等操作执行完了之后再回到主线程执行主线程的相应操作。
}


/*
 NSOperation、NSOperationQueue 线程同步和线程安全
 线程安全：如果你的代码所在的进程中有多个线程在同时运行，而这些线程可能会同时运行这段代码。如果每次运行结果和单线程运行的结果是一样的，而且其他的变量的值也和预期的是一样的，就是线程安全的。
 若每个线程中对全局变量、静态变量只有读操作，而无写操作，一般来说，这个全局变量是线程安全的；若有多个线程同时执行写操作（更改变量），一般都需要考虑线程同步，否则的话就可能影响线程安全。
 线程同步：可理解为线程 A 和 线程 B 一块配合，A 执行到一定程度时要依靠线程 B 的某个结果，于是停下来，示意 B 运行；B 依言执行，再将结果给 A；A 再继续操作。
 
 线程安全解决方案：可以给线程加锁，在一个线程执行该操作的时候，不允许其他线程进行操作。iOS 实现线程加锁有很多种方式。@synchronized、 NSLock、NSRecursiveLock、NSCondition、NSConditionLock、pthread_mutex、dispatch_semaphore、OSSpinLock、atomic(property) set/ge等等各种方式。这里我们使用 NSLock 对象来解决线程同步问题。NSLock 对象可以通过进入锁时调用 lock 方法，解锁时调用 unlock 方法来保证线程安全。
 */
- (IBAction)click10:(id)sender {
    NSLog(@"currentThread---%@",[NSThread currentThread]); // 打印当前线程

    self.ticketSurplusCount = 50;

    self.lock = [[NSLock alloc] init];  // 初始化 NSLock 对象

    // 1.创建 queue1,queue1 代表北京火车票售卖窗口
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;

    // 2.创建 queue2,queue2 代表上海火车票售卖窗口
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;

    // 3.创建卖票操作 op1
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketSafe];
    }];

    // 4.创建卖票操作 op2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketSafe];
    }];

    // 5.添加操作，开始卖票
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe {
    while (1) {

        // 加锁
        [self.lock lock];

        if (self.ticketSurplusCount > 0) {
            //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%ld 窗口:%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:self.randomNum];
        }

        // 解锁
        [self.lock unlock];

        if (self.ticketSurplusCount <= 0) {
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}

/**
 NSOperation 常用属性和方法
 取消操作方法
 - (void)cancel; 可取消操作，实质是标记 isCancelled 状态。
 判断操作状态方法
 - (BOOL)isFinished; 判断操作是否已经结束。
 - (BOOL)isCancelled; 判断操作是否已经标记为取消。
 - (BOOL)isExecuting; 判断操作是否正在在运行。
 - (BOOL)isReady; 判断操作是否处于准备就绪状态，这个值和操作的依赖关系相关。
 操作同步
 - (void)waitUntilFinished; 阻塞当前线程，直到该操作结束。可用于线程执行顺序的同步。
 - (void)setCompletionBlock:(void (^)(void))block; completionBlock 会在当前操作执行完毕时执行 completionBlock。
 - (void)addDependency:(NSOperation *)op; 添加依赖，使当前操作依赖于操作 op 的完成。
 - (void)removeDependency:(NSOperation *)op; 移除依赖，取消当前操作对操作 op 的依赖。
 @property (readonly, copy) NSArray<NSOperation *> *dependencies; 在当前操作开始执行之前完成执行的所有操作对象数组。
 */

/**
 NSOperationQueue 常用属性和方法
 取消/暂停/恢复操作
 - (void)cancelAllOperations; 可以取消队列的所有操作。
 - (BOOL)isSuspended; 判断队列是否处于暂停状态。 YES 为暂停状态，NO 为恢复状态。
 - (void)setSuspended:(BOOL)b; 可设置操作的暂停和恢复，YES 代表暂停队列，NO 代表恢复队列。
 操作同步
 - (void)waitUntilAllOperationsAreFinished; 阻塞当前线程，直到队列中的操作全部执行完毕。
 添加/获取操作`
 - (void)addOperationWithBlock:(void (^)(void))block; 向队列中添加一个 NSBlockOperation 类型操作对象。
 - (void)addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait; 向队列中添加操作数组，wait 标志是否阻塞当前线程直到所有操作结束
 - (NSArray *)operations; 当前在队列中的操作数组（某个操作执行结束后会自动从这个数组清除）。
 - (NSUInteger)operationCount; 当前队列中的操作数。
 获取队列
 + (id)currentQueue; 获取当前队列，如果当前线程不是在 NSOperationQueue 上运行则返回 nil。
 + (id)mainQueue; 获取主队列。
 
 注意：
 这里的暂停和取消（包括操作的取消和队列的取消）并不代表可以将当前的操作立即取消，而是当当前的操作执行完毕之后不再执行新的操作。
 暂停和取消的区别就在于：暂停操作之后还可以恢复操作，继续向下执行；而取消操作之后，所有的操作就清空了，无法再接着执行剩下的操作。
 */

/**
 参考
 https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationObjects/OperationObjects.html
 https://www.jianshu.com/p/4b1d77054b35
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
