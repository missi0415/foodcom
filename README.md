# foodcom
Nuxtでsnsサイトを作っているのを教材等ではみたことがなかったので勉強のために作成しました。

## リンク
https://www.foodcom.work/

名前はFoodcomとしています。私が前職飲食店で飲食店の人達で交流するサイトって見かけたことが無いなと思い作成しました。


## 使用した技術
- フロントエンド
  - node.js 14.15
  - HTML/CSS
  - Javascript
  - Nuxt.js（SPAモード）
  - Vuetify（UIフレームワーク）
  - Jest（テスト）
  - ESLint/Prettier（コード解析ツール)
  - Firebase
    - Authentication(ログイン時の認証で使用)
    - Cloud Firestore database(個別のリアルタイムチャット導入時に使用)
- バックエンド
  - Ruby 2.7.1
  - Ruby on Rails 6.0.3 （APIモード）
  - RSpec（テスト）
- インフラ・開発環境
  - PC windows
  - OS Ubuntu-20.04
  - Docker version 20.10.7
  - AWS
    - ECR
    - ECS
    - VPC
    - S3
    - Route53
    - ALB
    - RDS(postgleSQL 12.5-R1)
    - ACM
  - CircleCI（CI/CD）
 
## 機能一覧
- 基本機能
  - 新規会員登録・ログイン機能
  - CRUD機能
  - コメントにコメントできる無限コメント機能
  - いいね機能
  - 検索機能
  - フォロー機能
  - ユーザー登録情報変更
  - ユーザー削除
  - リアルタイムチャット機能

## 工夫した点・苦労した点
- フロントエンド
  - Nuxt.jsを採用し、SPA（シングルページアプリケーション）で配信している点
    - Nuxt.jsは初めて触りましたし、javascript自体も余り触ったことがなかったので最初はrailsに単純なapi通信をするコードを書くだけでも苦労しました。
    - 所々でvuexの利用や、componentを分け親componentと子コンポーネント間のデータの受け渡しなどをvueのルールにのっとり使用しています。
  - UIフレームワークにVuetifyを使用し、整ったUIを意識している点
  - ログイン認証にfirebaseを使用している点
  - firestoreを利用しリアルタイムチャットを導入した点
    - firestoreのリアルタイムチャットはただ導入するのは参考記事が多く簡単でしたが、沢山の人と個別チャットができるようにするのは大変でした。  
  - 遅延ローディングを導入している点
    -  vue-infinite-loading を導入してすべてのデータを取ってくるのではなく下までスクロールしたら次のデータを取ってくる仕様にしました。
  - 検索機能でハイライトをつけている点
    - vue-text-highlight を使用し検索したときに検索したワードにハイライトがつくようにしています。
- バックエンド
  - Ruby on RailsのAPIモードを利用し、APIサーバーとしてフロントエンドからのリクエストに対してJSONデータを返している点
    -  Active Model Serializer を使用しjsonを形成しています。データを取得するのが遅いなと感じたりn+1問題が発生している場合は可能な部分は自身でjsonデータを形成しています。
  - コメントを無限にできるように設計した点
    - 投稿に対するコメントをツイッターの様な仕様にしたかったためロジックを変えて作成してみました。
- インフラ・開発環境
  - windows環境特有のエラーに対応した点
    - 教材等を扱うときもそうでしたが、mac環境じゃないと対応していなかったり、windows環境特有のエラーに苦労する事が多くありました。最初はmacを買うしか無いのか。。。と諦めることもありましたが単純に知識不足でPCを使いこなせていなかっただけでした。今ではそんなに変わりないかなと感じています。
  - Docker を使用している点
    - まだまだわからないことだらけですが、現在トレンドとされる技術ですのでとにかく使ってみたかったです。確かに環境を構築する上では楽でしたが、自身で全部ファイルを書けないので今後も勉強を続けたいと思います。
  - ECR・ECSを使用してデプロイしている点
    - docker環境はデプロイの記事が少なく非常に大変でした。ロードバランサーを使用したのですが、ヘルスチェックが通らず何日も悩みました。この悩んだ期間でawsについての知識が深まったと思います。

## ER図
![image](https://user-images.githubusercontent.com/76615633/135578066-63d255db-ecd2-471b-8c2d-22fae890fd4c.png)

## インフラ構成図

![image](https://user-images.githubusercontent.com/76615633/135578394-c10201d7-d9b8-4ba7-a203-cdafd8a631be.png)


