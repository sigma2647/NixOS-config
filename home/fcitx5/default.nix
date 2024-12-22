{ config, pkgs, ... }:
{
  home.file = {
    # 默认配置
    ".local/share/fcitx5/rime/default.custom.yaml".text = ''
      patch:
        schema_list:
          - schema: double_pinyin_flypy    # 小鹤双拼
          - schema: luna_pinyin_simp       # 朙月拼音简体
        
        menu:
          page_size: 9                     # 候选词数量
        
        switcher:
          hotkeys:
            - "Control+grave"              # Control + `
          save_options:                    # 记住切换状态
            - full_shape
            - simplification
            - ascii_punct
        
        # 切换选项
        switches:
          - name: ascii_mode               # 中英文切换
            reset: 0                       # 默认中文
            states: ["中文", "西文"]
          - name: full_shape              # 全角/半角
            states: ["半角", "全角"]
          - name: simplification          # 简繁切换
            reset: 1                      # 默认简体
            states: ["漢字", "汉字"]
          - name: ascii_punct            # 标点符号中英文切换
            states: ["。，", "．，"]
    '';

    # 小鹤双拼方案
    ".local/share/fcitx5/rime/double_pinyin_flypy.custom.yaml".text = ''
      patch:
        switches:
          - name: ascii_mode
            reset: 0                       # 默认中文
          - name: full_shape
            reset: 0                       # 默认半角
          - name: simplification
            reset: 1                       # 默认简体
          - name: ascii_punct
            reset: 1                       # 默认中文标点
        
        translator:
          dictionary: luna_pinyin.extended # 使用扩展词库
          preedit_format:
            - xform/([bpmfdtnljqx])n/$1in/
            - xform/([bpmfdtnljqx])g/$1eng/
            - xform/([bpmfdtnljqx])q/$1iu/
            - xform/([gkhvuirzcs])w/$1ua/
            - xform/([dtnlgkhjqxyvuirzcs])r/$1uan/
            - xform/([dtnlgkhvuirzcs])t/$1ue/
            - xform/([gkhvuirzcs])y/$1uai/
            - xform/([dtnlgkhvuirzcs])o/$1uo/
            - xform/([rzcs])p/$1un/
            - xform/([dtnlgkhvuirzcs])s/$1ong/
            - xform/([dtnlgkhvuirzcs])d/$1ang/
            - xform/([dtnlgkhvuirzcs])f/$1en/
            - xform/([dtnlgkhvuirzcs])h/$1ang/
            - xform/([dtnlgkhvuirzcs])j/$1an/
            - xform/([dtnlgkhvuirzcs])k/$1ao/
            - xform/([dtnlgkhvuirzcs])l/$1ai/
            - xform/([bpmfdtnljqx])v/$1ui/
            - xform/([bpmfdtnljqx])b/$1ou/
            - xform/([bpmfdtnljqx])m/$1ian/
            - xform/([pmfdtnljqx])n/$1in/
        
        key_binder:
          bindings:
            - {accept: "Control+p", send: Page_Up, when: composing}
            - {accept: "Control+n", send: Page_Down, when: composing}
            - {accept: "Control+b", send: Left, when: composing}
            - {accept: "Control+f", send: Right, when: composing}
            - {accept: "Control+a", send: Home, when: composing}
            - {accept: "Control+e", send: End, when: composing}
            - {accept: "Control+d", send: Delete, when: composing}
            - {accept: "Control+k", send: "Shift+Delete", when: composing}
            - {accept: "Control+h", send: BackSpace, when: composing}
            - {accept: "Control+g", send: Escape, when: composing}
            - {accept: "Control+bracketleft", send: Escape, when: composing}
            - {accept: "Alt+v", send: Page_Up, when: composing}
            - {accept: "Control+v", send: Page_Down, when: composing}
    '';

    # 朙月拼音配置
    ".local/share/fcitx5/rime/luna_pinyin_simp.custom.yaml".text = ''
      patch:
        switches:
          - name: ascii_mode
            reset: 0
          - name: full_shape
            reset: 0
          - name: simplification
            reset: 1
        
        translator:
          dictionary: luna_pinyin.extended
          preedit_format:
            - xform/([nljqxy])v/$1ü/
            - xform/([nljqxy])V/$1Ü/
    '';

    # 方案选单配置
    ".local/share/fcitx5/rime/installation.yaml".text = ''
      distribution_code_name: "fcitx-rime"
      distribution_name: Rime
      distribution_version: 5
      install_time: "Manually Configured"
      installation_id: "fcitx-rime"
      rime_version: 1.8.5
    '';

    # Rime 同步配置
    ".local/share/fcitx5/rime/sync/default.yaml".text = ''
      # 同步配置
      sync_dir: '~/.local/share/fcitx5/rime/sync'
    '';
  };

  # fcitx5 基础配置
  xdg.configFile = {
    # 主配置
    "fcitx5/config".text = ''
      [Hotkey]
      # 切换输入法
      TriggerKeys=Alt+space
      # 候选词翻页
      PrevPage=minus
      NextPage=equal
      
      [Behavior]
      # 默认英文
      ShareInputState=No
      # 切换输入法时自动切换到第一个输入法
      DefaultInputMethodState=Yes
    '';
    
    # Rime 组件配置
    "fcitx5/conf/rime.conf".text = ''
      # Rime 配置
      PreeditInApplication=True
      ShowPreeditInApplication=True
    '';

    # 输入法配置
    "fcitx5/profile".text = ''
      [Groups/0]
      # 组名
      Name=Default
      # 默认输入法
      DefaultIM=rime

      [Groups/0/Items/0]
      # 启用 Rime
      Name=rime
      Layout=

      [GroupOrder]
      0=Default
    '';
  };
}
