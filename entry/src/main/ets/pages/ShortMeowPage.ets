import { media } from '@kit.MediaKit';
import { promptAction } from '@kit.ArkUI';

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

  // 短猫叫声数据 - 使用定义的接口
  private shortMeowSounds: Array<MeowSound> = [
    { id: 'eat', name: '吃饭', description: '喵~ (我饿了)' },
    { id: 'play', name: '出去玩', description: '喵喵~ (我想出去)' },
    { id: 'happy', name: '开心', description: '咕噜咕噜~ (我很开心)' },
    { id: 'angry', name: '生气', description: '嘶~ (我生气了)' },
    { id: 'sleepy', name: '困了', description: '呼噜~ (我想睡觉)' },
    { id: 'attention', name: '求关注', description: '喵? (看看我)' },
    { id: 'thanks', name: '感谢', description: '咪~ (谢谢)' },
    { id: 'no', name: '拒绝', description: '嘶嘶~ (不要)' }
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

  private async playSound(soundId: string, soundName: string) {
    try {
      this.isPlaying = true;
      this.currentSound = soundName;
      
      // Mock音频播放 - 使用系统提示音
      // 实际项目中这里会加载真实的音频文件
      promptAction.openToast({
        message: `正在播放: ${soundName}`,
        duration: 1000
      });
      
      // 模拟播放时间
      setTimeout(() => {
        this.isPlaying = false;
        this.currentSound = '';
      }, 1500);
      
    } catch (error) {
      console.error('播放音频失败:', error);
      this.isPlaying = false;
      this.currentSound = '';
    }
  }

  build() {
    Column({ space: 20 }) {
      // 页面标题
      Text('猫咪短语')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })
      
      Text('点击按钮听听猫咪想说什么~')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ bottom: 20 })

      // 声音按钮网格
      Grid() {
        ForEach(this.shortMeowSounds, (sound: MeowSound) => {
          GridItem() {
            Column({ space: 8 }) {
              Button(sound.name)
                .width('100%')
                .height(50)
                .fontSize(16)
                .backgroundColor(this.currentSound === sound.name ? '#FF6B6B' : '#4ECDC4')
                .fontColor(Color.White)
                .borderRadius(12)
                .enabled(!this.isPlaying || this.currentSound === sound.name)
                .onClick(() => {
                  this.playSound(sound.id, sound.name);
                })
              
              Text(sound.description)
                .fontSize(12)
                .fontColor('#999999')
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
      .layoutWeight(1)

      // 播放状态提示
      if (this.isPlaying) {
        Row({ space: 10 }) {
          LoadingProgress()
            .width(20)
            .height(20)
            .color('#4ECDC4')
          Text(`正在播放: ${this.currentSound}`)
            .fontSize(14)
            .fontColor('#4ECDC4')
        }
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 20, right: 20, bottom: 20 })
    .backgroundColor('#F8F9FA')
  }
}