# FYP
## 0. Useful links:
- [Features selected](https://github.com/ZhengdaoLI0602/FYP/blob/main/Features/README.md)
- [GPST Calculator](https://www.labsat.co.uk/index.php/en/gps-time-calculator)
- [Geodetic HK](https://www.geodetic.gov.hk/en/rinex/downv.aspx)
- [OneDrive FYP_ALL](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL?csf=1&web=1&e=xfShFL)
- Given Codes
  ||Versions|
  |---|---|
  |Weighted Least Square|[V1](https://github.com/ZhengdaoLI0602/FYP/releases/tag/c_code_wls)|
  |Labelling code|[V4](https://github.com/ZhengdaoLI0602/FYP/releases/tag/Labelling_v4) , [V3](https://github.com/ZhengdaoLI0602/FYP/releases/tag/labelling_v3) , [V2](https://github.com/ZhengdaoLI0602/FYP/releases/tag/labelling_v2) , [V1](https://github.com/ZhengdaoLI0602/FYP/releases/tag/Labelling_V1)|
  |Loosely coupled Kalman Filter|[V3](https://github.com/ZhengdaoLI0602/FYP/releases/tag/LCKF_V3) , [V2](https://github.com/ZhengdaoLI0602/FYP/releases/tag/LCKF_Version2) , [V1](https://github.com/ZhengdaoLI0602/FYP/releases/tag/LCKF)|
  |FGO|[V2](https://github.com/ZhengdaoLI0602/FYP/releases/tag/FGO_TB_NEW) , [V1](https://github.com/ZhengdaoLI0602/FYP/releases/tag/FGO)|
- Our Codes
  ||Contents|
  |---|---|
  |Codes after Interim||
  |PCA||
  |Fuzzy Logic||
  |ML||
  |Feature Refinement||
  
## 1. UrbanNav dataset:
- [GitHub link](https://github.com/IPNL-POLYU/UrbanNavDataset) 
- Labelling Results
  |TST|WP|MK|
  |---|---|---|
  |[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/ublox?csf=1&web=1&e=ZUDwR2)|[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/ublox?csf=1&web=1&e=ZSKviO)|[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/MK/Ublox?csf=1&web=1&e=Oo9ahB)|
  |[Xiaomi8](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/xiaomi?csf=1&web=1&e=3pIfEz)|[Xiaomi8](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/xiaomi?csf=1&web=1&e=nG12tH)|[Xiaomi8(Problems)]|
  |[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/novatel?csf=1&web=1&e=lyxOS8)|[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/novatel?csf=1&web=1&e=3P4Hho)|[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/MK/Novatel?csf=1&web=1&e=n3dIyl)|

- Labelling Maps
  |TST|WP|MK|
  |---|---|---|
  |[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/ublox/jpg?csf=1&web=1&e=XSppp3)|[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/ublox/jpg?csf=1&web=1&e=bYF5FJ)|[Ublox](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/MK/Ublox/MK_FIG.jpg?csf=1&web=1&e=hvfavw)|
  |[Xiaomi8](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/xiaomi/jpg?csf=1&web=1&e=6GQP0k)|[Xiaomi8](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/ublox/jpg?csf=1&web=1&e=bYF5FJ)|[Xiaomi8(Problems)]|
  |[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/novatel/jpg?csf=1&web=1&e=vF96Nb)|[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/novatel/jpg?csf=1&web=1&e=Ifpdfl)|[Novatel](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/MK/Novatel/MK_result_novatel.jpg?csf=1&web=1&e=LvmXFD)|

## 2. New dataset (KLT):
- Links:[Rinex File](https://www.dropbox.com/sh/7iag71h9sfn8f01/AAAlzaqvg50z1axRW_LzRgLaa?dl=0), [Ground Truth](https://www.dropbox.com/sh/8rhqsumsgfjrzzt/AACSaSfBrgEWHePB1RBxDUpXa?dl=0), [IMU data](https://www.dropbox.com/s/oan55icug5y9bw3/1203imudata.csv?dl=0), [Skymask](https://www.dropbox.com/s/rynyv2k6dwdvu3m/KLB.csv?dl=0)
- [Package from Patrick](https://github.com/ZhengdaoLI0602/FYP/releases/tag/Labelling_v4) , [GH's Supplement](https://github.com/ZhengdaoLI0602/FYP/releases/tag/KLT_Dataset_Supplement)
- Results
  |Results|Maps|
  |---|---|
  |[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/Ublox?csf=1&web=1&e=y0WzG1)|[Ublox](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/Ublox/KLT_ublox.jpg?csf=1&web=1&e=YTNpLh)|
  |[Xiaomi8](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/xiaomi?csf=1&web=1&e=Loh4fM)|[Xiaomi8](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/xiaomi/klt_xiaomi_result.jpg?csf=1&web=1&e=aw2bge)|
  |[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/Novatel?csf=1&web=1&e=pt1JXl)|[Novatel](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/Novatel/KLT_Novatel.jpg?csf=1&web=1&e=fcd18f)|
