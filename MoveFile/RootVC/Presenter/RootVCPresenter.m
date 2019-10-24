//
//  RootVCPresenter.m
//  MoverCode
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.

#import "RootVCPresenter.h"
#import "RootVCInteractor.h"
#import "RootVCProtocol.h"
#import <PoporFMDB/PoporFMDB.h>
#import "NSTextField+Address.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import "EditableTextField.h"

static int CellHeight = 23;

@interface RootVCPresenter ()

@property (nonatomic, weak  ) id<RootVCProtocol> view;
@property (nonatomic, strong) RootVCInteractor * interactor;

// 因为app启动之后,会自动修改最后一列column,所以刚开始不允许更新,1s后才可以.
@property (nonatomic, getter=isAllowColumnUpdateWidth) BOOL allowColumnUpdateWidth;

@end

@implementation RootVCPresenter

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setMyInteractor:(RootVCInteractor *)interactor {
    self.interactor = interactor;
    
}

- (void)setMyView:(id<RootVCProtocol>)view {
    self.view = view;
    
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.allowColumnUpdateWidth = YES;
    });
}

#pragma mark - VC_DataSource
- (NSArray *)columnFolderArray {
    return self.interactor.columnFolderArray;
}

- (NSArray *)columnTagArray {
    return self.interactor.columnTagArray;
}

#pragma mark table delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    if (aTableView.tag == folderTVTag) {
        //NSLog(@"folderTV %li", self.interactor.moveEntityArray.count);
        return self.interactor.folderEntityArray.count;
    }else if (aTableView.tag == TagTVTag){
        //NSLog(@"tagTV %li", self.interactor.moveTagArray.count);
        return self.interactor.tagEntityArray.count;
    }else{
        //NSLog(@"TV 0");
        return 0;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return CellHeight;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    __weak typeof(self) weakSelf = self;
    if (tableView.tag == folderTVTag) {
        NSInteger column = [[tableColumn.identifier substringFromIndex:tableColumn.identifier.length-1] intValue];
        //NSLog(@"column: %li", column);
        NSView *cell;
        MoveFolderEntity * entity = self.interactor.folderEntityArray[row];
        if (!entity) {
            NSLog(@"self.interactor.moveEntityArray count: %li", self.interactor.folderEntityArray.count);
            return nil;
        }
        // NSLog(@"%li - %li", row, column);
        switch (column) {
            case 0:{
                NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:NO initBlock:^(NSDictionary *dic) {
                    NSTextField * tf = dic[@"tf"];
                    tf.alignment = NSTextAlignmentCenter;
                }];
                cellTF.stringValue = [NSString stringWithFormat:@"%li", row];
                cell = cellTF;
                break;
            }
            case 1:{
                NSButton * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
                if (!cellBT) {
                    cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
                    [cellBT setButtonType:NSButtonTypeSwitch];
                    [cellBT setTarget:self];
                    [cellBT setAction:@selector(cellMoveBTAction:)];
                    cellBT.title = @"";
                }
                cellBT.tag = row;
                cellBT.state = entity.move ? NSControlStateValueOn:NSControlStateValueOff;
                cell = cellBT;
                
                break;
            }
            case 2:{
                NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:YES initBlock:^(NSDictionary *dic) {
                    NSTextField * tf = dic[@"tf"];
                    tf.alignment = NSTextAlignmentLeft;
                }];
                cellTF.stringValue = entity.originPath;
                cell = cellTF;
                
                cellTF.weakEntity = entity;
                __block BOOL startMonitor = NO;
                [cellTF.rac_textSignal subscribeNext:^(id x) {
                    if (!startMonitor) {
                        startMonitor = YES;
                    }else{
                        if (cellTF.weakEntity == entity) {
                            [weakSelf.interactor updateEntity:entity originPath:x];
                        }
                    }
                }];
                break;
            }
            case 3:{
                NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:YES initBlock:^(NSDictionary *dic) {
                    NSTextField * tf = dic[@"tf"];
                    tf.alignment = NSTextAlignmentLeft;
                }];
                cellTF.stringValue = entity.targetPath;
                cell = cellTF;
                
                cellTF.weakEntity = entity;
                __block BOOL startMonitor = NO;
                [cellTF.rac_textSignal subscribeNext:^(id x) {
                    if (!startMonitor) {
                        startMonitor = YES;
                    }else{
                        if (cellTF.weakEntity == entity) {
                            [weakSelf.interactor updateEntity:entity targetPath:x];
                        }
                    }
                }];
                
                break;
            }
            case 4:{
                NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:YES initBlock:^(NSDictionary *dic) {
                    NSTextField * tf = dic[@"tf"];
                    tf.alignment = NSTextAlignmentLeft;
                }];
                cellTF.stringValue = entity.tip;
                cell = cellTF;
                
                cellTF.weakEntity = entity;
                __block BOOL startMonitor = NO;
                [cellTF.rac_textSignal subscribeNext:^(id x) {
                    if (!startMonitor) {
                        startMonitor = YES;
                    }else{
                        if (cellTF.weakEntity == entity) {
                            [weakSelf.interactor updateEntity:entity tip:x];
                        }
                    }
                }];
                break;
            }
            default:
                break;
        }
        
        
        return cell;
    }else if (tableView.tag == TagTVTag){
        NSView *cell;
        MoveTagEntity * entity = self.interactor.tagEntityArray[row];
        NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:YES initBlock:^(NSDictionary *dic) {
            NSTextField * tf = dic[@"tf"];
            tf.alignment = NSTextAlignmentLeft;
        }];
        cellTF.stringValue = entity.title;
        cell = cellTF;
        
        cellTF.weakEntity = entity;
        __block BOOL startMonitor = NO;
        [cellTF.rac_textSignal subscribeNext:^(id x) {
            if (!startMonitor) {
                startMonitor = YES;
            }else{
                if (cellTF.weakEntity == entity) {
                    [weakSelf.interactor updateTagEntity:entity title:x];
                }
            }
        }];
        return cell;
    }else{
        return nil;
    }
}

