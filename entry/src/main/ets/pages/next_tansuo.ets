import { router } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import TitleBarComponent from '../view/TitleBarComponent'
import { webview } from '@kit.ArkWeb';
@Entry
@Component
struct Next_tansuo {
  controller: webview.WebviewController = new webview.WebviewController();
  @State message1: string = 'Hello World';
  aboutToAppear(): void {
    if (router.getParams() !== undefined && router.getParams() !== null) {
      let record = router.getParams() as Record<string, string>;
      if (record !== undefined && record !== null) {
        this.message1 = record['url']
        console.info('接收到前一个页面的参数：', JSON.stringify(record))
      }
    }
  }
  build() {
    Column(){
      TitleBarComponent()
      // Text(this.message1)
      //   .fontSize(30)
      //   .fontWeight(FontWeight.Bold)

      Web({  src: this.message1, controller: this.controller })
    }
    .height('100%')
    .width('100%')
  }
}