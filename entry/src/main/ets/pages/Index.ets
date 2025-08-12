import { router, promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  aboutToAppear() {
    // 自动跳转到主应用页面
    router.replaceUrl({
      url: 'pages/TabsPage'
    });
  }

  build() {
    Column() {
      Text('加载中...')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}