import { media } from '@kit.MediaKit';
import { promptAction } from '@kit.ArkUI';
import { ThemeManager, ThemeType, ThemeConfig } from '../common/ThemeManager';

// 定义猫叫声数据接口
interface MeowSound {
  id: string;
  name: string;
  description: string;
}

@Component
export struct ShortMeowPage {
  @State private audioPlayer: media.AVPlayer | null = null;
  @State private isPlaying: boolean = false;
  @State private currentSound: string = '';
  @State private currentSoundId: string = '';
  @State private currentPlayer: media.AVPlayer | null = null;
  @Consume('currentTheme') currentTheme: ThemeType;
  @Consume('themeManager') themeManager: ThemeManager;

  // 短猫叫声数据
  private shortMeowSounds: Array<MeowSound> = [
    // 第一组
    { id: 'eat', name: '吃饭', description: '喵~ (我饿了)' },
    { id: 'play', name: '出去玩', description: '喵喵~ (我想出去)' },
    { id: 'happy', name: '开心', description: '咕噜咕噜~ (我很开心)' },
    { id: 'angry', name: '生气', description: '嘶~ (我生气了)' },
    { id: 'sleepy', name: '困了', description: '呼噜~ (我想睡觉)' },
    { id: 'attention', name: '求关注', description: '喵? (看看我)' },
    { id: 'thanks', name: '感谢', description: '咪~ (谢谢)' },
    { id: 'no', name: '拒绝', description: '嘶嘶~ (不要)' },
    // 第二组
    { id: 'eat2', name: '吃饭', description: '喵~ (我饿了)' },
    { id: 'play2', name: '出去玩', description: '喵喵~ (我想出去)' },
    { id: 'happy2', name: '开心', description: '咕噜咕噜~ (我很开心)' },
    { id: 'angry2', name: '生气', description: '嘶~ (我生气了)' },
    { id: 'sleepy2', name: '困了', description: '呼噜~ (我想睡觉)' },
    { id: 'attention2', name: '求关注', description: '喵? (看看我)' },
    { id: 'thanks2', name: '感谢', description: '咪~ (谢谢)' },
    { id: 'no2', name: '拒绝', description: '嘶嘶~ (不要)' },
    // 第三组
    { id: 'eat3', name: '吃饭', description: '喵~ (我饿了)' },
    { id: 'play3', name: '出去玩', description: '喵喵~ (我想出去)' },
    { id: 'happy3', name: '开心', description: '咕噜咕噜~ (我很开心)' },
    { id: 'angry3', name: '生气', description: '嘶~ (我生气了)' },
    { id: 'sleepy3', name: '困了', description: '呼噜~ (我想睡觉)' },
    { id: 'attention3', name: '求关注', description: '喵? (看看我)' },
    { id: 'thanks3', name: '感谢', description: '咪~ (谢谢)' },
    { id: 'no3', name: '拒绝', description: '嘶嘶~ (不要)' }
  ];

  // 获取当前主题配置
  private getCurrentThemeConfig(): ThemeConfig {
    return this.themeManager.getThemeConfig(this.currentTheme);
  }

  aboutToAppear() {
    this.initAudioPlayer();
  }

  aboutToDisappear() {
    this.releaseAudioPlayer();
  }

  private async initAudioPlayer() {
    try {
      this.audioPlayer = await media.createAVPlayer();
    } catch (error) {
      console.error('初始化音频播放器失败:', error);
    }
  }

  private async releaseAudioPlayer() {
    if (this.audioPlayer) {
      await this.audioPlayer.release();
      this.audioPlayer = null;
    }
  }

  private async playSound(soundId: string, soundName: string) {
    try {
      this.isPlaying = true;
      this.currentSound = soundName;
      this.currentSoundId = soundId; // 设置当前音频ID
      
      // 使用AVPlayer播放MP3音频文件
      const avPlayer = await media.createAVPlayer();
      
      // 设置音频资源路径
      avPlayer.url = `resource://RAWFILE/sounds/${soundId}.mp3`;
      
      // 设置循环播放模式
      avPlayer.loop = true;
      
      // 设置播放状态回调
      avPlayer.on('stateChange', (state) => {
        if (state === 'error') {
          console.error('播放出错');
          this.isPlaying = false;
          this.currentSound = '';
          this.currentSoundId = ''; // 清空音频ID
          avPlayer.release();
        }
      });
      
      // 设置错误回调
      avPlayer.on('error', (error) => {
        console.error('播放音频失败:', error);
        this.isPlaying = false;
        this.currentSound = '';
        this.currentSoundId = ''; // 清空音频ID
        avPlayer.release();
      });
      
      // 开始播放
      await avPlayer.prepare();
      await avPlayer.play();
      
      // 存储播放器实例以便后续停止
      this.currentPlayer = avPlayer;
      
    } catch (error) {
      console.error('播放音频失败:', error);
      this.isPlaying = false;
      this.currentSound = '';
      this.currentSoundId = ''; // 清空音频ID
    }
  }

