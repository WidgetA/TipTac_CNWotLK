# TipTac_CNWotLK
 Personal modified version

 Start From [TipTac Reborn v24.04.27](https://www.curseforge.com/wow/addons/tiptac-reborn)

# 修改原因
国服怀旧服目前插件接口的版本和海外插件接口版本不一致，导致海外 WLK 可用的插件无法在国服使用，或者有各种报错。

## Change Log
### 2025/3/27
- `EnumerateInactive` 接口在更新后被删除，重新手工实现并且注入 `pool` 的类，使得后面代码能够正常运行
- `GetMouseFocus()` 方法在更新后被换成了 `GetMouseFoci()`，检测为国服时替换为更新的方法