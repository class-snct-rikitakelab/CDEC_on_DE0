# CEDC_Verilog_Model

## files

- CPU_shell.v　 CDECと実習装置のインターフェース部（装置に合わせて作り直す必要あり）
- CDEC8.v　     CDEC本体の最上位
- CDEC8_DP.v　  データ・パス部
- DEC8_PLA.v　  PLA制御部
- ALU_func.v　  ALUファンクション
- register.v　  レジスタ
- tbuf_func.v　 ３ステート・バッファ・ファンクション
- PULLUP.v　    プルアップ用ライブラリ（Xilinx用）
- my_const.vh　 定数定義
