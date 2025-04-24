import { MeasureText } from "@kit.ArkUI"

@ComponentV2
export struct TimeBarComponent {
  viewHeight = 80


  private path2Db: Path2D = new Path2D()
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Stack() {
      this.drawScaleLine()
    }
    .width('100%')
    .height(this.viewHeight)
  }

  @Builder
  drawScaleLine() {
    Canvas(this.context)
      .width('100%')
      .height('100%')
      .onReady(()=> {

      })
  }
}

@Component
struct NumberPickerItem {
  subGridCount: number = 0
  subGridWidth = 0
  itemHeight = 0
  valueStr = 0
  //0:列表首item 1:中间item 2:尾item
  type = 0
  scaleColor: string = ''
  scaleTextColor: string = ''
  itemWidth = 0
  startX = 0
  endX = 0

  aboutToAppear(): void {
    this.itemWidth = this.subGridWidth * this.subGridCount
    switch (this.type) {
      case 0: //首元素只绘制右半部分
        this.startX = this.itemWidth / 2;
        this.endX = this.itemWidth;
        break;
      case 2: //尾元素只绘制左半部分
        this.startX = 0;
        this.endX = this.itemWidth / 2;
        break;
      default: //中间元素全部绘制
        this.startX = 0;
        this.endX = this.itemWidth;
    }
  }

  private path2Db: Path2D = new Path2D()
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  currentTimeMinuteToString(min: number): string {
    let hour = Math.floor(min / 60)
    let minute = min % 60

    return (hour > 9 ? hour + '' : '0' + hour) + ':' +
      (minute > 9 ? '' + minute : '0' + minute)
  }

  build() {
    Stack() {
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .onReady(() => {
          //绘制竖线
          for (let x = this.startX; x <= this.endX; x += this.subGridWidth) {
            if (x == this.itemWidth / 2) {
              //中间为长刻度
              this.path2Db.moveTo(x, 0)
              this.path2Db.lineTo(x, this.itemHeight / 4)
            } else if (x == this.itemWidth || x == 0) {
              //5分钟处中长
              this.path2Db.moveTo(x, this.itemHeight / 12)
              this.path2Db.lineTo(x, this.itemHeight / 12 + this.itemHeight / 8)
            } else {
              //其他为短刻度
              this.path2Db.moveTo(x, this.itemHeight * 3 / 16 - this.itemHeight / 12)
              this.path2Db.lineTo(x, this.itemHeight * 3 / 16)
            }
          }
          this.context.strokeStyle = this.scaleColor
          this.context.lineWidth = 1
          this.context.stroke(this.path2Db)
          this.context.font = '11vp sans-serif'
          this.context.fillStyle = this.scaleTextColor
          let text = this.currentTimeMinuteToString(this.valueStr)
          let size = MeasureText.measureText({
            textContent: text,
            fontSize: '11vp'
          })
          let x = this.itemWidth / 2 - px2vp(size) / 2
          let y = this.itemHeight - 8
          this.context.fillText(text, x, y)
        })
    }
    .width(this.itemWidth)
    .height(this.itemHeight)
  }
}
