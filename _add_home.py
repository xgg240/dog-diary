#!/usr/bin/env python3
"""加 home_safety 详细数据"""
import json

PATH = '/Users/xiaochib/Desktop/养狗日记源码/assets/data/home_safety.json'
d = json.load(open(PATH))

# 1. toxic_plants 加 20+ 种
existing_toxic = {p['name_zh'] for p in d['toxic_plants']}
NEW_TOXIC = [
  {"name_zh": "百合 (Lilium)", "latin": "Lilium spp.", "toxicity": "high", "part": "全株(花粉都危险, 猫), 狗相对轻", "symptoms": "猫: 急性肾衰. 狗: 呕吐, 腹泻, 嗜睡", "note": "猫绝对禁忌, 百合花粉致命. 狗相对耐受但仍需避免"},
  {"name_zh": "滴水观音/海芋", "latin": "Alocasia", "toxicity": "high", "part": "全株含草酸钙针晶", "symptoms": "口腔灼痛, 肿胀, 流涎, 吞咽困难, 呕吐", "note": "汁液入眼致角膜损伤"},
  {"name_zh": "绿萝", "latin": "Epipremnum aureum", "toxicity": "medium", "part": "叶/茎", "symptoms": "口腔刺激, 流涎, 呕吐, 吞咽困难", "note": "草酸钙针晶, 咬碎后释放"},
  {"name_zh": "龟背竹", "latin": "Monstera deliciosa", "toxicity": "medium", "part": "全株", "symptoms": "口腔刺激, 呕吐, 流涎", "note": "草酸钙"},
  {"name_zh": "万年青", "latin": "Rohdea japonica", "toxicity": "high", "part": "全株", "symptoms": "口腔/咽喉肿痛, 恶心, 呕吐, 心律不齐", "note": "强心苷类"},
  {"name_zh": "夹竹桃", "latin": "Nerium oleander", "toxicity": "very_high", "part": "全株 (干枝也有毒)", "symptoms": "心律失常, 呕吐, 腹泻, 虚弱, 死亡", "note": "强心苷, 几片叶即可致命"},
  {"name_zh": "杜鹃花/映山红", "latin": "Rhododendron", "toxicity": "high", "part": "全株 (花蜜也含)", "symptoms": "流涎, 呕吐, 腹泻, 心衰", "note": "梫木毒素 grayanotoxin"},
  {"name_zh": "水仙花", "latin": "Narcissus", "toxicity": "high", "part": "鳞茎最毒, 叶/花也有", "symptoms": "呕吐, 腹泻, 心律失常, 低血压", "note": "石蒜碱 lycorine"},
  {"name_zh": "风信子", "latin": "Hyacinthus", "toxicity": "medium", "part": "鳞茎", "symptoms": "流涎, 呕吐, 腹泻, 皮肤过敏", "note": "石蒜碱"},
  {"name_zh": "郁金香/芍药", "latin": "Tulipa", "toxicity": "medium", "part": "球茎", "symptoms": "口腔刺激, 流涎, 呕吐", "note": "郁金香苷 A"},
  {"name_zh": "仙客来", "latin": "Cyclamen", "toxicity": "high", "part": "块茎最毒", "symptoms": "呕吐, 腹泻, 心律失常", "note": "番红花苷"},
  {"name_zh": "秋海棠", "latin": "Begonia", "toxicity": "medium", "part": "块茎/叶", "symptoms": "口腔灼热, 呕吐", "note": "草酸盐"},
  {"name_zh": "一品红", "latin": "Euphorbia pulcherrima", "toxicity": "low", "part": "乳汁/叶", "symptoms": "口腔/胃刺激, 呕吐, 腹泻", "note": "实际毒性低, 但乳汁刺激"},
  {"name_zh": "马蹄莲", "latin": "Zantedeschia", "toxicity": "medium", "part": "全株", "symptoms": "口腔灼痛, 肿胀, 呕吐", "note": "草酸钙针晶"},
  {"name_zh": "飞燕草", "latin": "Consolida", "toxicity": "high", "part": "种子/全株", "symptoms": "虚弱, 肌肉抽搐, 心律失常", "note": "二萜类生物碱"},
  {"name_zh": "毛茛", "latin": "Ranunculus", "toxicity": "medium", "part": "全株", "symptoms": "口腔/胃肠道刺激, 出血", "note": "原白头翁素, 干草毒性减"},
  {"name_zh": "鸢尾/马兰", "latin": "Iris", "toxicity": "medium", "part": "根茎/叶", "symptoms": "流涎, 呕吐, 腹泻, 皮肤刺激", "note": "鸢尾苷"},
  {"name_zh": "金莲花", "latin": "Tropaeolum", "toxicity": "low", "part": "全株", "symptoms": "轻度胃肠不适", "note": "辣味, 一般不主动食"},
  {"name_zh": "紫藤", "latin": "Wisteria", "toxicity": "medium", "part": "种子/豆荚", "symptoms": "呕吐, 腹泻, 脱水", "note": "紫藤苷"},
  {"name_zh": "蓖麻", "latin": "Ricinus communis", "toxicity": "very_high", "part": "种子 (1-2 粒可致命小型犬)", "symptoms": "严重呕吐, 腹泻, 抽搐, 死亡", "note": "蓖麻毒素, 极危险"},
  {"name_zh": "常春藤 (English Ivy)", "latin": "Hedera helix", "toxicity": "medium", "part": "叶/果", "symptoms": "流涎, 呕吐, 腹泻, 皮疹", "note": "常春藤皂苷"},
  {"name_zh": "桑叶/桑椹", "latin": "Morus alba", "toxicity": "low", "part": "未熟果/叶", "symptoms": "轻度胃肠不适", "note": "成熟桑椹少量无害"},
  {"name_zh": "龙葵/茄科杂草", "latin": "Solanum nigrum", "toxicity": "high", "part": "未熟果/叶", "symptoms": "流涎, 呕吐, 腹泻, 嗜睡, 心律异常", "note": "茄碱, 未熟果高毒"},
]
added = 0
for p in NEW_TOXIC:
    if p['name_zh'] not in existing_toxic:
        d['toxic_plants'].append(p)
        existing_toxic.add(p['name_zh'])
        added += 1
