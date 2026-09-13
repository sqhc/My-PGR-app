# 图片投放目录

把待入库的原图放进这个目录,文件名必须等于 `GameData.json` 里的 `image` 字段值。

```
_incoming_images/LuciaOrion.png
_incoming_images/GrayRaven.png
_incoming_images/Karenina.jpg
```

然后运行:

```bash
python3 Scripts/build_imagesets.py          # 生成 imageset 并写入 Assets.xcassets
python3 Scripts/build_imagesets.py --check  # 只看还缺哪些,不改动文件
```

脚本会按 `<键名>.imageset/<键名>.<扩展名>` + `Contents.json` 生成合法图集,并报告
「需要的键 vs 就位的键」差集。生成后把新图集加入 Xcode 的 Assets.xcassets(嵌套
catalog 通常会自动纳入),再跑一次单元测试确认 `testEveryCatalogueImageResolves` 通过。

支持格式:png / jpg / jpeg / heic / webp。
目录本身不入库,填报完即可清空。