// 返回编辑状态下成白色的背景色的TF.
- (EditableTextField *)tableView:(NSTableView *)tableView cellTFForColumn:(NSTableColumn *)tableColumn row:(NSInteger)row edit:(BOOL)edit initBlock:(BlockPDic)block {
    EditableTextField * cellTF = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
    if (!cellTF) {
        int font = 17;
        cellTF = [[EditableTextField alloc] initWithFrame:CGRectMake(0, (CellHeight-font)/2, tableColumn.width, font)];
        cellTF.font            = [NSFont systemFontOfSize:font-2];
        cellTF.alignment       = NSTextAlignmentCenter;
        cellTF.editable        = edit;
        cellTF.identifier      = tableColumn.identifier;
        
        cellTF.backgroundColor = [NSColor clearColor];
        cellTF.bordered        = NO;
        
        cellTF.lineBreakMode   = NSLineBreakByTruncatingMiddle;
        if (block) {
            block(@{@"tf":cellTF});
        }
    }
    cellTF.tag = row;
    return cellTF;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    // NSLog(@"clumn : %@", tableColumn.identifier);
}

// !!!: column 排序
- (void)tableView:(NSTableView *)tableView didDragTableColumn:(NSTableColumn *)tableColumn {
    if (tableView.tag == folderTVTag) {
        //NSLog(@"tv did drag : %@", tableColumn.identifier);
        for (int i=0; i< tableView.tableColumns.count; i++) {
            //NSLog(@"i = %i id:%@", i, tableColumn.identifier);
            NSTableColumn * column = tableView.tableColumns[i];
            [PDB updateClass:[ColumnEntity class] key:@"sort" equal:@(i) where:@"columnID" equal:column.identifier];
        }
    }
}

