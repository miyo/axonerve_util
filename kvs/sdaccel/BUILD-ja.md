## S3バケットの用意

- S3バケットを作成．名前はaws-f1-axonerve-kvs
- フォルダを作成．名前はaxonerve-kvs-20190503

## F1インスタンスの用意

- c4.4xlargeで作成．$0.796/時間
- ストレージはルートを100GB程度あると安心．二つ目のストレージは不要．
- キーペアは既存のキーペアを選択(以前つくったaws-f1-test-key)

## F1インスタンス起動後の設定

- aws configure を して Keyをセット
- /home/centos の下で git clone https://github.com/aws/aws-fpga.git $AWS_FPGA_REPO_DIR をする
- /home/centos の下で git clone https://github.com/miyo/axonerve_util.git を する
- AXONERVEネットリストをアップロードする
```
scp -i pemファイル AXONERVEネットリスト centos@AWSインスタンスのIP
```

## 作業ディレクトリに移動して環境設定

```
cd $AWS_FPGA_REPO_DIR
source sdaccel_setup.sh
```

## SDxプロジェクトを作成
- SDxの起動
```
cd ~/
sdx -workspace build
```
- "Create a Xilinx(R) SDx(TM) Application projectをクリック
- プロジェクト名を axonerve_kvs としてプロジェクト作成
- Platformは，aws-vu9p-f1...を選択
  - 候補がでないときは，Platformで Add Custom Platform... から，/home/centos/src/project_data/aws-fpga/SDAccel/aws_platform を追加
- Empty Applicationを選択

## RTLカーネルの用意

### Kernel Wizardで雛形を作成

- メニューのXilinxからRTL Kernel Wizardを選択
- General Settings
 - kernel name を axonerve_kvs_rtl，kernel vendor を wasalabo と設定してNext．
 - クロック数を2，Has Resetを1に設定
- Scalars
 - 数は1のまま．Argument nameをdata_numに変更して，Next．
- Global Memory
 - そのままNext

### ファイルの置換と追加

- 取り除く
 - axonerve_kvs_rtl_example.sv，axonerve_kvs_rtl_example_vadd.sv，axonerve_kvs_rtl_ooc.xdc と axonerve_kvs_rtl_user.xdc
- 追加
 - /home/centos/axonerve_util/kvs/sdaccel/src/hdl の 下の axonerve_kvs_rtl_example.sv，axonerve_kvs_rtl_example_vadd.sv，user_logic.sv
 - /home/centos/axonerve_util/kvs/hdl/sources の 下の axonerve_kvs_kernel.sv
 - /home/centos/axonerve_util/kvs/sdaccel/src/xilinx-ip/aws-f1-vu9p の 下の xciファイル．これはプロジェクトにコピー
 - アップロードした Axonerveネットリスト
 - /home/centos/axonerve_util/kvs/sdaccel/src/xdc/vu9p の 下の axonerve_kvs_rtl_ooc.xdc と axonerve_kvs_rtl_user.xdc
- 詳しい手順
 - SourecesペインのLibrariesタブに切り替えると作業しやすい
 - Design Sources → SystemVerilog → xil_defaultlib の axonerve_kvs_rtl_example.sv と axonerve_kvs_rtl_example_vadd.sv を取り除く
 - Design Sourcesで右クリックして，コンテクステメニューからAdd Sourcesを選択．"Add or create design sources"を選択してNext
 - /home/centos/axonerve_util/kvs/sdaccel/src/hdl の 下の axonerve_kvs_rtl_example.sv，axonerve_kvs_rtl_example_vadd.sv，user_logic.sv を 追加
 - /home/centos/axonerve_util/kvs/hdl/sources の 下の axonerve_kvs_kernel.sv を 追加
 - /home/centos/axonerve_util/kvs/sdaccel/src/xilinx-ip/aws-f1-vu9p の 下の xciファイルを追加(これはプロジェクトにコピーする - Copy sources into projectへのチェックを忘れない)
 - アップロードした Axonerveネットリスト を 追加
 - Constraints → constrs_1 の axonerve_kvs_rtl_ooc.xdc と axonerve_kvs_rtl_user.xdc を 取り除く
 - "Add or create constraints"を選択してNext
 - /home/centos/axonerve_util/kvs/sdaccel/src/xdc/vu9p の 下の axonerve_kvs_rtl_ooc.xdc と axonerve_kvs_rtl_user.xdc を 追加

