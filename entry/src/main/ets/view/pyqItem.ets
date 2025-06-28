import { CommentData1 } from '../model/CommentData1'
import font from '@ohos.font';
import {Pinlun} from '../pages/pinlun'
@Component

export struct pyqItem{
  @ObjectLink itemObj:CommentData1
  @Prop index:number
  @State isShow: Boolean = false;
  //onLikeClick=(index:number)=>{}

  aboutToAppear(): void {
    //注册字体
    font.registerFont({
      familyName:'fontpinlun',
      familySrc:'/font/iconfont.ttf'
    })

  }
  @Builder
  myBuilder() {
    Column() {
     Pinlun()
    }
  }
  build() {
    Column()
    {
      //头像、昵称
      Row(){
        Image(this.itemObj.avatar)
          .width(30).aspectRatio(1)//宽高比
          .margin({top:10})
          .borderRadius(15)
        Text(this.itemObj.name)
          .fontSize(13)
          .fontColor(Color.Gray)
          .margin({top:10,left:8})
      }

      //评论内容
      Text(this.itemObj.commentTxt)
        .fontSize(13)
        .fontColor(Color.Black)
        .margin({left:40,top:0,bottom:8})

      //评论日期和点赞互动
      Row(){
        Image(this.itemObj.commentImg)
      }.height(180)
      .width('100%')
      .borderRadius(20)

      Row()
      {
        Row(){
        Text(this.itemObj.timeString)
          .fontSize(11)
          .fontColor(Color.Gray)
        }
        Row(){
          Text('\ue605')
            .fontFamily('fontpinlun')
            .margin({right:20})
        }
        .onClick(()=>{
          this.isShow = true
        })
        .bindSheet($$this.isShow, this.myBuilder(), {
          height: SheetSize.MEDIUM,
          blurStyle: BlurStyle.Thick,
          showClose: false,
          //title: { title: "title", subtitle: "subtitle" },
          preferType: SheetType.CENTER,
          onWillDismiss: ((DismissSheetAction: DismissSheetAction) => {
            if (DismissSheetAction.reason == DismissReason.SLIDE_DOWN) {
              DismissSheetAction.dismiss() //注册dismiss行为
            }
          }),

          onWillSpringBackWhenDismiss: ((SpringBackAction: SpringBackAction) => {
            SpringBackAction.springBack()
          }),
        })

        Row(){

          Image(this.itemObj.isLike?$r('app.media.heart_fill'):$r('app.media.heart'))
            .width(15).aspectRatio(1)
          Text(this.itemObj.likeNum.toString())
            .fontSize(11)
            .fontColor(this.itemObj.isLike?Color.Red:Color.Gray)
        }.onClick(()=>{
          //点击增加点赞数并且变换成红心，需要调用父组件的方法
          //this.onLikeClick(this.index)
          if (this.itemObj.isLike) {
            this.itemObj.likeNum -=1
          }else{
            this.itemObj.likeNum +=1
          }
          this.itemObj.isLike = !this.itemObj.isLike
        })
      }.padding({left:40,top:5})
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .padding({left:15,right:15})
    .alignItems(HorizontalAlign.Start)
  }

}