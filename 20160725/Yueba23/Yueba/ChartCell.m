//
//  ChartCell.m
//  Yueba
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ChartCell.h"
#import <AVOSCloudIM.h>
#import "FaceModel.h"

@implementation ChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImage *image;
    if ([self.reuseIdentifier isEqualToString:@"chartcellleft"]) {
        //设置左边的bgimage
        image = [UIImage imageNamed:@"chat_bubble_gray"];
    }else {
        image = [UIImage imageNamed:@"chat_bubble_red"];
    }
    
    //设置image拉伸
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(17, 23, 18, 24)];
    self.bgImage.image = image;
    
}

-(void)bandingMessage:(AVIMTypedMessage *)message{
    //根据message,绑定内容
    if ([message isKindOfClass:[AVIMTextMessage class]]) {
        //将文字内容转化为富文本,图文混排
        self.messageText.attributedText = [self faceAttributedStringWithMessage:message.text withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} FaceSize:18];
    }
    
    //设置背景素材
    
}

//根据提供的文字和属性,将文字中的表情文字转化为图片
-(NSAttributedString *)faceAttributedStringWithMessage:(NSString *)message withAttributes:(NSDictionary *)attributes FaceSize:(CGFloat )facesize{
    
    //准备一个可变的属性字符串
    NSMutableAttributedString *messageAttributed = [[NSMutableAttributedString alloc] initWithString:message attributes:attributes];
    
    //读取表情文件,遍历数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Faces" ofType:@"plist"];
    NSDictionary *faceDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *tt = faceDict[@"TT"];//tt表情数组
    [tt enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FaceModel *faceModel = [[FaceModel alloc] initWithDict:obj];
        //创建表情富文本(image)
        NSTextAttachment *attachment  = [[NSTextAttachment alloc] init];
        UIImage *image = [UIImage imageNamed:faceModel.imgName];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, 0, facesize, facesize);
        //转化为属性字符
        NSAttributedString *faceString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        //表情在文件中存在的位置
        NSRange resultRange;
        //没有查找的范围
        NSRange searchRange = NSMakeRange(0, messageAttributed.length);
        
        do {
            //将属性字符串中的表情字符串替换为对应的表情富文本
            //查到结果
            resultRange = [messageAttributed.string rangeOfString:faceModel.text options:0 range:searchRange];
            
            if (resultRange.length != 0) {
                //将查到结果的地方,替换为富文本
                [messageAttributed replaceCharactersInRange:resultRange withAttributedString:faceString];
                
                //新的搜索位置起点,考虑转化为图片后,字符长度的减少
                NSInteger index = NSMaxRange(resultRange) - (faceModel.text.length - 1);
                
                searchRange = NSMakeRange(index, messageAttributed.length - index);
            }else{
                //查找空间为零
                searchRange.length = 0;
            }
            
        } while (resultRange.length != 0 && searchRange.location < message.length);
        
    }];
    return messageAttributed;
}

@end
