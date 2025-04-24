import router from '@ohos.router';
import { common } from '@kit.AbilityKit';

// 返回数据具体类型
interface term {
  id: number,
  monthCount: number,
  unit: string

}

// 定义返回值类型
interface Result<T = term> {
  code: number;
  message: string;
  data: Array<T>;
}

@Entry
@Component
struct LivePage {
  saveButtonOptions: SaveButtonOptions = {
    icon: SaveIconStyle.FULL_FILLED,
    text: SaveDescription.SAVE_TO_GALLERY,
    buttonType: ButtonType.Normal
  } // 设置安全控件按钮属性
  @State message: string = 'Hello World';
  @State input: string = ''
  context = getContext(this) as common.UIAbilityContext

  build() {
    Column() {
      Row() {
        Text('Go Event').padding(15).backgroundColor(Color.Gray).onClick(() => {
          router.pushUrl({ url: 'pages/SecPage' })
        })
        Text('Hello world').padding('15vp').backgroundColor(Color.Gray)
      }

      TextInput().onChange((value: string, previewText?: PreviewText) => {
        this.input = value
      })
      Text(this.message)
        .fontSize(20)
        .fontWeight(FontWeight.Normal)
        .onClick(async () => {

        })

    }
    .margin({ top: 20 })
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
  }


}
