# Bl👀per - Search engine built with Dart/Flutter

## Description

Blooper is a search tool for a dataset of Farsi webpages and it consists of 3 separate parts:
- Indexer (Parses the dataset and generates an index of words)
- Server (Serves results for a query by using the generated index)
- Client (Asks the server to fetch results of a query given provided by the user and displays results)

Have a look at [Blooper Search.pptx](https://github.com/alikro2000/blooper_search/blob/master/Blooper%20Search.pptx) for more details.

## Try it out

### **Perequisites**

- Dart SDK with Flutter ([Installation Guide](https://docs.flutter.dev/get-started/install))
- An IDE (e.g., VS Code or Android Studio)

###  **Project set-up and run**

Go to your preffered directory via Terminal and clone the project (Git LFS tracks the dataset and presentation files).

```shell
git clone https://github.com/alikro2000/blooper_search
```

Unzip ```dataset.rar``` and save its contents (xml files) under ```blooper_indexer/dataset``` directory.

Running blooper_indexer generates files in two new directories; ```hive_database``` and ```page_repo```. This process takes some time depending on the device specs (about 33 minutes in some tests).

When finished, copy ```page_repo``` and ```hive_database_2``` folders from ```blooper_indexer``` to ```blooper_server``` and rename the second one to ```hive_database```. Then, run blooper_server; it loads the data and starts listening on localhost:3000. You can enter queries in your browser like below:

```
localhost:3000/?query=دانشگاه
localhost:3000/?query=دانشگاه تهران
localhost:3000/?query=دانشگاه AND تهران AND ابوریحان
localhost:3000/?query=دانشگاه OR پردیس
localhost:3000/?query=دانشگاه NOT مدیریت
```

The result is a JSON data showing the results of your query.

> The words "AND", "OR", "NOT" are controller terms and identify Set operations "intersection", "union", "difference" between actual query terms respectively. "term1 op1 term2 op2 term3" is processed like "(term1 op1 term2) op2 term3". Also, "term1 term2" is equivalent to "term1 AND term2".

Finally, run blooper_client to enter queries and check their results.

###  **Run commands**

blooper_indexer and blooper_server are Dart console apps. To run each of them, navigate to their directory and simply enter the following command in Terminal

```
dart run
```

blooper_client is a Flutter app. You need to have web support for Flutter enabled first in order to run it on your preffered browser ([more details](https://docs.flutter.dev/get-started/web)). Enter the command below in Terminal to run it on chrome:

```
flutter run -d chrome
```

You can also use Use IDEs like VS Code or Android Studio.

More info on compiling Dart apps [here](https://dart.dev/tools/dart-compile).