  private async stopSound() {
    try {
      if (this.currentPlayer) {
        await this.currentPlayer.stop();
        await this.currentPlayer.release();
        this.currentPlayer = null;
      }
      this.isPlaying = false;
      this.currentSound = '';
      this.currentSoundId = ''; // 清空音频ID
    } catch (error) {
      console.error('停止播放失败:', error);
    }
  }

  build() {
    Stack() {
      Column({ space: 20 }) {
        // 页面标题区域
        Row() {
          Column() {
            Text('猫咪短语')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.getCurrentThemeConfig().textColor)
            
            Text('点击按钮听听猫咪想说什么~')
              .fontSize(14)
              .fontColor(this.getCurrentThemeConfig().subtitleColor)
              .margin({ top: 5 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          
          // 主题切换按钮
          Button() {
            Row({ space: 6 }) {
              Image($r('app.media.switch'))
                .width(12)
                .height(16)
                .fillColor(Color.White)
              Text(this.getCurrentThemeConfig().nextThemeName)
                .fontSize(12)
                .fontColor(Color.White)
            }
          }
          .width(70)
          .height(36)
          .backgroundColor(this.getCurrentThemeConfig().primaryColor)
          .borderRadius(18)
          .onClick(async () => {
            await this.themeManager.switchTheme();
            // 手动触发父组件状态更新
            this.currentTheme = this.themeManager.getCurrentTheme();
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Top)
        .margin({ top: 20, bottom: 20 })

        // 声音按钮网格
        Scroll() {
          Grid() {
            ForEach(this.shortMeowSounds, (sound: MeowSound) => {
              GridItem() {
                Column({ space: 8 }) {
                  Button() {
                    Row({ space: 8 }) {
                      // 根据播放状态显示不同图标
                      if (this.isPlaying && this.currentSoundId === sound.id) {
                        Image($r('sys.media.ohos_ic_public_pause'))
                          .width(16)
                          .height(16)
                          .fillColor(Color.White)
                      } else {
                        Image($r('sys.media.ohos_ic_public_play'))
                          .width(16)
                          .height(16)
                          .fillColor(Color.White)
                      }
                      Text(sound.name)
                        .fontSize(16)
                        .fontColor(Color.White)
                    }
                    .justifyContent(FlexAlign.Center)
                  }
                  .width('100%')
                  .height(50)
                  .backgroundColor(this.currentSoundId === sound.id ? this.getCurrentThemeConfig().activeColor : this.getCurrentThemeConfig().primaryColor)
                  .borderRadius(12)
                  .onClick(async () => {
                    // 如果点击的是正在播放的按钮，则停止播放
                    if (this.isPlaying && this.currentSoundId === sound.id) {
                      await this.stopSound();
                    } else {
                      // 如果正在播放其他音频，先停止当前播放
                      if (this.isPlaying) {
                        await this.stopSound();
                      }
                      // 播放新的音频
                      await this.playSound(sound.id, sound.name);
                    }
                  })
                  
                  Text(sound.description)
                    .fontSize(12)
                    .fontColor(this.getCurrentThemeConfig().subtitleColor)
                    .textAlign(TextAlign.Center)
                    .maxLines(2)
                }
                .width('100%')
                .padding(8)
              }
            })
          }
          .columnsTemplate('1fr 1fr')
          .rowsGap(15)
          .columnsGap(15)
          .width('100%')
        }
        .layoutWeight(1)
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Auto)
        .margin({ bottom: this.isPlaying ? 80 : 20 })
      }
      .width('100%')
      .height('100%')
      .padding({ left: 20, right: 20, bottom: 20 })
      .backgroundColor(this.getCurrentThemeConfig().backgroundColor)

      // 固定在底部的播放状态提示
      if (this.isPlaying) {
        Row({ space: 15 }) {
          // 播放状态信息
          Row({ space: 10 }) {
            LoadingProgress()
              .width(20)
              .height(20)
              .color(this.getCurrentThemeConfig().primaryColor)
            Text(`正在播放: ${this.currentSound}`)
              .fontSize(14)
              .fontColor(this.getCurrentThemeConfig().primaryColor)
              .layoutWeight(1)
          }
          .layoutWeight(1)
          
          // 停止按钮
          Button() {
            Row({ space: 6 }) {
              Image($r('sys.media.ohos_ic_public_pause'))
                .width(16)
                .height(16)
                .fillColor(Color.White)
              Text('停止')
                .fontSize(12)
                .fontColor(Color.White)
            }
          }
          .width(60)
          .height(36)
          .backgroundColor(this.getCurrentThemeConfig().secondaryColor)
          .borderRadius(18)
          .onClick(async () => {
            await this.stopSound();
          })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height(60)
        .padding({ left: 20, right: 20 })
        .backgroundColor(this.getCurrentThemeConfig().cardBackground)
        .borderRadius({ topLeft: 12, topRight: 12 })
        .shadow({
          radius: 8,
          color: this.currentTheme === ThemeType.DARK ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)',
          offsetX: 0,
          offsetY: -2
        })
        .position({ x: 0, y: '100%' })
        .translate({ x: 0, y: -60 })
      }
    }
    .width('100%')
    .height('100%')
  }
}