print(f"toxic_plants 加 {added}, 总 {len(d['toxic_plants'])}")

# 2. pet_safe_plants 加 15+ 种
existing_safe = {p['name_zh'] for p in d['pet_safe_plants']}
NEW_SAFE = [
  {"name_zh": "棕竹/观音竹", "note": "✅ 安全. 室内观叶"},
  {"name_zh": "波士顿蕨", "note": "✅ 安全. 净化空气"},
  {"name_zh": "鸟巢蕨", "note": "✅ 安全. 热带蕨类"},
  {"name_zh": "鹿角蕨", "note": "✅ 安全. 独特造型"},
  {"name_zh": "吊兰", "note": "✅ 安全. 净化空气"},
  {"name_zh": "蜘蛛草/吊兰变种", "note": "✅ 安全. 易养"},
  {"name_zh": "非洲紫罗兰", "note": "✅ 安全. 开花"},
  {"name_zh": "蝴蝶兰", "note": "✅ 安全. 开花"},
  {"name_zh": "金钱树", "note": "✅ 安全. 室内观叶"},
  {"name_zh": "散尾葵", "note": "✅ 安全. 净化空气"},
  {"name_zh": "夏威夷椰子/袖珍椰子", "note": "✅ 安全. 室内"},
  {"name_zh": "山乌龟/地不容", "note": "✅ 安全. 块根观叶"},
  {"name_zh": "彩叶芋", "note": "⚠️ 草酸钙, 中等刺激, 实际低毒但避免咬食"},
  {"name_zh": "紫罗兰 (African Violet)", "note": "✅ 安全. 开花"},
  {"name_zh": "口红花", "note": "✅ 安全. 垂吊开花"},
  {"name_zh": "海角樱草", "note": "✅ 安全"},
  {"name_zh": "蓝星花", "note": "✅ 安全"},
  {"name_zh": "罗勒/九层塔", "note": "✅ 安全. 香草"},
  {"name_zh": "迷迭香", "note": "✅ 安全. 香草"},
  {"name_zh": "薄荷", "note": "✅ 安全. 适量"},
  {"name_zh": "猫薄荷", "note": "✅ 安全. 狗也能玩"},
  {"name_zh": "薰衣草", "note": "✅ 安全. 适量"},
  {"name_zh": "向日葵 (观赏)", "note": "✅ 安全. 种子少量可"},
  {"name_zh": "雏菊", "note": "✅ 安全"},
  {"name_zh": "玫瑰", "note": "✅ 安全 (无刺). 月季同理"},
]
added = 0
for p in NEW_SAFE:
    if p['name_zh'] not in existing_safe:
        d['pet_safe_plants'].append(p)
        existing_safe.add(p['name_zh'])
        added += 1
