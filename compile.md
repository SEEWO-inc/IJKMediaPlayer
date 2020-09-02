## 0x00 获取ijkplayer源码
源码：https://github.com/bilibili/ijkplayer


## 0x01 编译ijkplayer
ijkplayer的编译依赖的另外两个仓库
1. https://github.com/bilibili/FFmpeg
2. https://github.com/bilibili/openssl


编译步骤也非常简单，参考官方的编译指导即可


### step1: 获取依赖的ffmpeg 和 openssl源码，配置支持的各种架构

```bash

./init-ios.sh

./init-ios-openssl.sh #用于支持https协议

```

在init-ios.sh文件里，IJK_FFMPEG_COMMIT字段定义了依赖的ffmpeg源码git tag。

如果需要编译其他版本的ffmpeg，去 https://github.com/bilibili/FFmpeg 查询tag，然后更新到这里即可~

```bash

#! /usr/bin/env bash
#
# Copyright (C) 2013-2015 Bilibili
# Copyright (C) 2013-2015 Zhang Rui <bbcallen@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# IJK_FFMPEG_UPSTREAM=git://git.videolan.org/ffmpeg.git
IJK_FFMPEG_UPSTREAM=https://github.com/Bilibili/FFmpeg.git
IJK_FFMPEG_FORK=https://github.com/Bilibili/FFmpeg.git
IJK_FFMPEG_COMMIT=ff4.0--ijk0.8.25--20200221--001
IJK_FFMPEG_LOCAL_REPO=extra/ffmpeg

```

在init-ios-openssl.sh文件里 ，IJK_OPENSSL_COMMIT字段定义了依赖的openssl源码git tag。

如果需要编译其他版本的openssl，去https://github.com/bilibili/openssl查询tag，然后更新到这里即可~

```bash

#! /usr/bin/env bash
#
# Copyright (C) 2013-2015 Bilibili
# Copyright (C) 2013-2015 Zhang Rui <bbcallen@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

IJK_OPENSSL_UPSTREAM=https://github.com/openssl/openssl
IJK_OPENSSL_FORK=https://github.com/Bilibili/openssl.git
IJK_OPENSSL_COMMIT=OpenSSL_1_0_2u
IJK_OPENSSL_LOCAL_REPO=extra/openssl

```


### step2: 配置ffmpeg编译选项

在config目录下有三个配置文件，可以按需选择一种配置文件链接到module.sh

```

module-default.sh #更多的编解码器/格式，编译出的包体积会很大

module-lite-hevc.sh #较少的编解码器/格式(包括hevc)

module-lite.sh #较少的编解码器/格式(默认情况)，编译出的包体积较小

```


这里我为了精简编译出的库体积大小，使用了module-lite.sh，然后又增加了一些编译选项，使其支持主流常见的音视频编解码和包装格式。

例如：使用module-lite.sh配置文件加上下面增加的编译选项即可支持播放主流常见的视频

```

Container: mp4, mov, mkv, 3gp, mpg, flv, wmv, rm, rmvb, avi, m4v, asf, m4a, webm, caf, ogg, ts

Video decoder: wmv1~3, h263, h264, hevc, mpeg*, msmpeg*, rv*, vp*, theora

Audio decoder: mp1~3, ac3, aac, amr*, alac, flac, opus, vorbis, cook

Not support: swf

```


编译出来的库支持播放哪些格式的音视频，这里的编译配置的关键，如果遇到一些视频无法播放，很有可能是这里没有打开对应视频解码器的开关

我这里为了在module-lite的基础上支持avi，rm, rmvb, 3gp，mpg, wmv的视频，增加的编译选项

```bash

# 开启openssl编译选项
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-openssl"' >> config/module.sh

# 开启demuxer编译选项
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=m4v"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=m4a"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=avi"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=rm"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=mpeg*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=msmpeg*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=avi"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=rm"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=mpeg*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=msmpeg*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=wmv*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=asf*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=webm"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=matroska"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=ogg"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=caf"' >> config/module.sh



# # 开启decoder编译选项
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=h263*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=cook"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=rv*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=ac3*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=mp2*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=mp1*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=wmv*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=mpeg*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=msmpeg*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=alac"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=amr*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=theora"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=vorbis"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=opus"' >> config/module.sh



#  开启parser编译选项
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=ac3"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=mpeg*"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=cook"' >> config/module.sh
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=h263"' >> config/module.sh
```


### step3:  切换到ios目录编译ffmpeg和openssl

```bash

cd ios

./compile-ffmpeg.sh clean

./compile-openssl.sh all

./compile-ffmpeg.sh all

```


### step4: 编译ijkplaye framework

打开IJKMediaPlayer/IJKMediaPlayer.xcodeproj即可编译（或使用xcodebuild命令行编译）

IJKMediaPlayer默认有两个target：IJKMediaFramework 和 IJKMediaFrameworkWithSSL

这两个target一个是Dynamic Framework（IJKMediaFrameworkWithSSL），一个是Static Framework（IJKMediaFramework），支持的特性是一样的。

其中IJKMediaFrameworkWithSSL.framework在使用时需要Embed使用



### step5: 使用lipo合成arm64+x86_64 FAT framework

略




## 0x03 编译基于ffmpeg4.0的ijkplayer

bilibili默认的ijkplayer依赖的ffmpeg版本是基于ffmpeg3.4的，不过bilibili也非常良心地保持着对ffmpeg高版本的适配和更新

目前支持的最新的ffmpeg版本为：ffmpeg4.0，于2020年2月21日更新（疫情期间还在保持更新，简直业界良心）


### step1: 修改ffmpeg4.0需要的编译配置选项

config/mudule.sh

```bash
# 关闭bitstream filter（ffmpeg4.0）
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-bsf=eac3_core"


# 注释掉这两行
#export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-ffserver"
#export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-vda"

```


### step:2 修改 ios/tools/do-compile-ffmpeg.sh和ios/tools/do-compile-openssl.sh中支持的最低版本

找到有关 version-min 小于8.0的都改成8.0