// !!!: column resize
- (void)tableViewColumnDidResize:(NSNotification *)notification {
    if (!self.isAllowColumnUpdateWidth) {
        return;
    }
    
    NSTableColumn * column = notification.userInfo[@"NSTableColumn"];
    if ([column.identifier hasPrefix:@"folder"]) {
        // 现在的策略是忽略最后一个NSTableColumn,因为这个会随着window.size变化,忽略即可完美处理.
        if ([column isEqual:self.view.folderTV.tableColumns.lastObject]) {
            //NSLog(@"ignore");
            return;
        }else{
            //NSLog(@"notification: %@ \n tableColumn.identifier:%@  width:%i", [notification description], column.identifier,  (int)column.width);
            //int NSOldWidth = (int)[notification.userInfo[@"NSOldWidth"] intValue];
            //NSLog(@"folder TV update column width : id:%@,  width:%i", column.identifier,  (int)column.width);
            NSLog(@"2  folder TV");
            [PDB updateClass:[ColumnEntity class] key:@"width" equal:@(column.width) where:@"columnID" equal:column.identifier];
        }
    }else if ([column.identifier hasPrefix:@"tag"]) {
        //NSLog(@"tag TV update column width : id:%@,  width:%i", column.identifier,  (int)column.width);
        NSLog(@"1  tag TV");
        [PDB updateClass:[ColumnEntity class] key:@"width" equal:@(column.width) where:@"columnID" equal:column.identifier];
        
        [self.view.tagTV_CSV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(column.width + 20);
        }];
    }
}

// !!!: row 排序模块
// [tableView registerForDraggedTypes:@[NSPasteboardNameDrag]];
// https://juejin.im/entry/5795deb90a2b580061c7eb74
- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    if (tableView == self.view.folderTV || tableView == self.view.tagTV) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
        //NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [pboard declareTypes:@[NSPasteboardNameDrag] owner:self];
        
        [pboard setData:data forType:NSPasteboardNameDrag];
        [pboard setString:[NSString stringWithFormat:@"%li", [rowIndexes firstIndex]] forType:NSPasteboardNameDrag];
        return YES;
    }else{
        return NO;
    }
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    if (tableView == self.view.folderTV || tableView == self.view.tagTV) {
        if (dropOperation == NSTableViewDropAbove) {
            return NSDragOperationMove;
        }else{
            return NSDragOperationNone;
        }
    }else{
        return NSDragOperationNone;
    }
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    NSString * currencyCode = [info.draggingPasteboard stringForType:NSPasteboardNameDrag];
    NSInteger from = [currencyCode integerValue];
    if (tableView == self.view.folderTV) {
        [self resortTV:tableView form:from to:row array:self.interactor.folderEntityArray];
        [self updateArray:self.interactor.folderEntityArray key:@"sort" whereKey:@"folderID"];
        return YES;
    }else if(tableView == self.view.tagTV){
        [self resortTV:tableView form:from to:row array:self.interactor.tagEntityArray];
        [self updateArray:self.interactor.tagEntityArray key:@"sort" whereKey:@"tagID"];
        return YES;
    }else{
        return NO;
    }
}

- (void)resortTV:(NSTableView *)tableView form:(NSInteger)from to:(NSInteger)to array:(NSMutableArray *)array {
    if (array.count > 1 && from != to && (from-to) != -1) {
        NSLog(@"from: %li, to:%li", from, to);
        id entity = array[from];
        [array removeObject:entity];
        if (from > to) {
            [array insertObject:entity atIndex:to];
        }else{
            [array insertObject:entity atIndex:to-1];
        }
        [tableView reloadData];
    }
}

- (void)updateArray:(NSMutableArray *)array key:(NSString *)key whereKey:(NSString *)whereKey {
    for (NSInteger i = 0; i<array.count; i++) {
        id sortEntity = array[i];
        [PDB updateEntity:sortEntity key:key equal:@(i) where:whereKey];
    }
}

#pragma mark - VC_EventHandler
- (void)tableViewClick:(NSTableView *)tableView {
    NSInteger row = tableView.clickedRow;
    //NSInteger Column = tableView.clickedColumn;
    //NSLog(@"点击Column: %li row: %li",Column, row);
    
    if (tableView.tag == TagTVTag) {
        if (self.interactor.tagEntityArray == 0) {
            [self.interactor.folderEntityArray removeAllObjects];
            [self.view.folderTV reloadData];
        }else{
            if (row>-1) {
                MoveTagEntity * entity = self.interactor.tagEntityArray[row];
                [self.interactor updateMoveFolderArrayWith:entity];
                [self.view.folderTV reloadData];
            }
        }
    }
}

