
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
let context = getContext(this) as common.UIAbilityContext;
let atManager = abilityAccessCtrl.createAtManager();

// 向用户请求位置权限设置。
atManager.requestPermissionsFromUser(context, ["ohos.permission.APPROXIMATELY_LOCATION"]).then((data) => {
  console.info('data:' + JSON.stringify(data));
  console.info('data permissions:' + data.permissions);
  console.info('data authResults:' + data.authResults);
}).catch((error: BusinessError) => {
  console.error(`Failed to request permissions from user. Code is ${error.code}, message is ${error.message}`);
})

@Component
export struct MapDemo {
  controller: webview.WebviewController = new webview.WebviewController();
  ports: webview.WebMessagePort[] = [];
  @State sendFromEts: string = '22222';
  @State receivedFromHtml: string = '';
  @State item: string = '杭州'
  @Link currentArea:string
  // origin: string = "file:///";
  // 该内容可以放在onPageEnd生命周期中调用。
    postmessage() {
      try {
      // 1、创建两个消息端口。
      this.ports = this.controller.createWebMessagePorts();
      // 2、在应用侧的消息端口(如端口1)上注册回调事件。
      this.ports[1].onMessageEvent((result: webview.WebMessage) => {
        let msg = 'receivefromHtml';
        if (typeof (result) === 'string') {
          console.info(`received string message from html5, string is: ${result}`);
          msg = msg + result;
        } else if (typeof (result) === 'object') {
          if (result instanceof ArrayBuffer) {
            console.info(`received arraybuffer from html5, length is: ${result.byteLength}`);
            msg = msg + 'length is ' + result.byteLength;
          } else {
            console.info('not support');
          }
        } else {
          console.info('not support');
        }
        this.receivedFromHtml = msg;
        this.currentArea=msg.split(':')[1].split(',')[0].replace('"','').replace('"','');
      })
      // 3、将另一个消息端口(如端口0)发送到HTML侧，由HTML侧保存并使用。
      this.controller.postMessage('__init_port__', [this.ports[0]], '*');
    } catch (error) {
      console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
    }
  }
  SendDataTOHTML(){
  try {
    if (this.ports && this.ports[1]) {
      this.ports[1].postMessageEvent(this.sendFromEts);
    } else {
      console.error(`ports is null, Please initialize first`);
    }
  } catch (error) {
    console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
  }
}

  build() {
    Column() {
      //展示接收到的来自HTML的内容
      //Text(this.receivedFromHtml)
      Web({ src: $rawfile('shouye.html'), controller: this.controller })
        
        .onPageEnd((event)=>{
            this.postmessage()
            this.SendDataTOHTML()
        })
        .geolocationAccess(true)
        .onGeolocationShow((event) => { // 地理位置权限申请通知
          AlertDialog.show({
            title: '位置权限请求',
            message: '是否允许获取位置信息',
            primaryButton: {
              value: 'cancel',
              action: () => {
                if (event) {
                  event.geolocation.invoke(event.origin, false, false); // 不允许此站点地理位置权限请求
                }
              }
            },
            secondaryButton: {
              value: 'ok',
              action: () => {
                if (event) {
                  event.geolocation.invoke(event.origin, true, false); // 允许此站点地理位置权限请求
                }
              }
            },
            cancel: () => {
              if (event) {
                event.geolocation.invoke(event.origin, false, false); // 不允许此站点地理位置权限请求
              }
            }
          })
        })

    }
  }
}