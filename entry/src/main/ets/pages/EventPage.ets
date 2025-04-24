import { common } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';
import { MyViewModel } from './MyViewModel';

const EVENT = 'test_event'

@Entry
@Component
struct EventPage {
  @State message: string = 'Hello World';
  private context = getContext() as common.UIAbilityContext
  private index = 1

  build() {
    Column() {
      MyComp()
      Text(this.message)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          hilog.debug(0, 'testThread', 'emit ')
          this.context.eventHub.emit(EVENT, this.index.toString())
          this.index++
        })
    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
  }
}

@Component
struct MyComp {
  context = getContext() as common.UIAbilityContext
  @State vm: MyViewModel = new MyViewModel()
  @State title: string = ''

  aboutToAppear(): void {
    hilog.debug(0, 'testThread', ' aboutToAppear 注册 ')
    this.context.eventHub.on(EVENT, this.testEvent.bind(this))
  }

  testEvent(obj: object[]) {
    hilog.debug(0, 'testThread', 'receive Event: ' + obj[0])
    this.vm.title = 'title ' + obj[0] as string
  }

  aboutToDisappear(): void {
    hilog.debug(0, 'testThread', 'aboutToDisappear 注册 ')
    this.context.eventHub.off(EVENT, this.testEvent)
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

