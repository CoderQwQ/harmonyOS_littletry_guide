import { router } from '@kit.ArkUI';
import StyleConstants from '../common/constants/StyleConstants';

/**
 * The title bar component.
 */
@Entry
@Component
export default struct TitleBarComponent {
  isBack: boolean = true;
  title: Resource = $r('app.string.empty');

  build() {
    Row() {
      if (this.isBack) {
        Image($r('app.media.ic_public_back'))
          .height($r('app.float.title_ic_size'))
          .width($r('app.float.title_ic_size'))
          .margin({ right: $r('app.float.title_ic_margin') })
          .onClick(() => {
            router.back();
          })
      }

      Text(this.title)
        .fontColor(Color.Black)
        .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        .fontWeight(FontWeight.Medium)
        .margin({ left: $r('app.float.title_text_margin_left') })
    }
    .width(StyleConstants.FULL_WIDTH)
    .height(StyleConstants.TITLE_BAR_HEIGHT_PERCENT)
    .padding({ left: $r('app.float.title_padding_left') })
  }
}