print(f"pet_safe_plants 加 {added}, 总 {len(d['pet_safe_plants'])}")

# 3. household_chemicals 详细化
d['household_chemicals'] = {
  "title": "家用化学品危险清单",
  "items": [
    {"name": "防冻剂 (乙二醇)", "danger": "very_high", "note": "有甜味, 犬主动喝. 4ml/kg 即可致命肾衰. 严防溅洒"},
    {"name": "漂白水/次氯酸钠", "danger": "high", "note": "强刺激. 误饮烧灼口/胃. 用清水稀释, 不可催吐"},
    {"name": "地板清洁剂", "danger": "medium", "note": "腐蚀性, 晾干后放回. 防舔地板"},
    {"name": "消毒酒精 (70%)", "danger": "medium", "note": "误饮致酒精中毒. 外用避免舔舐"},
    {"name": "洗衣液/凝珠", "danger": "high", "note": "色彩鲜艳, 犬误食. 致呕吐, 严重化学烧伤"},
    {"name": "洗洁精", "danger": "low", "note": "刺激胃肠, 致呕吐. 一般不致命"},
    {"name": "驱虫剂 (菊酯类/有机磷)", "danger": "very_high", "note": "家用喷雾/蚊香. 误食或长期暴露致神经症状. 用宠物专用"},
    {"name": "杀鼠剂/抗凝血毒", "danger": "very_high", "note": "误食致内出血. 2-5天出血症状. 维 K1 解毒"},
    {"name": "杀蟑螂/蚂蚁饵", "danger": "high", "note": "硼酸/氟蚁腙. 误食致胃肠/神经症状"},
    {"name": "园艺肥料", "danger": "medium", "note": "含氮磷钾+杀虫剂. 致胃肠, 严重肾衰"},
    {"name": "汽车防冻液/冷却液", "danger": "very_high", "note": "乙二醇. 甜味. 4ml/kg 致命"},
    {"name": "锂电池 (纽扣电池)", "danger": "very_high", "note": "误食致化学烧伤 + 重金属中毒. 1-2h 内窥镜取出"},
    {"name": "烟草/电子烟液", "danger": "high", "note": "尼古丁 9-12mg/kg 致命. 烟蒂浸泡水也危险"},
    {"name": "大麻/CBD 产品", "danger": "high", "note": "THC 中枢抑制. 犬比人敏感 3-5 倍. 共济失调/嗜睡"},
    {"name": "精油/扩香器", "danger": "medium", "note": "茶树/薄荷/冬青/柑橘油对犬有肝毒. 避免扩散器"},
    {"name": "油漆/涂料/稀释剂", "danger": "high", "note": "VOC 刺激呼吸道. 未干涂料勿让犬接触"},
    {"name": "处方药 (人用)", "danger": "very_high", "note": "对乙酰氨基酚/布洛芬/抗抑郁药/降压药等极易致死. 严格保管"},
    {"name": "塑料袋/绳类", "danger": "medium", "note": "误食致肠梗阻. 玩时监督, 用完收好"},
  ]
}

