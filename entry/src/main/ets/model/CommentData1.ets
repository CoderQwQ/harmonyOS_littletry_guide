@Observed
export class CommentData1{
  avatar:string//头像
  name:string //昵称
  likeNum:number  //点赞数量
  commentTxt:string//朋友圈内容
  commentImg:Resource//朋友圈图片
  isLike:boolean  //是否喜欢
  timeString:string //发布时间-基于时间戳处理后，展示给用户的属性
  time:number //时间戳

  constructor(avatar:string,name:string , time:number,likeNum:number,commentTxt:string,commentImg:Resource,isLike:boolean) {
    this.avatar=avatar
    this.name=name
    this.likeNum=likeNum
    this.commentTxt=commentTxt
    this.isLike=isLike
    this.timeString=this.convertime(time)
    this.time=time
    this.commentImg=commentImg
  }
  convertime(timestamp:number){
    const currentTimestamp=new Date().getTime();  //获取当前的时间戳
    const timeDifference=(currentTimestamp-timestamp)/1000;  //减去过去的时间戳并且转换为秒
    if(timeDifference<0||timeDifference==0){
      return '刚刚';
    }else if(timeDifference<60){
      return `${Math.floor(timeDifference)}秒前`;
    }else if(timeDifference<3600){
      return `${Math.floor(timeDifference/60)}分钟前`;
    }else if(timeDifference<86400){
      return `${Math.floor(timeDifference/3600)}小时前`;
    }else if(timeDifference<604800){
      return `${Math.floor(timeDifference/86400)}天前`;
    }else if(timeDifference<2592000){
      return `${Math.floor(timeDifference/604800)}周前`;
    }else if(timeDifference<31536000){
      return `${Math.floor(timeDifference/2592000)}个月前`;
    }else {
      return `${Math.floor(timeDifference/31536000)}年前`;
    }
  }

}
export const createListRange=():CommentData1[]=>{
  let result:CommentData1[]=new Array()
  result = [
    new CommentData1(`https://fastly.picsum.photos/id/770/600/600.jpg?hmac=tuK9EHg1ifTU3xKAiZj2nHSdWy4mk7enhylgOc2BW7E`, "雪山飞狐", 1645820201123, Math.floor(Math.random()*100), '23年一年干完的事😂😂😂真的非常仓促', $r('app.media.jingdian3'),false),
    new CommentData1(`https://fastly.picsum.photos/id/225/600/600.jpg?hmac=v97zt_t4mxeyMttX_m09pxhCvftiTxFR1MMBZi5HQxs`, "千纸鹤", 1677356201123 , Math.floor(Math.random()*100), '哈哈哈哈哈哈哈哈哈哈哈哈，景色真漂亮',$r('app.media.jingdian3'), false),
    new CommentData1(`https://fastly.picsum.photos/id/122/600/600.jpg?hmac=1oA93YbjYVt96DcJcGQ5PLthzjUsdtrnBQaM0USBozI`, "烟雨江南", 1688772201123, Math.floor(Math.random()*100), '黄山真漂亮', $r('app.media.jingdian3'), false),
    new CommentData1(`https://fastly.picsum.photos/id/654/600/600.jpg?hmac=ewnK6Bx_MKQLJa9waZOV1xNO7--K5oSwCShtz1JDYw8`, "魔法小精灵", 1697484201123 , Math.floor(Math.random()*100), '今天去了西湖。', $r('app.media.jingdian3'), false),
    new CommentData1(`https://fastly.picsum.photos/id/345/600/600.jpg?hmac=EQflzbIadAglm0RzotyKXM2itPfC49fR3QE7eW_UaPo`, "独行侠", 1704067200000 , Math.floor(Math.random()*100), '今天看到一个帖子，挺有意思的。', $r('app.media.jingdian3'), false),
    new CommentData1(`https://fastly.picsum.photos/id/905/600/600.jpg?hmac=DvIKicBZ45DEZoZFwdZ62VbmaCwkK4Sv7rwYzUvwweU`, "枫叶飘零", 1706745600000, Math.floor(Math.random()*100), '今天去了北京天安门看了升旗', $r('app.media.jingdian3'), false),
    new CommentData1(`https://fastly.picsum.photos/id/255/600/600.jpg?hmac=-lfdnAl71_eAIy1OPAupFFPh7EOJPmQRJFg-y7lRB3s`, "星空漫步", 1707523200000 , Math.floor(Math.random()*100), '优胜劣汰，自然选择吧，没什么好怪的。都是crud，招个大学生就能干了。', $r('app.media.jingdian3'), false),
    new CommentData1(`https://fastly.picsum.photos/id/22/600/600.jpg?hmac=QEZq7KUHwBZCt3kGSEHMwJlZfnzCxCeBgHjYj7iQ-UY`, "剑指苍穹", 1708300800000, Math.floor(Math.random()*100), '白嫖ChatGPT4的功能。然后，抱着试一试的态度把玩了一下。发现真的好用。', $r('app.media.jingdian3'), false),
    new CommentData1(`https://fastly.picsum.photos/id/439/600/600.jpg?hmac=LC9k_bzrN0NhKRyV62fou3ix3cRFZKNfAyXgxGs6zh8`, "黑暗王国", 1708646400000 , Math.floor(Math.random()*100), '字数越少，事情越大。',$r('app.media.jingdian3'), false),
  ]
  return result

}
