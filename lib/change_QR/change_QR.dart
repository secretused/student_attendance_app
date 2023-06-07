import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../edit_community/edit_community.dart';
import '../setting.dart';
import 'change_QR_model.dart';

class ChangeQRCode extends ConsumerWidget {
  final navigation = const NavigationSettings();

  String? gotCommunity;
  ChangeQRCode(String? community) {
    gotCommunity = community;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrChangeModel = ref.watch(qrChangeModelProvider);
    qrChangeModel.setCommunity(gotCommunity);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '団体情報',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 67, 176, 190),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              Navigator.push(
                context,
                navigation.navigationFade(EditCommunityPage(
                    qrChangeModel.communityName!,
                    qrChangeModel.department!,
                    qrChangeModel.email!,
                    qrChangeModel.phoneNumber!,
                    qrChangeModel.link!,
                    qrChangeModel.qrLink!)),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Column(
                      children: [
                        Text(
                          qrChangeModel.communityName ?? "名前なし",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  (qrChangeModel.department != "")
                      ? Column(
                          children: [
                            Text("${qrChangeModel.department}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.5,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (qrChangeModel.email != "")
                      ? Column(
                          children: [
                            const Text(
                              "メールアドレス",
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${qrChangeModel.email}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (qrChangeModel.phoneNumber != "0")
                      ? Column(
                          children: [
                            const Text(
                              "電話番号",
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${qrChangeModel.phoneNumber}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (qrChangeModel.link != "")
                      ? Column(
                          children: [
                            const Text(
                              "関連リンク",
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${qrChangeModel.link}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (qrChangeModel.qrLink != "")
                      ? Column(
                          children: [
                            const Text(
                              "QRLink",
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${qrChangeModel.qrLink}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            if (qrChangeModel.isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