- (void)addNewTagBTAction {
    {
        NSTextField *accessory = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,300,20)];
        //NSFont *font = [NSFont systemFontOfSize:20];
        //NSDictionary *textAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        //[accessory insertText:[[NSAttributedString alloc] initWithString:@""                                                                        attributes:textAttributes] replacementRange:(NSRange){0,0}];
        [accessory setEditable:YES];
        //accessory.textContainerInset = CGSizeMake(0, 3);
        //[accessory setDrawsBackground:NO];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSAlertStyleInformational];
        [alert setMessageText:@"新增标签"];
        [alert setInformativeText:@"请输入新标签名称"];
        [alert setHelpAnchor:@"help anchor"];
        [alert addButtonWithTitle:@"创建"];
        [alert addButtonWithTitle:@"取消"];
        //[alert setShowsSuppressionButton:YES];
        
        [alert setAccessoryView:accessory];
        __weak typeof(self) weakSelf = self;
        
        [alert beginSheetModalForWindow:self.view.vc.view.window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == NSAlertFirstButtonReturn) {
                NSLog(@"确定: %@", accessory.stringValue);
                if (accessory.stringValue.length>0) {
                    [weakSelf.interactor addMoveTagTitle:accessory.stringValue];
                    [weakSelf.view.tagTV reloadData];
                }
            }
        }];
        [accessory becomeFirstResponder];
    }
}

- (void)addNewFolderBTAction {
    if (self.interactor.tagEntityArray.count == 0) {
        AlertToastTitleTime(@"请先增加标签", 3, self.view.vc.view);
        return;
    }
    MoveTagEntity * tagEntity;
    if (self.view.tagTV.selectedRow > -1) {
        tagEntity = self.interactor.tagEntityArray[self.view.tagTV.selectedRow];
    }else{
        AlertToastTitleTime(@"请先选择标签", 3, self.view.vc.view);
        return;
    }
    
    NSLog(@"addNewFolderBTAction");
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:YES];
    //[panel setAllowedFileTypes:@[@"xcarchive"]];
    
    [NSApp.windows[0] setLevel:NSNormalWindowLevel];
    
    if ([panel runModal] == NSModalResponseOK) {
        for (int i = 0; i<panel.URLs.count; i++) {
            NSString * path   = [panel.URLs[i] path];
            NSLog(@"path: %@", path);   
            [self.interactor addNewPath:path tagID:tagEntity.tagID];
        }
        [self.view.folderTV reloadData];
    }
}

- (void)openDbFolderBTAction {
    [self openPath:PDBShare.DBPath];
}

- (void)cellMoveBTAction:(NSButton *)bt {
    NSLog(@"bt: %li switch: %li", bt.tag, bt.state);
    MoveFolderEntity * entity = self.interactor.folderEntityArray[bt.tag];
    [self.interactor updateEntity:entity move:bt.state==NSControlStateValueOn ? YES:NO];
}

- (void)clearAllFolderBTAction {
    NSLog(@"clearAllFolderBTAction");
}

- (void)tagTVRightDeleteAction:(id)sender {
    NSInteger row    = self.view.tagTV.clickedRow;
    if (row == -1) {
        AlertToastTitle(@"请右键想要删除的内容", self.view.vc.view);
        return;
    }
    MoveTagEntity * entity = self.interactor.tagEntityArray[row];
    
    [self.interactor deleteTagEntity:entity];
    [self.interactor.tagEntityArray removeObject:entity];
    [self.view.tagTV reloadData];
    
    if (self.interactor.tagEntityArray.count == 0) {
        [self.interactor.folderEntityArray removeAllObjects];
        [self.view.folderTV reloadData];
    }else{
        MoveTagEntity * entity = self.interactor.tagEntityArray[0];
        [self.interactor updateMoveFolderArrayWith:entity];
        [self.view.folderTV reloadData];
    }
}

