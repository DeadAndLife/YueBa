//
//  FacesView.m
//  Yueba
//
//  Created by qingyun on 16/7/23.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "FacesView.h"
#import "Common.h"
#import "FaceModel.h"

#define kFaceWith 60
#define kFaceHeight 40

@interface FacesView ()

@property (nonatomic)NSInteger columns;//每页列数
@property (nonatomic)NSInteger lines;//每页的行数
@property (nonatomic)NSInteger page;//多少页

@property (nonatomic, strong)NSArray *faces;//表情模型数组

@end

@implementation FacesView



-(void)awakeFromNib{
    _columns = kScreenWidth / kFaceWith;
    _lines = self.bounds.size.height / kFaceHeight;
    //加载数据
    [self loadFace];
    _page = self.faces.count/(_columns * _lines);
    
}

-(void)loadFace{
    //从plist中读取文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Faces" ofType:@"pilst"];
    NSDictionary *faceDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *tt = faceDict[@"TT"];//tt表情数组
    NSMutableArray *faceMu = [NSMutableArray array];
    //每页多少个
    NSInteger pageCount = _lines * _columns;
    for (int i = 0; i < tt.count; i ++) {
        NSDictionary *faceInfo = tt[i];
        
        
        //如果到最后一个添加一个回退按钮
        if (i % (pageCount -1) == 0) {
            [faceMu addObject:[self createdBackModel]];
        }
        
        FaceModel *model = [[FaceModel alloc] initWithDict:faceInfo];
        [faceMu addObject:model];
    }
    
    //把最后一页补满
    //最后一页剩余几个
    NSInteger last = faceMu.count%pageCount;
    //还差几个
    for (int i = 0; i < (pageCount - last); i ++) {
        FaceModel *model = [[FaceModel alloc] init];
        [faceMu addObject:model];
    }
    
    _faces = faceMu;
}

-(FaceModel*)createdBackModel{
    FaceModel *back = [[FaceModel alloc] init];
    back.imgName = @"ic_back_emojis";
    back.isBack = YES;
    return back;
}

@end
