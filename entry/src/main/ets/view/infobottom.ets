import { text } from '@kit.ArkGraphics2D'

@Entry
@Component
export struct infoBottom {
  @State txt:string='12fsfsf3'
  onSubmitComment=(content:string)=>{}
  build() {
    Row(){
      Row(){
        Text('\ue602')
          .fontFamily('fontpinlun')
          .fontSize(18)
          .margin({left:20})
        TextInput({
          placeholder:'写评论...',
          text:$$this.txt  //添加$$可以实现双向绑定
        })
          .backgroundColor(Color.Transparent)
          .fontSize(18)
          .onSubmit(()=>{
            //不能直接添加，需要调用父组件传递过来的方法
            this.onSubmitComment(this.txt)
          })
      }
        .height(40)
        .backgroundColor('#f5f6f5')
        .borderRadius(20)
        .margin({left:15,right:20,top:10,bottom:10})
        .layoutWeight(1)
      Text('\ue6de')
        .fontFamily('fontpinlun')
        .fontSize(26)
        .margin({left:6,right:6})
    }
    .height(60)
    .width('100%')
    //.backgroundColor(Color.Pink)
  }
}