- (void)tagTVRightRenameAction:(id)sender {
    NSInteger row    = self.view.tagTV.clickedRow;
    if (row == -1) {
        AlertToastTitle(@"请右键想要重命名的内容", self.view.vc.view);
        return;
    }
    MoveTagEntity * entity = self.interactor.tagEntityArray[row];
    
    {
        NSTextField *tf = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,300,20)];
        tf.stringValue = entity.title;
        
        [tf setEditable:YES];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSAlertStyleInformational];
        [alert setMessageText:@"警告"];
        [alert setInformativeText:@"请输入新名称"];
        [alert setHelpAnchor:@"help anchor"];
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
        //[alert setShowsSuppressionButton:YES];
        
        [alert setAccessoryView:tf];
        __weak typeof(self) weakSelf = self;
        
        [alert beginSheetModalForWindow:self.view.vc.view.window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == NSAlertFirstButtonReturn) {
                if (tf.stringValue.length>0) {
                    entity.title = tf.stringValue;
                    [weakSelf.view.tagTV reloadData];
                }
            }
        }];
        [tf becomeFirstResponder];
    }
    
}

- (void)folderTVUpdateOriginPathAction:(id)sender {
    NSInteger row    = self.view.folderTV.clickedRow;
    if (row == -1) {
        AlertToastTitle(@"请右键想要删除的内容", self.view.vc.view);
        return;
    }
    
    MoveFolderEntity * entity = self.interactor.folderEntityArray[row];
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:YES];
    //[panel setAllowedFileTypes:@[@"xcarchive"]];
    
    [NSApp.windows[0] setLevel:NSNormalWindowLevel];
    
    if ([panel runModal] == NSModalResponseOK) {
        for (int i = 0; i<panel.URLs.count; i++) {
            NSString * path   = [panel.URLs[i] path];
            //NSLog(@"path: %@", path);
            [self.interactor updateEntity:entity originPath:path];
        }
        [self.view.folderTV reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)]];
    }
}

- (void)folderTVUpdateTargetPathAction:(id)sender {
    NSInteger row    = self.view.folderTV.clickedRow;
    if (row == -1) {
        AlertToastTitle(@"请右键想要删除的内容", self.view.vc.view);
        return;
    }
    
    MoveFolderEntity * entity = self.interactor.folderEntityArray[row];
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:YES];
    //[panel setAllowedFileTypes:@[@"xcarchive"]];
    
    [NSApp.windows[0] setLevel:NSNormalWindowLevel];
    
    if ([panel runModal] == NSModalResponseOK) {
        for (int i = 0; i<panel.URLs.count; i++) {
            NSString * path   = [panel.URLs[i] path];
            //NSLog(@"path: %@", path);
            [self.interactor updateEntity:entity targetPath:path];
        }
        [self.view.folderTV reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)]];
    }
}

- (void)folderTVOpenOriginPathAction:(id)sender {
    NSInteger row    = self.view.folderTV.clickedRow;
    if (row == -1) {
        AlertToastTitle(@"请右键想要删除的内容", self.view.vc.view);
        return;
    }
    MoveFolderEntity * entity = self.interactor.folderEntityArray[row];
    
    [self openPath:entity.originPath];
}

- (void)folderTVOpenTargetPathAction:(id)sender {
    NSInteger row    = self.view.folderTV.clickedRow;
    if (row == -1) {
        AlertToastTitle(@"请右键想要删除的内容", self.view.vc.view);
        return;
    }
    MoveFolderEntity * entity = self.interactor.folderEntityArray[row];
    [self openPath:entity.targetPath];
}

- (void)openPath:(NSString *)path {
    NSURL * url = [NSURL fileURLWithPath:path];
    NSString * folder = [path substringToIndex:path.length - url.lastPathComponent.length];
    [[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:folder];
}

//- (BOOL)isDirectory:(NSString *)filePath {
//    BOOL isDirectory = NO;
//    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
//    return isDirectory;
//}

- (void)folderTVRightDeleteAction:(id)sender {
    NSInteger row    = self.view.folderTV.clickedRow;
    if (row == -1) {
        AlertToastTitle(@"请右键想要删除的内容", self.view.vc.view);
        return;
    }
    
    MoveFolderEntity * entity = self.interactor.folderEntityArray[row];
    
    [self.interactor deleteEntity:entity];
    [self.interactor.folderEntityArray removeObject:entity];
    
    [self.view.folderTV reloadData];
}

- (void)folderTVClearAllAction:(id)sender {
    NSInteger row    = self.view.tagTV.selectedRow;
    if (row == -1) {
        AlertToastTitle(@"请右键想要重命名的内容", self.view.vc.view);
        return;
    }
    MoveTagEntity * entity = self.interactor.tagEntityArray[row];
    {

        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSAlertStyleInformational];
        [alert setMessageText:@"警告"];
        [alert setInformativeText:[NSString stringWithFormat:@"确定要清空《%@》列表吗?", entity.title]];
        [alert setHelpAnchor:@"help anchor"];
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
        //[alert setShowsSuppressionButton:YES];
        
        __weak typeof(self) weakSelf = self;
        
        [alert beginSheetModalForWindow:self.view.vc.view.window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == NSAlertFirstButtonReturn) {
                [weakSelf folderTVClearAllEvent];
            }
        }];
    }
}