# 4. small_object_hazards 详细化
d['small_object_hazards'] = {
  "title": "小物件危险清单 (易误食)",
  "items": [
    {"name": "硬币 (含锌)", "danger": "high", "note": "胃酸溶锌, 致锌中毒溶血. 1 元以上硬币 >2cm 通常不卡"},
    {"name": "纽扣电池", "danger": "very_high", "note": "急诊! 1-2h 内窥镜取出. 烧穿食管/胃壁"},
    {"name": "磁铁 (尤其钕磁铁)", "danger": "very_high", "note": "多颗吸附, 致肠穿孔. 高磁场力"},
    {"name": "弹珠/玻璃球", "danger": "high", "note": "卡食管/肠. 需 X 光定位"},
    {"name": "橡皮筋/发圈", "danger": "medium", "note": "误食致线性异物, 切肠"},
    {"name": "毛线团/线绳", "danger": "high", "note": "舌下挂住, 切肠 (锯齿状). 危险! 不要让玩"},
    {"name": "塑料包装/锡纸", "danger": "medium", "note": "尖锐致穿孔, 锡纸金属"},
    {"name": "宠物小玩具零件", "danger": "high", "note": "眼/铃/小球咬下吞. 选整件不可拆卸"},
    {"name": "袜子/内衣", "danger": "high", "note": "布类线性异物, 切肠高发. 训练不玩"},
    {"name": "玉米芯/桃核/李核", "danger": "high", "note": "阻塞/穿孔. 啃咬后吞入"},
    {"name": "棉花/化妆棉", "danger": "low", "note": "一般可排出, 但量大可能梗阻"},
    {"name": "头发/丝线", "danger": "low", "note": "少量可排出, 大量+其他异物可能缠结"},
    {"name": "铅笔/圆珠笔", "danger": "low", "note": "石墨/油墨低毒, 但尖端穿肠. 大部分可自然排出"},
    {"name": "钉子/针", "danger": "very_high", "note": "尖锐! X 光定位 + 立即手术"},
    {"name": "鱼钩", "danger": "very_high", "note": "带倒钩! 极危险, 立即兽医处理"},
  ]
}

# 5. home_dangers 详细化
d['home_dangers'] = {
  "title": "家庭环境危险点",
  "areas": [
    {"area": "厨房", "risks": ["炉灶 (热油溅)", "刀叉未收", "垃圾袋 (骨头/巧克力/洋葱/葡萄/木糖醇)", "洗碗机 (干燥剂)", "垃圾桶盖未关"], "fix": "垃圾桶带锁, 刀具收纳, 烹饪时禁狗入厨"},
    {"area": "浴室", "risks": ["浴缸水 (溺水)", "马桶水 (含清洁剂)", "药品柜 (布洛芬/对乙酰氨基酚)", "剃须刀/刀片", "肥皂/洗发水"], "fix": "马桶盖常闭, 药品高处锁, 浴室门关"},
    {"area": "客厅", "risks": ["电线咬破 (触电)", "小物件掉落 (电池/硬币)", "沙发缝隙 (卡)", "落地窗/玻璃门 (撞)", "毛线球/绳类"], "fix": "电线收纳, 玻璃贴防撞条, 玩具有监督"},
    {"area": "卧室", "risks": ["床底暗藏异物", "衣袜 (线性异物)", "化妆品 (精油/香水)", "电热毯/暖宝宝 (低温烫伤)", "首饰 (吞)"], "fix": "床底定期检查, 衣物收纳, 化妆品高处"},
    {"area": "阳台/院子", "risks": ["高坠 (无防护网)", "有毒植物 (百合/夹竹桃)", "鸟池/水缸 (溺水)", "工具/钉子", "草籽/肥料"], "fix": "阳台全封闭, 植物清单核实, 工具锁"},
    {"area": "车库", "risks": ["防冻液 (甜味致命)", "汽车电池液", "机油", "油漆稀释剂", "工具/钉子"], "fix": "车库门常闭, 化学品锁柜, 工具收纳"},
    {"area": "楼梯", "risks": ["腊肠/柯基等短腿长身易摔伤椎间盘", "幼犬摔下", "老犬滑倒"], "fix": "防滑垫, 短腿犬上下楼抱"},
    {"area": "圣诞/节日", "risks": ["装饰彩带 (线性异物)", "圣诞树水 (防腐剂)", "蜡烛 (烫伤/烧)", "彩球/小装饰 (吞)"], "fix": "装饰用大件, 树水盖, 蜡烛人看管"},
  ]
}

