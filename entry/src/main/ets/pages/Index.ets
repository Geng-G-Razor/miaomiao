import { router, promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State isLoading: boolean = false;

  // 添加延迟工具函数
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
  
  @State waitingMessage: string = '';
  
  // 带提示的等待函数
  private async waitWithMessage(seconds: number): Promise<void> {
    for (let i = seconds; i > 0; i--) {
      this.waitingMessage = `准备跳转中... ${i}s`;
      await this.delay(1000);
    }
    this.waitingMessage = '';
  }
  
  // 在导航逻辑中使用
  private async handleNavigateToPractice(): Promise<void> {
    try {
      // 显示加载状态
      this.isLoading = true;
      
      // 数据验证
      if (!this.validateUserData()) {
        this.showErrorMessage('请先完善用户信息');
        return;
      }
      
      // 保存当前状态
      await this.saveCurrentState();
      
      // 等待3秒并显示倒计时
      await this.waitWithMessage(1);
      
      // 执行页面跳转
      await router.pushUrl({
        url: 'pages/Practice',
        params: {
          fromPage: 'Index',
          userMessage: this.message
        }
      });
      
      // 记录用户行为
      this.logUserAction('navigate_to_practice');
      
    } catch (error) {
      console.error('页面跳转失败:', error.message);
      this.showErrorMessage('跳转失败，请重试');
    } finally {
      this.isLoading = false;
    }
  }
  
  private validateUserData(): boolean {
    // 复杂的验证逻辑
    return this.message.length > 0;
  }
  
  private async saveCurrentState(): Promise<void> {
    // 保存状态到本地存储
    // ...
  }
  
  private logUserAction(action: string): void {
    // 用户行为统计
    console.log(`用户操作: ${action}`);
  }
  
  private showErrorMessage(message: string): void {
    // 显示错误提示
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }

  build() {
    RelativeContainer() {
      Column({ space: 20 }) {
        Text(this.message)
          .id('HelloWorld')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message = 'Welcome';
          })
        
        // 显示等待信息
        if (this.waitingMessage) {
          Text(this.waitingMessage)
            .fontSize(14)
            .fontColor('#666666')
        }
        
        Button(this.isLoading ? '跳转中...' : '进入练习页面')
          .fontSize(16)
          .backgroundColor(this.isLoading ? '#CCCCCC' : '#007DFF')
          .borderRadius(8)
          .padding({ top: 12, bottom: 12, left: 24, right: 24 })
          .enabled(!this.isLoading)
          .onClick(() => {
            // 简洁的事件处理
            this.handleNavigateToPractice();
          })
      }
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
    }
    .height('100%')
    .width('100%')
  }
}