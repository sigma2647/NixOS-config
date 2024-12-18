# home-manager 配置
{ config, pkgs, ... }:
{
  home.file = {
    # Rime 基础配置
    ".local/share/fcitx5/rime/default.custom.yaml".text = ''
      patch:
        schema_list:
          - schema: luna_pinyin          # 朙月拼音
          - schema: luna_pinyin_simp     # 朙月拼音 简体字模式
          - schema: double_pinyin        # 自然码双拼
        
        menu:
          page_size: 9                   # 候选词数量
        
        # 切换简体/繁体
        switches:
          - name: ascii_mode
            reset: 0                     # 默认英文
            states: ["中文", "西文"]
          - name: full_shape
            states: ["半角", "全角"]
          - name: simplification
            reset: 1                     # 默认简体
            states: ["漢字", "汉字"]
    '';

    # 朙月拼音配置
    ".local/share/fcitx5/rime/luna_pinyin.custom.yaml".text = ''
      patch:
        switches:
          - name: ascii_mode
            reset: 0
          - name: full_shape
            reset: 0
          - name: simplification
            reset: 1
        
        # 载入朙月拼音扩充词库
        "translator/dictionary": luna_pinyin.extended
        
        # 输入双拼时显示对应的全拼
        "translator/preedit_format": {}
    '';
  };

  # fcitx5 基础配置
  xdg.configFile = {
    "fcitx5/config".text = ''
      [Hotkey]
      # 切换输入法
      TriggerKeys=Alt+space
      # 候选词翻页
      PrevPage=minus
      NextPage=equal
      
      [Behavior]
      # 默认使用英文
      ShareInputState=No
      
      # 切换输入法时自动切换到第一个输入法
      DefaultInputMethodState=Yes
    '';
    
    # Rime 在 fcitx5 中的配置
    "fcitx5/conf/rime.conf".text = ''
      # 可以在这里添加 Rime 的特定配置
      PreeditInApplication=True
      ShowPreeditInApplication=True
    '';
  };
}
