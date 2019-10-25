//
//  RootVC.m
//  MoverCode
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.

#import "RootVC.h"
#import "RootVCPresenter.h"
#import "RootVCInteractor.h"

@interface RootVC ()

@property (nonatomic, strong) RootVCPresenter * present;
@property (nonatomic, strong) NSButton * addNewTagBT;
@property (nonatomic, strong) NSButton * addNewFolderBT;
@property (nonatomic, strong) NSButton * openDbFolderBT;

@property (nonatomic, strong) NSButton * moveBT;

@end

@implementation RootVC
@synthesize tagTV, tagTV_CSV, tagTVClickMenu;
@synthesize folderTV, folderTV_CSV, folderTVClickMenu;


- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        if (dic) {
            self.title = dic[@"title"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [self assembleViper];
    [super viewDidLoad];
    
    if (!self.title) {
        self.title = @"RootVC";
    }
    //self.view.backgroundColor = [UIColor whiteColor];
    //self.view.layer.back
    /*
    {
        NSView *view = [[NSView alloc]init];
        view.frame = NSMakeRect(0, 0, 100, 100);
        view.wantsLayer = YES;
        view.layer.backgroundColor = [NSColor redColor].CGColor;
        [self.view addSubview:view];
        //————————————————
        //版权声明：本文为CSDN博主「十二月融冰」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
        //原文链接：https://blog.csdn.net/u011876968/article/details/77639990
    }//*/
    {
        //self.view.layer.backgroundColor = [NSColor grayColor].CGColor;
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

#pragma mark - VCProtocol
- (NSViewController *)vc {
    return self;
}

#pragma mark - viper views
- (void)assembleViper {
    if (!self.present) {
        RootVCPresenter  * present    = [RootVCPresenter new];
        RootVCInteractor * interactor = [RootVCInteractor new];
        
        self.present = present;
        [present setMyInteractor:interactor];
        [present setMyView:self];
        
        [self addViews];
        [self startEvent];
    }
}

- (void)addViews {
    //    NSWindow * window = [NSApplication sharedApplication].keyWindow;
    //    window.title = @"MoveCode";
    
    self.moveBT = ({
        NSButton * bt = [NSButton buttonWithTitle:@"转移" target:self.present action:@selector(moveAction:)];
        
        [self.view addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(50);
        }];
        bt;
    });
    self.addNewTagBT = ({
        NSButton * bt = [NSButton buttonWithTitle:@"新增标签" target:self.present action:@selector(addNewTagBTAction)];
        
        [self.view addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.moveBT.mas_top);
            make.width.mas_equalTo(self.moveBT.mas_width);
            make.height.mas_equalTo(self.moveBT.mas_height);
        }];
        bt;
    });
    self.addNewFolderBT = ({
        NSButton * bt = [NSButton buttonWithTitle:@"新增路径" target:self.present action:@selector(addNewFolderBTAction)];
        
        [self.view addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.addNewTagBT.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.moveBT.mas_top);
            make.width.mas_equalTo(self.moveBT.mas_width);
            make.height.mas_equalTo(self.moveBT.mas_height);
        }];
        bt;
    });
    self.openDbFolderBT = ({
        NSButton * bt = [NSButton buttonWithTitle:@"数据库" target:self.present action:@selector(openDbFolderBTAction)];
        
        [self.view addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.addNewFolderBT.mas_right).mas_offset(50);
            make.top.mas_equalTo(self.moveBT.mas_top);
            make.width.mas_equalTo(self.moveBT.mas_width);
            make.height.mas_equalTo(self.moveBT.mas_height);
        }];
        bt;
    });
    
    [self addMenu];
    
    {
        self.tagTV_CSV  = [self addTagTVs];
        self.tagTV      = self.tagTV_CSV.documentView;
        self.tagTV.menu = self.tagTVClickMenu;
        self.tagTV.allowsEmptySelection = NO;
        [self.tagTV selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        [self.tagTV registerForDraggedTypes:@[NSPasteboardNameDrag]];
    }
    
    {
        self.folderTV_CSV  = [self addFolderTVs];
        self.folderTV      = self.folderTV_CSV.documentView;
        self.folderTV.menu = self.folderTVClickMenu;
        [self.folderTV registerForDraggedTypes:@[NSPasteboardNameDrag]];
    }
    
    {
        //[self.folderTV setDoubleAction:NSSelectorFromString(@"doubleClick:")]; // 双击事件
        [self.tagTV setTarget:self.present];
        [self.tagTV setAction:@selector(tableViewClick:)];// 单击事件
    }
}

