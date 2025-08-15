import { router } from '@kit.ArkUI';
import { ShortMeowPage } from './ShortMeowPage';
import { LongMeowPage } from './LongMeowPage';
import { ThemeManager, ThemeType, ThemeConfig } from '../common/ThemeManager';

@Entry
@Component
struct TabsPage {
  @State currentIndex: number = 0;
  @Provide('currentTheme') currentTheme: ThemeType = ThemeType.DEFAULT;
  @Provide('themeManager') themeManager: ThemeManager = ThemeManager.getInstance();

  // 获取当前主题配置
  private getCurrentThemeConfig(): ThemeConfig {
    return this.themeManager.getThemeConfig(this.currentTheme);
  }

  aboutToAppear() {
    this.currentTheme = this.themeManager.getCurrentTheme();
  }

  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
      // 使用重命名后的PNG图片
      Image(targetIndex === 0 ? $r('app.media.siamese_cat') : $r('app.media.ragdoll_cat'))
        .width(20)
        .height(20)
        .objectFit(ImageFit.Contain)
        .fillColor(this.currentIndex === targetIndex ? this.getCurrentThemeConfig().tabActiveColor : this.getCurrentThemeConfig().tabInactiveColor)
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? this.getCurrentThemeConfig().tabActiveColor : this.getCurrentThemeConfig().tabInactiveColor)
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
    .barBackgroundColor(this.getCurrentThemeConfig().tabBarBackground)
    .onChange((index: number) => {
      this.currentIndex = index;
    })
  }

  private tabsController: TabsController = new TabsController();
}