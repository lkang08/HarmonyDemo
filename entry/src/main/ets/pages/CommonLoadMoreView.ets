/**
 * 公共列表加载更多
 * yanf
 * 2024-05-27
 */
@Component
export struct CommonLoadMoreView {

  @Prop loadStatus: number=0//0 加载更多中   1加载失败
  onTryClick?: () => void//点击重试

  build() {
    if(this.loadStatus==0){
      Row(){
        LoadingProgress()
          .color('#FF353B50')
          .width(30)
          .height(30)
        Blank().width(10)
        Text('正在加载更多数据...')
          .fontSize(14)
          .fontColor( '#FF353B50')
      }.height(40).width('100%').backgroundColor(Color.White).justifyContent(FlexAlign.Center).alignItems(VerticalAlign.Center)
    }else if(this.loadStatus==1){
      Text('点击重试')
        .fontSize(14)
        .fontColor( '#FF353B50')
        .height(40).width('100%').backgroundColor(Color.White)
        .textAlign(TextAlign.Center)
        .onClick(()=>{
          if(this.onTryClick!=null){
            this.onTryClick()
          }
        })
    }else if(this.loadStatus==3){
      Text('暂无更多数据...')
        .fontSize(14)
        .fontColor( '#FF353B50')
        .height(40).width('100%').backgroundColor(Color.White)
        .textAlign(TextAlign.Center)
    }
  }
}
