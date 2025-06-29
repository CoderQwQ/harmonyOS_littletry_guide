import { router } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import TitleBarComponent from '../view/TitleBarComponent'
@Entry
@Component
struct Next_tansuo {
  @State message1: string = 'Hello World';
  @State message2: string=''
  @State introduceinfo:string=''
  aboutToAppear(): void {
    if (router.getParams() !== undefined && router.getParams() !== null) {
      let record = router.getParams() as Record<string, string>;
      if (record !== undefined && record !== null) {
        this.message1 = record['title']
        this.message2 = record['area']

        console.info('接收到前一个页面的参数：', JSON.stringify(record))
      }
    }
    let httpRequest = http.createHttp();
    // 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
    // 从API 8开始，使用on('headersReceive', Callback)替代on('headerReceive', AsyncCallback)。 8+
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer sk-1e8e20c7403c49b2a8e6a6c41773c19a'
        },
        // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定
        extraData:{
          "model": "qwen-plus",
          "messages": [
            {
              "role": "system",
              "content": "You are a helpful assistant."
            },
            {
              "role": "user",
              "content": `介绍一下+${this.message2}+'的'+${this.message1}`
            }
          ]
        },
        expectDataType:http.HttpDataType.OBJECT,
        connectTimeout: 60000, // 可选，默认为60000ms
        readTimeout: 60000, // 可选，默认为60000ms

      }, (err: BusinessError, data: http.HttpResponse) => {
      if (!err) {
        // data.result为HTTP响应内容，可根据业务需要进行解析
        console.info('Result:' + JSON.stringify(data.result));
        // data.header为HTTP响应头，可根据业务需要进行解析

        console.info(typeof (data.result))
        console.info(JSON.stringify(data.result["choices"][0].message.content))
        this.introduceinfo=data.result["choices"][0].message.content
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      } else {
        console.error('error:' + JSON.stringify(err));
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    }
    );

    }

  build() {

   Scroll(){
    Column() {
      TitleBarComponent()
      Text(this.message1)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)

      Row() {
        Text(this.introduceinfo)
      }
      .backgroundColor('#ffa0b3ca')
      .borderRadius(5)
    }

    }

  }
}