import prompt from '@ohos.prompt';
import hilog from '@ohos.hilog';

@Extend(Text) function textStyle () {
  .width('25%')
  .height(35)
  .fontSize(16)
  .textAlign(TextAlign.Center)
  .backgroundColor(0xAFEEEE)
}
@Entry
@Component
struct Drag {
  @State numbers: string[] = ['one', 'two', 'three', 'four', 'five', 'six']
  @State text: string = ''
  @State bool: boolean = true
  @State eventType: string = ''
  @State appleVisible: Visibility = Visibility.Visible
  @State orangeVisible: Visibility = Visibility.Visible
  @State bananaVisible: Visibility = Visibility.Visible
  private dragList: string[] = ['0', 'apple', 'orange', 'banana']
  @State fruitVisible: Visibility[] = [Visibility.Visible, Visibility.Visible, Visibility.Visible]
  @State index: number = 0
  @State dragIn: boolean = false

  // 自定义拖拽过程中显示的内容
  @Builder pixelMapBuilder() {
    Column() {
      Text(this.text)
        .width('50%')
        .height(60)
        .fontSize(16)
        .borderRadius(10)
        .textAlign(TextAlign.Center)
        .backgroundColor(Color.Yellow)
    }
  }

  log(msg: string) {
    hilog.debug(0, 'testThread', msg)
  }

  build() {
    Column() {
      Text('There are three Text elements here')
        .fontSize(20)
        .fontColor(0xCCCCCC)
        .width('90%')
        .textAlign(TextAlign.Start)
        .margin(5)
      Row({ space: 15 }) {
        ForEach(this.dragList, (item: string, index) => {
          Text(item)
            .textStyle()
            .visibility(this.fruitVisible[index])
            .onDragStart(() => {
              this.log('onDragStart ' + item + ' ' + index)
              this.bool = true
              this.text = item
              this.fruitVisible[index] = Visibility.None
              return this.pixelMapBuilder
            })
            .onDragEnd(()=>{
              this.log('onDragEnd ' + item + ' ' + index)
              if (this.bool) {
                this.fruitVisible[index] = Visibility.Visible
              }
            })
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Down) {
                this.eventType = 'Down'
                this.index = index
              }
              if (event.type === TouchType.Up) {
                this.eventType = 'Up'
                if (this.bool) {
                  this.fruitVisible[index] = Visibility.Visible
                }
              }
            })
        })
      }.padding({ top: 10, bottom: 10 }).margin(10)

      Text('This is a List element')
        .fontSize(20)
        .fontColor(0xCCCCCC)
        .width('90%')
        .textAlign(TextAlign.Start)
        .margin(15)
      List({ space: 20 }) {
        ForEach(this.numbers, (item: string) => {
          ListItem() {
            Text(item)
              .width('100%')
              .height(80)
              .fontSize(16)
              .borderRadius(10)
              .textAlign(TextAlign.Center)
              .backgroundColor(0xAFEEEE)
          }
        })
      }
      .editMode(true)
      .height('50%')
      .width('90%')
      .border({ width: 1 })
      .padding(15)
      .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 })
      .onDragEnter((event: DragEvent, extraParams: string) => {
        this.log('List onDragEnter, ' + extraParams + 'X:' + event.getX() + 'Y:' + event.getY())
      })
      .onDragMove((event: DragEvent, extraParams: string) => {
        this.log('List onDragMove, ' + extraParams + 'X:' + event.getX() + 'Y:' + event.getY())
      })
      .onDragLeave((event: DragEvent, extraParams: string) => {
        this.log('List onDragLeave, ' + extraParams + 'X:' + event.getX() + 'Y:' + event.getY())
      })
      .onDrop((event: DragEvent, extraParams: string) => {
        this.log('List onDrop:' + extraParams)
        let jsonString: object = JSON.parse(extraParams);
        if (this.bool) {
          // 通过splice方法插入元素
          this.numbers.splice(jsonString['insertIndex'], 0, this.text)
          this.bool = false
          prompt.showToast({ message:"移入成功" })

        }
        this.fruitVisible[this.index] = Visibility.None
      })
    }.width('100%').height('100%').padding({ top: 20 }).margin({ top: 20 })
  }
}