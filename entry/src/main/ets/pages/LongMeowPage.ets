import { media } from '@kit.MediaKit';
import { promptAction } from '@kit.ArkUI';
import { ThemeManager, ThemeType, ThemeConfig } from '../common/ThemeManager';

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
  @State private currentSoundId: string = '';
  @State private currentPlayer: media.AVPlayer | null = null;
  @State private currentTheme: ThemeType = ThemeType.DEFAULT;
  
  private themeManager: ThemeManager = ThemeManager.getInstance();
  private themeListener = (theme: ThemeType) => {
    this.currentTheme = theme;
  };

  // 长猫叫声数据 - 使用定义的接口
  private longMeowSounds: Array<LongMeowSound> = [
    // 原始数据组
    { id: 'kitten', name: '奶猫叫', description: '细嫩的小奶猫叫声', duration: '10s' },
    { id: 'fight', name: '公猫打架', description: '激烈的打斗嘶吼声', duration: '15s' },
    { id: 'mating', name: '母猫发情', description: '发情期的长声呼唤', duration: '20s' },
    { id: 'purr', name: '满足呼噜', description: '舒适满足的呼噜声', duration: '30s' },
    { id: 'hunt', name: '狩猎模式', description: '发现猎物时的低吼', duration: '8s' },
    { id: 'territory', name: '领地宣示', description: '宣示领地的长嚎', duration: '25s' },
    
    // 第二组 - 情感表达类
    { id: 'lonely', name: '孤独呼唤', description: '独自在家时的长声呼唤', duration: '18s' },
    { id: 'excited', name: '兴奋尖叫', description: '看到主人回家的兴奋叫声', duration: '12s' },
    { id: 'scared', name: '恐惧嚎叫', description: '受到惊吓时的长声嚎叫', duration: '22s' },
    { id: 'pain', name: '疼痛呻吟', description: '身体不适时的低沉呻吟', duration: '16s' },
    { id: 'warning', name: '警告嘶吼', description: '警告入侵者的威胁声', duration: '14s' },
    { id: 'comfort', name: '安慰呼噜', description: '寻求安慰时的轻柔呼噜', duration: '28s' },
    
    // 第三组 - 行为需求类
    { id: 'food_demand', name: '强烈要饭', description: '饥饿时的持续要食声', duration: '35s' },
    { id: 'door_request', name: '开门请求', description: '想要出门时的持续叫声', duration: '26s' },
    { id: 'attention_seek', name: '撒娇求宠', description: '想要主人关注的撒娇声', duration: '19s' },
    { id: 'play_invite', name: '邀请游戏', description: '邀请主人一起玩耍的叫声', duration: '13s' },
    { id: 'litter_complaint', name: '猫砂抗议', description: '对脏猫砂的不满抗议声', duration: '21s' },
    { id: 'night_patrol', name: '夜间巡逻', description: '深夜巡视领地的低吼声', duration: '24s' }
  ];

  // 获取当前主题配置
  private getCurrentThemeConfig(): ThemeConfig {
    return this.themeManager.getThemeConfig(this.currentTheme);
  }

  aboutToAppear() {
    this.initAudioPlayer();
    this.currentTheme = this.themeManager.getCurrentTheme();
    this.themeManager.addListener(this.themeListener);
  }

  aboutToDisappear() {
    this.releaseAudioPlayer();
    this.themeManager.removeListener(this.themeListener);
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

  private async playLongSound(soundId: string, soundName: string) {
    try {
      this.isPlaying = true;
      this.currentSound = soundName;
      this.currentSoundId = soundId;
      
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
          this.currentSoundId = '';
          avPlayer.release();
        }
      });
      
      // 设置错误回调
      avPlayer.on('error', (error) => {
        console.error('播放音频失败:', error);
        this.isPlaying = false;
        this.currentSound = '';
        this.currentSoundId = '';
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
      this.currentSoundId = '';
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
      this.currentSoundId = '';
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
            Text('猫咪长音')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.getCurrentThemeConfig().textColor)
            
            Text('各种情况下的猫咪长叫声~')
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
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Top)
        .margin({ top: 20, bottom: 20 })

        // 声音列表
        Scroll() {
          List({ space: 15 }) {
            ForEach(this.longMeowSounds, (sound: LongMeowSound) => {
              ListItem() {
                Row({ space: 15 }) {
                  // 播放按钮
                  Button() {
                    Row({ space: 8 }) {
                      // 根据播放状态显示不同图标
                      if (this.isPlaying && this.currentSoundId === sound.id) {
                        Image($r('sys.media.ohos_ic_public_pause'))
                          .width(20)
                          .height(20)
                          .fillColor(Color.White)
                      } else {
                        Image($r('sys.media.ohos_ic_public_play'))
                          .width(20)
                          .height(20)
                          .fillColor(Color.White)
                      }
                    }
                    .justifyContent(FlexAlign.Center)
                  }
                  .width(50)
                  .height(50)
                  .backgroundColor(this.currentSoundId === sound.id ? this.getCurrentThemeConfig().activeColor : this.getCurrentThemeConfig().primaryColor)
                  .borderRadius(25)
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
                      await this.playLongSound(sound.id, sound.name);
                    }
                  })

                  // 声音信息
                  Column({ space: 5 }) {
                    Row() {
                      Text(sound.name)
                        .fontSize(18)
                        .fontWeight(FontWeight.Medium)
                        .fontColor(this.getCurrentThemeConfig().textColor)
                        .layoutWeight(1)
                      
                      Text(sound.duration)
                        .fontSize(12)
                        .fontColor(this.getCurrentThemeConfig().subtitleColor)
                        .backgroundColor(this.getCurrentThemeConfig().cardBackground)
                        .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                        .borderRadius(10)
                        .border({ width: 1, color: this.getCurrentThemeConfig().primaryColor })
                    }
                    .width('100%')
                    
                    Text(sound.description)
                      .fontSize(14)
                      .fontColor(this.getCurrentThemeConfig().subtitleColor)
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
                .padding(15)
                .backgroundColor(this.currentSoundId === sound.id ? 
                  (this.currentTheme === ThemeType.DARK ? 'rgba(100, 181, 246, 0.1)' : this.getCurrentThemeConfig().cardBackground) : 
                  this.getCurrentThemeConfig().cardBackground)
                .borderRadius(12)
                .border({ 
                  width: this.currentSoundId === sound.id ? 2 : 1, 
                  color: this.currentSoundId === sound.id ? this.getCurrentThemeConfig().primaryColor : 
                    (this.currentTheme === ThemeType.DARK ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)')
                })
                .shadow({
                  radius: 4,
                  color: this.currentTheme === ThemeType.DARK ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)',
                  offsetX: 0,
                  offsetY: 2
                })
              }
            })
          }
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