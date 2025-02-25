# auto-video-compressor
自動で動画を圧縮してくれるスクリプト

使用するためにはffmpegとsystemdが必要です。

使用する際には，以下ファイルに適切なpathを設定してください
- auto_video_compressor.service
- autovideocompressor.sh

auto_video_compressor.serviceをsystemdに設定すればデーモンとして動かせます


### スクリプトの変数に設定すべき値
- WATCH_DIR: 監視対象のディレクトリ。このディレクトリに入っている動画を自動で圧縮します
- OUTPUT_DIR: 圧縮した動画ファイルの保存先
- PROCESSED_DIR: 圧縮が完了した動画の元ファイルはこっちのディレクトリに移動させられます
- FFMPEG_OPTIONS: ffmpegのエンコードオプション
- SLEEP_INTERVAL: 未圧縮の動画が（見つから）なくなった時に，動画を再検索するまでのインターバル
- LOG_FILE: ログの出力先