```bash
#do-compile-ffmpeg
if [ "$FF_ARCH" = "i386" ]; then
    FF_BUILD_NAME="ffmpeg-i386"
    FF_BUILD_NAME_OPENSSL=openssl-i386
    FF_XCRUN_PLATFORM="iPhoneSimulator"
    FF_XCRUN_OSVERSION="-mios-simulator-version-min=8.0"
    FFMPEG_CFG_FLAGS="$FFMPEG_CFG_FLAGS $FFMPEG_CFG_FLAGS_SIMULATOR"
elif [ "$FF_ARCH" = "x86_64" ]; then
    FF_BUILD_NAME="ffmpeg-x86_64"
    FF_BUILD_NAME_OPENSSL=openssl-x86_64
    FF_XCRUN_PLATFORM="iPhoneSimulator"
    FF_XCRUN_OSVERSION="-mios-simulator-version-min=8.0"
    FFMPEG_CFG_FLAGS="$FFMPEG_CFG_FLAGS $FFMPEG_CFG_FLAGS_SIMULATOR"
elif [ "$FF_ARCH" = "armv7" ]; then
    FF_BUILD_NAME="ffmpeg-armv7"
    FF_BUILD_NAME_OPENSSL=openssl-armv7
    FF_XCRUN_OSVERSION="-miphoneos-version-min=8.0"
    FF_XCODE_BITCODE="-fembed-bitcode"
    FFMPEG_CFG_FLAGS="$FFMPEG_CFG_FLAGS $FFMPEG_CFG_FLAGS_ARM"
#    FFMPEG_CFG_CPU="--cpu=cortex-a8"
elif [ "$FF_ARCH" = "armv7s" ]; then
    FF_BUILD_NAME="ffmpeg-armv7s"
    FF_BUILD_NAME_OPENSSL=openssl-armv7s
    FFMPEG_CFG_CPU="--cpu=swift"
    FF_XCRUN_OSVERSION="-miphoneos-version-min=8.0"
    FF_XCODE_BITCODE="-fembed-bitcode"
    FFMPEG_CFG_FLAGS="$FFMPEG_CFG_FLAGS $FFMPEG_CFG_FLAGS_ARM"
elif [ "$FF_ARCH" = "arm64" ]; then
    FF_BUILD_NAME="ffmpeg-arm64"
    FF_BUILD_NAME_OPENSSL=openssl-arm64
    FF_XCRUN_OSVERSION="-miphoneos-version-min=8.0"
    FF_XCODE_BITCODE="-fembed-bitcode"
    FFMPEG_CFG_FLAGS="$FFMPEG_CFG_FLAGS $FFMPEG_CFG_FLAGS_ARM"
    FF_GASPP_EXPORT="GASPP_FIX_XCODE5=1"
else
    echo "unknown architecture $FF_ARCH";
    exit 1
fi


#do-compile-openssh
if [ "$FF_ARCH" = "i386" ]; then
    FF_BUILD_NAME="openssl-i386"
    FF_XCRUN_PLATFORM="iPhoneSimulator"
    FF_XCRUN_OSVERSION="-mios-simulator-version-min=8.0"
    OPENSSL_CFG_FLAGS="darwin-i386-cc $OPENSSL_CFG_FLAGS"
elif [ "$FF_ARCH" = "x86_64" ]; then
    FF_BUILD_NAME="openssl-x86_64"
    FF_XCRUN_PLATFORM="iPhoneSimulator"
    FF_XCRUN_OSVERSION="-mios-simulator-version-min=8.0"
    OPENSSL_CFG_FLAGS="darwin64-x86_64-cc $OPENSSL_CFG_FLAGS"
elif [ "$FF_ARCH" = "armv7" ]; then
    FF_BUILD_NAME="openssl-armv7"
    FF_XCRUN_OSVERSION="-miphoneos-version-min=8.0"
    FF_XCODE_BITCODE="-fembed-bitcode"
    OPENSSL_CFG_FLAGS="$OPENSSL_CFG_FLAGS_ARM $OPENSSL_CFG_FLAGS"
#    OPENSSL_CFG_CPU="--cpu=cortex-a8"
elif [ "$FF_ARCH" = "armv7s" ]; then
    FF_BUILD_NAME="openssl-armv7s"
    OPENSSL_CFG_CPU="--cpu=swift"
    FF_XCRUN_OSVERSION="-miphoneos-version-min=8.0"
    FF_XCODE_BITCODE="-fembed-bitcode"
    OPENSSL_CFG_FLAGS="$OPENSSL_CFG_FLAGS_ARM $OPENSSL_CFG_FLAGS"
elif [ "$FF_ARCH" = "arm64" ]; then
    FF_BUILD_NAME="openssl-arm64"
    FF_XCRUN_OSVERSION="-miphoneos-version-min=8.0"
    FF_XCODE_BITCODE="-fembed-bitcode"
    OPENSSL_CFG_FLAGS="$OPENSSL_CFG_FLAGS_ARM $OPENSSL_CFG_FLAGS"
    FF_GASPP_EXPORT="GASPP_FIX_XCODE5=1"
else
    echo "unknown architecture $FF_ARCH";
    exit 1
fi

```
然后按照3.4相同的步骤编译和打包即可


## 0x04 遇到不支持播放的视频，从哪里查找配置字符串

因为ijkplayer的视频播放部分底层都是基于ffmpeg的，所以只需要查找一下ffmpeg支持哪些编译配置选项就可以了

使用ffmpeg的一些命令查找（不同版本的ffmpeg，输出会有差异）

```bash
ffmpeg -version
ffmpeg --help   
ffmpeg -demuxers   #解复用, 与formats类似
ffmpeg -formats    #容器包装格式
ffmpeg -protocols  #协议
ffmpeg -decoders   #解码器
ffmpeg -hwaccels   #硬件加速
```

### eg: demuxers

我自己电脑上的版本是4.2.2

