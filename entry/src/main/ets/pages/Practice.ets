import { router } from '@kit.ArkUI';

@Entry
@Component
struct Practice {
  @State count: number = 0
  @State inputText: string = ''
  @State items: string[] = ['项目1', '项目2', '项目3']

  build() {
    Column({ space: 20 }) {
      // 1. 基础组件练习
      Text(`计数器: ${this.count}`)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      
      Row({ space: 10 }) {
        Button('减少')
          .onClick(() => this.count--)
        Button('增加')
          .onClick(() => this.count++)
      }
      
      // 2. 输入组件
      TextInput({ placeholder: '请输入内容' })
        .onChange((value: string) => {
          this.inputText = value
        })
      
      Text(`输入的内容: ${this.inputText}`)
      
      // 3. 列表组件
      List({ space: 10 }) {
        ForEach(this.items, (item: string, index: number) => {
          ListItem() {
            Text(item)
              .width('100%')
              .padding(10)
              .backgroundColor('#f0f0f0')
              .borderRadius(8)
          }
        })
      }
      .height(200)
      
      // 4. 导航组件
      Button('返回首页')
        .fontSize(16)
        .backgroundColor('#007DFF')
        .borderRadius(8)
        .padding({ top: 12, bottom: 12, left: 24, right: 24 })
        .onClick(() => {
          router.back()
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}