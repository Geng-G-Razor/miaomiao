// 定义主题枚举
export enum ThemeType {
  DEFAULT = 'default',
  PINK = 'pink',
  DARK = 'dark'
}

// 定义主题配置接口
export interface ThemeConfig {
  name: string;
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

  // 主题配置
  private themeConfigs: Record<ThemeType, ThemeConfig> = {
    [ThemeType.DEFAULT]: {
      name: '默认',
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
    }
  };

  static getInstance(): ThemeManager {
    if (!ThemeManager.instance) {
      ThemeManager.instance = new ThemeManager();
    }
    return ThemeManager.instance;
  }

  getCurrentTheme(): ThemeType {
    return this.currentTheme;
  }

  getThemeConfig(theme?: ThemeType): ThemeConfig {
    return this.themeConfigs[theme || this.currentTheme];
  }

  switchTheme(): void {
    const themes = Object.values(ThemeType);
    const currentIndex = themes.indexOf(this.currentTheme);
    const nextIndex = (currentIndex + 1) % themes.length;
    this.currentTheme = themes[nextIndex];
    this.notifyListeners();
  }

  setTheme(theme: ThemeType): void {
    this.currentTheme = theme;
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