# 6. seasonal_hazards 详细化
d['seasonal_hazards'] = {
  "title": "季节性危险",
  "seasons": [
    {"season": "春", "risks": ["花粉过敏", "跳蚤蜱虫活跃", "杀鼠剂 (田园)", "草坪化学剂", "繁殖期猫狗攻击性", "发情走失"], "fix": "防虫滴剂, 遛狗牵绳, 避开新施药草坪"},
    {"season": "夏", "risks": ["中暑 (短鼻/老年/幼犬高发)", "热沥青烫脚垫", "游泳溺水/水毒", "车中热死", "雷暴恐惧", "跳蚤蜱高峰", "冰棍棒/雪糕棍 (木屑)"], "fix": "早晚遛, 阴凉, 凉垫, 绝不关车内, 防虫"},
    {"season": "秋", "risks": ["落叶堆 (霉菌/细菌)", "橡子/栗子 (阻塞)", "减毛/洗澡不当致感冒", "新学期寄养焦虑"], "fix": "避开落叶堆, 慢慢加衣, 适应分离"},
    {"season": "冬", "risks": ["低温/冰冻 (短毛小型犬)", "冰/雪盐 (脚垫刺激/中毒)", "防冻液", "暖炉烫伤", "圣诞装饰 (彩带/树水)", "干冷皮肤 (静电)"], "fix": "穿衣, 脚掌护肤, 防冻液锁, 暖炉围栏, 树水盖"},
  ]
}

# 7. safety_checklist 详细化
d['safety_checklist'] = {
  "title": "新家养犬安全检查清单",
  "before_dog_arrives": [
    "封阳台/院子防高坠",
    "电线收纳 + 防咬套",
    "垃圾桶带锁 (厨房/卫生间)",
    "马桶盖常闭",
    "有毒植物清单核查 + 移出",
    "药品/化学品高处锁",
    "小物件 (纽扣电池/硬币/磁铁/橡皮筋) 收纳",
    "防冻液/机油等车库物品锁",
    "安装围栏限制危险区域",
    "准备急救包: 纱布/生理盐水/双氧水(小伤口)/伊丽莎白圈/冰袋",
  ],
  "first_week": [
    "熟悉环境, 标出安全区/危险区",
    "藏好所有电线 + 插电板防护",
    "床边/沙发下检查, 移除异物",
    "垃圾桶上锁 (第一天就教)",
    "测试警报器 (烟雾/CO), 避免噪音恐惧",
    "急救电话 (兽医/急救中心) 记手边",
  ],
  "ongoing": [
    "每天检查院子有无新掉落物",
    "每月检查玩具破损",
    "每 3 月检查防虫滴剂有效期",
    "季节性更换防护 (夏季冰垫/冬季穿衣)",
    "出游前预查目的地安全 (毒草池/家畜/路)",
  ]
}

# 8. human_food_recap 详细化
d['human_food_recap'] = {
  "title": "人类食物禁忌快速对照 (Top 10)",
  "items": [
    {"food": "巧克力", "danger": "中毒剂量 60mg/kg (牛奶巧克力 500g, 烘焙黑巧 60g)", "symptom": "呕吐, 心律失常, 抽搐"},
    {"food": "葡萄/葡萄干", "danger": "极小量致肾衰, 不明阈值", "symptom": "呕吐, 急性肾衰"},
    {"food": "洋葱/大蒜/葱", "danger": "任意量累积中毒", "symptom": "溶血性贫血"},
    {"food": "木糖醇", "danger": "0.1g/kg 低血糖, 0.5g/kg 肝衰", "symptom": "低血糖, 急性肝衰"},
    {"food": "咖啡因/茶/咖啡", "danger": "咖啡因 9-12mg/kg 中毒", "symptom": "心率异常, 抽搐"},
    {"food": "酒精", "danger": "极小剂量中毒", "symptom": "昏迷, 呼吸抑制"},
    {"food": "牛油果 (狗)", "danger": "Persin 毒素, 量大中毒", "symptom": "呕吐, 呼吸困难"},
    {"food": "澳洲坚果", "danger": "少量致共济失调", "symptom": "虚弱, 呕吐, 走路摇晃"},
    {"food": "生面团 (含酵母)", "danger": "胃内发酵膨胀", "symptom": "胃扩张, 酒精中毒"},
    {"food": "鸡骨/鱼骨 (煮熟)", "danger": "尖锐碎片", "symptom": "胃肠穿孔"},
  ]
}

d['last_updated'] = '2026-06-05'
json.dump(d, open(PATH, 'w'), ensure_ascii=False, indent=2)
print('OK home_safety')