- (NSScrollView *)addTagTVs {
    CGFloat width = 100;
    // create a table view and a scroll view
    NSScrollView * tableContainer  = [[NSScrollView alloc] initWithFrame:CGRectZero];
    NSTableView * tableView        = [[NSTableView alloc] initWithFrame:tableContainer.bounds];
    tableView.tag = TagTVTag;
    
    NSArray * folderEntityArray = [self.present columnTagArray];
    for (int i=0; i<folderEntityArray.count; i++) {
        ColumnEntity * entity = folderEntityArray[i];
        NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier:entity.columnID];
        column.width         = entity.width;
        column.minWidth      = entity.miniWidth;
        column.title         = entity.title;
        column.headerToolTip = entity.tip;
        
        [tableView addTableColumn:column];
        
        width = entity.width;
    }
    
    tableView.delegate                   = self.present;
    tableView.dataSource                 = self.present;
    tableContainer.documentView          = tableView;
    tableContainer.hasVerticalScroller   = YES;
    tableContainer.hasHorizontalScroller = YES;
    
    [self.view addSubview:tableContainer];
    [tableView reloadData];
    
    [tableContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.moveBT.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(width+20);
        make.bottom.mas_equalTo(-10);
    }];
    
    return tableContainer;
}

- (NSScrollView *)addFolderTVs {
    // create a table view and a scroll view
    NSScrollView * tableContainer  = [[NSScrollView alloc] initWithFrame:CGRectZero];
    NSTableView * tableView        = [[NSTableView alloc] initWithFrame:tableContainer.bounds];
    tableView.tag = folderTVTag;
    NSArray * folderEntityArray = [self.present columnFolderArray];
    for (int i=0; i<folderEntityArray.count; i++) {
        ColumnEntity * entity = folderEntityArray[i];
        NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier:entity.columnID];
        column.width         = entity.width;
        column.minWidth      = entity.miniWidth;
        column.title         = entity.title;
        column.headerToolTip = entity.tip;
        
        [tableView addTableColumn:column];
    }
    
    tableView.delegate                   = self.present;
    tableView.dataSource                 = self.present;
    tableContainer.documentView          = tableView;
    tableContainer.hasVerticalScroller   = YES;
    tableContainer.hasHorizontalScroller = YES;
    
    [self.view addSubview:tableContainer];
    [tableView reloadData];
    
    [tableContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagTV_CSV.mas_right).mas_offset(2);
        make.top.mas_equalTo(self.moveBT.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.tagTV_CSV.mas_bottom);
    }];
    
    return tableContainer;
}

#pragma mark - addMenu
- (void)addMenu {
    if (!self.folderTVClickMenu) {
        self.folderTVClickMenu = [[NSMenu alloc] init];
        
        NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:@"设置源文件路径" action:@selector(folderTVUpdateOriginPathAction:) keyEquivalent:@""];
        NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:@"设置新文件路径" action:@selector(folderTVUpdateTargetPathAction:) keyEquivalent:@""];
        
        NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:@"打开源文件路径" action:@selector(folderTVOpenOriginPathAction:) keyEquivalent:@""];
        NSMenuItem *item4 = [[NSMenuItem alloc] initWithTitle:@"打开新文件路径" action:@selector(folderTVOpenTargetPathAction:) keyEquivalent:@""];
        
        NSMenuItem *item5 = [[NSMenuItem alloc] initWithTitle:@"删除" action:@selector(folderTVRightDeleteAction:) keyEquivalent:@""];
        NSMenuItem *item6 = [[NSMenuItem alloc] initWithTitle:@"清空" action:@selector(folderTVClearAllAction:) keyEquivalent:@""];
        
        [item1 setTarget:self.present];
        [item2 setTarget:self.present];
        [item3 setTarget:self.present];
        [item4 setTarget:self.present];
        [item5 setTarget:self.present];
        [item6 setTarget:self.present];
        
        [self.folderTVClickMenu addItem:item1];
        [self.folderTVClickMenu addItem:item2];
        [self.folderTVClickMenu addItem:[NSMenuItem separatorItem]];
        [self.folderTVClickMenu addItem:item3];
        [self.folderTVClickMenu addItem:item4];
        [self.folderTVClickMenu addItem:[NSMenuItem separatorItem]];
        [self.folderTVClickMenu addItem:item5];
        [self.folderTVClickMenu addItem:item6];
    }
    if (!self.tagTVClickMenu) {
        self.tagTVClickMenu = [NSMenu new];
        
        NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:@"删除" action:@selector(tagTVRightDeleteAction:) keyEquivalent:@""];
        NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:@"重命名" action:@selector(tagTVRightRenameAction:) keyEquivalent:@""];
        
        [item1 setTarget:self.present];
        [item2 setTarget:self.present];
        
        [self.tagTVClickMenu addItem:item1];
        [self.tagTVClickMenu addItem:item2];
    }
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    [self.present startEvent];
    
}

// -----------------------------------------------------------------------------

- (void)resetWindowFrame:(id)sender {
    
}

@end
