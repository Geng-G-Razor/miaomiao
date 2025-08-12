import { media } from '@kit.MediaKit';
import { promptAction } from '@kit.ArkUI';

// 定义长猫叫声数据接口
interface LongMeowSound {
  id: string;
  name: string;
  description: string;
  duration: string;
}

@Component
export struct LongMeowPage {
  @State private audioPlayer: media.AVPlayer | null = null;
  @State private isPlaying: boolean = false;
  @State private currentSound: string = '';

  // 长猫叫声数据 - 使用定义的接口
  private longMeowSounds: Array<LongMeowSound> = [
    { id: 'kitten', name: '奶猫叫', description: '细嫩的小奶猫叫声', duration: '10s' },
    { id: 'fight', name: '公猫打架', description: '激烈的打斗嘶吼声', duration: '15s' },
    { id: 'mating', name: '母猫发情', description: '发情期的长声呼唤', duration: '20s' },
    { id: 'purr', name: '满足呼噜', description: '舒适满足的呼噜声', duration: '30s' },
    { id: 'hunt', name: '狩猎模式', description: '发现猎物时的低吼', duration: '8s' },
    { id: 'territory', name: '领地宣示', description: '宣示领地的长嚎', duration: '25s' }
  ];

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

  private async playLongSound(soundId: string, soundName: string, duration: string) {
    try {
      this.isPlaying = true;
      this.currentSound = soundName;
      
      // Mock音频播放
      promptAction.openToast({
        message: `正在播放: ${soundName} (${duration})`,
        duration: 2000
      });
      
      // 模拟较长的播放时间
      const playTime = parseInt(duration) * 100; // 简化的时间计算
      setTimeout(() => {
        this.isPlaying = false;
        this.currentSound = '';
      }, Math.min(playTime, 3000)); // 最长3秒的模拟播放
      
    } catch (error) {
      console.error('播放音频失败:', error);
      this.isPlaying = false;
      this.currentSound = '';
    }
  }

  private stopSound() {
    this.isPlaying = false;
    this.currentSound = '';
    promptAction.openToast({
      message: '已停止播放',
      duration: 1000
    });
  }

  build() {
    Column({ space: 20 }) {
      // 页面标题
      Text('猫咪长音')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })
      
      Text('各种情况下的猫咪长叫声~')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ bottom: 20 })

      // 声音列表
      List({ space: 15 }) {
        ForEach(this.longMeowSounds, (sound: LongMeowSound) => {
          ListItem() {
            Row({ space: 15 }) {
              // 播放按钮
              // 在 build() 方法中的播放按钮部分，将图标替换为文本
              Button() {
                Text(this.currentSound === sound.name ? '⏸️' : '▶️')
                  .fontSize(16)
                  .fontColor(Color.White)
              }
              .width(50)
              .height(50)
              .backgroundColor(this.currentSound === sound.name ? '#FF6B6B' : '#4ECDC4')
              .borderRadius(25)
              .onClick(() => {
                if (this.currentSound === sound.name && this.isPlaying) {
                  this.stopSound();
                } else {
                  this.playLongSound(sound.id, sound.name, sound.duration);
                }
              })

              // 声音信息
              Column({ space: 5 }) {
                Row() {
                  Text(sound.name)
                    .fontSize(18)
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(1)
                  
                  Text(sound.duration)
                    .fontSize(12)
                    .fontColor('#999999')
                    .backgroundColor('#F0F0F0')
                    .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                    .borderRadius(10)
                }
                .width('100%')
                
                Text(sound.description)
                  .fontSize(14)
                  .fontColor('#666666')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .padding(15)
            .backgroundColor(this.currentSound === sound.name ? '#FFF5F5' : Color.White)
            .borderRadius(12)
            .shadow({ radius: 2, color: '#00000010', offsetX: 0, offsetY: 1 })
          }
        })
      }
      .layoutWeight(1)
      .width('100%')

      // 播放控制区域
      if (this.isPlaying) {
        Column({ space: 10 }) {
          Row({ space: 10 }) {
            LoadingProgress()
              .width(20)
              .height(20)
              .color('#4ECDC4')
            Text(`正在播放: ${this.currentSound}`)
              .fontSize(14)
              .fontColor('#4ECDC4')
              .layoutWeight(1)
            
            Button('停止')
              .fontSize(12)
              .backgroundColor('#FF6B6B')
              .fontColor(Color.White)
              .padding({ left: 15, right: 15, top: 5, bottom: 5 })
              .borderRadius(15)
              .onClick(() => {
                this.stopSound();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .padding(15)
        .backgroundColor('#F0F8FF')
        .borderRadius(10)
        .margin({ bottom: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 20, right: 20, bottom: 20 })
    .backgroundColor('#F8F9FA')
  }
}