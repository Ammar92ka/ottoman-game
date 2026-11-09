import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const OttomanApp());

class OttomanApp extends StatelessWidget {
  const OttomanApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0F1F3D), colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC9A227), brightness: Brightness.dark)),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double treasury = 12000;
  double debt = 0;
  int sultan = 65;
  int stability = 63;
  double grain = 12;
  int month = 1;
  int eventIndex = 0;
  List<String> history = [];
  String provider = 'Gemini';

  final events = [
    {
      'title': 'أزمة خراج بغداد',
      'place': 'إسطنبول - الباب العالي',
      'scene': 'كانت القاعة هادئة. على طاولتك خارطة كبيرة للإمبراطورية، من البوسنة إلى بغداد. دخل الصدر الأعظم ووضع رسالة مختومة أمامك.',
      'dilemma': 'رسالة من بغداد: الوالي يقول إن الضريبة لم تجمع. التجار أغلقوا دكاكينهم. يجب أن تقرر: هل تكمل طريق النظام الجديد، أم تتراجع خطوة؟',
      'choices': [
        {'t': 'أكمل بناء الجيش الجديد', 'r': 'تم تمويل الجيش. زادت قوته، لكن غضب الإنكشارية ارتفع. الخزينة نقصت ورضا السلطان ارتفع.', 'treasury': -800, 'sultan': 6, 'stability': -2, 'grain': 2},
        {'t': 'أوقف الضريبة وأتفاوض', 'r': 'هدأت بغداد. فتح التجار دكاكينهم. لكن الجيش تأخر والسلطان تساءل عن حزمك.', 'treasury': -200, 'sultan': -4, 'stability': 4, 'grain': -2},
        {'t': 'أرسل مفتشا سريا لبغداد', 'r': 'عاد المفتش بتقرير: الفساد أكبر من الرفض الشعبي. الملتزمون يأخذون ضعف ما يجب.', 'treasury': -150, 'sultan': 5, 'stability': 3, 'grain': 0},
      ]
    },
    {
      'title': 'أزمة الإنكشارية',
      'place': 'إسطنبول - قاعة الديوان',
      'scene': 'دخل قائد الإنكشارية دون استئذان ووقف وسط القاعة. ساد الصمت.',
      'dilemma': 'قال: جنودي لم يتقاضوا رواتبهم منذ 3 أشهر. بينما جنود النظام الجديد يتقاضون رواتبهم كاملة. فهل هذا عدل؟',
      'choices': [
        {'t': 'أصرف رواتبهم فورا', 'r': 'تم صرف الرواتب. خرج الجنود راضين. لكن الخزينة نقصت كثيرا.', 'treasury': -900, 'sultan': -2, 'stability': 4, 'grain': 1},
        {'t': 'أرفض وأؤكد النظام الجديد', 'r': 'غضب القائد وخرج. انتشرت الشائعات في المقاهي. السلطان احترم حزمك.', 'treasury': 0, 'sultan': 7, 'stability': -6, 'grain': 3},
        {'t': 'أدعوهم لإصلاح داخل الإنكشارية', 'r': 'وافق الضباط الشباب على التدريب الجديد. بدأ مشروع دمج طويل يمنع الصدام.', 'treasury': -400, 'sultan': 3, 'stability': 3, 'grain': 0},
      ]
    },
    {
      'title': 'مصر بعد الفرنسيين',
      'place': 'مصر - القاهرة',
      'scene': 'وصلت رسالة من مصر. الفرنسيون خرجوا، لكن مصر متعبة. المماليك يتصارعون والفلاحون بلا بذور.',
      'dilemma': 'إذا لم ترسل واليا قويا ومالا، ستضيع مصر. ومصر هي سلة خبز الإمبراطورية. لكن الخزينة لا تكفي للجهتين.',
      'choices': [
        {'t': 'أرسل كل المال لمصر', 'r': 'وصل المال لمصر وعاد الأمن نسبيا. لكن حدود الشمال صارت مكشوفة.', 'treasury': -1200, 'sultan': 2, 'stability': 2, 'grain': -4},
        {'t': 'أركز على إسطنبول والبلقان', 'r': 'حماية العاصمة صارت أقوى. لكن مصر بدأت تبتعد.', 'treasury': 0, 'sultan': -6, 'stability': -4, 'grain': 5},
        {'t': 'أرسل محمد علي باشا', 'r': 'هذا هو الخيار التاريخي الحقيقي. محمد علي نظم الجيش وجمع الضرائب.', 'treasury': -600, 'sultan': 8, 'stability': 5, 'grain': -2},
      ]
    },
  ];

  void choose(Map<String, dynamic> c) {
    setState(() {
      treasury += (c['treasury'] as num).toDouble();
      sultan = (sultan + (c['sultan'] as int)).clamp(0, 100);
      stability = (stability + (c['stability'] as int)).clamp(0, 100);
      grain = (grain + (c['grain'] as num).toDouble()).clamp(5, 60);
      if (treasury < 0) { debt += -treasury + 500; treasury = 200; }
      debt = debt + debt * 0.04;
      month++;
      eventIndex++;
      history.add(c['t']);
    });
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('النتيجة'),
      content: Text('${c['r']}\n\nالخزينة الآن: ${treasury.toStringAsFixed(0)}\nالدين: ${debt.toStringAsFixed(0)}\nسعر الحبوب: ${grain.toStringAsFixed(1)}'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('متابعة'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final e = events[eventIndex % events.length];
    return Scaffold(
      appBar: AppBar(title: Text('كانون الثاني 1800 - الشهر $month')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Wrap(spacing: 8, runSpacing: 8, children: [
          Chip(label: Text('الخزينة: ${treasury.toStringAsFixed(0)}')),
          Chip(label: Text('الديون - القروض: ${debt.toStringAsFixed(0)}')),
          Chip(label: Text('رضا السلطان: $sultan / 100')),
          Chip(label: Text('الاستقرار: $stability')),
          Chip(label: Text('سعر الحبوب: ${grain.toStringAsFixed(1)}')),
          Chip(label: Text('المزود: $provider')),
        ]),
        const SizedBox(height: 12),
        Text(e['title'] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFC9A227))),
        Text(e['place'] as String, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 12),
        const Text('المشهد', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC9A227))),
        Text(e['scene'] as String, style: const TextStyle(height: 1.7)),
        const SizedBox(height: 12),
        const Text('المعضلة', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC9A227))),
        Text(e['dilemma'] as String, style: const TextStyle(height: 1.7)),
        const SizedBox(height: 16),
        ...(e['choices'] as List).map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.all(14)),
            onPressed: () => choose(c),
            child: Text(c['t'], textAlign: TextAlign.right),
          ),
        )),
        const SizedBox(height: 16),
        Row(children: [
          ElevatedButton(onPressed: () async {
            final p = await SharedPreferences.getInstance();
            await p.setDouble('treasury', treasury);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحفظ محليا')));
          }, child: const Text('حفظ محلي')),
          const SizedBox(width: 10),
          OutlinedButton(onPressed: () {
            showDialog(context: context, builder: (_) => AlertDialog(
              title: const Text('المزودات'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(title: const Text('Gemini - الأساسي'), onTap: () { setState(() => provider = 'Gemini'); Navigator.pop(context); }),
                ListTile(title: const Text('Groq'), onTap: () { setState(() => provider = 'Groq'); Navigator.pop(context); }),
                ListTile(title: const Text('Llama'), onTap: () { setState(() => provider = 'Llama'); Navigator.pop(context); }),
                ListTile(title: const Text('مخصص'), onTap: () { setState(() => provider = 'مخصص'); Navigator.pop(context); }),
              ]),
            ));
          }, child: Text('المزود: $provider')),
        ]),
        const SizedBox(height: 12),
        const Text('سجل القرارات', style: TextStyle(fontWeight: FontWeight.bold)),
        ...history.map((h) => Text('• $h', style: const TextStyle(color: Colors.white70))),
      ]),
    );
  }
}
