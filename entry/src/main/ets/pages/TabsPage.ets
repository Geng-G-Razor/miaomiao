import { router } from '@kit.ArkUI';
import { ShortMeowPage } from './ShortMeowPage';
import { LongMeowPage } from './LongMeowPage';

@Entry
@Component
struct TabsPage {
  @State currentIndex: number = 0;

  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
      // 使用重命名后的PNG图片
      Image(targetIndex === 0 ? $r('app.media.siamese_cat') : $r('app.media.ragdoll_cat'))
        .width(20)
        .height(20)
        .objectFit(ImageFit.Contain)
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
        .fontSize(10)
        .fontWeight(500)
        .lineHeight(14)
        .margin({ top: 2 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        ShortMeowPage()
      }
      .tabBar(this.TabBuilder('短叫声', 0))

      TabContent() {
        LongMeowPage()
      }
      .tabBar(this.TabBuilder('长叫声', 1))
    }
    .width('100%')
    .height('100%')
    .barBackgroundColor('#F1F3F5')
    .onChange((index: number) => {
      this.currentIndex = index;
    })
  }

  private tabsController: TabsController = new TabsController();
}