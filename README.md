# auto-video-compressor
自動で動画を圧縮してくれるスクリプト

使用するためにはffmpegとsystemdが必要です。

以下の2つのファイル内のpathを適切に設定してください。
- autovideocompressor.sh
- auto_video_compressor.service

auto_video_compressor.serviceをsystemdに設定すればデーモンとして動かせます
