ffmpeg \
-stream_loop -1 -i 1.mp4 \
-stream_loop -1 -i 2.mp4 \
-stream_loop -1 -i 3.mp4 \
-stream_loop -1 -i 1.mp3 \
-stream_loop -1 -i 2.mp3 \
-stream_loop -1 -i 3.mp3 \
-map 0:v \
-map 0:a \
-map 1:v \
-map 1:a \
-map 2:v \
-map 2:a \
-map 3:a \
-map 4:a \
-map 5:a \
-c:v:0 copy \
-c:a:0 mp2 -ar 48000 -ab 192000 -ac 2 -metadata:s:a:1 language=DEU \
-c:v:1 copy \
-c:a:1 mp2 -ar 48000 -ab 192000 -ac 2 -metadata:s:a:1 language=DEU \
-c:v:2 copy \
-c:a:2 mp2 -ar 48000 -ab 192000 -ac 2 -metadata:s:a:1 language=DEU \
-c:a:3 mp2 -ar 48000 -ab 192000 -ac 2 -metadata:s:a:1 language=DEU \
-c:a:4 mp2 -ar 48000 -ab 192000 -ac 2 -metadata:s:a:1 language=DEU \
-c:a:5 mp2 -ar 48000 -ab 192000 -ac 2 -metadata:s:a:1 language=DEU \
-program title="hd1":program_num=0x1001:st=0:st=1 \
-program title="hd2":program_num=0x1002:st=2:st=3 \
-program title="hd3":program_num=0x1003:st=4:st=5 \
-program title="Radio1":program_num=0x2001:st=6 \
-program title="Radio2":program_num=0x2002:st=7 \
-program title="Radio3":program_num=0x2003:st=8 \
-muxrate 44.51M \
-f mpegts -y - | \
tsp -v \
-I file \
-P filter --max-payload-size 0 --negate -s \
-P scrambler hd1 --ecmg localhost:8888 --super-cas-id 0x06020000 --channel-id 0x0001 --pid-ecm 0x1EC1 --cp-duration 10 --access-criteria 000a75301006271010061212300a7530 --stream-id 0x1001 --private-data 4E656F566973696F6E73 \
-P scrambler hd2 --ecmg localhost:8888 --super-cas-id 0x06020000 --channel-id 0x0002 --pid-ecm 0x1EC2 --cp-duration 10 --access-criteria 000a753010062710 --stream-id 0x1002 --private-data 4E656F566973696F6E73 \
-P cat -c -a 0x0602/0x11F2 \
-P datainject -r -s localhost:32000 -b 50000 -p 0x11F2 \
-P svrename -n "NeoVision HD 1" -p "NeoVision" hd1 \
-P svrename -n "NeoVision HD 2" -p "NeoVision" hd2 \
-P svrename -n "NeoVision HD 3" -p "NeoVision" hd3 \
-P svrename -n "NeoRadio 1" -p "NeoVision" radio1 -t 2 \
-P svrename -n "NeoRadio 2" -p "NeoVision" radio2 -t 2 \
-P svrename -n "NeoRadio 3" -p "NeoVision" radio3 -t 2 \
-O file | vlc -
