# シュッ席 -入館管理アプリ

Flutter & Firebase 製の入館管理アプリ

- [iOS 版 App Store リンク](https://apps.apple.com/jp/app/id1620188388)
- [Android 版 Google Play Store リンク](https://play.google.com/store/apps/details?id=com.app.attendance_management_app)

## Screenshots

| QR コード入館                                                                                                                       | 出席管理                                                                                                                            | メンバー管理                                                                                                                        |
| ----------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| ![iphone13.004.jpeg](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/1631114/910ac0b9-6c61-47d6-44f8-387ec686750c.jpeg) | ![iphone13.006.jpeg](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/1631114/c7cd05a9-264a-5fa7-ae5a-de681394a723.jpeg) | ![iphone13.005.jpeg](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/1631114/6f1bf517-9722-724c-1db0-1f69398e80df.jpeg) |

## Show Summary

[Qiita アプリ詳細](https://qiita.com/utasan_com/items/8024b860191dd69fdcc6)

## Functions

- 認証機能 (Firebase Authentication)
- `Provider`, `ChangeNotifier` を用いた状態管理
- ユーザ編集・削除
- QR コード読み込み
- 入館管理・絞り込み
- メンバー管理・絞り込み（Flutter の Stream を用いたお気に入りステイタスの監視を含む）
- 団体の編集・削除

## Code

アプリを構成する主なコードは[student_attendance_app/lib](https://github.com/secretused/student_attendance_app/tree/main/lib)以下に配置されています。

## Terms of Service & Privacy Policy

[Qiita 利用規約・プライバシーポリシー
](https://qiita.com/utasan_com/private/ffebc0e73b8bae704306)