```
Last login: Wed Sep  2 16:21:06 on ttys001
(base) qingwei@guoxiucai ~ % ffmpeg -demuxers
ffmpeg version 4.2.2 Copyright (c) 2000-2019 the FFmpeg developers
  built with Apple clang version 11.0.0 (clang-1100.0.33.17)
  configuration: --prefix=/usr/local/Cellar/ffmpeg/4.2.2_4 --enable-shared --enable-pthreads --enable-version3 --enable-avresample --cc=clang --host-cflags=-fno-stack-check --host-ldflags= --enable-ffplay --enable-gnutls --enable-gpl --enable-libaom --enable-libbluray --enable-libmp3lame --enable-libopus --enable-librubberband --enable-libsnappy --enable-libsrt --enable-libtesseract --enable-libtheora --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxvid --enable-lzma --enable-libfontconfig --enable-libfreetype --enable-frei0r --enable-libass --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-librtmp --enable-libspeex --enable-libsoxr --enable-videotoolbox --disable-libjack --disable-indev=jack
  libavutil      56. 31.100 / 56. 31.100
  libavcodec     58. 54.100 / 58. 54.100
  libavformat    58. 29.100 / 58. 29.100
  libavdevice    58.  8.100 / 58.  8.100
  libavfilter     7. 57.100 /  7. 57.100
  libavresample   4.  0.  0 /  4.  0.  0
  libswscale      5.  5.100 /  5.  5.100
  libswresample   3.  5.100 /  3.  5.100
  libpostproc    55.  5.100 / 55.  5.100
File formats:
 D. = Demuxing supported
 .E = Muxing supported
 --
 D  3dostr          3DO STR
 D  4xm             4X Technologies
 D  aa              Audible AA format files
 D  aac             raw ADTS AAC (Advanced Audio Coding)
 D  ac3             raw AC-3
 D  acm             Interplay ACM
 D  act             ACT Voice file format
 D  adf             Artworx Data Format
 D  adp             ADP
 D  ads             Sony PS2 ADS
 D  adx             CRI ADX
 D  aea             MD STUDIO audio
 D  afc             AFC
 D  aiff            Audio IFF
 D  aix             CRI AIX
 D  alaw            PCM A-law
 D  alias_pix       Alias/Wavefront PIX image
 D  amr             3GPP AMR
 D  amrnb           raw AMR-NB
 D  amrwb           raw AMR-WB
 D  anm             Deluxe Paint Animation
 D  apc             CRYO APC
 D  ape             Monkey's Audio
 D  apng            Animated Portable Network Graphics
 D  aptx            raw aptX
 D  aptx_hd         raw aptX HD
 D  aqtitle         AQTitle subtitles
 D  asf             ASF (Advanced / Active Streaming Format)
 D  asf_o           ASF (Advanced / Active Streaming Format)
 D  ass             SSA (SubStation Alpha) subtitle
 D  ast             AST (Audio Stream)
 D  au              Sun AU
 D  avfoundation    AVFoundation input device
 D  avi             AVI (Audio Video Interleaved)
 D  avr             AVR (Audio Visual Research)
 D  avs             Argonaut Games Creature Shock
 D  avs2            raw AVS2-P2/IEEE1857.4
 D  bethsoftvid     Bethesda Softworks VID
 D  bfi             Brute Force & Ignorance
 D  bfstm           BFSTM (Binary Cafe Stream)
 D  bin             Binary text
 D  bink            Bink
 D  bit             G.729 BIT file format
 D  bmp_pipe        piped bmp sequence
 D  bmv             Discworld II BMV
 D  boa             Black Ops Audio
 D  brender_pix     BRender PIX image
 D  brstm           BRSTM (Binary Revolution Stream)
 D  c93             Interplay C93
 D  caf             Apple CAF (Core Audio Format)
 D  cavsvideo       raw Chinese AVS (Audio Video Standard)
 D  cdg             CD Graphics
 D  cdxl            Commodore CDXL video
 D  cine            Phantom Cine
 D  codec2          codec2 .c2 demuxer
 D  codec2raw       raw codec2 demuxer
 D  concat          Virtual concatenation script
 D  data            raw data
 D  daud            D-Cinema audio
 D  dcstr           Sega DC STR
 D  dds_pipe        piped dds sequence
 D  dfa             Chronomaster DFA
 D  dhav            Video DAV
 D  dirac           raw Dirac
 D  dnxhd           raw DNxHD (SMPTE VC-3)
 D  dpx_pipe        piped dpx sequence
 D  dsf             DSD Stream File (DSF)
 D  dsicin          Delphine Software International CIN
 D  dss             Digital Speech Standard (DSS)
 D  dts             raw DTS
 D  dtshd           raw DTS-HD
 D  dv              DV (Digital Video)
 D  dvbsub          raw dvbsub
 D  dvbtxt          dvbtxt
 D  dxa             DXA
 D  ea              Electronic Arts Multimedia
 D  ea_cdata        Electronic Arts cdata
 D  eac3            raw E-AC-3
 D  epaf            Ensoniq Paris Audio File
 D  exr_pipe        piped exr sequence
 D  f32be           PCM 32-bit floating-point big-endian
 D  f32le           PCM 32-bit floating-point little-endian
 D  f64be           PCM 64-bit floating-point big-endian
 D  f64le           PCM 64-bit floating-point little-endian
 D  ffmetadata      FFmpeg metadata in text
 D  film_cpk        Sega FILM / CPK
 D  filmstrip       Adobe Filmstrip
 D  fits            Flexible Image Transport System
 D  flac            raw FLAC
 D  flic            FLI/FLC/FLX animation
 D  flv             FLV (Flash Video)
 D  frm             Megalux Frame
 D  fsb             FMOD Sample Bank
 D  g722            raw G.722
 D  g723_1          G.723.1
 D  g726            raw big-endian G.726 ("left aligned")
 D  g726le          raw little-endian G.726 ("right aligned")
 D  g729            G.729 raw format demuxer
 D  gdv             Gremlin Digital Video
 D  genh            GENeric Header
 D  gif             CompuServe Graphics Interchange Format (GIF)
 D  gif_pipe        piped gif sequence
 D  gsm             raw GSM
 D  gxf             GXF (General eXchange Format)
 D  h261            raw H.261
 D  h263            raw H.263
 D  h264            raw H.264 video
 D  hcom            Macintosh HCOM
 D  hevc            raw HEVC video
 D  hls             Apple HTTP Live Streaming
 D  hnm             Cryo HNM v4
 D  ico             Microsoft Windows ICO
 D  idcin           id Cinematic
 D  idf             iCE Draw File
 D  iff             IFF (Interchange File Format)
 D  ifv             IFV CCTV DVR
 D  ilbc            iLBC storage
 D  image2          image2 sequence
 D  image2pipe      piped image2 sequence
 D  ingenient       raw Ingenient MJPEG
 D  ipmovie         Interplay MVE
 D  ircam           Berkeley/IRCAM/CARL Sound Format
 D  iss             Funcom ISS
 D  iv8             IndigoVision 8000 video
 D  ivf             On2 IVF
 D  ivr             IVR (Internet Video Recording)
 D  j2k_pipe        piped j2k sequence
 D  jacosub         JACOsub subtitle format
 D  jpeg_pipe       piped jpeg sequence
 D  jpegls_pipe     piped jpegls sequence
 D  jv              Bitmap Brothers JV
 D  kux             KUX (YouKu)
 D  lavfi           Libavfilter virtual input device
 D  live_flv        live RTMP FLV (Flash Video)
 D  lmlm4           raw lmlm4
 D  loas            LOAS AudioSyncStream
 D  lrc             LRC lyrics
 D  lvf             LVF
 D  lxf             VR native stream (LXF)
 D  m4v             raw MPEG-4 video
 D  matroska,webm   Matroska / WebM
 D  mgsts           Metal Gear Solid: The Twin Snakes
 D  microdvd        MicroDVD subtitle format
 D  mjpeg           raw MJPEG video
 D  mjpeg_2000      raw MJPEG 2000 video
 D  mlp             raw MLP
 D  mlv             Magic Lantern Video (MLV)
 D  mm              American Laser Games MM
 D  mmf             Yamaha SMAF
 D  mov,mp4,m4a,3gp,3g2,mj2 QuickTime / MOV
 D  mp3             MP2/3 (MPEG audio layer 2/3)
 D  mpc             Musepack
 D  mpc8            Musepack SV8
 D  mpeg            MPEG-PS (MPEG-2 Program Stream)
 D  mpegts          MPEG-TS (MPEG-2 Transport Stream)
 D  mpegtsraw       raw MPEG-TS (MPEG-2 Transport Stream)
 D  mpegvideo       raw MPEG video
 D  mpjpeg          MIME multipart JPEG
 D  mpl2            MPL2 subtitles
 D  mpsub           MPlayer subtitles
 D  msf             Sony PS3 MSF
 D  msnwctcp        MSN TCP Webcam stream
 D  mtaf            Konami PS2 MTAF
 D  mtv             MTV
 D  mulaw           PCM mu-law
 D  musx            Eurocom MUSX
 D  mv              Silicon Graphics Movie
 D  mvi             Motion Pixels MVI
 D  mxf             MXF (Material eXchange Format)
 D  mxg             MxPEG clip
 D  nc              NC camera feed
 D  nistsphere      NIST SPeech HEader REsources
 D  nsp             Computerized Speech Lab NSP
 D  nsv             Nullsoft Streaming Video
 D  nut             NUT
 D  nuv             NuppelVideo
 D  ogg             Ogg
 D  oma             Sony OpenMG audio
 D  paf             Amazing Studio Packed Animation File
 D  pam_pipe        piped pam sequence
 D  pbm_pipe        piped pbm sequence
 D  pcx_pipe        piped pcx sequence
 D  pgm_pipe        piped pgm sequence
 D  pgmyuv_pipe     piped pgmyuv sequence
 D  pictor_pipe     piped pictor sequence
 D  pjs             PJS (Phoenix Japanimation Society) subtitles
 D  pmp             Playstation Portable PMP
 D  png_pipe        piped png sequence
 D  ppm_pipe        piped ppm sequence
 D  psd_pipe        piped psd sequence
 D  psxstr          Sony Playstation STR
 D  pva             TechnoTrend PVA
 D  pvf             PVF (Portable Voice Format)
 D  qcp             QCP
 D  qdraw_pipe      piped qdraw sequence
 D  r3d             REDCODE R3D
 D  rawvideo        raw video
 D  realtext        RealText subtitle format
 D  redspark        RedSpark
 D  rl2             RL2
 D  rm              RealMedia
 D  roq             id RoQ
 D  rpl             RPL / ARMovie
 D  rsd             GameCube RSD
 D  rso             Lego Mindstorms RSO
 D  rtp             RTP input
 D  rtsp            RTSP input
 D  s16be           PCM signed 16-bit big-endian
 D  s16le           PCM signed 16-bit little-endian
 D  s24be           PCM signed 24-bit big-endian
 D  s24le           PCM signed 24-bit little-endian
 D  s32be           PCM signed 32-bit big-endian
 D  s32le           PCM signed 32-bit little-endian
 D  s337m           SMPTE 337M
 D  s8              PCM signed 8-bit
 D  sami            SAMI subtitle format
 D  sap             SAP input
 D  sbc             raw SBC (low-complexity subband codec)
 D  sbg             SBaGen binaural beats script
 D  scc             Scenarist Closed Captions
 D  sdp             SDP
 D  sdr2            SDR2
 D  sds             MIDI Sample Dump Standard
 D  sdx             Sample Dump eXchange
 D  ser             SER (Simple uncompressed video format for astronomical capturing)
 D  sgi_pipe        piped sgi sequence
 D  shn             raw Shorten
 D  siff            Beam Software SIFF
 D  sln             Asterisk raw pcm
 D  smjpeg          Loki SDL MJPEG
 D  smk             Smacker
 D  smush           LucasArts Smush
 D  sol             Sierra SOL
 D  sox             SoX native
 D  spdif           IEC 61937 (compressed data in S/PDIF)
 D  srt             SubRip subtitle
 D  stl             Spruce subtitle format
 D  subviewer       SubViewer subtitle format
 D  subviewer1      SubViewer v1 subtitle format
 D  sunrast_pipe    piped sunrast sequence
 D  sup             raw HDMV Presentation Graphic Stream subtitles
 D  svag            Konami PS2 SVAG
 D  svg_pipe        piped svg sequence
 D  swf             SWF (ShockWave Flash)
 D  tak             raw TAK
 D  tedcaptions     TED Talks captions
 D  thp             THP
 D  tiertexseq      Tiertex Limited SEQ
 D  tiff_pipe       piped tiff sequence
 D  tmv             8088flex TMV
 D  truehd          raw TrueHD
 D  tta             TTA (True Audio)
 D  tty             Tele-typewriter
 D  txd             Renderware TeXture Dictionary
 D  ty              TiVo TY Stream
 D  u16be           PCM unsigned 16-bit big-endian
 D  u16le           PCM unsigned 16-bit little-endian
 D  u24be           PCM unsigned 24-bit big-endian
 D  u24le           PCM unsigned 24-bit little-endian
 D  u32be           PCM unsigned 32-bit big-endian
 D  u32le           PCM unsigned 32-bit little-endian
 D  u8              PCM unsigned 8-bit
 D  v210            Uncompressed 4:2:2 10-bit
 D  v210x           Uncompressed 4:2:2 10-bit
 D  vag             Sony PS2 VAG
 D  vc1             raw VC-1
 D  vc1test         VC-1 test bitstream
 D  vidc            PCM Archimedes VIDC
 D  vividas         Vividas VIV
 D  vivo            Vivo
 D  vmd             Sierra VMD
 D  vobsub          VobSub subtitle format
 D  voc             Creative Voice
 D  vpk             Sony PS2 VPK
 D  vplayer         VPlayer subtitles
 D  vqf             Nippon Telegraph and Telephone Corporation (NTT) TwinVQ
 D  w64             Sony Wave64
 D  wav             WAV / WAVE (Waveform Audio)
 D  wc3movie        Wing Commander III movie
 D  webm_dash_manifest WebM DASH Manifest
 D  webp_pipe       piped webp sequence
 D  webvtt          WebVTT subtitle
 D  wsaud           Westwood Studios audio
 D  wsd             Wideband Single-bit Data (WSD)
 D  wsvqa           Westwood Studios VQA
 D  wtv             Windows Television (WTV)
 D  wv              WavPack
 D  wve             Psion 3 audio
 D  xa              Maxis XA
 D  xbin            eXtended BINary text (XBIN)
 D  xmv             Microsoft XMV
 D  xpm_pipe        piped xpm sequence
 D  xvag            Sony PS3 XVAG
 D  xwd_pipe        piped xwd sequence
 D  xwma            Microsoft xWMA
 D  yop             Psygnosis YOP
 D  yuv4mpegpipe    YUV4MPEG pipe
(base) qingwei@guoxiucai ~ % 


```