### Generate RTL Kernelを実行
- source-only kernel を 選択

## SDxでシステム全体のビルド

### ファイルの削除と追加

- host_example.cppを削除．axonerve_kvs.cpp，axonerve_kvs.hpp，host.cpp，xcl2.cpp，xcl2.hppを追加
 - Project Explorer の src → sdx_rtl_kernel → axonerve_kvs_rtl の 下の host_example.cpp (2018.2以前のバージョンなら main.c だった) は 削除
 - Project Explorer の トップ の axonerve_kvsで右クリック．コンテクストメニューからImport Sources...を選択
 - Browse...で/home/centos/axonerve_util/kvs/sdaccel/src を 選択
 - axonerve_kvs.cpp，axonerve_kvs.hpp，host.cpp，xcl2.cpp，xcl2.hppを選択してFinish

### ビルドオプションの設定

- ターゲットをSystemに変更
 - 右ペイン，右上のActive build configurationでSystemを選択
- コンパイルオプションに--kernel_frequncy "0:150|1:300"を追加．
 - Project Explorer の トップ の axonerve_kvsで右クリック．
 - コンテクストメニューから，C/C++ Build Settingsを選択．
 - 左ペインのSettingsをクリック
 - Configuration タブ を System にセット(この手順ならセットされているはず)
 - Tool Settingsタブを開く
 - SDx XOCC Kernel Compiler → Miscellaneos で --kernel_frequency "0:150|1:3000" を追加
 - SDx XOCC Kernel Linker → Miscellaneos で --kernel_frequency "0:150|1:300" を追加
 - Apply and Closeで閉じる
- Hardware Functions(ハードウェア側の関数)としてaxonerve_kvs_rtlを設定
 - 右ペインの Hardware Functions の右にある Add Hardware Function...ボタン(稲妻みたいなアイコン)をクリック
 - axonerve_kvs_rtlを選択してOK

### ビルド

- メニューの Project → Build Project で ビルド
 - ツールバーのハンマーみたいなアイコンをクリックしてもいい

## AFIイメージを作る

- cd /home/centos/build/axonerve_kvs/System で移動して binary_container_1.xclbin があるのを確認
- binary_container_1 フォルダが邪魔になるので mv binary_container_1 binary_container_1.o で リネーム
- AFIイメージ作る↓で binary_container_1.awsxclbin が できる
```
$SDACCEL_DIR/tools/create_sdaccel_afi.sh \
  -xclbin=<xclbin file name>.xclbin \
  -s3_bucket=<bucket-name> \
  -s3_dcp_key=<dcp-folder-name> \
  -s3_logs_key=<logs-folder-name>
```
- 今回の例だと
```
$SDACCEL_DIR/tools/create_sdaccel_afi.sh \
  -xclbin=binary_container_1.xclbin \
  -s3_bucket=aws-f1-axonerve-kvs \
  -s3_dcp_key=axonerve-kvs-20190503 \
  -s3_logs_key=axonerve-kvs-20190503
```
- *_afi_id.txtを開いてFpgaImageIdを確認
- AFIイメージの作成をまつ(↓コマンドを実行してStateがavailableになるのを待つ)
```
aws ec2 describe-fpga-images --fpga-image-ids 確認したFpgaImageId
```
- axonerve_kvs.exeとbinary_container_1.awsxclbinを手元にコピーする

## AWS-F1で実行

- AWS-F1インスタンスを作成
 - AMIでFPGAを検索．今度はf1.2xlargeで作成．
- (作成後初回のみ)
 - 起動したら aws configure を 実行
 - /home/centos の下で git clone https://github.com/aws/aws-fpga.git $AWS_FPGA_REPO_DIR
```
cd $AWS_FPGA_REPO_DIR; source sdaccel_setup.sh
```
 - axonerve_kvs.exeとbinary_container_1.awsxclbinをアップロードする
- 実行する
```
sudo -s
source $AWS_FPGA_REPO_DIR/sdaccel_runtime_setup.sh
./axonerve_kvs.exe binary_container_1.awsxclbin
```

