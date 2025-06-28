import TitleBarComponent from '../view/TitleBarComponent'
@Entry
@Component
struct Shoucang {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      TitleBarComponent()
      Text(this.message)
        .id('ShoucangHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}