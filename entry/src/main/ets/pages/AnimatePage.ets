import lottie, { AnimationItem } from '@ohos/lottie';

@Entry
@Component
struct AnimatePage {
  @State message: string = 'Hello World';
  // 构建上下文
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings)
  private animateItem: AnimationItem | null = null;
  private animateList = [null, null, null]
  private animateName: string = "animation"; // 动画名称
  private curIndex = 0
  private resList = ["common/guide_home_1.json", "common/guide_home_2.json", "common/guide_home_3.json"]

  // 页面销毁时释放动画资源
  aboutToDisappear(): void {
    console.info('aboutToDisappear');
    lottie.destroy();
  }

  build() {
    Column() {
      Blank().height(50)
      Text(this.message)
        .id('AnimatePageHelloWorld')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

      // 关联画布
      Canvas(this.canvasRenderingContext)
        .width('100% - 27 - 27')
        .margin({ left: 27, right: 27 })
        .height(350)
        .backgroundColor(Color.Transparent)
        .borderRadius(8)
        .onReady(() => {
          // 加载动画
          if (this.animateItem != null) {
            // 可在此生命回调周期中加载动画，可以保证动画尺寸正确
            this.animateItem?.resize();
          } else {
            // 抗锯齿的设置
            this.canvasRenderingContext.imageSmoothingEnabled = true;
            this.canvasRenderingContext.imageSmoothingQuality = 'medium'
            this.loadAnimation0(0);
          }
        })
      Row() {
        Text('上一条').fontSize(16).fontColor(Color.Gray)
          .onClick(() => {
            this.animateItem?.stop()
          })
        Text('下一条').fontSize(16).fontColor(Color.Gray).margin({ left: 10 })
          .onClick(() => {
            this.animateItem?.play()
          })
      }
      .margin({ top: 10 })

      Swiper() {
        /*ForEach(this.resList, (res: string, index) => {
          // 关联画布
          Canvas(this.canvasRenderingContext)
            .width('100%')
            .height('100%')
            .onReady(() => {
              // 加载动画
              if (this.animateList[index] != null) {
                if (this.curIndex == index) {
                  // 可在此生命回调周期中加载动画，可以保证动画尺寸正确
                  this.animateItem?.resize();
                }
              } else {
                // 抗锯齿的设置
                this.canvasRenderingContext.imageSmoothingEnabled = true;
                this.canvasRenderingContext.imageSmoothingQuality = 'medium'
                //this.loadAnimation(index);
              }
            })
        })*/
      }
      .width('100% - 27 - 27')
      .margin({ left: 27, right: 27 })
      .height(350)
      .backgroundColor(Color.Transparent)
      .borderRadius(8)
      .onChange((selectedIndex) => {
        this.curIndex = selectedIndex
      })
    }
    .height('100%')
    .width('100%')
  }

  loadAnimation0(index: number) {
    let path = this.resList[index]
    if (this.animateItem != null) {
      this.destroy()
    }
    this.animateItem = lottie.loadAnimation({
      container: this.canvasRenderingContext,
      renderer: 'canvas', // canvas 渲染模式
      loop: false,
      autoplay: true,
      name: this.animateName,
      contentMode: 'Contain',
      path: path,
    })
    // 因为动画是异步加载，所以对animateItem的操作需要放在动画加载完成回调里操作
    this.animateItem.addEventListener('DOMLoaded', (args: Object): void => {
      //this.animateItem?.changeColor([225, 25, 100, 1]);
      if (this.curIndex == index) {
        this.animateItem?.play()
      }
    });
  }

  loadAnimation(index: number) {
    let path = this.resList[index]
    if (this.animateItem != null) {
      this.destroy()
    }
    this.animateItem = lottie.loadAnimation({
      container: this.canvasRenderingContext,
      renderer: 'canvas', // canvas 渲染模式
      loop: true,
      autoplay: true,
      name: this.animateName,
      contentMode: 'Contain',
      path: path,
    })
    // 因为动画是异步加载，所以对animateItem的操作需要放在动画加载完成回调里操作
    this.animateItem.addEventListener('DOMLoaded', (args: Object): void => {
      //this.animateItem?.changeColor([225, 25, 100, 1]);
      if (this.curIndex == index) {
        this.animateItem?.play()
      }
    });
  }

  destroy() {
    this.animateItem?.removeEventListener("DOMLoaded");
    lottie.destroy(this.animateName);
    this.animateItem = null;
  }
}