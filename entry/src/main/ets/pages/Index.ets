import { AddressBook, Person } from '../model/Model';
import taskpool from '@ohos.taskpool';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction, router } from '@kit.ArkUI';
import { SearchSwiper } from '../component/SearchSwiper';
import { RouterPath } from '../constant/RouterPath';
import { AppRouter } from '../router/AppRouter';
import { common, OpenLinkOptions, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { http } from '@kit.NetworkKit';
import { picker } from '@kit.CoreFileKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { fileUri } from '@kit.CoreFileKit';

@Concurrent
function serviceHandle(pars: number): number {

  hilog.info(0x0000, 'testTag', 'start ServiceHandle:%{public}d', pars);
  let t: number = Date.now();
  // 业务处理过程,并将结果返回
  while ((Date.now() - t) < 1000) {
    hilog.info(0x0000, 'testTag', 'time:%{public}d', Date.now());
    continue;

  }
  let result = 0;

  return result;

}

const tag = '#########Index'

@Entry
@Component
struct Index {
  @State message: string = 'goto download';
  @Provide addrBook: AddressBook = new AddressBook();
  @State selectedPerson: Person = new Person("", "", 0, "", []);
  @State click1: number = 1
  @State click2: number = 2
  @State point: FingerInfo = {
    id: 0,
    globalX: 0,
    globalY: 0,
    localX: 0,
    localY: 0,
    displayX: 0,
    displayY: 0
  }
  @State videoHeight: number = 200

  aboutToAppear(): void {
    this.addrBook.init((p: Person) => {
      this.selectedPerson = p
    })
  }

  test() {
    let task = new taskpool.Task(serviceHandle, 22)
    taskpool.execute(task, taskpool.Priority.LOW).then(() => {
      hilog.info(0x0000, 'testTag', 'taskpool end');
      promptAction.showToast({ message: 'taskpool end:' + Date.now() })
    })
  }

  build() {
    Column() {
      /*AddressBookView({
        me: this.addrBook.me,
        contacts: this.addrBook.contacts,
        selectedPerson: this.selectedPerson
      })
      Column() {
        Text(this.message).fontSize(14).backgroundColor(Color.Red).height(40)
      }.justifyContent(FlexAlign.Center).height(50).backgroundColor(Color.Gray).width('100%')*/

      Blank().height(5)
      Column() {
        Text(this.message).fontSize(14).backgroundColor(Color.Red).height(40).onClick(() => {
          //this.test()
          AppRouter.pushNamedPage(RouterPath.DownloadPage)
          //router.pushUrl({url:'pages/DownloadPage'})
        })
      }
      .alignItems(HorizontalAlign.Start)
      .height(50)
      .backgroundColor(Color.Gray)
      .width('100%')
      .justifyContent(FlexAlign.End)

      SearchSwiper().width('100%')
      Blank().height(5)
      Column() {
        Text(this.message).fontSize(14).backgroundColor(Color.Red).height(40)

      }
      .height(50)
      .backgroundColor(Color.Gray)
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .onClick(() => {
        //router.pushUrl({url:'pages/DownloadPage'})
        //router.push({url:'pages/DownloadPage'})
        router.pushUrl({url: 'pages/AnimatePage'})
      })


      Blank().height(5)
      Text('Text')
        .fontSize(15)
        .onClick(() => {
          this.httpTest()
        })

      Text('Text2')
        .fontSize(15)
        .margin(10)
        .onClick(() => {
          let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
          let want: Want = {
            uri: "tysl-tyyy://vcp1/message?test=hello"
          };

          try {
            context.startAbility(want).then(() => {
              hilog.info(0, tag, 'start ability success.');
            }).catch((err: BusinessError) => {
              hilog.error(0, tag, `start ability failed. Code is ${err.code}, message is ${err.message}`);
            });
          } catch (paramError) {
            hilog.error(0, tag,
              `Failed to start ability. Code is ${paramError.code}, message is ${paramError.message}`);
          }
        })
      Text('write')
        .fontSize(15)
        .margin(10)
        .onClick(() => {
          //this.openLink()
          this.write()
        })
      Text('Save')
        .fontSize(15)
        .margin(10)
        .onClick(() => {
          //this.openLink()
          this.save()
        })
      Text('crash')
        .fontSize(15)
        .margin(10)
        .onClick(() => {
          this.crash()
        })
    }
  }

  crash() {
    // 在按钮点击函数中构造一个crash场景，触发应用崩溃事件
    let test = 'abc'
    let result: object = JSON.parse(test);
  }

  async write() {
    let context = getContext(this) as common.Context;
    let pathDir = context.filesDir;
    let filePath = pathDir + "/test.txt";
    let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let str: string = "hello, world\n我的天\n12344444";
    fs.write(file.fd, str).then((writeLen: number) => {
      console.info("write data to file succeed and size is:" + writeLen);
    }).catch((err: BusinessError) => {
      console.error("write data to file failed with error message: " + err.message + ", error code: " + err.code);
    }).finally(() => {
      fs.closeSync(file);
    });
  }
  async save() { // 需确保 context 由 UIAbilityContext 转换而来
    try {
      let context = getContext(this) as common.Context;
      let pathDir = context.filesDir;
      let filePath = pathDir + "/test.txt";
      let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let uri = fileUri.getUriFromPath(filePath);
      let fileUriObject = new fileUri.FileUri(filePath);
      let name = fileUriObject.toString()
      let documentSaveOptions = new picker.DocumentSaveOptions();
      //documentSaveOptions.defaultFilePathUri = name
      documentSaveOptions.newFileNames = ['log.txt'];
      let documentPicker = new picker.DocumentViewPicker(context);
      documentPicker.save(documentSaveOptions).then((documentSaveResult: Array<string>) => {
        console.info('DocumentViewPicker.save successfully, documentSaveResult uri: ' +
        JSON.stringify(documentSaveResult));
        let dst = fs.openSync(documentSaveResult[0],fs.OpenMode.WRITE_ONLY)
        fs.copyFileSync(file.fd, dst.fd)
      }).catch((err: BusinessError) => {
        console.error('DocumentViewPicker.save failed with err: ' + JSON.stringify(err));
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error('DocumentViewPicker failed with err: ' + JSON.stringify(err));
    }
  }

  url = "https://www.kuaidi100.com/query?type=shunfeng&postid=sf1222"

  async httpTest() {
    let httpRequest = http.createHttp();
    let res = await httpRequest.request(this.url)
    hilog.debug(0, 'httpTest', `${res.result}`)
  }

  openLink() {
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    let link: string = "link://www.example.com";
    let openLinkOptions: OpenLinkOptions = {
      appLinkingOnly: false
    };

    try {
      context.openLink(link, openLinkOptions)
        .then(() => {
          hilog.info(0, tag, 'open link success.');
        }).catch((err: BusinessError) => {
        hilog.error(0, tag, `open link failed. Code is ${err.code}, message is ${err.message}`);
      });
    } catch (paramError) {
      hilog.error(0, tag, `Failed to start link. Code is ${paramError.code}, message is ${paramError.message}`);
    }
  }

  @State zIndex1: number = 1
  @State zIndex2: number = 2
  @State largeMode: boolean = true

  change() {
    this.largeMode = !this.largeMode
    if (this.largeMode) {
      this.zIndex1 = 1
      this.zIndex2 = 2
    } else {
      this.zIndex1 = 2
      this.zIndex2 = 1
    }
  }
}

@Component
struct MyText {
  @Prop text: number
  @Prop largeMode: boolean

  build() {
    Stack() {
      Text('' + this.text)
        .width(this.largeMode ? '100%' : 100)
        .height(this.largeMode ? '100%' : 100)
        .fontSize(16)
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .backgroundColor(this.largeMode ? Color.Gray : Color.Blue)
    }
  }
}