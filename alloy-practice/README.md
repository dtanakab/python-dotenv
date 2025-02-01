# Alloyによる形式検証の実習

## 検証対象のOSS
**python-dotenv**
- 環境変数の管理、設定のためのモジュール
- `.env` ファイルからキーと値のペアを読み取り、環境変数として設定する
- 公式リポジトリ: [python-dotenv GitHub](https://github.com/theskumar/python-dotenv)
- 公式ドキュメント: [PyPI - python-dotenv](https://pypi.org/project/python-dotenv/)

## 検証すべき性質
- 環境変数の展開が正しく処理される
  - `.env` ファイル内で `${VARIABLE}` の形式で定義された値が、他のキーで定義された値においても展開される
  - 環境変数の依存関係を正しく解決するために不可欠な性質
  - [公式ドキュメント](https://pypi.org/project/python-dotenv/#variable-expansion)においても、変数の展開仕様が明示されており、期待動作が定義されている

## モデル化
- `Environment`: `EnvVar`の集合としての環境
- `EnvVar`: 環境変数のキー (`Name`) と値 (`Value`) のペア
- `Name`: 環境変数のキーを表す抽象シグネチャ
- `Value`: 環境変数の値を表す抽象シグネチャ
- `RawValue`: 直接的な値を持つ環境変数
  - 例: `FOO=bar`
- `RefValue`: 他の変数を参照する環境変数
  - 例: `FOO=${BAR}`

## 検証手法
- 変数の展開時に参照先が環境内に存在する必要があるため、以下2つで本性質を表現した
  - `RawValue`の場合: そのまま値を返す。
  - `RefValue`の場合: `ref`先の`EnvVar`を検索し、適切に展開されることを保証
- ファイル内の変数展開が正しく展開されることの確認
  - `check CorrectResolution`