- (void)folderTVClearAllEvent {
    for (MoveFolderEntity * entity in self.interactor.folderEntityArray) {
        [self.interactor deleteEntity:entity];
    }
    [self.interactor.folderEntityArray removeAllObjects];
    [self.view.folderTV reloadData];
}

- (void)moveAction:(id)sender {
    NSMutableArray * sourceArray = [NSMutableArray new];
    NSMutableArray * destArray = [NSMutableArray new];
    
    for (MoveFolderEntity * entity in self.interactor.folderEntityArray) {
        if (entity.isMove) {
            [sourceArray addObject:entity.originPath];
            [destArray   addObject:entity.targetPath];
        }
    }
    [self moveFile:sourceArray to:destArray];
}

// !!!:最终解决方案.
// http://www.itstrike.cn/Question/ee0322c9-5b96-4f0e-9f2d-9177425e0613.html, 非常优秀
- (void)moveFile:(NSArray *)sourceArray to:(NSArray *)destArray {
    if (sourceArray.count != destArray.count || sourceArray.count == 0) {
        return;
    }
    // @"do shell script \"chmod -R 777 /Users/apple/Desktop/move/2/ \" with administrator privileges"
    NSMutableString * cpShell    = [NSMutableString new];
    NSMutableString * chmodShell = [NSMutableString new];
    for (int i = 0; i<sourceArray.count; i++) {
        NSString * sourcePath = sourceArray[i]; // 源文件
        NSString * destFolder = destArray[i];   // 复制到文件夹
        NSString * destPath   = [NSString stringWithFormat:@"%@/%@", destFolder, [NSURL fileURLWithPath:sourcePath].lastPathComponent];
        //NSLog(@"sourcePath: %@", sourcePath);
        //NSLog(@"destPath: %@", destPath);
        [cpShell appendFormat:@"rm -R %@\n", destPath];
        [cpShell appendFormat:@"cp -R %@ %@\n", sourcePath, destFolder];
        [chmodShell appendFormat:@"chmod -R 777 %@\n", destPath];
        
        {
            // 不需要在 dest 后面增加source 的文件名称,系统自动处理; 不然第二次执行的会发生迭代路径.
            // NSString * sourcePath = sourceArray[i]; // 源文件
            // NSString * destFolder = destArray[i];   // 复制到文件夹
            // NSString * destPath   = [NSString stringWithFormat:@"%@/%@", destFolder, [NSURL fileURLWithPath:sourcePath].lastPathComponent];
            //
            // [cpShell appendFormat:@"cp -R %@ %@\n", sourcePath, destPath];
            // [chmodShell appendFormat:@"chmod -R 777 %@\n", destPath];
        }
     
    }
    
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    
    NSString * shell             = [NSString stringWithFormat:@"do shell script \"\n%@ \n%@\" with administrator privileges", cpShell, chmodShell];
    NSAppleScript * scriptObject = [[NSAppleScript alloc] initWithSource:shell];
    returnDescriptor             = [scriptObject executeAndReturnError: &errorDict];
    
    NSLog(@"shell: %@", shell);
    NSLog(@"returnDescriptor : %@, error:%@", returnDescriptor, errorDict);
    if (errorDict) {
        AlertToastTitle(@"转移失败", self.view.vc.view);
    }else{
        AlertToastTitle(@"转移成功", self.view.vc.view);
    }
}

#pragma mark - Interactor_EventHandler

@end