### eg: decoders
我自己电脑上的版本是4.2.2

```
Last login: Wed Sep  2 19:02:43 on ttys004
(base) qingwei@guoxiucai ~ % ffmpeg -decoders
ffmpeg version 4.2.2 Copyright (c) 2000-2019 the FFmpeg developers
  built with Apple clang version 11.0.0 (clang-1100.0.33.17)
  configuration: --prefix=/usr/local/Cellar/ffmpeg/4.2.2_4 --enable-shared --enable-pthreads --enable-version3 --enable-avresample --cc=clang --host-cflags=-fno-stack-check --host-ldflags= --enable-ffplay --enable-gnutls --enable-gpl --enable-libaom --enable-libbluray --enable-libmp3lame --enable-libopus --enable-librubberband --enable-libsnappy --enable-libsrt --enable-libtesseract --enable-libtheora --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxvid --enable-lzma --enable-libfontconfig --enable-libfreetype --enable-frei0r --enable-libass --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-librtmp --enable-libspeex --enable-libsoxr --enable-videotoolbox --disable-libjack --disable-indev=jack
  libavutil      56. 31.100 / 56. 31.100
  libavcodec     58. 54.100 / 58. 54.100
  libavformat    58. 29.100 / 58. 29.100
  libavdevice    58.  8.100 / 58.  8.100
  libavfilter     7. 57.100 /  7. 57.100
  libavresample   4.  0.  0 /  4.  0.  0
  libswscale      5.  5.100 /  5.  5.100
  libswresample   3.  5.100 /  3.  5.100
  libpostproc    55.  5.100 / 55.  5.100
Decoders:
 V..... = Video
 A..... = Audio
 S..... = Subtitle
 .F.... = Frame-level multithreading
 ..S... = Slice-level multithreading
 ...X.. = Codec is experimental
 ....B. = Supports draw_horiz_band
 .....D = Supports direct rendering method 1
 ------
 V....D 012v                 Uncompressed 4:2:2 10-bit
 V....D 4xm                  4X Movie
 V....D 8bps                 QuickTime 8BPS video
 V....D aasc                 Autodesk RLE
 V....D agm                  Amuse Graphics Movie
 VF...D aic                  Apple Intermediate Codec
 V....D alias_pix            Alias/Wavefront PIX image
 V....D amv                  AMV Video
 V....D anm                  Deluxe Paint Animation
 V....D ansi                 ASCII/ANSI art
 VF...D apng                 APNG (Animated Portable Network Graphics) image
 V....D arbc                 Gryphon's Anim Compressor
 V....D asv1                 ASUS V1
 V....D asv2                 ASUS V2
 V....D aura                 Auravision AURA
 V....D aura2                Auravision Aura 2
 V....D libaom-av1           libaom AV1 (codec av1)
 V..... avrn                 Avid AVI Codec
 V....D avrp                 Avid 1:1 10-bit RGB Packer
 V....D avs                  AVS (Audio Video Standard) video
 V....D avui                 Avid Meridien Uncompressed
 V....D ayuv                 Uncompressed packed MS 4:4:4:4
 V....D bethsoftvid          Bethesda VID video
 V....D bfi                  Brute Force & Ignorance
 V....D binkvideo            Bink video
 V....D bintext              Binary text
 V..X.. bitpacked            Bitpacked
 V....D bmp                  BMP (Windows and OS/2 bitmap)
 V....D bmv_video            Discworld II BMV video
 V....D brender_pix          BRender PIX image
 V....D c93                  Interplay C93
 V....D cavs                 Chinese AVS (Audio Video Standard) (AVS1-P2, JiZhun profile)
 V....D cdgraphics           CD Graphics video
 V....D cdxl                 Commodore CDXL video
 VF...D cfhd                 Cineform HD
 V....D cinepak              Cinepak
 V....D clearvideo           Iterated Systems ClearVideo
 V....D cljr                 Cirrus Logic AccuPak
 VF...D cllc                 Canopus Lossless Codec
 V....D eacmv                Electronic Arts CMV video (codec cmv)
 V....D cpia                 CPiA video format
 V....D camstudio            CamStudio (codec cscd)
 V....D cyuv                 Creative YUV (CYUV)
 V.S..D dds                  DirectDraw Surface image decoder
 V....D dfa                  Chronomaster DFA
 V.S..D dirac                BBC Dirac VC-2
 VFS..D dnxhd                VC3/DNxHD
 V....D dpx                  DPX (Digital Picture Exchange) image
 V....D dsicinvideo          Delphine Software International CIN video
 VFS..D dvvideo              DV (Digital Video)
 V....D dxa                  Feeble Files/ScummVM DXA
 V....D dxtory               Dxtory
 VFS..D dxv                  Resolume DXV
 V....D escape124            Escape 124
 V....D escape130            Escape 130
 VFS..D exr                  OpenEXR image
 VFS..D ffv1                 FFmpeg video codec #1
 VF..BD ffvhuff              Huffyuv FFmpeg variant
 V.S..D fic                  Mirillis FIC
 V....D fits                 Flexible Image Transport System
 V....D flashsv              Flash Screen Video v1
 V....D flashsv2             Flash Screen Video v2
 V....D flic                 Autodesk Animator Flic video
 V...BD flv                  FLV / Sorenson Spark / Sorenson H.263 (Flash Video) (codec flv1)
 V....D fmvc                 FM Screen Capture Codec
 VF...D fraps                Fraps
 V....D frwu                 Forward Uncompressed
 V....D g2m                  Go2Meeting
 V....D gdv                  Gremlin Digital Video
 V....D gif                  GIF (Graphics Interchange Format)
 V....D h261                 H.261
 V...BD h263                 H.263 / H.263-1996, H.263+ / H.263-1998 / H.263 version 2
 V...BD h263i                Intel H.263
 V...BD h263p                H.263 / H.263-1996, H.263+ / H.263-1998 / H.263 version 2
 VFS..D h264                 H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10
 VFS..D hap                  Vidvox Hap
 VFS..D hevc                 HEVC (High Efficiency Video Coding)
 V....D hnm4video            HNM 4 video
 V....D hq_hqa               Canopus HQ/HQA
 VFS..D hqx                  Canopus HQX
 VF..BD huffyuv              Huffyuv / HuffYUV
 VF..BD hymt                 HuffYUV MT
 V....D idcinvideo           id Quake II CIN video (codec idcin)
 V....D idf                  iCEDraw text
 V....D iff                  IFF ACBM/ANIM/DEEP/ILBM/PBM/RGB8/RGBN (codec iff_ilbm)
 V....D imm4                 Infinity IMM4
 V....D indeo2               Intel Indeo 2
 V....D indeo3               Intel Indeo 3
 V....D indeo4               Intel Indeo Video Interactive 4
 V....D indeo5               Intel Indeo Video Interactive 5
 V....D interplayvideo       Interplay MVE video
 VFS..D jpeg2000             JPEG 2000
 VF...D libopenjpeg          OpenJPEG JPEG 2000 (codec jpeg2000)
 V....D jpegls               JPEG-LS
 V....D jv                   Bitmap Brothers JV video
 V....D kgv1                 Kega Game Video
 V....D kmvc                 Karl Morton's video codec
 VF...D lagarith             Lagarith lossless
 V....D loco                 LOCO
 V....D lscr                 LEAD Screen Capture
 V....D m101                 Matrox Uncompressed SD
 V....D eamad                Electronic Arts Madcow Video (codec mad)
 VFS..D magicyuv             MagicYUV video
 VF...D mdec                 Sony PlayStation MDEC (Motion DECoder)
 VF...D mimic                Mimic
 V....D mjpeg                MJPEG (Motion JPEG)
 V....D mjpegb               Apple MJPEG-B
 V....D mmvideo              American Laser Games MM Video
 V....D motionpixels         Motion Pixels video
 V.S.BD mpeg1video           MPEG-1 video
 V.S.BD mpeg2video           MPEG-2 video
 V.S.BD mpegvideo            MPEG-1 video (codec mpeg2video)
 VF..BD mpeg4                MPEG-4 part 2
 V....D msa1                 MS ATC Screen
 V....D mscc                 Mandsoft Screen Capture Codec
 V...BD msmpeg4v1            MPEG-4 part 2 Microsoft variant version 1
 V...BD msmpeg4v2            MPEG-4 part 2 Microsoft variant version 2
 V...BD msmpeg4              MPEG-4 part 2 Microsoft variant version 3 (codec msmpeg4v3)
 V....D msrle                Microsoft RLE
 V....D mss1                 MS Screen 1
 V....D mss2                 MS Windows Media Video V9 Screen
 V....D msvideo1             Microsoft Video 1
 VF...D mszh                 LCL (LossLess Codec Library) MSZH
 V....D mts2                 MS Expression Encoder Screen
 V....D mvc1                 Silicon Graphics Motion Video Compressor 1
 V....D mvc2                 Silicon Graphics Motion Video Compressor 2
 V....D mwsc                 MatchWare Screen Capture Codec
 V....D mxpeg                Mobotix MxPEG video
 V....D nuv                  NuppelVideo/RTJPEG
 V....D paf_video            Amazing Studio Packed Animation File Video
 V....D pam                  PAM (Portable AnyMap) image
 V....D pbm                  PBM (Portable BitMap) image
 V....D pcx                  PC Paintbrush PCX image
 V....D pgm                  PGM (Portable GrayMap) image
 V....D pgmyuv               PGMYUV (Portable GrayMap YUV) image
 V....D pictor               Pictor/PC Paint
 VF...D pixlet               Apple Pixlet
 VF...D png                  PNG (Portable Network Graphics) image
 V....D ppm                  PPM (Portable PixelMap) image
 VFS..D prores               ProRes (iCodec Pro)
 V....D prosumer             Brooktree ProSumer Video
 VF...D psd                  Photoshop PSD file
 V....D ptx                  V.Flash PTX image
 V....D qdraw                Apple QuickDraw
 V....D qpeg                 Q-team QPEG
 V....D qtrle                QuickTime Animation (RLE) video
 V....D r10k                 AJA Kona 10-bit RGB Codec
 V....D r210                 Uncompressed RGB 10-bit
 V....D rasc                 RemotelyAnywhere Screen Capture
 V..... rawvideo             raw video
 V....D rl2                  RL2 video
 V....D roqvideo             id RoQ video (codec roq)
 V....D rpza                 QuickTime video (RPZA)
 V....D rscc                 innoHeim/Rsupport Screen Capture Codec
 V....D rv10                 RealVideo 1.0
 V....D rv20                 RealVideo 2.0
 VF...D rv30                 RealVideo 3.0
 VF...D rv40                 RealVideo 4.0
 V....D sanm                 LucasArts SANM/Smush video
 V....D scpr                 ScreenPressor
 V....D screenpresso         Screenpresso
 V....D sgi                  SGI image
 V....D sgirle               Silicon Graphics RLE 8-bit video
 VF...D sheervideo           BitJazz SheerVideo
 V....D smackvid             Smacker video (codec smackvideo)
 V....D smc                  QuickTime Graphics (SMC)
 V..... smvjpeg              SMV JPEG
 V....D snow                 Snow
 V....D sp5x                 Sunplus JPEG (SP5X)
 V....D speedhq              NewTek SpeedHQ
 V....D srgc                 Screen Recorder Gold Codec
 V....D sunrast              Sun Rasterfile image
 V....D svq1                 Sorenson Vector Quantizer 1 / Sorenson Video 1 / SVQ1
 V...BD svq3                 Sorenson Vector Quantizer 3 / Sorenson Video 3 / SVQ3
 V....D targa                Truevision Targa image
 V....D targa_y216           Pinnacle TARGA CineWave YUV16
 V....D tdsc                 TDSC
 V....D eatgq                Electronic Arts TGQ video (codec tgq)
 V....D eatgv                Electronic Arts TGV video (codec tgv)
 VF..BD theora               Theora
 V....D thp                  Nintendo Gamecube THP video
 V....D tiertexseqvideo      Tiertex Limited SEQ video
 VF...D tiff                 TIFF image
 V....D tmv                  8088flex TMV
 V....D eatqi                Electronic Arts TQI Video (codec tqi)
 V....D truemotion1          Duck TrueMotion 1.0
 V....D truemotion2          Duck TrueMotion 2.0
 V....D truemotion2rt        Duck TrueMotion 2.0 Real Time
 V....D camtasia             TechSmith Screen Capture Codec (codec tscc)
 V....D tscc2                TechSmith Screen Codec 2
 V....D txd                  Renderware TXD (TeXture Dictionary) image
 V....D ultimotion           IBM UltiMotion (codec ulti)
 VF...D utvideo              Ut Video
 V....D v210                 Uncompressed 4:2:2 10-bit
 V....D v210x                Uncompressed 4:2:2 10-bit
 V....D v308                 Uncompressed packed 4:4:4
 V....D v408                 Uncompressed packed QT 4:4:4:4
 V....D v410                 Uncompressed 4:4:4 10-bit
 V....D vb                   Beam Software VB
 VF...D vble                 VBLE Lossless Codec
 V....D vc1                  SMPTE VC-1
 V....D vc1image             Windows Media Video 9 Image v2
 V....D vcr1                 ATI VCR1
 V....D xl                   Miro VideoXL (codec vixl)
 V....D vmdvideo             Sierra VMD video
 V....D vmnc                 VMware Screen Codec / VMware Video
 VF..BD vp3                  On2 VP3
 VF..BD vp4                  On2 VP4
 V....D vp5                  On2 VP5
 V....D vp6                  On2 VP6
 V.S..D vp6a                 On2 VP6 (Flash version, with alpha channel)
 V....D vp6f                 On2 VP6 (Flash version)
 V....D vp7                  On2 VP7
 VFS..D vp8                  On2 VP8
 V....D libvpx               libvpx VP8 (codec vp8)
 VFS..D vp9                  Google VP9
 V....D libvpx-vp9           libvpx VP9 (codec vp9)
 V....D wcmv                 WinCAM Motion Video
 VF...D webp                 WebP image
 V...BD wmv1                 Windows Media Video 7
 V...BD wmv2                 Windows Media Video 8
 V....D wmv3                 Windows Media Video 9
 V....D wmv3image            Windows Media Video 9 Image
 V....D wnv1                 Winnov WNV1
 V..... wrapped_avframe      AVPacket to AVFrame passthrough
 V....D vqavideo             Westwood Studios VQA (Vector Quantized Animation) video (codec ws_vqa)
 V....D xan_wc3              Wing Commander III / Xan
 V....D xan_wc4              Wing Commander IV / Xxan
 V....D xbin                 eXtended BINary text
 V....D xbm                  XBM (X BitMap) image
 V..... xface                X-face image
 V....D xpm                  XPM (X PixMap) image
 V....D xwd                  XWD (X Window Dump) image
 V....D y41p                 Uncompressed YUV 4:1:1 12-bit
 VF...D ylc                  YUY2 Lossless Codec
 V..... yop                  Psygnosis YOP Video
 V....D yuv4                 Uncompressed packed 4:2:0
 V....D zerocodec            ZeroCodec Lossless Video
 VF...D zlib                 LCL (LossLess Codec Library) ZLIB
 V....D zmbv                 Zip Motion Blocks Video
 A....D 8svx_exp             8SVX exponential
 A....D 8svx_fib             8SVX fibonacci
 A....D aac                  AAC (Advanced Audio Coding)
 A....D aac_fixed            AAC (Advanced Audio Coding) (codec aac)
 A....D aac_at               aac (AudioToolbox) (codec aac)
 A....D aac_latm             AAC LATM (Advanced Audio Coding LATM syntax)
 A....D ac3                  ATSC A/52A (AC-3)
 A....D ac3_fixed            ATSC A/52A (AC-3) (codec ac3)
 A....D ac3_at               ac3 (AudioToolbox) (codec ac3)
 A....D adpcm_4xm            ADPCM 4X Movie
 A....D adpcm_adx            SEGA CRI ADX ADPCM
 A....D adpcm_afc            ADPCM Nintendo Gamecube AFC
 A....D adpcm_agm            ADPCM AmuseGraphics Movie
 A....D adpcm_aica           ADPCM Yamaha AICA
 A....D adpcm_ct             ADPCM Creative Technology
 A....D adpcm_dtk            ADPCM Nintendo Gamecube DTK
 A....D adpcm_ea             ADPCM Electronic Arts
 A....D adpcm_ea_maxis_xa    ADPCM Electronic Arts Maxis CDROM XA
 A....D adpcm_ea_r1          ADPCM Electronic Arts R1
 A....D adpcm_ea_r2          ADPCM Electronic Arts R2
 A....D adpcm_ea_r3          ADPCM Electronic Arts R3
 A....D adpcm_ea_xas         ADPCM Electronic Arts XAS
 A....D g722                 G.722 ADPCM (codec adpcm_g722)
 A....D g726                 G.726 ADPCM (codec adpcm_g726)
 A....D g726le               G.726 ADPCM little-endian (codec adpcm_g726le)
 A....D adpcm_ima_amv        ADPCM IMA AMV
 A....D adpcm_ima_apc        ADPCM IMA CRYO APC
 A....D adpcm_ima_dat4       ADPCM IMA Eurocom DAT4
 A....D adpcm_ima_dk3        ADPCM IMA Duck DK3
 A....D adpcm_ima_dk4        ADPCM IMA Duck DK4
 A....D adpcm_ima_ea_eacs    ADPCM IMA Electronic Arts EACS
 A....D adpcm_ima_ea_sead    ADPCM IMA Electronic Arts SEAD
 A....D adpcm_ima_iss        ADPCM IMA Funcom ISS
 A....D adpcm_ima_oki        ADPCM IMA Dialogic OKI
 A....D adpcm_ima_qt         ADPCM IMA QuickTime
 A....D adpcm_ima_qt_at      adpcm_ima_qt (AudioToolbox) (codec adpcm_ima_qt)
 A....D adpcm_ima_rad        ADPCM IMA Radical
 A....D adpcm_ima_smjpeg     ADPCM IMA Loki SDL MJPEG
 A....D adpcm_ima_wav        ADPCM IMA WAV
 A....D adpcm_ima_ws         ADPCM IMA Westwood
 A....D adpcm_ms             ADPCM Microsoft
 A....D adpcm_mtaf           ADPCM MTAF
 A....D adpcm_psx            ADPCM Playstation
 A....D adpcm_sbpro_2        ADPCM Sound Blaster Pro 2-bit
 A....D adpcm_sbpro_3        ADPCM Sound Blaster Pro 2.6-bit
 A....D adpcm_sbpro_4        ADPCM Sound Blaster Pro 4-bit
 A....D adpcm_swf            ADPCM Shockwave Flash
 A....D adpcm_thp            ADPCM Nintendo THP
 A....D adpcm_thp_le         ADPCM Nintendo THP (little-endian)
 A....D adpcm_vima           LucasArts VIMA audio
 A....D adpcm_xa             ADPCM CDROM XA
 A....D adpcm_yamaha         ADPCM Yamaha
 AF...D alac                 ALAC (Apple Lossless Audio Codec)
 A....D alac_at              alac (AudioToolbox) (codec alac)
 A....D amrnb                AMR-NB (Adaptive Multi-Rate NarrowBand) (codec amr_nb)
 A....D amr_nb_at            amr_nb (AudioToolbox) (codec amr_nb)
 A....D libopencore_amrnb    OpenCORE AMR-NB (Adaptive Multi-Rate Narrow-Band) (codec amr_nb)
 A....D amrwb                AMR-WB (Adaptive Multi-Rate WideBand) (codec amr_wb)
 A....D libopencore_amrwb    OpenCORE AMR-WB (Adaptive Multi-Rate Wide-Band) (codec amr_wb)
 A....D ape                  Monkey's Audio
 A....D aptx                 aptX (Audio Processing Technology for Bluetooth)
 A....D aptx_hd              aptX HD (Audio Processing Technology for Bluetooth)
 A....D atrac1               ATRAC1 (Adaptive TRansform Acoustic Coding)
 A....D atrac3               ATRAC3 (Adaptive TRansform Acoustic Coding 3)
 A....D atrac3al             ATRAC3 AL (Adaptive TRansform Acoustic Coding 3 Advanced Lossless)
 A....D atrac3plus           ATRAC3+ (Adaptive TRansform Acoustic Coding 3+) (codec atrac3p)
 A....D atrac3plusal         ATRAC3+ AL (Adaptive TRansform Acoustic Coding 3+ Advanced Lossless) (codec atrac3pal)
 A....D atrac9               ATRAC9 (Adaptive TRansform Acoustic Coding 9)
 A....D on2avc               On2 Audio for Video Codec (codec avc)
 A....D binkaudio_dct        Bink Audio (DCT)
 A....D binkaudio_rdft       Bink Audio (RDFT)
 A....D bmv_audio            Discworld II BMV audio
 A....D comfortnoise         RFC 3389 comfort noise generator
 A....D cook                 Cook / Cooker / Gecko (RealAudio G2)
 A....D dolby_e              Dolby E
 A..... dsd_lsbf             DSD (Direct Stream Digital), least significant bit first
 A..... dsd_lsbf_planar      DSD (Direct Stream Digital), least significant bit first, planar
 A..... dsd_msbf             DSD (Direct Stream Digital), most significant bit first
 A..... dsd_msbf_planar      DSD (Direct Stream Digital), most significant bit first, planar
 A....D dsicinaudio          Delphine Software International CIN audio
 A....D dss_sp               Digital Speech Standard - Standard Play mode (DSS SP)
 A....D dst                  DST (Digital Stream Transfer)
 A....D dca                  DCA (DTS Coherent Acoustics) (codec dts)
 A....D dvaudio              Ulead DV Audio
 A....D eac3                 ATSC A/52B (AC-3, E-AC-3)
 A....D eac3_at              eac3 (AudioToolbox) (codec eac3)
 A....D evrc                 EVRC (Enhanced Variable Rate Codec)
 AF...D flac                 FLAC (Free Lossless Audio Codec)
 A....D g723_1               G.723.1
 A....D g729                 G.729
 A....D gremlin_dpcm         DPCM Gremlin
 A....D gsm                  GSM
 A....D gsm_ms               GSM Microsoft variant
 A....D gsm_ms_at            gsm_ms (AudioToolbox) (codec gsm_ms)
 A....D hcom                 HCOM Audio
 A....D iac                  IAC (Indeo Audio Coder)
 A....D ilbc                 iLBC (Internet Low Bitrate Codec)
 A....D ilbc_at              ilbc (AudioToolbox) (codec ilbc)
 A....D imc                  IMC (Intel Music Coder)
 A....D interplay_dpcm       DPCM Interplay
 A....D interplayacm         Interplay ACM
 A....D mace3                MACE (Macintosh Audio Compression/Expansion) 3:1
 A....D mace6                MACE (Macintosh Audio Compression/Expansion) 6:1
 A....D metasound            Voxware MetaSound
 A....D mlp                  MLP (Meridian Lossless Packing)
 A....D mp1                  MP1 (MPEG audio layer 1)
 A....D mp1float             MP1 (MPEG audio layer 1) (codec mp1)
 A....D mp1_at               mp1 (AudioToolbox) (codec mp1)
 A....D mp2                  MP2 (MPEG audio layer 2)
 A....D mp2float             MP2 (MPEG audio layer 2) (codec mp2)
 A....D mp2_at               mp2 (AudioToolbox) (codec mp2)
 A....D mp3float             MP3 (MPEG audio layer 3) (codec mp3)
 A....D mp3                  MP3 (MPEG audio layer 3)
 A....D mp3_at               mp3 (AudioToolbox) (codec mp3)
 A....D mp3adufloat          ADU (Application Data Unit) MP3 (MPEG audio layer 3) (codec mp3adu)
 A....D mp3adu               ADU (Application Data Unit) MP3 (MPEG audio layer 3)
 A....D mp3on4float          MP3onMP4 (codec mp3on4)
 A....D mp3on4               MP3onMP4
 A....D als                  MPEG-4 Audio Lossless Coding (ALS) (codec mp4als)
 A....D mpc7                 Musepack SV7 (codec musepack7)
 A....D mpc8                 Musepack SV8 (codec musepack8)
 A....D nellymoser           Nellymoser Asao
 A....D opus                 Opus
 A....D libopus              libopus Opus (codec opus)
 A....D paf_audio            Amazing Studio Packed Animation File Audio
 A....D pcm_alaw             PCM A-law / G.711 A-law
 A....D pcm_alaw_at          pcm_alaw (AudioToolbox) (codec pcm_alaw)
 A....D pcm_bluray           PCM signed 16|20|24-bit big-endian for Blu-ray media
 A....D pcm_dvd              PCM signed 16|20|24-bit big-endian for DVD media
 A....D pcm_f16le            PCM 16.8 floating point little-endian
 A....D pcm_f24le            PCM 24.0 floating point little-endian
 A....D pcm_f32be            PCM 32-bit floating point big-endian
 A....D pcm_f32le            PCM 32-bit floating point little-endian
 A....D pcm_f64be            PCM 64-bit floating point big-endian
 A....D pcm_f64le            PCM 64-bit floating point little-endian
 A....D pcm_lxf              PCM signed 20-bit little-endian planar
 A....D pcm_mulaw            PCM mu-law / G.711 mu-law
 A....D pcm_mulaw_at         pcm_mulaw (AudioToolbox) (codec pcm_mulaw)
 A....D pcm_s16be            PCM signed 16-bit big-endian
 A....D pcm_s16be_planar     PCM signed 16-bit big-endian planar
 A....D pcm_s16le            PCM signed 16-bit little-endian
 A....D pcm_s16le_planar     PCM signed 16-bit little-endian planar
 A....D pcm_s24be            PCM signed 24-bit big-endian
 A....D pcm_s24daud          PCM D-Cinema audio signed 24-bit
 A....D pcm_s24le            PCM signed 24-bit little-endian
 A....D pcm_s24le_planar     PCM signed 24-bit little-endian planar
 A....D pcm_s32be            PCM signed 32-bit big-endian
 A....D pcm_s32le            PCM signed 32-bit little-endian
 A....D pcm_s32le_planar     PCM signed 32-bit little-endian planar
 A....D pcm_s64be            PCM signed 64-bit big-endian
 A....D pcm_s64le            PCM signed 64-bit little-endian
 A....D pcm_s8               PCM signed 8-bit
 A....D pcm_s8_planar        PCM signed 8-bit planar
 A....D pcm_u16be            PCM unsigned 16-bit big-endian
 A....D pcm_u16le            PCM unsigned 16-bit little-endian
 A....D pcm_u24be            PCM unsigned 24-bit big-endian
 A....D pcm_u24le            PCM unsigned 24-bit little-endian
 A....D pcm_u32be            PCM unsigned 32-bit big-endian
 A....D pcm_u32le            PCM unsigned 32-bit little-endian
 A....D pcm_u8               PCM unsigned 8-bit
 A....D pcm_vidc             PCM Archimedes VIDC
 A....D pcm_zork             PCM Zork
 A....D qcelp                QCELP / PureVoice
 A....D qdm2                 QDesign Music Codec 2
 A....D qdm2_at              qdm2 (AudioToolbox) (codec qdm2)
 A....D qdmc                 QDesign Music Codec 1
 A....D qdmc_at              qdmc (AudioToolbox) (codec qdmc)
 A....D real_144             RealAudio 1.0 (14.4K) (codec ra_144)
 A....D real_288             RealAudio 2.0 (28.8K) (codec ra_288)
 A....D ralf                 RealAudio Lossless
 A....D roq_dpcm             DPCM id RoQ
 A....D s302m                SMPTE 302M
 A....D sbc                  SBC (low-complexity subband codec)
 A....D sdx2_dpcm            DPCM Squareroot-Delta-Exact
 A....D shorten              Shorten
 A....D sipr                 RealAudio SIPR / ACELP.NET
 A....D smackaud             Smacker audio (codec smackaudio)
 A....D sol_dpcm             DPCM Sol
 A..X.D sonic                Sonic
 A....D libspeex             libspeex Speex (codec speex)
 AF...D tak                  TAK (Tom's lossless Audio Kompressor)
 A....D truehd               TrueHD
 A....D truespeech           DSP Group TrueSpeech
 AF...D tta                  TTA (True Audio)
 A....D twinvq               VQF TwinVQ
 A....D vmdaudio             Sierra VMD audio
 A....D vorbis               Vorbis
 A..... libvorbis            libvorbis (codec vorbis)
 A....D wavesynth            Wave synthesis pseudo-codec
 AF...D wavpack              WavPack
 A....D ws_snd1              Westwood Audio (SND1) (codec westwood_snd1)
 A....D wmalossless          Windows Media Audio Lossless
 A....D wmapro               Windows Media Audio 9 Professional
 A....D wmav1                Windows Media Audio 1
 A....D wmav2                Windows Media Audio 2
 A....D wmavoice             Windows Media Audio Voice
 A....D xan_dpcm             DPCM Xan
 A....D xma1                 Xbox Media Audio 1
 A....D xma2                 Xbox Media Audio 2
 S..... ssa                  ASS (Advanced SubStation Alpha) subtitle (codec ass)
 S..... ass                  ASS (Advanced SubStation Alpha) subtitle
 S..... dvbsub               DVB subtitles (codec dvb_subtitle)
 S..... dvdsub               DVD subtitles (codec dvd_subtitle)
 S..... cc_dec               Closed Caption (EIA-608 / CEA-708) (codec eia_608)
 S..... pgssub               HDMV Presentation Graphic Stream subtitles (codec hdmv_pgs_subtitle)
 S..... jacosub              JACOsub subtitle
 S..... microdvd             MicroDVD subtitle
 S..... mov_text             3GPP Timed Text subtitle
 S..... mpl2                 MPL2 subtitle
 S..... pjs                  PJS subtitle
 S..... realtext             RealText subtitle
 S..... sami                 SAMI subtitle
 S..... stl                  Spruce subtitle format
 S..... srt                  SubRip subtitle (codec subrip)
 S..... subrip               SubRip subtitle
 S..... subviewer            SubViewer subtitle
 S..... subviewer1           SubViewer1 subtitle
 S..... text                 Raw text subtitle
 S..... vplayer              VPlayer subtitle
 S..... webvtt               WebVTT subtitle
 S..... xsub                 XSUB
(base) qingwei@guoxiucai ~ % 


```











