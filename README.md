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
  |PCA|[PCA](https://github.com/ZhengdaoLI0602/FYP/blob/Nancy/Codes/Results/Combined_Data.m)|
  |Fuzzy Logic||
  |ML||
  |Feature Refinement||
  |FGO||
  
## 1. UrbanNav dataset:
- [GitHub link](https://github.com/IPNL-POLYU/UrbanNavDataset) 
- Labelling Results
  |TST|WP|MK|
  |---|---|---|
  |[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/ublox?csf=1&web=1&e=ZUDwR2)|[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/ublox?csf=1&web=1&e=ZSKviO)|[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/MK/Ublox?csf=1&web=1&e=Oo9ahB)|
  |[Xiaomi8](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/xiaomi?csf=1&web=1&e=3pIfEz)|[Xiaomi8](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/xiaomi?csf=1&web=1&e=nG12tH)|[Xiaomi8](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/MK/Xiaomi8/MK_result_xiaomi.jpg?csf=1&web=1&e=BOzrp5)|
  |[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/novatel?csf=1&web=1&e=lyxOS8)|[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/novatel?csf=1&web=1&e=3P4Hho)|[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/MK/Novatel?csf=1&web=1&e=n3dIyl)|

- Labelling Maps
  |TST|WP|MK|
  |---|---|---|
  |[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/ublox/jpg?csf=1&web=1&e=XSppp3)|[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/ublox/jpg?csf=1&web=1&e=bYF5FJ)|[Ublox](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/MK/Ublox/MK_FIG.jpg?csf=1&web=1&e=hvfavw)|
  |[Xiaomi8](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/xiaomi/jpg?csf=1&web=1&e=6GQP0k)|[Xiaomi8](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/ublox/jpg?csf=1&web=1&e=bYF5FJ)|[Xiaomi8](https://connectpolyu-my.sharepoint.com/:u:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/MK/Xiaomi8/MK_result_xiaomi.mat?csf=1&web=1&e=o5O3Yr)|
  |[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/TST/novatel/jpg?csf=1&web=1&e=vF96Nb)|[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/WP/novatel/jpg?csf=1&web=1&e=Ifpdfl)|[Novatel](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/MK/Novatel/MK_result_novatel.jpg?csf=1&web=1&e=LvmXFD)|
  
- PCA Result
  |Novatel|Ublox|Xiaomi8|
  |-------|-----|------|
  |[Novatel](https://connectpolyu-my.sharepoint.com/personal/18081447d_connect_polyu_hk/_layouts/15/onedrive.aspx?FolderCTID=0x0120004465C1649728174A96AAB6738BA8A0D8&id=%2Fpersonal%2F18081447d%5Fconnect%5Fpolyu%5Fhk%2FDocuments%2FFYP%5FALL%2FGitHub%2FLabelling%20results%2Fnovatel)|[Ublox](https://connectpolyu-my.sharepoint.com/personal/18081447d_connect_polyu_hk/_layouts/15/onedrive.aspx?FolderCTID=0x0120004465C1649728174A96AAB6738BA8A0D8&id=%2Fpersonal%2F18081447d%5Fconnect%5Fpolyu%5Fhk%2FDocuments%2FFYP%5FALL%2FGitHub%2FLabelling%20results%2Fublox)|[Xiaomi8](https://connectpolyu-my.sharepoint.com/personal/18081447d_connect_polyu_hk/_layouts/15/onedrive.aspx?FolderCTID=0x0120004465C1649728174A96AAB6738BA8A0D8&id=%2Fpersonal%2F18081447d%5Fconnect%5Fpolyu%5Fhk%2FDocuments%2FFYP%5FALL%2FGitHub%2FLabelling%20results%2Fxiaomi)|

- Updated labelling result
  |TST|WP|MK|KLB|
  |-------|-----|------|------|
  |[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/tst/novatel?csf=1&web=1&e=V4dkaW)|[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/wp/novatel?csf=1&web=1&e=c70YYF)|[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/wp/novatel?csf=1&web=1&e=zmc8Eb)|[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/klb/Novatel?csf=1&web=1&e=AMbr9i)|
  |[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/tst/ublox?csf=1&web=1&e=j7cDqk)|[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/wp/ublox?csf=1&web=1&e=JcX8N7)|[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/mk/ublox?csf=1&web=1&e=Gnbn5Q)|[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/klb/ublox?csf=1&web=1&e=iiKSgd)|
  |[Xiaomi](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/tst/xiaomi?csf=1&web=1&e=vPzjca)|[Xiaomi](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/wp/xiaomi?csf=1&web=1&e=Z5slda)|[Xiaomi](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/mk/xiaomi?csf=1&web=1&e=gmWScD)|[Xiaomi](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/updated%20result/klb/xiaomi?csf=1&web=1&e=Ba5k1X)|
## 2. New dataset (KLT):
- Links:[Rinex File](https://www.dropbox.com/sh/7iag71h9sfn8f01/AAAlzaqvg50z1axRW_LzRgLaa?dl=0), [Ground Truth](https://www.dropbox.com/sh/8rhqsumsgfjrzzt/AACSaSfBrgEWHePB1RBxDUpXa?dl=0), [IMU data](https://www.dropbox.com/s/oan55icug5y9bw3/1203imudata.csv?dl=0), [Skymask](https://www.dropbox.com/s/rynyv2k6dwdvu3m/KLB.csv?dl=0)
- [Package from Patrick](https://github.com/ZhengdaoLI0602/FYP/releases/tag/Labelling_v4) , [GH's Supplement](https://github.com/ZhengdaoLI0602/FYP/releases/tag/KLT_Dataset_Supplement)
- Results
  |Results|Maps|
  |---|---|
  |[Ublox](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/Ublox?csf=1&web=1&e=y0WzG1)|[Ublox](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/Ublox/KLT_ublox.jpg?csf=1&web=1&e=YTNpLh)|
  |[Xiaomi8](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/xiaomi?csf=1&web=1&e=Loh4fM)|[Xiaomi8](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/xiaomi/klt_xiaomi_result.jpg?csf=1&web=1&e=qKiQ1B)|
  |[Novatel](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/Novatel?csf=1&web=1&e=pt1JXl)|[Novatel](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/Novatel/KLT_Novatel.jpg?csf=1&web=1&e=fcd18f)|
  |[Samsung](https://connectpolyu-my.sharepoint.com/:f:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/Samsung?csf=1&web=1&e=EEv7ka)|[Samsung](https://connectpolyu-my.sharepoint.com/:i:/r/personal/18081447d_connect_polyu_hk/Documents/FYP_ALL/GitHub/Labelling%20results/KLT/Samsung/klt_samsung_result.jpg?csf=1&web=1&e=QOUBKq)|


## 3. FGO Results:
- [INS estimation by Nancy](https://connectpolyu-my.sharepoint.com/personal/18081447d_connect_polyu_hk/_layouts/15/onedrive.aspx?csf=1&web=1&e=PZmXHk&cid=17f1415a%2D6dad%2D4cc1%2D8401%2De5830ce9a36d&id=%2Fpersonal%2F18081447d%5Fconnect%5Fpolyu%5Fhk%2FDocuments%2FFYP%5FALL%2FGitHub%2FINS&FolderCTID=0x0120004465C1649728174A96AAB6738BA8A0D8)
- [INS estimation by Patrick](https://github.com/ZhengdaoLI0602/FYP/releases/tag/FGO_INS_by_Patrick)
