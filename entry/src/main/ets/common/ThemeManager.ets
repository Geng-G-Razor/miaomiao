import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

// 定义主题枚举
export enum ThemeType {
  DEFAULT = 'default',
  PINK = 'pink',
  DARK = 'dark',
  BLUE = 'blue',
  GREEN = 'green',
  PURPLE = 'purple',
  ORANGE = 'orange'
}

// 定义主题配置接口
export interface ThemeConfig {
  name: string;
  nextThemeName: string;
  backgroundColor: string;
  primaryColor: string;
  secondaryColor: string;
  textColor: string;
  subtitleColor: string;
  cardBackground: string;
  activeColor: string;
  tabBarBackground: string;
  tabActiveColor: string;
  tabInactiveColor: string;
}

// 全局主题管理器
export class ThemeManager {
  private static instance: ThemeManager;
  private currentTheme: ThemeType = ThemeType.DEFAULT;
  private listeners: Array<(theme: ThemeType) => void> = [];
  private preferencesStore: preferences.Preferences | null = null;
  private readonly THEME_KEY = 'selected_theme';
  private readonly STORE_NAME = 'theme_preferences';

  // 主题配置
  private themeConfigs: Record<ThemeType, ThemeConfig> = {
    [ThemeType.DEFAULT]: {
      name: '默认',
      nextThemeName: '粉色',
      backgroundColor: '#F8F9FA',
      primaryColor: '#4ECDC4',
      secondaryColor: '#FF6B6B',
      textColor: '#333333',
      subtitleColor: '#666666',
      cardBackground: '#FFFFFF',
      activeColor: '#FF6B6B',
      tabBarBackground: '#F1F3F5',
      tabActiveColor: '#1698CE',
      tabInactiveColor: '#6B6B6B'
    },
    [ThemeType.PINK]: {
      name: '粉色',
      nextThemeName: '深色',
      backgroundColor: '#FEF7F7',
      primaryColor: '#F8BBD9',
      secondaryColor: '#F5A3C7',
      textColor: '#8B5A6B',
      subtitleColor: '#B8818F',
      cardBackground: '#FFFFFF',
      activeColor: '#E91E63',
      tabBarBackground: '#FDF2F8',
      tabActiveColor: '#EC4899',
      tabInactiveColor: '#BE7A8A'
    },
    [ThemeType.DARK]: {
      name: '深色',
      nextThemeName: '蓝色',
      backgroundColor: '#1A1A1A',
      primaryColor: '#64B5F6',
      secondaryColor: '#4FC3F7',
      textColor: '#FFFFFF',
      subtitleColor: '#CCCCCC',
      cardBackground: '#2D2D2D',
      activeColor: '#81C784',
      tabBarBackground: '#2D2D2D',
      tabActiveColor: '#64B5F6',
      tabInactiveColor: '#999999'
    },
    [ThemeType.BLUE]: {
      name: '蓝色',
      nextThemeName: '绿色',
      backgroundColor: '#F0F8FF',
      primaryColor: '#2196F3',
      secondaryColor: '#03A9F4',
      textColor: '#1565C0',
      subtitleColor: '#42A5F5',
      cardBackground: '#FFFFFF',
      activeColor: '#1976D2',
      tabBarBackground: '#E3F2FD',
      tabActiveColor: '#1976D2',
      tabInactiveColor: '#90CAF9'
    },
    [ThemeType.GREEN]: {
      name: '绿色',
      nextThemeName: '紫色',
      backgroundColor: '#F1F8E9',
      primaryColor: '#4CAF50',
      secondaryColor: '#8BC34A',
      textColor: '#2E7D32',
      subtitleColor: '#66BB6A',
      cardBackground: '#FFFFFF',
      activeColor: '#388E3C',
      tabBarBackground: '#E8F5E8',
      tabActiveColor: '#388E3C',
      tabInactiveColor: '#81C784'
    },
    [ThemeType.PURPLE]: {
      name: '紫色',
      nextThemeName: '橙色',
      backgroundColor: '#F3E5F5',
      primaryColor: '#9C27B0',
      secondaryColor: '#BA68C8',
      textColor: '#6A1B9A',
      subtitleColor: '#AB47BC',
      cardBackground: '#FFFFFF',
      activeColor: '#7B1FA2',
      tabBarBackground: '#F3E5F5',
      tabActiveColor: '#7B1FA2',
      tabInactiveColor: '#CE93D8'
    },
    [ThemeType.ORANGE]: {
      name: '橙色',
      nextThemeName: '默认',
      backgroundColor: '#FFF3E0',
      primaryColor: '#FF9800',
      secondaryColor: '#FFB74D',
      textColor: '#E65100',
      subtitleColor: '#FF8A65',
      cardBackground: '#FFFFFF',
      activeColor: '#F57C00',
      tabBarBackground: '#FFF8E1',
      tabActiveColor: '#F57C00',
      tabInactiveColor: '#FFCC02'
    }
  };

  static getInstance(): ThemeManager {
    if (!ThemeManager.instance) {
      ThemeManager.instance = new ThemeManager();
    }
    return ThemeManager.instance;
  }

  // 初始化preferences存储
  async initPreferences(context: Context): Promise<void> {
    try {
      this.preferencesStore = await preferences.getPreferences(context, this.STORE_NAME);
      await this.loadSavedTheme();
    } catch (error) {
      console.error('初始化主题存储失败:', error);
    }
  }

  // 加载保存的主题
  private async loadSavedTheme(): Promise<void> {
    if (!this.preferencesStore) return;
    
    try {
      const savedTheme = await this.preferencesStore.get(this.THEME_KEY, ThemeType.DEFAULT) as string;
      if (Object.values(ThemeType).includes(savedTheme as ThemeType)) {
        this.currentTheme = savedTheme as ThemeType;
      }
    } catch (error) {
      console.error('加载保存的主题失败:', error);
    }
  }

  // 保存主题到存储
  private async saveTheme(): Promise<void> {
    if (!this.preferencesStore) return;
    
    try {
      await this.preferencesStore.put(this.THEME_KEY, this.currentTheme);
      await this.preferencesStore.flush();
    } catch (error) {
      console.error('保存主题失败:', error);
    }
  }

  getCurrentTheme(): ThemeType {
    return this.currentTheme;
  }

  getThemeConfig(theme?: ThemeType): ThemeConfig {
    return this.themeConfigs[theme || this.currentTheme];
  }

  async switchTheme(): Promise<void> {
    const themes = Object.values(ThemeType);
    const currentIndex = themes.indexOf(this.currentTheme);
    const nextIndex = (currentIndex + 1) % themes.length;
    this.currentTheme = themes[nextIndex];
    
    // 保存新主题
    await this.saveTheme();
    this.notifyListeners();
  }

  async setTheme(theme: ThemeType): Promise<void> {
    this.currentTheme = theme;
    
    // 保存新主题
    await this.saveTheme();
    this.notifyListeners();
  }

  addListener(listener: (theme: ThemeType) => void): void {
    this.listeners.push(listener);
  }

  removeListener(listener: (theme: ThemeType) => void): void {
    const index = this.listeners.indexOf(listener);
    if (index > -1) {
      this.listeners.splice(index, 1);
    }
  }

  private notifyListeners(): void {
    this.listeners.forEach(listener => listener(this.currentTheme));
  }
}