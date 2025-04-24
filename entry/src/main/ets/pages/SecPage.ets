import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
export let EVENT_ID_HELLO = 'EVENT_ID_HELLO'
export let TAG = '通知事件'

@Entry
@Component
struct SecPage {
  @State message: string = 'Hello World';
  context = getContext(this) as common.UIAbilityContext
  private index = 1;
  aboutToAppear(): void {
    AppStorage.setOrCreate('mycontext',this.context)
  }

  build() {
    Column() {
      MyComp()
      Text(this.message)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          console.debug(TAG, 'testThread', 'emit ')
          this.context.eventHub.emit(EVENT_ID_HELLO, this.index.toString())
          this.index++
        })
      Button('返回')
        .onClick(() => {
          router.back()
        })
    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
  }
}

@Component
struct MyComp {
  context : common.UIAbilityContext  = getContext() as common.UIAbilityContext
  @State vm: MyViewModel = new MyViewModel()
  @State title: string = ''

  aboutToAppear(): void {
    console.debug(TAG, 'testThread', ' aboutToAppear 注册 ')
    this.context?.eventHub.on(EVENT_ID_HELLO, this.testEvent)
    AppStorage.setOrCreate('myvm',this.vm)
  }

  testEvent(number: number) {
    console.debug(TAG, 'testThread', 'receive Event: ' + number)
    // this.vm.title = 'title ' + obj[0] as string
    let vm:MyViewModel | undefined  =  AppStorage.get('myvm')
    vm?.title ? vm.title = 'title' + number : undefined
  }

  aboutToDisappear(): void {
    console.debug(TAG, 'testThread', 'aboutToDisappear')
    try {
      this.context?.eventHub.off(EVENT_ID_HELLO,this.testEvent)

    } catch (e) {
      console.info(JSON.stringify(e))
    }
  }

  build() {
    Column() {
      Row() {
        Text(this.vm.title)
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
      }
    }.margin({ top: 10, bottom: 20 })
  }
}

@Observed
export class MyViewModel {
  title: string = 'title'
}
