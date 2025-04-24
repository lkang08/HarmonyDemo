// 1400国标设备图片云存列表
export class ProPictureCloudFileBean {
  data?: PictureInfoResp
}

export class PictureInfoResp {
  imageGroupType = 0 //0:所有,1:特征图,2:背景图
  isNext = false
  sortArr = ''
  lastTime = ''
  picList: Array<PictureItem> = new Array()
}

export class PictureItem {
  deviceCode = ''
  gbId = ''
  deviceName = ''
  imageGroupId = ''
  featureImageId = ''
  backgroundImageId = ''
  featureUrl = '' // 特征图url
  backgroundUrl = '' // 背景图url
  featureContainerId = 0
  featureObjectId = ''
  backgroundContainerId = 0
  backgroundObjectId = ''
  shotTime = ''
  features = ''
}

export class PictureBean {
  showImageUrl = '' //显示出来的URL图片地址
  deviceCode = ''
  deviceName = ''
  shotTime = '' //"shotTime":"2024-06-24 11:17:20",
  showTime = '' //显示的时间

  constructor(showImageUrl: string, deviceCode: string, deviceName: string, showTime: string) {
    this.showImageUrl = showImageUrl
    this.deviceCode = deviceCode
    this.deviceName = deviceName
    this.shotTime = showTime
    this.showTime = showTime
    /*if (showTime) {
      this.showTime = showTime.substring(11, 19)
    }*/
  }
}

export class PictureFilesDataSource {
  data: ProPictureCloudFileDataSource = new ProPictureCloudFileDataSource()
  hour = '0' //一天中的哪个小时
  count = 0 //每个小时的图片总数量
}

@Observed
export class PictureFatherDataSource implements IDataSource {
  public dataArray: Array<PictureFilesDataSource> = []
  private listeners: Array<DataChangeListener> = []

  totalCount(): number {
    return this.dataArray.length
  }

  deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }

  getData(index: number): PictureFilesDataSource {
    if (this.dataArray.length > index && index >= 0) {
      return this.dataArray[index]
    }
    return new PictureFilesDataSource()
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if (pos < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  public insertData(index: number, bean: PictureFilesDataSource): void {
    this.dataArray.splice(index, 0, bean)
    this.notifyDataAdd(index)
  }

  public pushData(bean: PictureFilesDataSource): void {
    this.dataArray.push(bean)
    this.notifyDataAdd(this.totalCount() - 1)
  }

  public pushAllData(beans: Array<PictureFilesDataSource>): void {
    beans.forEach((bean) => {
      this.pushData(bean)
    })
  }

  public refreshIndex(index: number) {
    this.notifyDataChange(index)
  }

  public reloadData(data: Array<PictureFilesDataSource>): void {
    this.dataArray = data
    this.notifyDataReload()
  }

  public notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  private notifyDataAdd(index: number): void {
    this.listeners.forEach((listener) => {
      listener.onDataAdd(index)
    })
  }

  private notifyDataChange(index: number): void {
    this.listeners.forEach((listener) => {
      listener.onDataChange(index)
    })
  }
}

@Observed
export class ProPictureCloudFileDataSource implements IDataSource {
  public dataArray: Array<PictureBean> = []
  private listeners: Array<DataChangeListener> = []

  totalCount(): number {
    return this.dataArray.length
  }

  getData(index: number): PictureBean {
    if (this.dataArray.length > index && index >= 0) {
      return this.dataArray[index]
    }
    return new PictureBean('', '', '', '')
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if (pos < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  public insertData(index: number, bean: PictureBean): void {
    this.dataArray.splice(index, 0, bean)
    this.notifyDataAdd(index)
  }

  public pushData(bean: PictureBean): void {
    this.dataArray.push(bean)
    this.notifyDataAdd(this.totalCount() - 1)
  }

  public pushAllData(beans: Array<PictureBean>): void {
    beans.forEach((bean) => {
      this.pushData(bean)
    })
  }

  public refreshIndex(index: number) {
    this.notifyDataChange(index)
  }

  public reloadData(data: Array<PictureBean>): void {
    this.dataArray = data
    this.notifyDataReload()
  }

  public notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  private notifyDataAdd(index: number): void {
    this.listeners.forEach((listener) => {
      listener.onDataAdd(index)
    })
  }

  private notifyDataChange(index: number): void {
    this.listeners.forEach((listener) => {
      listener.onDataChange(index)
    })
  }
}