import { CommonLoadMoreView } from "./CommonLoadMoreView"
import { PictureBean, PictureFatherDataSource, PictureFilesDataSource } from "./ProPictureCloudFileBean"

@Component
export struct LazyListText {
  @State
  dataList: Array<PictureFilesDataSource> = new Array()
  index = 1

  aboutToAppear(): void {
    this.dataList.push(new PictureFilesDataSource())
    let list: Array<PictureBean> = new Array()
    for (let i = 0; i < 40; i++) {
      let bean = new PictureBean('', `code${i}`, `name${i}`, 'num:' + this.index++)
      list.push(bean)
    }
    this.dataList[this.getLastIndex()].data.pushAllData(list)
    this.dataList[this.getLastIndex()].count = this.dataList[this.getLastIndex()].data.totalCount()

    let list1: Array<PictureBean> = new Array()
    for (let i = 0; i < 40; i++) {
      let bean = new PictureBean('', `code${i}`, `name${i}`, 'num:' + this.index++)
      list1.push(bean)
    }
    let source = new PictureFilesDataSource()
    source.data.pushAllData(list1)
    source.count = this.dataList[this.getLastIndex()].data.totalCount()
    this.dataList.push(source)

    let list2: Array<PictureBean> = new Array()
    for (let i = 0; i < 40; i++) {
      let bean = new PictureBean('', `code${i}`, `name${i}`, 'num:' + this.index++)
      list2.push(bean)
    }
    let source1 = new PictureFilesDataSource()
    source1.data.pushAllData(list2)
    source1.count = this.dataList[this.getLastIndex()].data.totalCount()
    this.dataList.push(source1)
  }

  @State isLoading: number = -1

  getLastIndex() {
    return this.dataList.length - 1
  }
  add() {
    this.isLoading = 0
    setTimeout(() => {
      let list: Array<PictureBean> = new Array()
      for (let i = 0; i < 40; i++) {
        let bean = new PictureBean('', `code${i}`, `name${i}`, 'num:' + this.index++)
        list.push(bean)
      }
      let source = new PictureFilesDataSource()
      source.data.pushAllData(list)
      source.count = this.dataList[this.getLastIndex()].data.totalCount()
      this.dataList.push(source)
      this.isLoading = 2
    }, 1000)
  }

  build() {
    Column() {
      Text(`Add${this.dataList[this.getLastIndex()].count}`).fontSize(16).onClick(() => {
        this.add()
      })
      Scroll() {
        Column() {
          ForEach(this.dataList, (father: PictureFilesDataSource) => {
            Text('num:' + father.count).fontSize(16).width('100%').textAlign(TextAlign.Start)
            Grid() {
              LazyForEach(father.data, (bean: PictureBean) => {
                GridItem() {
                  Column() {
                    Stack({ alignContent: Alignment.BottomStart }) {
                      Image($r("app.media.startIcon"))
                        .width('100%')
                        .aspectRatio(1)
                        .align(Alignment.BottomStart)
                        .borderRadius(5)

                    }

                    Text(bean.showTime)
                      .fontSize(12)
                      .textAlign(TextAlign.Start)
                      .align(Alignment.Center)
                      .height(25)
                      .fontColor('#606780')
                      .margin({ top: 5 })
                  }
                  .alignItems(HorizontalAlign.Start)
                }.width('100%').onClick(() => {
                })
              }, (item: PictureBean) => {
                // key一定要唯一，否则不会实时刷新
                return item.showImageUrl
              })
            }
            .scrollBar(BarState.On)
            //.enableScrollInteraction(false)
            .focusable(false)
            .width('100%')
            .layoutWeight(1)
            .columnsTemplate('1fr 1fr 1fr 1fr')
            .rowsGap(10)
            .columnsGap(10)
            /*.onReachEnd(() => {
              if (this.isLoading != 0) {
                this.add()
              }
            })*/
            .padding({ left: 10, right: 10 })
          })
        }
      }.width('100%').layoutWeight(1).scrollBar(BarState.Off).onReachEnd(() => {
        if (this.isLoading != 0) {
          this.add()
        }
      })
      CommonLoadMoreView({ loadStatus: this.isLoading })
    }.height('100%')
  }
}