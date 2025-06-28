@Extend(Button)
function fancyButton(ison:boolean){
  .width(46)
  .height(32)
  .fontSize(12)
  .padding({left:5,right:5})
  .backgroundColor(ison?'#fff':'#F7F8FA')
  .fontColor(ison?'#2f2e33':'#8e9298')
  .border({width:1,color:ison?'#e4e5e6':'#F7F8FA'})
}


@Component
struct InfoTop{
  @State isOn:boolean=true
  onSort=(type:number)=>{}
  build() {

    Row(){
      Text('全部评论')
        .fontColor(Color.Black)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Row(){
        Button('最新',{stateEffect:false})//去掉点击激活的效果
          .fancyButton(this.isOn)
          .onClick(()=>{
            this.isOn=true
            this.onSort(0)
          })
        Button('最热')
          .fancyButton(!this.isOn)
          .onClick(()=>{
            this.isOn=false
            this.onSort(1)
          })
     }.backgroundColor('#F7F8FA')
      .borderRadius(20)

    }.width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding(16)
    .height(50)


  }
}
export default InfoTop