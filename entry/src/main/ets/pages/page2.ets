import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import buffer from '@ohos.buffer';
import util from '@ohos.util';
import { text } from '@kit.ArkGraphics2D';


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State cityname:string='宣城市'
  @State jingdian1:string=''
  sendhttp(){
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
   let result=encodeURIComponent(this.cityname)
    console.log(result)
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      `http://127.0.0.1:5000/?userId=3&city=${result}`,
      {
        header: {
          'Content-Type': 'application/json',
        },
        method: http.RequestMethod.GET,
        expectDataType:http.HttpDataType.OBJECT,
        connectTimeout: 60000, // 可选，默认为60000ms
        readTimeout: 60000, // 可选，默认为60000ms

      }, (err: BusinessError, data) => {
      if (!err) {
        // data.result为HTTP响应内容，可根据业务需要进行解析
        if(JSON.stringify(data.result['recommended_jingdians']).length==2){
          console.info('没有推荐景点')
        }
        else
        {
          console.info('Result:' + JSON.stringify(data.result));
          console.info('Result:' + data.result['recommended_jingdians'][0]['name']);
          //this.jingdian1=data.result['recommended_jingdians'][0]['name']
          console.info('Result:' + JSON.stringify(data.result['recommended_jingdians'][1]));
          console.info('Result:' + JSON.stringify(data.result));
          console.info('Result:' + data.result['recommended_jingdians'][0]['name']);
        }

        //this.jingdian1=data.result['recommended_jingdians'][0]['name']
        console.info('code:' + JSON.stringify(data.responseCode));
        // data.header为HTTP响应头，可根据业务需要进行解析
        console.info('header:' + JSON.stringify(data.header));
        console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
        // let data_obj:object = JSON.parse(data.result);
        console.info(typeof (data.result))
        console.info(JSON.stringify(data.result))
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
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

      Button('click')
        .onClick(()=>{
          this.sendhttp()
        })
      Text('当前所在地:'+this.jingdian1);
    }
    .height('100%')
    .width('100%')
  }
}